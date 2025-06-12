#!/bin/bash

# Quick Install Script for Claude Master and Commander
# Usage: curl -sSL https://raw.githubusercontent.com/jparkypark/claude-master-and-commander/main/install.sh | bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Claude Master and Commander Quick Install${NC}"
echo "Installing Claude Master and Commander workflow..."
echo

# Check prerequisites
if ! command -v node &> /dev/null; then
    echo -e "${RED}❌ Node.js is required but not installed.${NC}"
    echo "Please install Node.js (14.0.0 or higher) and try again:"
    echo "  - macOS: brew install node"
    echo "  - Ubuntu: sudo apt install nodejs npm"
    echo "  - Or visit: https://nodejs.org/"
    exit 1
fi

if ! command -v git &> /dev/null; then
    echo -e "${RED}❌ Git is required but not installed.${NC}"
    echo "Please install Git and try again."
    exit 1
fi

echo -e "${GREEN}✅ Prerequisites check passed${NC}"
echo

# Determine install location
INSTALL_DIR="$HOME/claude-master-and-commander"
if [ -d "$INSTALL_DIR" ]; then
    echo -e "${YELLOW}📁 Directory $INSTALL_DIR already exists.${NC}"
    read -p "Remove and reinstall? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm -rf "$INSTALL_DIR"
    else
        echo "Installation cancelled."
        exit 1
    fi
fi

# Clone repository
echo -e "${BLUE}📥 Downloading Claude Master and Commander...${NC}"
git clone https://github.com/jparkypark/claude-master-and-commander.git "$INSTALL_DIR"
cd "$INSTALL_DIR"

echo -e "${GREEN}✅ Download complete${NC}"
echo

# Run setup
echo -e "${BLUE}🔧 Running setup...${NC}"
chmod +x scripts/*.sh scripts/*.js
./scripts/setup.sh

echo
echo -e "${GREEN}🎉 Installation complete!${NC}"
echo
echo -e "${BLUE}Next steps:${NC}"
echo "1. Restart your terminal or run: source ~/.zshrc"
echo "2. Try: prd new my-first-project"
echo "3. Read the docs: $INSTALL_DIR/README.md"
echo
echo -e "${YELLOW}💡 Pro tip: Check out the example project at $INSTALL_DIR/examples/todo-app/${NC}"
echo
echo "Happy building! 🚀"
