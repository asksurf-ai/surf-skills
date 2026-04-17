---
name: odin-dev-argo
description: ArgoCD operations for Surf platform — list/sync/diff/rollback Applications via argocd CLI in --core mode. Use when user says /odin-dev-argo or asks about ArgoCD sync, argo app status, diff against git, pause auto-sync, rollback, or debugging out-of-sync/progressing/degraded Applications across dev-app, stg-app, or prd-app.
---

# ArgoCD Operations

Inspect and sync ArgoCD Applications. Stays within GitOps — never mutates
desired state in-cluster; git is source of truth.

## Prerequisites

- `argocd` CLI installed: `brew install argocd`
- kubectl context points at the target cluster (via Tailscale-proxied
  kubeconfig: `tailscale configure kubeconfig <cluster>-operator`)
- Tailnet identity has cluster-admin (granted by domain-group binding in
  dev-app; AWS IAM in stg/prd)

## Why `--core` mode

`argocd --core` talks directly to the ArgoCD CRDs via your kubeconfig —
no `argocd login` / no API token / no fighting Pomerium. Works as long as
your k8s user has rights on `applications.argoproj.io`.

Make it the default:

```bash
export ARGOCD_OPTS='--core'
# add to ~/.zshrc
```

Then everything below works without the `--core` flag. Examples below
show the flag for clarity; omit it when the env var is set.

## Environment selection

**Before any argocd command, confirm the target cluster.**

| Environment | kubectl context | Notes |
|-------------|-----------------|-------|
| **Dev**     | `dev-app` (Tailscale-proxied) | Ephemeral services; safe to experiment |
| **Staging** | `stg-app` | Shared team env; check before disrupting |
| **Prod**    | `prd-app` | Never sync/rollback without explicit user approval |

If ambiguous → **ASK**. Do NOT default to prd.

## Safe commands (read-only)

```bash
kubectx dev-app                          # set target cluster first
argocd --core app list                   # all Applications in this cluster
argocd --core app get hermod             # details: sources, sync status, health
argocd --core app diff hermod            # desired (git) vs live
argocd --core app history hermod         # recent syncs
argocd --core app logs hermod            # container logs across all app pods
argocd --core app resources hermod       # live resource tree
```

## Write commands (use judiciously)

### `sync` — GitOps-safe, always OK

Forces ArgoCD to reconcile git → cluster now instead of waiting for the
next auto-poll (~3min).

```bash
argocd --core app sync hermod
argocd --core app sync hermod --prune         # also delete resources no longer in git
argocd --core app sync hermod --dry-run       # preview what would apply
argocd --core app sync hermod --revision HEAD~1   # sync a specific git ref (useful for diff)
```

### `rollback` — BREAK-GLASS ONLY

`argocd app rollback` is an anti-pattern in a selfHeal-enabled setup. It
reverts LIVE to an old sync, but git still says "latest". On the next
reconcile, ArgoCD re-applies git and clobbers the rollback.

**Proper rollback = `git revert` the bad commit in the gitops repo**, then
let ArgoCD sync. Example:

```bash
cd gitops-dev
git revert <bad-sha>
git push    # auto-approve workflow + ArgoCD sync
```

Only use `argocd app rollback` to STOP BLEEDING in an incident, and
follow with a proper git revert. Leave a paper trail.

### `refresh` — forces ArgoCD to re-read git

If a git push isn't showing up in ArgoCD, kick the cache:

```bash
argocd --core app get hermod --refresh   # normal refresh (caches for 3s)
argocd --core app get hermod --hard-refresh   # bypass manifest cache
```

## Debugging `OutOfSync` / `Progressing` / `Degraded`

### OutOfSync

"Live state drifted from git." Usually one of:
1. Someone `kubectl edit`-ed a resource ArgoCD owns → drift.
2. A manifest in git was just merged; auto-sync hasn't picked it up → wait or force `app sync`.
3. ServerSideApply diff bug (known on k8s 1.35 — see `syncOptions: - ServerSideApply=true` in ApplicationSet).

Run `argocd app diff <app>` to see the delta. If it's hand-edits,
`app sync` wipes them. If it's a known false positive (e.g.
`status.terminatingReplicas` on k8s 1.35), drop `ServerSideApply` from
syncOptions.

### Progressing

Pods not yet healthy. `argocd app logs <app>` + `stern -n app <app>` to
tail. Usually a missing secret / ConfigMap / image pull error.

### Degraded

A managed resource reports unhealthy status. `kubectl describe` the
specific resource ArgoCD highlights. Common: failing probes, crashloops,
PVC not bound.

## Pausing auto-sync (proper way)

Auto-sync in ApplicationSet `syncPolicy.automated`. To pause ONE app,
edit the ApplicationSet in git and remove/comment the `automated:` block
for that generator entry.

```bash
# WRONG (creates drift, gets overwritten by ApplicationSet reconcile):
argocd --core app set hermod --sync-policy none

# RIGHT (edit gitops repo):
vim gitops-dev/bootstrap/applicationset.yaml
# remove automated: block for the hermod route
git commit && git push
```

## GitOps rule of thumb

**If a command modifies desired state in the cluster without a matching
git change, you're fighting GitOps.** Reads are always fine. `sync` is
fine. Anything else → edit git.

## Quick troubleshooting table

| Symptom | First thing to try |
|---------|-------------------|
| App stuck Syncing | `argocd app get <app> --hard-refresh` |
| New commit not picked up | `argocd app sync <app>` (skip the 3min poll) |
| Can't reach ArgoCD at all | Check Tailnet kubectl works; `--core` needs kubectl auth |
| Resources not deleted after removing from git | Sync without auto-prune; re-run with `--prune` |
| ImagePullBackOff despite Image Updater running | Check Image Updater logs: `kubectl -n argocd logs deploy/argocd-image-updater` |
| Wrong repo in write-back | Set `argocd-image-updater.argoproj.io/git-repository` explicitly on the Application (multi-source apps confuse auto-detect) |

## See also

- `/odin-dev-kube` — generic kubectl operations (rollouts, sealed secrets, logs)
- `/odin-dev-push-code` — git workflow that pairs with this (push → CI builds → ECR → Image Updater bumps → ArgoCD syncs)
