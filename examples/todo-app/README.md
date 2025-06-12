# Todo App Example

This example demonstrates the complete Claude Master and Commander process, from initial PRD creation to task breakdown and development planning.

## Project Overview

**Type:** Web Application  
**Technology Stack:** React, Node.js, PostgreSQL  
**AI Integration:** Claude API for intelligent task assistance  
**Development Time:** Estimated 4-6 weeks  

## Files Included

- **[prd.md](docs/prd.md)** - Complete Product Requirements Document
- **[tasks.md](docs/tasks.md)** - Generated task breakdown with priorities
- **[.cmc-config.json](.cmc-config.json)** - Project metadata and configuration
- **scripts/** - Project-specific development scripts
- **src/** - Source code structure (scaffolded)
- **tests/** - Test framework setup

## Learning Objectives

This example shows you how to:

1. **Write a comprehensive PRD** with clear requirements
2. **Generate actionable tasks** from high-level requirements
3. **Structure a development project** with proper organization
4. **Integrate AI assistance** throughout the development process
5. **Track progress** with visual indicators and status updates

## Key Features Demonstrated

### PRD Best Practices
- Clear problem statement and solution approach
- Detailed user stories with acceptance criteria  
- Technical architecture decisions
- Phased implementation plan
- Measurable success metrics

### Task Management
- Automatic task generation from PRD functional requirements
- Priority and effort estimation
- Phase-based organization (Foundation → Features → Deployment)
- Visual status tracking with emoji indicators

### AI Integration Patterns
- PRD analysis and improvement suggestions
- Task breakdown and refinement
- Code generation for specific components
- Architecture guidance and best practices

## Using This Example

### 1. Study the PRD Structure

Open `docs/prd.md` to see:
- How problems are clearly defined
- User story formatting: "As a [user], I want [goal] so that [benefit]"
- Technical requirements and constraints
- Success criteria and metrics

### 2. Examine Task Breakdown

Review `docs/tasks.md` to understand:
- How PRD requirements become actionable tasks
- Task prioritization and effort estimation
- Subtask breakdown for complex features
- Progress tracking with status indicators

### 3. Try the Workflow

```bash
# Navigate to the example
cd examples/todo-app

# Check project status
cmc-status .

# Generate your own task breakdown
cmc-generate docs/prd.md

# Ask Claude for development guidance
# "Claude, review this PRD and suggest implementation priorities"
```

### 4. Adapt for Your Projects

Use this example as a template:
- Copy the PRD structure for similar web applications
- Adapt the task categories for your technology stack
- Modify success metrics for your specific goals
- Customize the project structure as needed

## Development Phases

### Phase 1: Foundation (1-2 weeks)
- Project setup and tooling
- Database design and setup  
- Basic authentication system
- Development environment configuration

### Phase 2: Core Features (2-3 weeks)
- Task CRUD operations
- User interface development
- Basic AI integration
- Testing framework implementation

### Phase 3: AI Enhancement (1-2 weeks)  
- Advanced AI task assistance
- Natural language processing
- Intelligent prioritization
- Smart scheduling features

### Phase 4: Deployment (1 week)
- Production environment setup
- Performance optimization
- Monitoring and alerting
- User documentation

## Technical Highlights

### Architecture Decisions
- **Frontend:** React with TypeScript for type safety
- **Backend:** Node.js with Express for API development
- **Database:** PostgreSQL for reliable data storage
- **AI Integration:** Claude API for intelligent features
- **Authentication:** JWT tokens with refresh mechanism

### Key Integrations
- Claude API for task analysis and suggestions
- PostgreSQL for structured data storage
- JWT authentication for secure user sessions
- Real-time updates for collaborative features

## Success Metrics

The example PRD defines clear success criteria:
- **User Engagement:** 75% task completion rate
- **Growth:** 1000+ daily active users within 3 months  
- **AI Effectiveness:** 60% AI suggestion acceptance rate
- **User Experience:** 10+ minute average session time

## Next Steps

After studying this example:

1. **Create your own project** using the learned patterns
2. **Customize the PRD template** for your specific domain
3. **Experiment with Claude integration** for your technology stack
4. **Share your improvements** with the community

## Questions and Discussion

- How would you modify this PRD for a mobile app?
- What additional features would you prioritize?
- How would you adapt the task breakdown for your team size?
- What metrics would you add for your specific use case?

---

**This example represents a real-world application of Claude Master and Commander. Use it as inspiration and adapt it to your specific needs!**
