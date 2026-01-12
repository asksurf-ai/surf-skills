# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a Claude Code skills repository for Surf platform development. Skills are specialized knowledge modules that provide domain-specific guidance for Go backend development on muninn (REST API) and argus (gRPC/data processing) services.

## Repository Structure

```
surf-skills/
├── surf-golang-dev/           # Go development skill
│   ├── SKILL.md               # Skill definition with YAML frontmatter
│   ├── learnings.md           # Team-shared learnings (updated by Claude)
│   └── references/            # Detailed reference documentation
│       ├── architecture.md    # Multi-mode architecture, read/write split
│       ├── conventions.md     # Code style, naming, error handling
│       ├── ent-orm.md         # Ent ORM patterns and queries
│       └── ci-cd.md           # Deployment and GitHub Actions
└── README.md
```

## Adding New Skills

1. Create a directory: `surf-<skill-name>/`
2. Add `SKILL.md` with YAML frontmatter:
   ```yaml
   ---
   name: surf-<skill-name>
   description: <description for when to activate this skill>
   ---
   ```
3. Add `references/` directory for detailed documentation
4. Add `learnings.md` for team-shared learnings
5. Update root README.md

## Self-Learning Protocol

When working on Surf platform code and receiving user feedback:

1. **Apply the feedback** to the current task
2. **Persist the learning**:
   - General Go patterns → Update `learnings.md` in this repo
   - Project-specific info → Update that project's `CLAUDE.md`
3. **Commit the update** to the appropriate repository

Learning format:
```markdown
## [Category]

### [Brief Title]

**Rule**: [Clear statement]
**Rationale**: [Why this matters]
**Example**: [Code if applicable]
```

## Skill Installation

Users enable skills by creating symlinks:
```bash
cd ~/.claude/skills
ln -s surf-skills/surf-golang-dev surf-golang-dev
```
