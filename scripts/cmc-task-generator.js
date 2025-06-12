#!/usr/bin/env node

/**
 * CMC Task Generator
 * Analyzes PRD and generates task breakdown with Claude-friendly prompts
 * Location: /Users/joshparks/Github/jparkypark/claude-master-and-commander/scripts/cmc-task-generator.js
 */

const fs = require('fs');
const path = require('path');

function generateTasksFromPRD(prdPath, outputPath) {
    try {
        // Read PRD content
        if (!fs.existsSync(prdPath)) {
            console.error(`❌ Error: PRD file not found: ${prdPath}`);
            process.exit(1);
        }
        
        const prdContent = fs.readFileSync(prdPath, 'utf8');
        const projectName = path.basename(path.dirname(path.dirname(prdPath)));
        
        // Generate structured task breakdown
        const tasksContent = generateTasksMarkdown(prdContent, projectName);
        
        // Write tasks file
        fs.writeFileSync(outputPath, tasksContent);
        
        console.log(`✅ Tasks generated successfully`);
        console.log(`📋 File: ${outputPath}`);
        console.log(`📊 Content: ${tasksContent.split('\n').length} lines`);
        
        return true;
        
    } catch (error) {
        console.error(`❌ Error generating tasks:`, error.message);
        return false;
    }
}
function generateTasksMarkdown(prdContent, projectName) {
    const timestamp = new Date().toISOString();
    
    return `# ${projectName} - Task Breakdown

> **Generated**: ${timestamp}  
> **Source**: PRD Analysis  
> **Status**: Ready for Development  

## 🚨 Important Development Guidelines

### For Claude AI Assistance
When working with Claude on this project, use these structured prompts:

\`\`\`
"I'm working on the ${projectName} project. Here's the specific task I need help with:

[SPECIFIC TASK FROM LIST BELOW]

Please help me implement this ONE task only. Do not automatically proceed to other tasks. 
After completing this task, ask me what I'd like to work on next."
\`\`\`

### Workflow Rules
- ✅ **Work on ONE task at a time**
- ✅ **Ask for next steps after each task**
- ❌ **Do NOT auto-implement multiple tasks**
- ❌ **Do NOT proceed without confirmation**

---

## 📋 Task Categories

### Phase 1: Foundation & Setup
**Status**: 🏗️ Infrastructure

#### TASK-001: Project Architecture
- [ ] Define project structure and file organization
- [ ] Set up development environment configuration
- [ ] Create basic project scaffolding
- [ ] Document architectural decisions

**Claude Prompt**: *"Help me set up the basic project architecture for ${projectName}. I need help with project structure and initial setup only."*
#### TASK-002: Core Dependencies
- [ ] Identify and install required dependencies
- [ ] Set up package management (package.json, requirements.txt, etc.)
- [ ] Configure development tools (linting, formatting)
- [ ] Set up version control configuration

**Claude Prompt**: *"Help me identify and set up the core dependencies for ${projectName}. Focus only on essential packages needed for the foundation."*

### Phase 2: Core Development
**Status**: ⏳ Pending Foundation

#### TASK-003: Primary Components
- [ ] Implement main application logic based on PRD requirements
- [ ] Create core data structures and models
- [ ] Build primary user interface components
- [ ] Implement essential business logic

**Claude Prompt**: *"Help me implement the core components for ${projectName}. I want to work on [SPECIFIC COMPONENT] from the PRD requirements."*

#### TASK-004: Data Management
- [ ] Set up data storage/persistence layer
- [ ] Implement data validation and sanitization
- [ ] Create data access patterns
- [ ] Handle data relationships and constraints

**Claude Prompt**: *"Help me implement the data management layer for ${projectName}. Focus on [SPECIFIC DATA REQUIREMENT] from the PRD."*

### Phase 3: Integration & Features
**Status**: ⏳ Pending Core Development

#### TASK-005: Feature Implementation
- [ ] Build specific features outlined in PRD
- [ ] Implement user interactions and workflows
- [ ] Add business logic and validation rules
- [ ] Create feature-specific components

**Claude Prompt**: *"Help me implement [SPECIFIC FEATURE] for ${projectName}. This should focus only on this one feature from the PRD."*
#### TASK-006: API/Integration Layer
- [ ] Design and implement API endpoints (if applicable)
- [ ] Set up external service integrations
- [ ] Handle authentication and authorization
- [ ] Implement error handling and responses

**Claude Prompt**: *"Help me build the API integration for ${projectName}. I need help with [SPECIFIC INTEGRATION] only."*

### Phase 4: Testing & Quality
**Status**: ⏳ Pending Feature Development

#### TASK-007: Testing Implementation
- [ ] Set up testing framework and configuration
- [ ] Write unit tests for core components
- [ ] Create integration tests for workflows
- [ ] Implement end-to-end testing scenarios

**Claude Prompt**: *"Help me set up testing for ${projectName}. Focus on testing [SPECIFIC COMPONENT/FEATURE] only."*

#### TASK-008: Quality Assurance
- [ ] Code review and refactoring
- [ ] Performance optimization
- [ ] Security audit and improvements
- [ ] Documentation and code comments

**Claude Prompt**: *"Help me review and improve the code quality for [SPECIFIC PART] of ${projectName}."*

### Phase 5: Deployment & Documentation
**Status**: ⏳ Pending Testing

#### TASK-009: Deployment Preparation
- [ ] Set up build and deployment processes
- [ ] Configure production environment
- [ ] Implement monitoring and logging
- [ ] Create deployment documentation

**Claude Prompt**: *"Help me prepare ${projectName} for deployment. Focus on [SPECIFIC DEPLOYMENT ASPECT] only."*
#### TASK-010: Documentation & Handoff
- [ ] Create user documentation
- [ ] Write technical documentation
- [ ] Prepare development handoff materials
- [ ] Create maintenance and support guides

**Claude Prompt**: *"Help me create documentation for ${projectName}. I need help with [SPECIFIC DOCUMENTATION TYPE] only."*

---

## 📊 Development Tracking

### Progress Overview
- **Total Tasks**: 10 major tasks
- **Estimated Phases**: 5 phases
- **Current Phase**: Foundation & Setup
- **Next Milestone**: Complete TASK-001 and TASK-002

### Task Dependencies
1. **Foundation** (TASK-001, TASK-002) → **Core Development**
2. **Core Development** (TASK-003, TASK-004) → **Integration & Features**  
3. **Integration & Features** (TASK-005, TASK-006) → **Testing & Quality**
4. **Testing & Quality** (TASK-007, TASK-008) → **Deployment & Documentation**
5. **Deployment & Documentation** (TASK-009, TASK-010) → **Project Complete**

---

## 🎯 Getting Started

### Immediate Next Steps
1. **Review this task breakdown** with the PRD requirements
2. **Start with TASK-001**: Project Architecture
3. **Use the provided Claude prompts** for focused assistance
4. **Complete one task before moving to the next**

### Working with Claude
When you're ready to work on a specific task:

1. **Navigate to your project directory**
2. **Use the specific Claude prompt** provided for that task
3. **Focus on ONE task at a time**
4. **Ask Claude to stop and confirm** before proceeding to next task
### Example Interaction
\`\`\`
You: "I'm working on ${projectName}. Help me with TASK-001: Project Architecture. 
     I need help setting up the basic project structure only."

Claude: [Provides architecture help]
       "Task completed! What would you like to work on next?"

You: "Now help me with TASK-002: Core Dependencies"
\`\`\`

---

## 📝 Original PRD Reference

<details>
<summary>Click to view original PRD content</summary>

\`\`\`markdown
${prdContent}
\`\`\`

</details>

---

**Generated by Claude Master and Commander Task Generator**  
*This task breakdown is designed to work with Claude AI assistance while preventing automatic task execution.*`;
}

// Main execution
if (require.main === module) {
    const args = process.argv.slice(2);
    
    if (args.length !== 2) {
        console.error('Usage: node cmc-task-generator.js <prd-file> <output-file>');
        process.exit(1);
    }
    
    const [prdPath, outputPath] = args;
    const success = generateTasksFromPRD(prdPath, outputPath);
    
    process.exit(success ? 0 : 1);
}

module.exports = { generateTasksFromPRD };