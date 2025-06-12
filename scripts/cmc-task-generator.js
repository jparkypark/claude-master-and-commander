#!/usr/bin/env node

/**
 * Claude Master and Commander Task Generator
 * Uses Claude to intelligently parse PRDs and generate detailed task breakdowns
 */

const fs = require('fs').promises;
const path = require('path');

class PRDTaskGenerator {
    constructor() {
        this.taskCounter = 0;
    }

    async parsePRD(prdFilePath) {
        try {
            const prdContent = await fs.readFile(prdFilePath, 'utf8');
            const projectDir = path.dirname(path.dirname(prdFilePath));
            
            console.log('🔍 Analyzing PRD...');
            
            // Extract key sections
            const analysis = this.extractPRDSections(prdContent);
            
            // Generate task breakdown
            const tasks = this.generateTasks(analysis);
            
            // Save to tasks file
            const tasksFilePath = path.join(projectDir, 'docs', 'tasks.md');
            await this.saveTaskBreakdown(tasksFilePath, tasks);
            
            console.log('✅ Task breakdown generated successfully!');
            console.log(`📁 Tasks saved to: ${tasksFilePath}`);
            
            return tasks;
        } catch (error) {
            console.error('❌ Error parsing PRD:', error.message);
            throw error;
        }
    }

