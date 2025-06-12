#!/bin/bash

# Enhanced Claude Master and Commander with Confirmation Gates
# Location: /Users/joshparks/Github/jparkypark/claude-master-and-commander/scripts/cmc.sh

set -e

CMC_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEMPLATES_DIR="$CMC_ROOT/templates"
PROJECTS_DIR="$HOME/cmc-projects"

# Ensure projects directory exists
mkdir -p "$PROJECTS_DIR"

function show_usage() {
    echo "Claude Master and Commander - PRD-driven development workflow"
    echo ""
    echo "Usage: cmc <command> [options]"
    echo ""
    echo "Commands:"
    echo "  new <project>       Create new PRD project with template"
    echo "  review <project>    Open PRD for review and editing"
    echo "  approve <project>   Approve PRD for task generation"
    echo "  generate <project>  Generate task breakdown from approved PRD"
    echo "  status <project>    Show project status and next steps"
    echo "  list               List all CMC projects"
    echo "  cd <project>       Navigate to project directory"
    echo ""
    echo "Workflow:"
    echo "  1. cmc new myproject      # Create PRD template"
    echo "  2. cmc review myproject   # Edit PRD"
    echo "  3. cmc approve myproject  # Approve for task generation"
    echo "  4. cmc generate myproject # Generate tasks with Claude"
    echo ""
}

