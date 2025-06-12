# User Guide

## Quick Start

### Installation
```bash
curl -sSL https://raw.githubusercontent.com/jparkypark/claude-master-and-commander/main/install.sh | bash
```

### Create Your First Project
```bash
cmc new my-awesome-project
```

### Generate Tasks from PRD
```bash
cmc-generate ~/Projects/my-awesome-project/docs/prd.md
```

### Check Project Status
```bash
cmc-status ~/Projects/my-awesome-project
```

## Commands

- `cmc new <n>` - Create new PRD project
- `cmc-generate <cmc-file>` - Generate tasks from PRD
- `cmc-status <project-dir>` - Show project status
- `cmc-list` - List all PRD projects
- `cmc-cd <project>` - Navigate to project

## Workflow

1. Create project with `cmc new`
2. Write detailed PRD in `docs/prd.md`
3. Generate tasks with `cmc-generate`
4. Develop with Claude assistance
5. Track progress with `cmc-status`

For detailed information, see [Architecture](architecture.md) and [Workflow](workflow.md) documentation.
