# CI/CD and Deployment

## GitHub Actions Workflows

Located in `.github/workflows/`:

| File | Trigger | Purpose |
|------|---------|--------|
| `stg.yml` | Push to `main` | Deploy to staging |
| `prd.yml` | Release published | Deploy to production |
| `auto-approve.yml` | PR opened | Auto-approve team PRs |

## Staging Deployment Flow

```
Push to main
    ↓
GitHub Actions (stg.yml)
    ↓
Build Docker image (multi-stage)
    ↓
Push to ECR: 996435522985.dkr.ecr.us-west-2.amazonaws.com/{service}
    ↓
Tag: sha-{commit}
    ↓
Update GitOps repo (cybertino/gitops-stg)
    ↓
ArgoCD syncs deployment
```

## Production Deployment Flow

```
Create Release (tag)
    ↓
GitHub Actions (prd.yml)
    ↓
Build Docker image
    ↓
Push to ECR with tag version
    ↓
Update GitOps repo (cybertino/gitops)
    ↓
ArgoCD syncs deployment
```

## Dockerfile Structure

Both services use multi-stage builds:

```dockerfile
# Stage 1: Builder
FROM golang:1.24-alpine AS builder

# Configure private repo access
ARG GITHUB_PAT
ENV GOPRIVATE=github.com/cyberconnecthq/*

# Efficient caching: download deps first
COPY go.mod go.sum ./
RUN go mod download

# Build with optimizations
COPY . .
RUN CGO_ENABLED=0 go build -trimpath -ldflags="-s -w" -o /app main.go

# Stage 2: Runtime
FROM debian:bookworm-slim
RUN apt-get update && apt-get install -y ca-certificates
COPY --from=builder /app /app
ENTRYPOINT ["/app"]
```

### Build Optimizations

- `CGO_ENABLED=0`: Pure Go binary, no C dependencies
- `-trimpath`: Remove local paths from binary
- `-ldflags="-s -w"`: Strip debug info, reduce binary size
- Multi-stage: Final image ~50MB vs ~1GB with Go toolchain

## GitOps Structure

Each service deploys multiple Kubernetes resources:

### muninn
- `muninn-api`: REST API deployment
- `muninn-task`: Background task processor

### argus
- `argus-api`: gRPC server
- `argus-task`: Kinesis consumers
- `argus-cron`: Scheduled jobs

## Docker Compose (Local Dev)

```yaml
# docker-compose.yml
services:
  db:
    image: postgres:14.4-alpine
    ports: ["5432:5432"]
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
      POSTGRES_DB: odin

  redis:
    image: redis:alpine
    ports: ["6379:6379"]
```

Usage:
```bash
docker-compose up -d
```

## ECR Repository

- Region: `us-west-2`
- Account: `996435522985`
- Repos: `muninn`, `argus`

## Branch Strategy

- `main`: Staging deployment
- Tags/Releases: Production deployment
- Feature branches: No automatic deployment

## Monitoring

### DataDog Integration

Both services integrate with DataDog for:
- APM traces (muninn uses Orchestrion auto-instrumentation)
- Custom metrics
- Log aggregation

### Health Checks

Kubernetes probes configured:
- Liveness: Basic health endpoint
- Readiness: Returns 503 during shutdown

## Secrets Management

- GitHub Actions secrets for CI
- AWS credentials via OIDC
- ECR login via `aws-actions/amazon-ecr-login`
- Private repo access via `GITHUB_PAT`

## Pre-commit Hooks

Run before committing:
```bash
pre-commit run --all-files
```

Checks:
- `golines`: Line length
- `go-fmt`: Formatting
- `go-imports`: Import organization
- `go-mod-tidy`: Dependency cleanup
