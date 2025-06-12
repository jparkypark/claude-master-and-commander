#!/bin/bash

# Claude Master and Commander Helper Script
# Usage: ./prd-helper.sh [command] [options]

set -e

WORKFLOW_DIR="$HOME/.claude-master-and-commander"
PROJECTS_DIR="$HOME/Projects"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_usage() {
    echo "Claude Master and Commander Helper"
    echo "Usage: $0 [command] [options]"
    echo ""
    echo "Commands:"
    echo "  new <project-name>     Create new project with PRD structure"
    echo "  parse <prd-file>       Parse PRD and generate task breakdown"
    echo "  status <project-dir>   Show project status and next tasks"
    echo "  complete <task-id>     Mark task as complete"
    echo "  list                   List all PRD projects"
    echo "  help                   Show this help message"
}

create_new_project() {
    local project_name="$1"
    if [[ -z "$project_name" ]]; then
        echo -e "${RED}Error: Project name required${NC}"
        print_usage
        exit 1
    fi
    
    local project_dir="$PROJECTS_DIR/$project_name"
    
    if [[ -d "$project_dir" ]]; then
        echo -e "${YELLOW}Project directory already exists: $project_dir${NC}"
        read -p "Continue anyway? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi
    
    echo -e "${BLUE}Creating new PRD project: $project_name${NC}"
    
    # Create project structure
    mkdir -p "$project_dir"/{docs,src,tests,scripts,assets}
    
    # Copy PRD template
    cp "$WORKFLOW_DIR/templates/prd-template.md" "$project_dir/docs/prd.md"
    
    # Create initial files
    cat > "$project_dir/docs/tasks.md" << 'EOF'
# Task Breakdown

## Status Legend
- 🔲 Not Started
- 🔄 In Progress  
- ✅ Completed
- ❌ Blocked
- ⏸️ On Hold

## Current Sprint

### High Priority
- 🔲 Task 1: [Generated from PRD]
- 🔲 Task 2: [Generated from PRD]

### Medium Priority
- 🔲 Task 3: [Generated from PRD]

### Low Priority
- 🔲 Task 4: [Generated from PRD]

## Backlog
[Future tasks will be added here]

## Completed Tasks
[Completed tasks will be moved here]
EOF
    
    cat > "$project_dir/scripts/README.md" << 'EOF'
# Project Scripts

This directory contains utility scripts for this project:

- `setup.sh` - Initial project setup
- `dev.sh` - Start development environment
- `test.sh` - Run tests
- `deploy.sh` - Deployment script

## Usage
Make scripts executable: `chmod +x scripts/*.sh`
EOF
    
    cat > "$project_dir/.prd-config.json" << EOF
{
  "projectName": "$project_name",
  "createdDate": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "prdVersion": "1.0",
  "status": "planning",
  "currentPhase": "foundation",
  "taskCounter": 0
}
EOF
    
    echo -e "${GREEN}✅ Project created successfully!${NC}"
    echo -e "${BLUE}Next steps:${NC}"
    echo "1. Edit the PRD: $project_dir/docs/prd.md"
    echo "2. Run: $0 parse $project_dir/docs/prd.md"
    echo "3. Start development!"
    
    # Open PRD in default editor if available
    if command -v code &> /dev/null; then
        echo -e "${BLUE}Opening PRD in VS Code...${NC}"
        code "$project_dir/docs/prd.md"
    elif command -v nano &> /dev/null; then
        echo -e "${BLUE}Opening PRD in nano...${NC}"
        nano "$project_dir/docs/prd.md"
    fi
}
parse_prd() {
    local prd_file="$1"
    if [[ ! -f "$prd_file" ]]; then
        echo -e "${RED}Error: PRD file not found: $prd_file${NC}"
        exit 1
    fi
    
    local project_dir=$(dirname $(dirname "$prd_file"))
    local tasks_file="$project_dir/docs/tasks.md"
    
    echo -e "${BLUE}Parsing PRD and generating task breakdown...${NC}"
    
    # Use Claude via Desktop Commander to analyze PRD and generate tasks
    echo -e "${YELLOW}Analyzing PRD structure...${NC}"
    
    # Extract functional requirements
    local requirements=$(grep -A 10 "## Functional Requirements" "$prd_file" | grep -E "^\s*\*|\s*-|\d\." || true)
    
    if [[ -z "$requirements" ]]; then
        echo -e "${YELLOW}No functional requirements found. Please add them to your PRD.${NC}"
        return 1
    fi
    
    echo -e "${GREEN}Found functional requirements. Generating task breakdown...${NC}"
    
    # Create task breakdown template
    cat > "$tasks_file" << 'EOF'
# Task Breakdown

*Generated from PRD analysis*

## Status Legend
- 🔲 Not Started
- 🔄 In Progress  
- ✅ Completed
- ❌ Blocked
- ⏸️ On Hold

## Phase 1: Foundation

### Setup & Infrastructure
- 🔲 **TASK-001**: Initialize project structure
  - Create directory structure
  - Setup version control
  - Configure development environment
  - Priority: High | Effort: Small

- 🔲 **TASK-002**: Setup development tools
  - Configure linting and formatting
  - Setup testing framework
  - Create build pipeline
  - Priority: High | Effort: Medium

### Core Architecture
- 🔲 **TASK-003**: Design system architecture
  - Define data models
  - Plan API structure
  - Choose technology stack
  - Priority: High | Effort: Large

- 🔲 **TASK-004**: Setup database/storage
  - Configure database
  - Create initial schemas
  - Setup migrations
  - Priority: High | Effort: Medium

## Phase 2: Core Features

[Tasks will be generated based on your PRD functional requirements]

## Phase 3: Enhancement

[Secondary features and optimizations]

## Phase 4: Deployment

[Production setup and launch tasks]

## Notes
- Review and refine tasks based on your specific PRD
- Break down large tasks into smaller subtasks
- Update priorities based on dependencies
- Add time estimates as you learn more

EOF
    
    echo -e "${GREEN}✅ Initial task breakdown generated!${NC}"
    echo -e "${BLUE}Next steps:${NC}"
    echo "1. Review and customize: $tasks_file"
    echo "2. Add specific tasks based on your functional requirements"
    echo "3. Run: $0 status $project_dir"
}

