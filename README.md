# Surf Skills

Claude Code skills for Surf platform development.

## Available Skills

| Skill | Description | For |
|-------|-------------|-----|
| `surf-golang-dev` | Go development guide (muninn, argus) | Backend engineers |
| *(more coming...)* | | |

## Setup

### 1. Clone this repo

```bash
cd ~/.claude/skills
git clone git@github.com:cyberconnecthq/surf-skills.git
```

### 2. Enable the skills you need

Create symlinks only for the skills relevant to your role:

```bash
cd ~/.claude/skills

# Backend engineers - enable Go skill
ln -s surf-skills/surf-golang-dev surf-golang-dev

# Frontend engineers - enable frontend skill (coming soon)
# ln -s surf-skills/surf-frontend-dev surf-frontend-dev
```

### 3. Sync updates

Periodically pull to get team learnings:

```bash
cd ~/.claude/skills/surf-skills
git pull
```

## Contributing Learnings

When Claude suggests adding a learning:

1. Claude will update `learnings.md` in the appropriate skill
2. Commit and push the change
3. Team members get updates via `git pull`

## Adding New Skills

To add a new skill (e.g., `surf-frontend-dev`):

1. Create directory: `surf-frontend-dev/`
2. Add `SKILL.md` with YAML frontmatter
3. Add `references/` and `learnings.md` as needed
4. Update this README
