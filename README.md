# Claude Master and Commander

A professional Product Requirements Document (PRD) driven development workflow that combines the best of [Claude Desktop Commander](https://github.com/AnthropicAI/claude-desktop-commander) and [Claude Taskmaster AI](https://github.com/eyaltoledano/claude-task-master) approaches. Get the benefits of structured, AI-enhanced development without additional subscription costs or complex multi-AI configurations.

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Node](https://img.shields.io/badge/node-%3E%3D14.0.0-brightgreen.svg)
![Platform](https://img.shields.io/badge/platform-macOS%20%7C%20Linux-lightgrey.svg)

## 🎯 Overview

Transform your development process with a systematic, AI-enhanced workflow that helps you:

- **Plan systematically** with detailed Product Requirements Documents
- **Break down complexity** into manageable, prioritized tasks  
- **Track progress** with visual status indicators
- **Leverage AI** for code generation and architectural guidance
- **Stay organized** with consistent project structure

This workflow replicates the core benefits of [Claude Taskmaster AI](https://github.com/eyaltoledano/claude-task-master) while leveraging [Claude Desktop Commander](https://github.com/AnthropicAI/claude-desktop-commander) for seamless AI integration.

## 🔗 Related Claude Ecosystem Tools

**Claude Master and Commander** stands on the shoulders of two excellent Claude ecosystem projects:

### [Claude Desktop Commander](https://github.com/AnthropicAI/claude-desktop-commander)
Claude Desktop Commander provides the foundation for seamless AI integration in development workflows. Master and Commander leverages its file system operations, command execution, and Claude API integration to enhance PRD-driven development with intelligent assistance.

### [Claude Taskmaster AI](https://github.com/eyaltoledano/claude-task-master) 
Claude Taskmaster AI pioneered the concept of AI-powered task management and PRD-driven development. Master and Commander was inspired by Taskmaster's approach but reimagined for users who prefer:
- Single AI provider (Claude-only) instead of multi-AI complexity
- No additional API costs beyond Claude Desktop Commander
- Simpler setup and configuration
- Full customization and open-source transparency

**When to use each:**
- **Claude Master and Commander**: You use Claude Desktop Commander and want structured project workflows without additional complexity or costs
- **Claude Taskmaster AI**: You need multi-AI provider support and don't mind additional API management
- **Claude Desktop Commander**: You want general AI development assistance without specific project methodology

## ✨ Features

- 📋 **PRD Templates** - Professional templates for comprehensive project planning
- 🤖 **AI Task Generation** - Intelligent breakdown of requirements into actionable tasks
- 📊 **Progress Tracking** - Visual task management with status indicators
- 🏗️ **Project Structure** - Consistent, scalable project organization
- 🔄 **Claude Integration** - Seamless workflow with Claude Desktop Commander
- 🛠️ **Shell Integration** - Convenient CLI commands for project management
- 📝 **Documentation** - Comprehensive guides and examples

## 🚀 Quick Start

### Prerequisites

- Node.js 14.0.0 or higher
- [Claude Desktop Commander](https://github.com/AnthropicAI/claude-desktop-commander) (recommended for full AI integration)
- Bash or Zsh shell

### Quick Install (Recommended)

```bash
curl -sSL https://raw.githubusercontent.com/jparkypark/claude-master-and-commander/main/install.sh | bash
```

### Manual Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/jparkypark/claude-master-and-commander.git
   cd claude-master-and-commander
   ```

2. **Run setup:**
   ```bash
   chmod +x scripts/setup.sh
   ./scripts/setup.sh
   ```

3. **Restart your terminal** or run:
   ```bash
   source ~/.zshrc  # or ~/.bashrc
   ```

### Create Your First Project

```bash
# Create new PRD project
prd new my-awesome-app

# Generate task breakdown
prd-generate ~/Projects/my-awesome-app/docs/prd.md

# Check project status
prd-status ~/Projects/my-awesome-app
```

## 📚 Documentation

- [**Installation Guide**](docs/installation.md) - Detailed setup instructions
- [**User Guide**](docs/user-guide.md) - Complete workflow documentation
- [**System Architecture**](docs/architecture.md) - Technical architecture and component overview
- [**Workflow Process**](docs/workflow.md) - Detailed workflow sequence and user journey
- [**FAQ**](docs/faq.md) - Frequently asked questions and troubleshooting

## 💡 Example Workflow

### 1. Project Planning
```bash
prd new ecommerce-platform
# Edit the generated PRD with your requirements
```

### 2. Task Generation
```bash
prd-generate ~/Projects/ecommerce-platform/docs/prd.md
```

### 3. Development with Claude
```bash
prd-cd ecommerce-platform

# Ask Claude to help:
# "Review my PRD and suggest improvements"
# "Generate database schema for user management"
# "Break down TASK-004 into smaller subtasks"
```

### 4. Progress Tracking
```bash
prd-status .
# Update task statuses as you progress
```

## 🛠️ Available Commands

| Command | Description |
|---------|-------------|
| `prd new <n>` | Create new PRD project |
| `prd-generate <prd-file>` | Generate tasks from PRD |
| `prd-status <project-dir>` | Show project status |
| `prd-list` | List all PRD projects |
| `prd-cd <project>` | Navigate to project |

## 📊 Benefits vs. Other Claude Tools

| Feature | Claude Master & Commander | Claude Taskmaster AI | Claude Desktop Commander |
|---------|--------------------------|---------------------|--------------------------|
| PRD-driven development | ✅ | ✅ | ❌ |
| AI task breakdown | ✅ | ✅ | ⚠️ Manual |
| No additional API costs | ✅ | ❌ Multiple APIs | ✅ |
| Full customization | ✅ | ⚠️ Limited | ✅ |
| Integrated CLI workflow | ✅ | ⚠️ Complex setup | ✅ |
| Simple installation | ✅ | ❌ Multi-step | ✅ |
| Built-in project structure | ✅ | ✅ | ❌ |

## 🏗️ Project Structure

```
my-project/
├── .prd-config.json          # Project metadata
├── docs/
│   ├── prd.md               # Product Requirements Document
│   └── tasks.md             # Generated task breakdown
├── src/                     # Source code
├── tests/                   # Test files
├── scripts/                 # Project scripts
└── assets/                  # Static assets
```

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

### Development Setup

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Make your changes
4. Add tests if applicable
5. Commit: `git commit -m 'Add amazing feature'`
6. Push: `git push origin feature/amazing-feature`
7. Open a Pull Request

## 📋 Roadmap

- [ ] **v1.1**: GUI interface for PRD editing
- [ ] **v1.2**: Integration with popular project management tools
- [ ] **v1.3**: Team collaboration features
- [ ] **v1.4**: CI/CD integration templates
- [ ] **v2.0**: Visual project dashboards

## 🐛 Issues & Support

- **Bug Reports**: [GitHub Issues](https://github.com/jparkypark/claude-master-and-commander/issues)
- **Feature Requests**: [GitHub Discussions](https://github.com/jparkypark/claude-master-and-commander/discussions)
- **Questions**: Check our [FAQ](docs/faq.md) or start a discussion

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **[Claude Taskmaster AI](https://github.com/eyaltoledano/claude-task-master)** - Inspiration for PRD-driven development methodology and task management approach
- **[Claude Desktop Commander](https://github.com/AnthropicAI/claude-desktop-commander)** - Foundation for Claude AI integration and development workflow automation
- Built for the Claude ecosystem and community
- Thanks to all contributors and users providing feedback

---

**⭐ If this workflow helps your development process, please star the repository!**

[Get Started](docs/installation.md) | [Documentation](docs/) | [Examples](examples/) | [Contributing](CONTRIBUTING.md)