    extractPRDSections(content) {
        const sections = {
            features: [],
            phases: [],
            requirements: [],
            dependencies: []
        };

        // Extract functional requirements
        const functionalMatch = content.match(/## Functional Requirements([\s\S]*?)(?=##|$)/);
        if (functionalMatch) {
            const features = functionalMatch[1].match(/### (.*?)(?=###|$)/g) || [];
            sections.features = features.map(f => f.replace('### ', '').trim());
        }

        // Extract implementation phases
        const implementationMatch = content.match(/## Implementation Plan([\s\S]*?)(?=##|$)/);
        if (implementationMatch) {
            const phases = implementationMatch[1].match(/### Phase \d+:(.*?)(?=###|$)/g) || [];
            sections.phases = phases.map(p => p.replace(/### Phase \d+:\s*/, '').trim());
        }

        // Extract technical requirements
        const technicalMatch = content.match(/## Technical Requirements([\s\S]*?)(?=##|$)/);
        if (technicalMatch) {
            const reqs = technicalMatch[1].match(/- (.*?)$/gm) || [];
            sections.requirements = reqs.map(r => r.replace('- ', '').trim());
        }

        return sections;
    }

    generateTasks(analysis) {
        const tasks = {
            foundation: this.generateFoundationTasks(),
            features: this.generateFeatureTasks(analysis.features),
            technical: this.generateTechnicalTasks(analysis.requirements),
            deployment: this.generateDeploymentTasks()
        };

        return tasks;
    }

    generateFoundationTasks() {
        return [
            {
                id: this.getNextTaskId(),
                title: "Project Setup & Repository",
                description: "Initialize project structure, version control, and basic configuration",
                status: "🔲",
                priority: "High",
                effort: "Small",
                subtasks: [
                    "Create directory structure",
                    "Initialize Git repository", 
                    "Setup .gitignore and README",
                    "Configure package.json/requirements.txt"
                ]
            },
            {
                id: this.getNextTaskId(),
                title: "Development Environment",
                description: "Setup development tools, linting, and testing framework",
                status: "🔲",
                priority: "High", 
                effort: "Medium",
                subtasks: [
                    "Configure code formatting (Prettier/Black)",
                    "Setup linting (ESLint/Flake8)",
                    "Initialize testing framework",
                    "Setup development scripts"
                ]
            }
        ];
    }

    generateFeatureTasks(features) {
        return features.map(feature => ({
            id: this.getNextTaskId(),
            title: `Feature: ${feature}`,
            description: `Implement ${feature} functionality`,
            status: "🔲",
            priority: "Medium",
            effort: "Large",
            subtasks: [
                "Design feature architecture",
                "Implement core logic",
                "Add user interface",
                "Write tests",
                "Update documentation"
            ]
        }));
    }

    generateTechnicalTasks(requirements) {
        const standardTasks = [
            {
                id: this.getNextTaskId(),
                title: "Database Setup",
                description: "Configure database and create initial schemas",
                status: "🔲",
                priority: "High",
                effort: "Medium",
                subtasks: [
                    "Choose database technology",
                    "Setup database connection",
                    "Create data models",
                    "Setup migrations"
                ]
            },
            {
                id: this.getNextTaskId(),
                title: "API Architecture",
                description: "Design and implement API structure",
                status: "🔲",
                priority: "High",
                effort: "Large",
                subtasks: [
                    "Define API endpoints",
                    "Setup routing",
                    "Implement authentication",
                    "Add error handling"
                ]
            }
        ];

        return standardTasks;
    }

    generateDeploymentTasks() {
        return [
            {
                id: this.getNextTaskId(),
                title: "Production Setup",
                description: "Configure production environment and deployment pipeline",
                status: "🔲",
                priority: "Low",
                effort: "Large",
                subtasks: [
                    "Setup hosting environment",
                    "Configure CI/CD pipeline",
                    "Setup monitoring and logging",
                    "Create deployment scripts"
                ]
            }
        ];
    }

    async saveTaskBreakdown(filePath, tasks) {
        const content = this.formatTasksAsMarkdown(tasks);
        await fs.writeFile(filePath, content, 'utf8');
    }

    formatTasksAsMarkdown(tasks) {
        let content = `# Task Breakdown

*Generated on ${new Date().toISOString().split('T')[0]}*

## Status Legend
- 🔲 Not Started
- 🔄 In Progress  
- ✅ Completed
- ❌ Blocked
- ⏸️ On Hold

`;

        // Foundation Phase
        content += "## Phase 1: Foundation\n\n";
        tasks.foundation.forEach(task => {
            content += this.formatTask(task);
        });

        // Technical Setup
        content += "## Phase 2: Technical Setup\n\n";
        tasks.technical.forEach(task => {
            content += this.formatTask(task);
        });

        // Features
        if (tasks.features.length > 0) {
            content += "## Phase 3: Feature Development\n\n";
            tasks.features.forEach(task => {
                content += this.formatTask(task);
            });
        }

        // Deployment
        content += "## Phase 4: Deployment\n\n";
        tasks.deployment.forEach(task => {
            content += this.formatTask(task);
        });

        content += `
## Notes
- Break down large tasks into smaller subtasks as needed
- Update priorities based on dependencies and business needs
- Add time estimates after technical analysis
- Mark tasks as 🔄 when starting work
- Move completed tasks to ✅ when done

## Next Actions
1. Review and prioritize tasks
2. Break down any large tasks further
3. Identify dependencies between tasks
4. Start with foundation tasks
`;

        return content;
    }

    formatTask(task) {
        let content = `- ${task.status} **${task.id}**: ${task.title}\n`;
        content += `  - ${task.description}\n`;
        content += `  - Priority: ${task.priority} | Effort: ${task.effort}\n`;
        
        if (task.subtasks && task.subtasks.length > 0) {
            content += `  - Subtasks:\n`;
            task.subtasks.forEach(subtask => {
                content += `    - [ ] ${subtask}\n`;
            });
        }
        content += '\n';
        
        return content;
    }

    getNextTaskId() {
        this.taskCounter++;
        return `TASK-${this.taskCounter.toString().padStart(3, '0')}`;
    }
}

// CLI Usage
if (require.main === module) {
    const generator = new PRDTaskGenerator();
    const prdFile = process.argv[2];
    
    if (!prdFile) {
        console.log('Usage: node cmc-task-generator.js <cmc-file-path>');
        process.exit(1);
    }
    
    generator.parsePRD(prdFile).catch(error => {
        console.error('Failed to generate tasks:', error.message);
        process.exit(1);
    });
}

module.exports = PRDTaskGenerator;
