# Installation Guide

## Prerequisites

Before installing Claude Master and Commander, ensure you have:

### Required
- **Node.js 14.0.0 or higher** - [Download here](https://nodejs.org/)
- **Bash or Zsh shell** - Default on macOS and most Linux distributions
- **Git** - For cloning the repository

### Optional but Recommended
- **Claude Desktop Commander** - For enhanced AI integration
- **VS Code** - For editing PRD files (will auto-open if available)

## Quick Installation

### 1. Clone Repository

```bash
git clone https://github.com/jparkypark/claude-master-and-commander.git
cd claude-master-and-commander
```

### 2. Run Setup Script

```bash
chmod +x scripts/setup.sh
./scripts/setup.sh
```

The setup script will:
- Add shell aliases to your profile (`.zshrc` or `.bashrc`)
- Create a `~/Projects` directory for your PRD projects
- Optionally create an example project to explore

### 3. Restart Terminal

```bash
# Restart your terminal or reload your shell profile
source ~/.zshrc  # for Zsh
# or
source ~/.bashrc  # for Bash
```

### 4. Verify Installation

```bash
# Test the commands
prd --help
prd-list
```

## Manual Installation

If you prefer manual setup or the automatic script doesn't work:

### 1. Clone Repository

```bash
git clone https://github.com/jparkypark/claude-master-and-commander.git
```

### 2. Make Scripts Executable

```bash
cd claude-master-and-commander
chmod +x scripts/*.sh
chmod +x scripts/*.js
```

### 3. Add to Shell Profile

Add these lines to your `~/.zshrc` or `~/.bashrc`:

```bash
# Claude Master and Commander
export WORKFLOW_DIR="/path/to/claude-master-and-commander"
alias prd="$WORKFLOW_DIR/scripts/prd-helper.sh"
alias prd-new="$WORKFLOW_DIR/scripts/prd-helper.sh new"
alias prd-parse="$WORKFLOW_DIR/scripts/prd-helper.sh parse"
alias prd-status="$WORKFLOW_DIR/scripts/prd-helper.sh status"
alias prd-list="$WORKFLOW_DIR/scripts/prd-helper.sh list"

# Enhanced task generation
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
        
        if [[ -f ".prd-config.json" ]]; then
            "$WORKFLOW_DIR/scripts/prd-helper.sh" status .
        fi
    else
        echo "❌ Project not found: $project"
        "$WORKFLOW_DIR/scripts/prd-helper.sh" list
    fi
}
```

### 4. Create Projects Directory

```bash
mkdir -p ~/Projects
```

### 5. Reload Shell

```bash
source ~/.zshrc  # or ~/.bashrc
```

## Platform-Specific Notes

### macOS
- Works out of the box with default Zsh shell
- VS Code integration automatic if installed
- Uses `~/.zshrc` for configuration

### Linux
- Tested on Ubuntu, Debian, CentOS
- May use Bash (`.bashrc`) or Zsh (`.zshrc`)
- Package managers may require `sudo` for Node.js installation

### Windows (WSL)
- Use Windows Subsystem for Linux
- Follow Linux installation steps
- Ensure Node.js is installed in WSL environment

## Troubleshooting

### Command Not Found

If `prd` commands aren't recognized:

1. **Check shell profile location:**
   ```bash
   echo $SHELL  # Should show /bin/zsh or /bin/bash
   ```

2. **Manually source profile:**
   ```bash
   source ~/.zshrc  # or ~/.bashrc
   ```

3. **Verify aliases were added:**
   ```bash
   grep -n "Claude Master and Commander" ~/.zshrc
   ```

### Node.js Issues

If Node.js commands fail:

1. **Check Node.js version:**
   ```bash
   node --version  # Should be 14.0.0 or higher
   ```

2. **Install Node.js if missing:**
   ```bash
   # macOS with Homebrew
   brew install node
   
   # Ubuntu/Debian
   sudo apt update
   sudo apt install nodejs npm
   
   # CentOS/RHEL
   sudo yum install nodejs npm
   ```

### Permission Issues

If you get permission errors:

```bash
# Make scripts executable
chmod +x scripts/*.sh scripts/*.js

# If needed, fix ownership
sudo chown -R $USER:$USER ~/Projects
```

### Path Issues

If scripts can't find files:

1. **Use absolute paths in aliases:**
   ```bash
   export PRD_WORKFLOW_DIR="$HOME/path/to/claude-master-and-commander"
   ```

2. **Verify directory structure:**
   ```bash
   ls -la ~/claude-master-and-commander/scripts/
   ```

## Uninstallation

To remove the workflow:

1. **Remove shell aliases:**
   ```bash
   # Edit ~/.zshrc or ~/.bashrc and remove the Claude Master and Commander section
   nano ~/.zshrc
   ```

2. **Remove repository:**
   ```bash
   rm -rf ~/claude-master-and-commander
   ```

3. **Optionally remove projects:**
   ```bash
   # Only if you want to remove all PRD projects
   rm -rf ~/Projects
   ```

## Next Steps

After installation:

1. **Create your first project:**
   ```bash
   prd new my-first-project
   ```

2. **Read the [User Guide](user-guide.md)**

3. **Explore the [example project](../examples/todo-app/)**

4. **Set up [Claude integration](claude-integration.md)** if available

## Getting Help

- **Issues**: [GitHub Issues](https://github.com/joshparks/claude-master-and-commander/issues)
- **Questions**: [GitHub Discussions](https://github.com/joshparks/claude-master-and-commander/discussions)
- **Documentation**: [Full docs](README.md)
