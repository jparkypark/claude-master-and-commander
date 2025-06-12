#!/bin/bash

# Claude Master and Commander Integration Script
# Integrates Claude Master and Commander workflow with Claude Desktop Commander

WORKFLOW_DIR="$HOME/.claude-master-and-commander"
CLAUDE_CONFIG="$HOME/.claude-server-commander"

# Add Claude Master and Commander workflow to shell profile
setup_shell_integration() {
    local shell_rc=""
    if [[ "$SHELL" == *"zsh"* ]]; then
        shell_rc="$HOME/.zshrc"
    elif [[ "$SHELL" == *"bash"* ]]; then
        shell_rc="$HOME/.bashrc"
    else
        echo "Unsupported shell. Please add manually."
        return 1
    fi
    
    # Check if already added
    if grep -q "Claude Master and Commander" "$shell_rc" 2>/dev/null; then
        echo "Claude Master and Commander workflow already integrated in shell."
        return 0
    fi
    
    cat >> "$shell_rc" << 'EOF'

# Claude Master and Commander Integration
export WORKFLOW_DIR="$HOME/.claude-master-and-commander"
alias prd="$WORKFLOW_DIR/scripts/prd-helper.sh"
alias prd-new="$WORKFLOW_DIR/scripts/prd-helper.sh new"
alias prd-parse="$WORKFLOW_DIR/scripts/prd-helper.sh parse"
alias prd-status="$WORKFLOW_DIR/scripts/prd-helper.sh status"
alias prd-list="$WORKFLOW_DIR/scripts/prd-helper.sh list"

# Claude-enhanced task generation
prd-generate() {
    if [[ -z "$1" ]]; then
        echo "Usage: prd-generate <path-to-prd.md>"
        return 1
    fi
    node "$WORKFLOW_DIR/scripts/prd-task-generator.js" "$1"
}

# Quick project navigation
prd-cd() {
    local project="$1"
    if [[ -z "$project" ]]; then
        echo "Available projects:"
        "$WORKFLOW_DIR/scripts/prd-helper.sh" list
        return 1
    fi
    
    local project_path="$HOME/Projects/$project"
    if [[ -d "$project_path" ]]; then
        cd "$project_path"
        echo "📁 Switched to project: $project"
        
        # Show status if it's a PRD project
        if [[ -f ".prd-config.json" ]]; then
            "$WORKFLOW_DIR/scripts/prd-helper.sh" status .
        fi
    else
        echo "❌ Project not found: $project"
        echo "Available projects:"
        "$WORKFLOW_DIR/scripts/prd-helper.sh" list
    fi
}

EOF
    
    echo "✅ Shell integration added to $shell_rc"
    echo "🔄 Run 'source $shell_rc' or restart your terminal to use new commands"
}

