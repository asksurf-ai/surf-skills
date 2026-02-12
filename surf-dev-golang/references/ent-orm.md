# Ent ORM Guide

Ent is a **code-first** ORM framework. Schema definitions in `ent/schema/*.go` are the source of truth.

## Critical Rules

1. **NEVER manually create migration files** - Ent generates everything
2. **NEVER edit files in `ent/` except `ent/schema/`** - They are regenerated
3. **ALWAYS regenerate after schema changes**: `cd ent && go generate`

## Schema Workflow

### Creating New Entity

1. Create file in `ent/schema/`:
```go
// ent/schema/token.go
package schema

import (
    "entgo.io/ent"
    "entgo.io/ent/schema/field"
    "entgo.io/ent/schema/index"
    "github.com/google/uuid"
)

type Token struct {
    ent.Schema
}

func (Token) Fields() []ent.Field {
    return []ent.Field{
        field.UUID("id", uuid.UUID{}).Default(uuid.New),
        field.String("symbol").NotEmpty(),
        field.String("name"),
        field.Float("price").Optional(),
        field.Time("created_at").Default(time.Now),
    }
}

func (Token) Indexes() []ent.Index {
    return []ent.Index{
        index.Fields("symbol").Unique(),
    }
}
```

2. Generate code:
```bash
cd ent && go generate
```

3. Use in service:
```go
token, err := s.EntWriteClient.Token.Create().
    SetSymbol("BTC").
    SetName("Bitcoin").
    SetPrice(50000.0).
    Save(ctx)
```

### Modifying Schema

```bash
# 1. Edit schema file
vim ent/schema/token.go

# 2. Regenerate (generates migrations automatically)
cd ent && go generate

# 3. Deploy - migrations run automatically
```

## Query Patterns

### Basic Queries

```go
// Query single record
token, err := s.EntROClient.Token.Query().
    Where(token.Symbol("BTC")).
    Only(ctx)

// Query multiple records
tokens, err := s.EntROClient.Token.Query().
    Where(token.PriceGTE(1000)).
    Order(ent.Desc(token.FieldPrice)).
    Limit(100).
    All(ctx)

// Select specific fields
tokens, err := s.EntROClient.Token.Query().
    Select(token.FieldSymbol, token.FieldPrice).
    Where(token.SymbolIn("BTC", "ETH")).
    All(ctx)
```

### Common Where Clauses

```go
token.ID(id)                    // Equal
token.IDIn(ids...)              // IN clause
token.IDNEQ(id)                 // Not equal
token.PriceGT(value)            // Greater than
token.PriceGTE(value)           // Greater than or equal
token.PriceLT(value)            // Less than
token.PriceLTE(value)           // Less than or equal
token.PriceIsNil()              // IS NULL
token.PriceNotNil()             // IS NOT NULL
token.SymbolContains("BTC")     // LIKE %value%
token.SymbolHasPrefix("B")      // LIKE value%
```

### Ordering & Pagination

```go
tokens, err := s.EntROClient.Token.Query().
    Where(token.PriceNotNil()).
    Order(ent.Desc(token.FieldPrice)).
    Offset(20).
    Limit(10).
    All(ctx)
```

### Count

```go
count, err := s.EntROClient.Token.Query().
    Where(token.PriceGTE(1000)).
    Count(ctx)
```

## Write Operations

### Create

```go
token, err := s.EntWriteClient.Token.Create().
    SetSymbol("BTC").
    SetName("Bitcoin").
    Save(ctx)
```

### Bulk Create

```go
bulk := make([]*ent.TokenCreate, len(data))
for i, d := range data {
    bulk[i] = s.EntWriteClient.Token.Create().
        SetSymbol(d.Symbol).
        SetName(d.Name)
}
tokens, err := s.EntWriteClient.Token.CreateBulk(bulk...).Save(ctx)
```

### Update

```go
// Update by ID
token, err := s.EntWriteClient.Token.UpdateOneID(id).
    SetPrice(51000.0).
    Save(ctx)

// Bulk update
affected, err := s.EntWriteClient.Token.Update().
    Where(token.PriceLT(100)).
    SetPrice(100).
    Save(ctx)
```

### Upsert

```go
err := s.EntWriteClient.Token.Create().
    SetSymbol("BTC").
    SetName("Bitcoin").
    SetPrice(50000).
    OnConflictColumns(token.FieldSymbol).
    UpdateNewValues().
    Exec(ctx)
```

### Delete

```go
// Delete by ID
err := s.EntWriteClient.Token.DeleteOneID(id).Exec(ctx)

// Bulk delete
affected, err := s.EntWriteClient.Token.Delete().
    Where(token.CreatedAtLT(cutoff)).
    Exec(ctx)
```

## Index Optimization

### Composite Index Rules

A composite index `(A, B, C)` covers:
- Queries on `(A)` alone
- Queries on `(A, B)`
- Queries on `(A, B, C)`

It does NOT cover: `(B)`, `(C)`, or `(B, C)`

### Example: Avoid Redundant Indexes

```go
// WRONG - post_at index is redundant
func (Tweet) Indexes() []ent.Index {
    return []ent.Index{
        index.Fields("post_at"),                           // Redundant!
        index.Fields("post_at", "is_deleted", "tweet_id"), // Covers post_at
    }
}

// CORRECT - only composite index
func (Tweet) Indexes() []ent.Index {
    return []ent.Index{
        index.Fields("post_at", "is_deleted", "tweet_id"),
    }
}
```

### Index Design Checklist

1. Analyze exact WHERE/ORDER BY clauses
2. Create composite index matching query pattern
3. Remove redundant single-column indexes
4. Test with `EXPLAIN ANALYZE`

## Relationships (Edges)

### Define Edge

```go
// In Project schema
func (Project) Edges() []ent.Edge {
    return []ent.Edge{
        edge.To("tokens", Token.Type),           // One-to-many
        edge.From("owner", User.Type).Unique(),  // Many-to-one
    }
}

// In Token schema
func (Token) Edges() []ent.Edge {
    return []ent.Edge{
        edge.From("project", Project.Type).Unique(),
    }
}
```

### Query with Edges

```go
// Eager loading
project, err := s.EntROClient.Project.Query().
    Where(project.ID(id)).
    WithTokens().
    Only(ctx)

// Access loaded edge
for _, token := range project.Edges.Tokens {
    fmt.Println(token.Symbol)
}
```

## Transactions

```go
import "github.com/cyberconnecthq/muninn/internal/repository"

err := repository.WithTx(ctx, s.EntWriteClient, func(tx *ent.Tx) error {
    // All operations use tx.Client()
    project, err := tx.Client().Project.Create().
        SetName("New Project").
        Save(ctx)
    if err != nil {
        return err  // Rolls back
    }

    _, err = tx.Client().Token.Create().
        SetSymbol("TKN").
        SetProject(project).
        Save(ctx)
    return err  // Commits if nil
})
```

## When Raw SQL is Acceptable

- Complex aggregations (`AVG`, `SUM` with custom grouping)
- Performance-critical queries needing manual optimization
- Queries on tables not managed by Ent

```go
// Raw SQL example (use sparingly)
rows, err := s.EntROClient.QueryContext(ctx, `
    SELECT tag, SUM(views) as total_views
    FROM project_tag_share_1d
    WHERE created_at > $1
    GROUP BY tag
    ORDER BY total_views DESC
    LIMIT 10
`, startTime)
```
