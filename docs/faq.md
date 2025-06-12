# Frequently Asked Questions

## Installation

### Q: What are the system requirements?
**A:** Node.js 14.0.0 or higher, Git, and Bash/Zsh shell.

### Q: How do I install Claude Master and Commander?
**A:** Run: `curl -sSL https://raw.githubusercontent.com/jparkypark/claude-master-and-commander/main/install.sh | bash`

## Usage

### Q: How do I create a new project?
**A:** Use `cmc new project-name` to create a structured PRD project.

### Q: How do I generate tasks from my PRD?
**A:** Run `cmc-generate path/to/your/prd.md` to create an intelligent task breakdown.

### Q: How do I integrate with Claude?
**A:** Install [Claude Desktop Commander](https://github.com/wonderwhy-er/DesktopCommanderMCP) and ask Claude to read your PRD and task files.

## Troubleshooting

### Q: Commands not found after installation?
**A:** Restart your terminal or run `source ~/.zshrc` (or `~/.bashrc`).

### Q: Can't generate tasks from PRD?
**A:** Ensure your PRD has a "## Functional Requirements" section with detailed features.

## Claude Integration

### Q: How is this different from Claude Taskmaster AI?
**A:** We're inspired by their methodology but use only Claude (no multi-AI complexity) and integrate with Claude Desktop Commander.

### Q: Do I need additional API costs?
**A:** No, this works with Claude Desktop Commander which uses your Claude subscription.

For more help, see our [documentation](README.md) or [open an issue](https://github.com/jparkypark/claude-master-and-commander/issues).
