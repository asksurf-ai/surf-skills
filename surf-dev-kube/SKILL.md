---
name: surf-dev-kube
description: Debug and inspect Dagster pipeline runs on Kubernetes (EKS). Use when investigating failed pipeline runs, checking pod logs, diagnosing OOM kills, or inspecting Dagster run status. Use when user says /surf-dev-kube or asks about dagster pods, k8s logs, or pipeline failures.
---

# Kubernetes Debugging for Dagster Pipeline

Debug Dagster pipeline runs on EKS. Use this skill to inspect pods, read logs, and diagnose failures.

## Cluster Access

**EKS cluster**: `prd-app` in `us-west-2` (account `996435522985`)
**Namespace**: `dagster`

```bash
# Update kubeconfig (one-time setup)
aws eks update-kubeconfig --region us-west-2 --name prd-app

# Verify access
kubectl get pods -n dagster | head -5
```

**IP whitelisting required**: EKS public access CIDRs are managed in `cybertino/gitops` Terraform. If `kubectl` times out, your IP needs whitelisting.

## Pod Layout

| Pod Pattern | Role |
|-------------|------|
| `dagster-core-daemon-*` | Dagster daemon (schedules, sensors, run queue) |
| `dagster-core-dagster-webserver-*` | Dagster UI |
| `swell-dagster-user-deployments-swell-*` | User code server (our pipeline code) |
| `dagster-run-{uuid}-*` | One pod per run (Completed or Running) |

## Common Debugging Commands

### List Active Pods (skip completed runs)

```bash
kubectl get pods -n dagster | grep -v Completed
```

### Check for OOMKilled Pods

```bash
kubectl get pods -n dagster -o json | jq '.items[] | select(.status.containerStatuses[]?.lastState.terminated.reason == "OOMKilled") | .metadata.name'
```

### User Code Server Logs

Asset-level errors (dbt failures, script errors) surface in the user code server:

```bash
# Find the pod name
kubectl get pods -n dagster | grep swell-dagster-user-deployments

# Read recent logs
kubectl logs -n dagster swell-dagster-user-deployments-swell-<suffix> --tail=200
```

### Run Pod Logs

Each Dagster run creates its own pod. Find it by run ID or by recency:

```bash
# List recent run pods (newest last)
kubectl get pods -n dagster --sort-by='.metadata.creationTimestamp' | grep dagster-run | tail -10

# Logs from a specific run
kubectl logs -n dagster dagster-run-<uuid>-<suffix> --tail=200

# Follow logs from a running pod
kubectl logs -n dagster dagster-run-<uuid>-<suffix> --tail=50 -f
```

### Find Failed Runs

```bash
# Pods in Error state
kubectl get pods -n dagster | grep Error

# Recently terminated pods with non-zero exit
kubectl get pods -n dagster -o json | jq -r '.items[] | select(.status.phase == "Failed" or (.status.containerStatuses[]?.state.terminated.exitCode // 0) != 0) | "\(.metadata.name) \(.status.phase) \(.status.containerStatuses[0].state.terminated.reason // "unknown")"'
```

### Pod Resource Usage

```bash
# Memory/CPU usage of running pods
kubectl top pods -n dagster | grep -v Completed | sort -k3 -h
```

### Describe Pod (events, restart reasons)

```bash
kubectl describe pod -n dagster <pod-name> | tail -30
```

## Deployment

- **GitOps**: `cybertino/gitops` repo → `apps/dagster/dagster-user-deployments/swell-prod-values.yaml`
- **CI**: `.github/workflows/dagster-prod.yml` builds Docker image → pushes to ECR → updates gitops values
- **Docker image**: `996435522985.dkr.ecr.us-west-2.amazonaws.com/swell-dagster`
- **Dockerfile**: `Dockerfile-Dagster` at repo root
- **Sync**: Flux/ArgoCD picks up values change and rolls out new pods

## Troubleshooting

### kubectl times out
Your IP is not whitelisted on EKS public access CIDRs. Check your IP (`curl ifconfig.me`) and add it in `cybertino/gitops` Terraform.

### Pod stuck in Running for hours
Check if it's a long-running backfill or stuck. Read logs:
```bash
kubectl logs -n dagster <pod-name> --tail=20
```

### OOM on ClickHouse (not k8s)
Dagster pods may succeed but the ClickHouse query they trigger OOMs server-side. Check ClickHouse `system.query_log`:
```sql
SELECT query_start_time, round(query_duration_ms/1000,1) as sec,
    round(memory_usage/1024/1024/1024,2) as gib, exception
FROM system.query_log
WHERE type != 'QueryStart' AND exception != ''
ORDER BY query_start_time DESC LIMIT 10
```
