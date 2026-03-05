#!/usr/bin/env python3
"""Decrypt a Kubernetes secret from cluster and write it as a plaintext secrets file.

Usage:
    kseal-decrypt.py <gitops-app-path> [--context stg-app|prd-app]
    kseal-decrypt.py <gitops-app-path> --context stg-app --dry-run

Examples:
    kseal-decrypt.py apps/dagster/common/swell/
    kseal-decrypt.py apps/dagster/common/swell/ --context prd-app
    kseal-decrypt.py /Users/peng/Workspace/k8s/gitops/apps/urania-agent/ --dry-run
"""

import argparse
import base64
import json
import os
import subprocess
import sys

import yaml

GITOPS_ROOT = "/Users/peng/Workspace/k8s/gitops"
DEFAULT_CONTEXT = "stg-app"


def find_sealed_secret(app_path):
    """Find sealed-secret.yaml in the given path."""
    candidates = [
        os.path.join(app_path, "sealed-secret.yaml"),
        os.path.join(app_path, "sealed-secret.json"),
    ]
    for c in candidates:
        if os.path.isfile(c):
            return c
    return None


def parse_sealed_secret(filepath):
    """Extract secret name and namespace from sealed-secret.yaml (YAML or JSON)."""
    with open(filepath) as f:
        doc = yaml.safe_load(f)

    name = doc.get("metadata", {}).get("name")
    namespace = doc.get("metadata", {}).get("namespace")

    # Some files have template metadata instead
    if not name or not namespace:
        tmpl = doc.get("spec", {}).get("template", {}).get("metadata", {})
        name = name or tmpl.get("name")
        namespace = namespace or tmpl.get("namespace")

    if not name or not namespace:
        print(f"ERROR: Cannot extract name/namespace from {filepath}", file=sys.stderr)
        sys.exit(1)

    return name, namespace


def fetch_secret(name, namespace, context):
    """Fetch secret from cluster via kubectl."""
    cmd = [
        "kubectl", "get", "secret", name,
        "-n", namespace,
        "--context", context,
        "-o", "json",
    ]
    result = subprocess.run(cmd, capture_output=True, text=True)
    if result.returncode != 0:
        print(f"ERROR: kubectl failed:\n{result.stderr.strip()}", file=sys.stderr)
        sys.exit(1)
    return json.loads(result.stdout)


def secret_to_plaintext_yaml(secret_json):
    """Convert a K8s Secret JSON to plaintext YAML with stringData."""
    meta = secret_json["metadata"]
    data = secret_json.get("data", {})

    lines = [
        "apiVersion: v1",
        "kind: Secret",
        "metadata:",
        "  creationTimestamp: null",
        f"  name: {meta['name']}",
        f"  namespace: {meta['namespace']}",
        "stringData:",
    ]

    for key in sorted(data):
        value = base64.b64decode(data[key]).decode("utf-8")
        if "\n" in value:
            lines.append(f"  {key}: |")
            for line in value.rstrip("\n").split("\n"):
                lines.append(f"    {line}")
        else:
            # Quote values that could be misinterpreted by YAML
            if needs_quoting(value):
                lines.append(f'  {key}: "{escape_yaml_string(value)}"')
            else:
                lines.append(f"  {key}: {value}")

    return "\n".join(lines) + "\n"


def needs_quoting(value):
    """Check if a YAML value needs quoting to avoid misinterpretation."""
    if not value:
        return True
    # Values that look like booleans, nulls, or numbers
    lower = value.lower()
    if lower in ("true", "false", "yes", "no", "on", "off", "null", "~"):
        return True
    # Values starting/ending with whitespace
    if value != value.strip():
        return True
    # Values containing characters that could break YAML
    if any(c in value for c in "{}[]|>:,#&*?!%@`"):
        return True
    return False


def escape_yaml_string(value):
    """Escape special characters for double-quoted YAML strings."""
    return value.replace("\\", "\\\\").replace('"', '\\"')


def resolve_app_path(path_arg):
    """Resolve the app path to an absolute path under gitops root."""
    if os.path.isabs(path_arg):
        return path_arg.rstrip("/")

    # Relative path — resolve under gitops root
    full = os.path.join(GITOPS_ROOT, path_arg)
    if os.path.isdir(full):
        return full.rstrip("/")

    print(f"ERROR: Path not found: {full}", file=sys.stderr)
    sys.exit(1)


def main():
    parser = argparse.ArgumentParser(description="Decrypt K8s secret from cluster to plaintext file")
    parser.add_argument("path", help="Gitops app path (absolute or relative to gitops root)")
    parser.add_argument("--context", default=DEFAULT_CONTEXT, choices=["stg-app", "prd-app"],
                        help=f"Kubernetes context (default: {DEFAULT_CONTEXT})")
    parser.add_argument("--dry-run", action="store_true",
                        help="Print to stdout instead of writing to file")
    args = parser.parse_args()

    app_path = resolve_app_path(args.path)

    sealed_path = find_sealed_secret(app_path)
    if not sealed_path:
        print(f"ERROR: No sealed-secret.yaml found in {app_path}", file=sys.stderr)
        sys.exit(1)

    name, namespace = parse_sealed_secret(sealed_path)
    print(f"Secret: {name} (namespace: {namespace}, context: {args.context})")

    secret_json = fetch_secret(name, namespace, args.context)
    plaintext = secret_to_plaintext_yaml(secret_json)

    key_count = len(secret_json.get("data", {}))

    if args.dry_run:
        # In dry-run, show key names only (no values)
        print(f"\n--- {key_count} keys found ---")
        for key in sorted(secret_json.get("data", {})):
            print(f"  - {key}")
        print(f"\nWould write to: {os.path.join(app_path, 'secrets')}")
    else:
        output_path = os.path.join(app_path, "secrets")
        with open(output_path, "w") as f:
            f.write(plaintext)
        print(f"Wrote {key_count} keys to {output_path}")


if __name__ == "__main__":
    main()
