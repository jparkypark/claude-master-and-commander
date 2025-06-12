#!/bin/bash

# Claude Master and Commander Setup Script
# Location: /Users/joshparks/Github/jparkypark/claude-master-and-commander/scripts/setup.sh

set -e

CMC_ROOT="/Users/joshparks/Github/jparkypark/claude-master-and-commander"
SCRIPTS_DIR="$CMC_ROOT/scripts"
TEMPLATES_DIR="$CMC_ROOT/templates"

echo "🚀 Claude Master and Commander Setup"
echo "===================================="
echo ""

# Check if we're in the right directory
if [[ ! -f "$CMC_ROOT/README.md" ]]; then
    echo "❌ Error: Please run this script from the CMC root directory"
    echo "Expected location: $CMC_ROOT"
    echo "Current location: $(pwd)"
    exit 1
fi

echo "📁 CMC Root Directory: $CMC_ROOT"
echo ""

# Check Node.js installation
echo "🔍 Checking prerequisites..."
if command -v node >/dev/null 2>&1; then
    NODE_VERSION=$(node --version)
    echo "✅ Node.js found: $NODE_VERSION"
else
    echo "❌ Node.js not found. Please install Node.js (>=14.0.0)"
    echo "   Visit: https://nodejs.org/"
    exit 1
fi

# Check jq installation
if command -v jq >/dev/null 2>&1; then
    echo "✅ jq found: $(jq --version)"
else
    echo "❌ jq not found. Installing jq..."
    if command -v brew >/dev/null 2>&1; then
        brew install jq
        echo "✅ jq installed via Homebrew"
    else
        echo "❌ Please install jq manually:"
        echo "   macOS: brew install jq"
        echo "   Linux: sudo apt-get install jq"
        exit 1
    fi
fi

echo ""
# Create necessary directories
echo "📁 Creating directory structure..."
mkdir -p "$SCRIPTS_DIR"
mkdir -p "$TEMPLATES_DIR"
mkdir -p "$HOME/cmc-projects"

echo "✅ Created: $SCRIPTS_DIR"
echo "✅ Created: $TEMPLATES_DIR"
echo "✅ Created: $HOME/cmc-projects (projects directory)"
echo ""

# Make scripts executable
echo "🔧 Setting up scripts..."
chmod +x "$SCRIPTS_DIR/cmc.sh" 2>/dev/null || echo "   Note: cmc.sh not found yet"
chmod +x "$SCRIPTS_DIR/cmc-task-generator.js" 2>/dev/null || echo "   Note: cmc-task-generator.js not found yet"
chmod +x "$SCRIPTS_DIR/setup.sh"

echo "✅ Scripts configured"
echo ""

# Create symlink for global access
echo "🔗 Setting up global command access..."
GLOBAL_BIN_DIR="/usr/local/bin"
CMC_SYMLINK="$GLOBAL_BIN_DIR/cmc"

if [[ -L "$CMC_SYMLINK" ]]; then
    echo "⚠️  Existing cmc symlink found, removing..."
    sudo rm "$CMC_SYMLINK"
fi

if sudo ln -s "$SCRIPTS_DIR/cmc.sh" "$CMC_SYMLINK" 2>/dev/null; then
    echo "✅ Global command created: cmc"
    echo "   You can now run 'cmc' from anywhere"
else
    echo "⚠️  Could not create global symlink (requires sudo)"
    echo "   You can still run: $SCRIPTS_DIR/cmc.sh"
    echo "   Or add to your PATH: export PATH=\"$SCRIPTS_DIR:\$PATH\""
fi

echo ""

# Test the installation
echo "🧪 Testing installation..."
if command -v cmc >/dev/null 2>&1; then
    echo "✅ Global cmc command working"
    cmc help >/dev/null 2>&1 && echo "✅ cmc help command working" || echo "⚠️  cmc help had issues"
else
    echo "⚠️  Global cmc command not available"
    echo "   Try: $SCRIPTS_DIR/cmc.sh help"
fi

echo ""
# Configuration summary
echo "📋 Installation Summary"
echo "======================="
echo "CMC Root:      $CMC_ROOT"
echo "Scripts:       $SCRIPTS_DIR"
echo "Templates:     $TEMPLATES_DIR"
echo "Projects:      $HOME/cmc-projects"
echo "Global Command: $(command -v cmc 2>/dev/null || echo 'Not available')"
echo ""

# Next steps
echo "🎯 Next Steps"
echo "============="
echo "1. Verify installation:"
echo "   cmc help"
echo ""
echo "2. Create your first project:"
echo "   cmc new my-first-project"
echo ""
echo "3. Follow the workflow:"
echo "   cmc review my-first-project    # Edit PRD"
echo "   cmc approve my-first-project   # Approve PRD"
echo "   cmc generate my-first-project  # Generate tasks"
echo ""
echo "4. Start development:"
echo "   cmc cd my-first-project"
echo "   # Ask Claude for help with specific tasks"
echo ""

# Check for required files
echo "📄 Required Files Check"
echo "======================="

REQUIRED_FILES=(
    "scripts/cmc.sh"
    "scripts/cmc-task-generator.js"
    "templates/prd-template.md"
)

for file in "${REQUIRED_FILES[@]}"; do
    if [[ -f "$CMC_ROOT/$file" ]]; then
        echo "✅ $file"
    else
        echo "❌ $file (missing - create this file)"
    fi
done

echo ""

# Final status
if command -v cmc >/dev/null 2>&1 && [[ -f "$SCRIPTS_DIR/cmc.sh" ]]; then
    echo "🎉 Setup Complete!"
    echo "   Claude Master and Commander is ready to use."
    echo ""
    echo "💡 Remember: CMC prevents auto-execution by design."
    echo "   Each workflow step requires your explicit approval."
else
    echo "⚠️  Setup Partially Complete"
    echo "   Some components may need manual configuration."
    echo ""
    echo "💡 Check the required files list above and create missing files."
fi

echo ""
echo "📚 For more information:"
echo "   README.md in the project root"
echo "   Use 'cmc help' for command reference"
echo ""