function cmc_new() {
    local project=$1
    
    if [[ -z "$project" ]]; then
        echo "❌ Error: Project name required"
        echo "Usage: cmc new <project-name>"
        return 1
    fi
    
    local project_dir="$PROJECTS_DIR/$project"
    
    if [[ -d "$project_dir" ]]; then
        echo "❌ Error: Project '$project' already exists at $project_dir"
        return 1
    fi
    
    echo "🚀 Creating new CMC project: $project"
    echo "📁 Location: $project_dir"
    
    # Create project structure
    mkdir -p "$project_dir"/{docs,src,tests,scripts,assets}
    
    # Copy PRD template
    if [[ -f "$TEMPLATES_DIR/prd-template.md" ]]; then
        cp "$TEMPLATES_DIR/prd-template.md" "$project_dir/docs/prd.md"
        # Replace placeholder with actual project name
        sed -i.bak "s/{{PROJECT_NAME}}/$project/g" "$project_dir/docs/prd.md" 2>/dev/null || true
        rm -f "$project_dir/docs/prd.md.bak" 2>/dev/null || true
    else
        echo "⚠️  Warning: PRD template not found, creating basic template"        cat > "$project_dir/docs/prd.md" << EOF
# $project - Product Requirements Document

## Project Overview
<!-- Describe what this project does and why it exists -->

## Objectives
<!-- What are the main goals? -->

## Requirements
<!-- What needs to be built? -->

## Technical Specifications
<!-- Technical details, architecture, etc. -->

## Success Criteria
<!-- How will you know this is successful? -->
EOF
    fi
    
    # Create configuration with draft status
    cat > "$project_dir/.cmc-config.json" << EOF
{
  "project": "$project",
  "status": "prd-draft",
  "created": "$(date -Iseconds)",
  "workflow": {
    "require_approval": true,
    "auto_advance": false,
    "current_phase": "prd-creation"
  },
  "paths": {
    "prd": "docs/prd.md",
    "tasks": "docs/tasks.md",
    "src": "src/",
    "tests": "tests/"
  }
}
EOF
    
    # Create README
    cat > "$project_dir/README.md" << EOF
# $project

This is a Claude Master and Commander project.

## Status
📝 PRD Draft - Ready for review

## Next Steps1. Review and edit the PRD: \`cmc review $project\`
2. Approve PRD: \`cmc approve $project\`
3. Generate tasks: \`cmc generate $project\`

## Files
- \`docs/prd.md\` - Product Requirements Document
- \`.cmc-config.json\` - Project configuration and status
EOF
    
    echo ""
    echo "✅ Project created successfully!"
    echo ""
    echo "📋 Project Structure:"
    echo "   $project_dir/"
    echo "   ├── docs/prd.md           # Your PRD template (edit this)"
    echo "   ├── .cmc-config.json      # Project status and config"
    echo "   ├── src/                  # Source code (when ready)"
    echo "   ├── tests/                # Test files"
    echo "   └── assets/               # Static assets"
    echo ""
    echo "🎯 Next Steps:"
    echo "   1. Review PRD: cmc review $project"
    echo "   2. Edit PRD with your project details"
    echo "   3. Approve when ready: cmc approve $project"
    echo ""
    echo "⚠️  Important: Tasks will NOT be generated automatically."
    echo "   Each step requires your explicit approval."
}

function cmc_review() {
    local project=$1
    
    if [[ -z "$project" ]]; then
        echo "❌ Error: Project name required"
        echo "Usage: cmc review <project-name>"
        return 1
    fi
    
    local project_dir="$PROJECTS_DIR/$project"
    local prd_file="$project_dir/docs/prd.md"    
    if [[ ! -f "$prd_file" ]]; then
        echo "❌ Error: Project '$project' not found or missing PRD"
        echo "Available projects: $(ls "$PROJECTS_DIR" 2>/dev/null | tr '\n' ' ')"
        return 1
    fi
    
    echo "📝 Opening PRD for review: $project"
    echo "📁 File: $prd_file"
    
    # Try to open with system default editor
    if command -v open >/dev/null 2>&1; then
        open "$prd_file"
    elif command -v xdg-open >/dev/null 2>&1; then
        xdg-open "$prd_file"
    else
        echo "💡 Open this file in your editor:"
        echo "   $prd_file"
    fi
    
    echo ""
    echo "📖 After reviewing/editing your PRD:"
    echo "   • Save your changes"
    echo "   • Run: cmc approve $project"
}

function cmc_approve() {
    local project=$1
    
    if [[ -z "$project" ]]; then
        echo "❌ Error: Project name required"
        echo "Usage: cmc approve <project-name>"
        return 1
    fi
    
    local project_dir="$PROJECTS_DIR/$project"
    local config_file="$project_dir/.cmc-config.json"
    local prd_file="$project_dir/docs/prd.md"    
    if [[ ! -f "$config_file" ]]; then
        echo "❌ Error: Project '$project' not found"
        return 1
    fi
    
    local current_status=$(jq -r '.status' "$config_file")
    
    if [[ "$current_status" != "prd-draft" ]]; then
        echo "ℹ️  Project status: $current_status"
        if [[ "$current_status" == "prd-approved" ]]; then
            echo "✅ PRD already approved. Ready for task generation."
            echo "   Run: cmc generate $project"
            return 0
        fi
    fi
    
    echo "📋 PRD Review for: $project"
    echo "=================================="
    echo ""
    
    # Show PRD preview
    if [[ -f "$prd_file" ]]; then
        echo "📄 PRD Preview (first 20 lines):"
        echo "---"
        head -20 "$prd_file"
        echo "---"
        echo ""
        
        local line_count=$(wc -l < "$prd_file")
        echo "📊 PRD Stats: $line_count lines total"
    else
        echo "❌ PRD file not found: $prd_file"
        return 1
    fi    
    echo ""
    echo "🤔 Review Questions:"
    echo "   • Does the PRD clearly describe what needs to be built?"
    echo "   • Are the requirements specific and actionable?"
    echo "   • Is the scope well-defined?"
    echo ""
    
    read -p "✅ Approve this PRD and proceed to task generation? (y/N): " -r response
    
    if [[ $response =~ ^[Yy]$ ]]; then
        # Update status to approved
        local temp_file=$(mktemp)
        jq '.status = "prd-approved" | .workflow.current_phase = "ready-for-tasks" | .approved = now | .approved_by = "user"' "$config_file" > "$temp_file" && mv "$temp_file" "$config_file"
        
        echo ""
        echo "✅ PRD Approved!"
        echo "📊 Status updated to: prd-approved"
        echo ""
        echo "🎯 Next Step:"
        echo "   Generate task breakdown: cmc generate $project"
        echo ""
        echo "💡 This will use Claude AI to analyze your PRD and create"
        echo "   a detailed breakdown of implementation tasks."
    else
        echo ""
        echo "📝 PRD approval cancelled."
        echo "💡 Continue editing: cmc review $project"
        echo "   Then approve when ready: cmc approve $project"
        echo ""
        echo "📄 PRD location: $prd_file"
    fi
}
function cmc_generate() {
    local project=$1
    
    if [[ -z "$project" ]]; then
        echo "❌ Error: Project name required"
        echo "Usage: cmc generate <project-name>"
        return 1
    fi
    
    local project_dir="$PROJECTS_DIR/$project"
    local config_file="$project_dir/.cmc-config.json"
    local prd_file="$project_dir/docs/prd.md"
    local tasks_file="$project_dir/docs/tasks.md"
    
    if [[ ! -f "$config_file" ]]; then
        echo "❌ Error: Project '$project' not found"
        return 1
    fi
    
    local current_status=$(jq -r '.status' "$config_file")
    
    if [[ "$current_status" != "prd-approved" ]]; then
        echo "❌ Error: PRD must be approved first"
        echo "📊 Current status: $current_status"
        echo "💡 Run: cmc approve $project"
        return 1
    fi
    
    echo "🤖 AI Task Generation for: $project"
    echo "=================================="
    echo ""
    echo "This will use Claude AI to:"
    echo "• Analyze your PRD requirements"
    echo "• Break down work into specific tasks"
    echo "• Create an implementation roadmap"
    echo "• Generate development guidance"    echo ""
    echo "⚠️  Important: This is AI task generation only."
    echo "   No code will be generated automatically."
    echo "   You'll review tasks before any implementation."
    echo ""
    
    read -p "🚀 Continue with AI task generation? (y/N): " -r response
    
    if [[ $response =~ ^[Yy]$ ]]; then
        echo ""
        echo "🔄 Generating tasks..."
        echo "📄 Analyzing PRD: $prd_file"
        
        # Check if task generator exists
        local task_generator="$CMC_ROOT/scripts/cmc-task-generator.js"
        if [[ -f "$task_generator" ]]; then
            echo "🤖 Running AI task generator..."
            
            # Run the task generator
            if node "$task_generator" "$prd_file" "$tasks_file"; then
                # Update project status
                local temp_file=$(mktemp)
                jq '.status = "tasks-generated" | .workflow.current_phase = "development-ready" | .tasks_generated = now' "$config_file" > "$temp_file" && mv "$temp_file" "$config_file"
                
                echo ""
                echo "✅ Task generation complete!"
                echo "📋 Tasks saved to: $tasks_file"
                echo "📊 Status updated to: tasks-generated"
                echo ""
                echo "🎯 Next Steps:"
                echo "   1. Review tasks: cmc status $project"
                echo "   2. Navigate to project: cmc cd $project"
                echo "   3. Begin development with Claude's help"                echo ""
                echo "💡 When working in the project directory, ask Claude to:"
                echo "   'Help me implement [specific task] from the task list'"
            else
                echo "❌ Error: Task generation failed"
                echo "💡 Check that Node.js is installed and task generator is working"
                return 1
            fi
        else
            echo "❌ Error: Task generator not found at $task_generator"
            echo "💡 You can manually create tasks or ask Claude to help analyze your PRD"
            return 1
        fi
    else
        echo ""
        echo "⏸️  Task generation cancelled."
        echo "💡 Generate tasks later: cmc generate $project"
    fi
}

function cmc_status() {
    local project=$1
    
    if [[ -z "$project" ]]; then
        echo "❌ Error: Project name required"
        echo "Usage: cmc status <project-name>"
        return 1
    fi
    
    local project_dir="$PROJECTS_DIR/$project"
    local config_file="$project_dir/.cmc-config.json"
    
    if [[ ! -f "$config_file" ]]; then
        echo "❌ Error: Project '$project' not found"
        echo "Available projects:"
        cmc_list
        return 1
    fi    
    local current_status=$(jq -r '.status' "$config_file")
    local project_name=$(jq -r '.project' "$config_file")
    local created=$(jq -r '.created' "$config_file")
    local current_phase=$(jq -r '.workflow.current_phase' "$config_file")
    
    echo "📊 Project Status: $project_name"
    echo "=================================="
    echo "📍 Location: $project_dir"
    echo "📅 Created: $created"
    echo "📋 Status: $current_status"
    echo "🎯 Phase: $current_phase"
    echo ""
    
    # Phase-specific information and next steps
    case $current_status in
        "prd-draft")
            echo "📝 Current Phase: PRD Development"
            echo "   Status: Draft in progress"
            echo ""
            echo "🎯 Next Actions:"
            echo "   1. Review/edit PRD: cmc review $project"
            echo "   2. Approve when ready: cmc approve $project"
            echo ""
            echo "📄 PRD Location: $project_dir/docs/prd.md"
            ;;
            
        "prd-approved")
            echo "✅ Current Phase: PRD Approved"
            echo "   Status: Ready for task generation"
            echo ""
            echo "🎯 Next Action:"
            echo "   Generate task breakdown: cmc generate $project"            echo ""
            echo "📄 Files:"
            echo "   • PRD: $project_dir/docs/prd.md"
            ;;
            
        "tasks-generated")
            echo "🚀 Current Phase: Development Ready"
            echo "   Status: Tasks generated, ready to build"
            echo ""
            echo "🎯 Next Actions:"
            echo "   1. Navigate to project: cmc cd $project"
            echo "   2. Review tasks and begin development"
            echo ""
            echo "📄 Files:"
            echo "   • PRD: $project_dir/docs/prd.md"
            echo "   • Tasks: $project_dir/docs/tasks.md"
            echo ""
            echo "💡 Development Tips:"
            echo "   • Work in project directory for best Claude context"
            echo "   • Ask Claude: 'Help me with [specific task]'"
            echo "   • Implement one component at a time"
            ;;
            
        *)
            echo "❓ Unknown status: $current_status"
            ;;
    esac
    
    echo ""
    echo "📁 Project Structure:"
    if [[ -f "$project_dir/docs/prd.md" ]]; then
        echo "   ✅ PRD: docs/prd.md"
    else
        echo "   ❌ PRD: missing"
    fi    
    if [[ -f "$project_dir/docs/tasks.md" ]]; then
        echo "   ✅ Tasks: docs/tasks.md"
    else
        echo "   ⏳ Tasks: not generated yet"
    fi
    
    # Show source files if any exist
    local src_count=$(find "$project_dir/src" -name "*.js" -o -name "*.py" -o -name "*.ts" -o -name "*.html" -o -name "*.css" 2>/dev/null | wc -l)
    if [[ $src_count -gt 0 ]]; then
        echo "   📁 Source: $src_count files in src/"
    else
        echo "   📁 Source: empty (ready for development)"
    fi
}

function cmc_list() {
    echo "📋 CMC Projects"
    echo "==============="
    
    if [[ ! -d "$PROJECTS_DIR" ]] || [[ -z "$(ls -A "$PROJECTS_DIR" 2>/dev/null)" ]]; then
        echo "No projects found."
        echo ""
        echo "💡 Create your first project:"
        echo "   cmc new my-first-project"
        return 0
    fi
    
    echo "📁 Location: $PROJECTS_DIR"
    echo ""
    
    for project_path in "$PROJECTS_DIR"/*; do
        if [[ -d "$project_path" ]]; then
            local project_name=$(basename "$project_path")
            local config_file="$project_path/.cmc-config.json"            
            if [[ -f "$config_file" ]]; then
                local status=$(jq -r '.status' "$config_file" 2>/dev/null || echo "unknown")
                local created=$(jq -r '.created' "$config_file" 2>/dev/null || echo "unknown")
                
                # Status emoji
                local status_emoji
                case $status in
                    "prd-draft") status_emoji="📝" ;;
                    "prd-approved") status_emoji="✅" ;;
                    "tasks-generated") status_emoji="🚀" ;;
                    *) status_emoji="❓" ;;
                esac
                
                printf "   %s %-20s %s\n" "$status_emoji" "$project_name" "$status"
            else
                printf "   ❓ %-20s %s\n" "$project_name" "invalid (no config)"
            fi
        fi
    done
    
    echo ""
    echo "Commands:"
    echo "   cmc status <project>  # View project details"
    echo "   cmc cd <project>      # Navigate to project"
}

function cmc_cd() {
    local project=$1
    
    if [[ -z "$project" ]]; then
        echo "❌ Error: Project name required"
        echo "Usage: cmc cd <project-name>"
        return 1
    fi    
    local project_dir="$PROJECTS_DIR/$project"
    
    if [[ ! -d "$project_dir" ]]; then
        echo "❌ Error: Project '$project' not found"
        return 1
    fi
    
    echo "📁 Navigating to: $project_dir"
    echo ""
    echo "💡 Once in the project directory, you can:"
    echo "   • Ask Claude to help with specific tasks"
    echo "   • Review files: ls -la"
    echo "   • Check status: cmc status $project"
    
    # Change to project directory
    cd "$project_dir"
    
    # If running in interactive shell, spawn new shell in project directory
    if [[ $- == *i* ]]; then
        exec "$SHELL"
    fi
}

# Main command router
case "${1:-help}" in
    "new")      cmc_new "$2" ;;
    "review")   cmc_review "$2" ;;
    "approve")  cmc_approve "$2" ;;
    "generate") cmc_generate "$2" ;;
    "status")   cmc_status "$2" ;;
    "list")     cmc_list ;;
    "cd")       cmc_cd "$2" ;;
    "help"|"-h"|"--help") show_usage ;;
    *)          
        echo "❌ Unknown command: $1"
        echo ""
        show_usage
        exit 1
        ;;
esac