show_project_status() {
    local project_dir="$1"
    if [[ ! -d "$project_dir" ]]; then
        echo -e "${RED}Error: Project directory not found: $project_dir${NC}"
        exit 1
    fi
    
    local config_file="$project_dir/.prd-config.json"
    local tasks_file="$project_dir/docs/tasks.md"
    
    if [[ ! -f "$config_file" ]]; then
        echo -e "${RED}Error: Not a PRD project (missing .prd-config.json)${NC}"
        exit 1
    fi
    
    echo -e "${BLUE}=== Project Status ===${NC}"
    echo
    
    # Show project info
    local project_name=$(grep '"projectName"' "$config_file" | cut -d'"' -f4)
    local status=$(grep '"status"' "$config_file" | cut -d'"' -f4)
    local phase=$(grep '"currentPhase"' "$config_file" | cut -d'"' -f4)
    
    echo -e "${GREEN}Project:${NC} $project_name"
    echo -e "${GREEN}Status:${NC} $status"
    echo -e "${GREEN}Phase:${NC} $phase"
    echo
    
    # Show task summary
    if [[ -f "$tasks_file" ]]; then
        local total_tasks=$(grep -c "🔲\|🔄\|✅\|❌\|⏸️" "$tasks_file" || echo "0")
        local completed=$(grep -c "✅" "$tasks_file" || echo "0")
        local in_progress=$(grep -c "🔄" "$tasks_file" || echo "0")
        local blocked=$(grep -c "❌" "$tasks_file" || echo "0")
        
        echo -e "${GREEN}Task Summary:${NC}"
        echo "  Total: $total_tasks"
        echo "  Completed: $completed"
        echo "  In Progress: $in_progress"
        echo "  Blocked: $blocked"
        echo
        
        # Show next tasks
        echo -e "${BLUE}Next Tasks:${NC}"
        grep -A 1 "🔲" "$tasks_file" | head -10 | while read line; do
            if [[ $line =~ 🔲 ]]; then
                echo "  $line"
            fi
        done
    else
        echo -e "${YELLOW}No tasks file found. Run 'parse' command first.${NC}"
    fi
}

list_projects() {
    echo -e "${BLUE}PRD Projects:${NC}"
    echo
    
    find "$PROJECTS_DIR" -name ".prd-config.json" -type f 2>/dev/null | while read config_file; do
        local project_dir=$(dirname "$config_file")
        local project_name=$(grep '"projectName"' "$config_file" | cut -d'"' -f4)
        local status=$(grep '"status"' "$config_file" | cut -d'"' -f4)
        local created=$(grep '"createdDate"' "$config_file" | cut -d'"' -f4)
        
        echo -e "${GREEN}$project_name${NC} ($status)"
        echo "  Path: $project_dir"
        echo "  Created: $created"
        echo
    done
}

# Main command handler
case "${1:-help}" in
    "new")
        create_new_project "$2"
        ;;
    "parse")
        parse_prd "$2"
        ;;
    "status")
        show_project_status "$2"
        ;;
    "list")
        list_projects
        ;;
    "help"|*)
        print_usage
        ;;
esac