# Create example project
create_example_project() {
    echo "🚀 Creating example project to demonstrate Claude Master and Commander workflow..."
    
    "$WORKFLOW_DIR/scripts/prd-helper.sh" new "example-todo-app"
    
    # Create a sample PRD
    local example_prd="$HOME/Projects/example-todo-app/docs/prd.md"
    
    cat > "$example_prd" << 'EOF'
# Product Requirements Document (PRD)

## Project Overview
**Project Name:** Todo App with AI Assistant
**Version:** 1.0
**Date:** 2025-06-11
**Author:** Josh Parks

## Executive Summary
A modern todo application that leverages AI to help users organize, prioritize, and complete their tasks more effectively.

## Problem Statement
- Users struggle with task prioritization and organization
- Existing todo apps lack intelligent assistance
- No automated task breakdown for complex projects

## Solution Overview
- AI-powered task prioritization and suggestions
- Intelligent task breakdown for complex projects
- Natural language task creation
- Smart scheduling and reminders

## Target Users
- Busy professionals managing multiple projects
- Students organizing coursework and assignments
- Anyone looking to improve productivity with AI assistance

## Functional Requirements

### Core Features
1. **Task Management**
   - Description: Basic CRUD operations for tasks
   - User Story: As a user, I want to create, edit, and delete tasks so that I can manage my workload
   - Acceptance Criteria: 
     - [ ] Create tasks with title, description, due date
     - [ ] Edit existing tasks
     - [ ] Mark tasks as complete
     - [ ] Delete tasks
   - Priority: High
   - Estimated Effort: Medium

2. **AI Task Assistant**
   - Description: AI-powered task suggestions and prioritization
   - User Story: As a user, I want AI to help prioritize my tasks so that I focus on what's most important
   - Acceptance Criteria:
     - [ ] AI analyzes task context and suggests priorities
     - [ ] Natural language task creation
     - [ ] Intelligent task breakdown for complex items
   - Priority: High
   - Estimated Effort: Large

3. **Smart Scheduling**
   - Description: Intelligent scheduling based on user patterns and deadlines
   - User Story: As a user, I want the app to suggest optimal times for task completion
   - Acceptance Criteria:
     - [ ] Analyze user productivity patterns
     - [ ] Suggest optimal scheduling
     - [ ] Send smart reminders
   - Priority: Medium
   - Estimated Effort: Large

## Technical Requirements

### Architecture
- Frontend: React with TypeScript
- Backend: Node.js with Express
- Database: PostgreSQL
- AI Integration: Claude API
- Authentication: JWT with refresh tokens

### Performance Requirements
- Page load time < 2 seconds
- AI response time < 3 seconds
- Support 1000+ concurrent users

## Implementation Plan

### Phase 1: Foundation
- [ ] Setup project structure and development environment
- [ ] Configure database and basic authentication
- [ ] Create core data models
- [ ] Setup CI/CD pipeline

### Phase 2: Core Features
- [ ] Implement basic task CRUD operations
- [ ] Create user interface for task management
- [ ] Add user authentication and authorization
- [ ] Setup basic API endpoints

### Phase 3: AI Integration
- [ ] Integrate Claude API for task assistance
- [ ] Implement natural language task processing
- [ ] Add AI-powered prioritization
- [ ] Create intelligent task breakdown feature

### Phase 4: Enhancement & Deployment
- [ ] Add smart scheduling features
- [ ] Implement real-time notifications
- [ ] Performance optimization
- [ ] Production deployment and monitoring

## Success Metrics
- User task completion rate > 75%
- Daily active users > 1000 within 3 months
- AI suggestion acceptance rate > 60%
- Average session time > 10 minutes
EOF
    
    echo "✅ Example project created with sample PRD"
    echo "📁 Location: $HOME/Projects/example-todo-app"
    echo "📝 Next steps:"
    echo "1. Run: prd-generate $example_prd"
    echo "2. Run: prd-status $HOME/Projects/example-todo-app"
}

# Main setup function
main() {
    echo "🔧 Setting up Claude Master and Commander workflow with Claude Desktop Commander..."
    echo
    
    # Check prerequisites
    if ! command -v node &> /dev/null; then
        echo "❌ Node.js is required but not installed."
        echo "Please install Node.js and try again."
        exit 1
    fi
    
    # Create Projects directory if it doesn't exist
    mkdir -p "$HOME/Projects"
    
    # Setup shell integration
    setup_shell_integration
    
    # Create example project
    read -p "Create example project? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        create_example_project
    fi
    
    echo
    echo "🎉 Claude Master and Commander workflow setup complete!"
    echo
    echo "📚 Available commands:"
    echo "  prd new <project-name>    - Create new PRD project"
    echo "  prd-generate <prd-file>   - Generate tasks from PRD using Claude"
    echo "  prd-status <project-dir>  - Show project status"
    echo "  prd-list                  - List all PRD projects"
    echo "  prd-cd <project-name>     - Navigate to project directory"
    echo
    echo "💡 Pro tip: Use Claude Desktop Commander with these workflows:"
    echo "  - Ask Claude to analyze your PRD and suggest improvements"
    echo "  - Use Claude to break down complex tasks into subtasks"
    echo "  - Let Claude help prioritize tasks based on dependencies"
    echo "  - Ask Claude to generate code for specific tasks"
    echo
    echo "🔄 Restart your terminal or run 'source ~/.zshrc' to use new commands"
}

# Run main function
main "$@"
