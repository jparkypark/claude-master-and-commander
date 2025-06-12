# User Guide

## Quick Start

### Installation
```bash
curl -sSL https://raw.githubusercontent.com/jparkypark/claude-master-and-commander/main/install.sh | bash
```

### Create Your First Project
```bash
prd new my-awesome-project
```

### Generate Tasks from PRD
```bash
prd-generate ~/Projects/my-awesome-project/docs/prd.md
```

### Check Project Status
```bash
prd-status ~/Projects/my-awesome-project
```

## Commands

- `prd new <name>` - Create new PRD project
- `prd-generate <prd-file>` - Generate tasks from PRD
- `prd-status <project-dir>` - Show project status
- `prd-list` - List all PRD projects
- `prd-cd <project>` - Navigate to project

## Workflow

1. Create project with `prd new`
2. Write detailed PRD in `docs/prd.md`
3. Generate tasks with `prd-generate`
4. Develop with Claude assistance
5. Track progress with `prd-status`

For detailed information, see [Architecture](architecture.md) and [Workflow](workflow.md) documentation.
