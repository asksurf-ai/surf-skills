# Code Conventions

## Language

**English only** in all code and comments. This is strictly enforced.

## Naming

### Variables & Functions
```go
// Correct
entWriteClient    // camelCase for private
EntWriteClient    // PascalCase for exported
projectID         // Acronyms: ID not Id
userURL           // URL not Url

// Incorrect
ent_write_client  // No underscores
projectId         // ID should be capitalized
```

### Files
```go
tweet_engagement_cron.go   // Underscore-separated
grpc_mindshare.go          // grpc prefix for gRPC handlers
*_test.go                  // Test files
```

## Error Handling

### Ent Queries
```go
// Always use MaskNotFound for optional entities
project, err := s.EntROClient.Project.Query().
    Where(project.ID(id)).
    Only(ctx)
if ent.MaskNotFound(err) != nil {
    return nil, fmt.Errorf("query project: %w", err)
}
if project == nil {
    // Handle not found case
}
```

### Error Wrapping
```go
// Always wrap with context
if err != nil {
    return nil, fmt.Errorf("failed to fetch project %s: %w", id, err)
}
```

### Fatal vs Error Logging
```go
// Fatal: Only for startup failures that prevent service from running
if err := app.InitializeIndex(ctx); err != nil {
    zap.L().Fatal("failed to initialize index", zap.Error(err))
}

// Error: For runtime errors that should be handled
if err != nil {
    zap.L().Error("failed to process tweet",
        zap.Error(err),
        zap.String("tweet_id", tweetID))
    return err
}
```

## Parallel Processing

**CRITICAL**: Never use raw goroutines with WaitGroup. Always use the project's worker pool.

```go
// WRONG
var wg sync.WaitGroup
for _, item := range items {
    wg.Add(1)
    go func(item Item) {
        defer wg.Done()
        processItem(item)  // No panic recovery!
    }(item)
}
wg.Wait()

// CORRECT
import "github.com/cyberconnecthq/argus/internal/utils"

works := make([]func() error, 0, len(items))
for _, item := range items {
    item := item // Capture for closure
    works = append(works, func() error {
        return processItem(item)
    })
}

if err := utils.ParallelExec(works); err != nil {
    // Handle aggregated errors
}

// With custom worker count
utils.ParallelExecWithWorkers(works, 20)
```

## Comments

### Swagger (muninn)
```go
// GetProjectByIdV2 godoc
//
//	@Summary		Get detailed project information
//	@Description	Returns comprehensive information about a project
//	@Tags			projects
//	@Accept			json
//	@Produce		json
//	@Param			project_id	path		string	true	"Project ID"
//	@Success		200			{object}	model.GetProjectByIdV2Response
//	@Failure		404			{object}	model.Error
//	@Router			/v2/projects/{project_id} [get]
func (s *Service) GetProjectByIdV2(c *gin.Context) {
```

### Code Comments
```go
// ProcessTweetBatch processes incoming tweets in parallel.
// It performs: parsing, author upsert, tweet upsert, and signal detection.
func (s *Service) ProcessTweetBatch(ctx context.Context, tweets [][]byte) error {

// xidToProjectID maps Twitter X ID to project UUID.
// After initialization, this map is read-only and safe for concurrent access.
xidToProjectID map[string]string
```

## Transactions

### Passing Transactions
```go
// Prefer client *ent.Client over tx *ent.Tx
func (s *Service) CreateWithRelations(ctx context.Context, client *ent.Client) error {
    // Use client directly
}

// When calling:
err := repository.WithTx(ctx, s.EntWriteClient, func(tx *ent.Tx) error {
    return s.CreateWithRelations(ctx, tx.Client())
})
```

## HTTP Errors (muninn)

```go
// Use model.NewError for consistent responses
if project == nil {
    c.JSON(http.StatusNotFound, model.NewError("project not found"))
    return
}

if err != nil {
    c.JSON(http.StatusInternalServerError, model.NewError("internal error"))
    return
}
```

## Logging

Use structured logging with zap:

```go
// Good - structured fields
zap.L().Info("processing batch",
    zap.Int("tweet_count", len(tweets)),
    zap.Duration("duration", time.Since(start)),
    zap.Int("cycle", cycle),
    zap.Int("tier", tier))

// Bad - string formatting
zap.L().Info(fmt.Sprintf("processing %d tweets in %v", len(tweets), duration))
```

## Pre-commit Hooks

The following hooks run automatically:
- `golines`: Format long lines
- `go-fmt`: Standard Go formatting
- `go-imports`: Sort and organize imports
- `go-mod-tidy`: Clean up go.mod

Run manually: `pre-commit run --all-files`
