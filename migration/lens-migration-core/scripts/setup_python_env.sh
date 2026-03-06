#!/bin/bash
# Setup Python virtual environment for lens-migration-core

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
VENV_DIR="$PROJECT_DIR/venv"

echo "==========================================="
echo "Setting up Python environment"
echo "==========================================="
echo ""

# Check Python installation
if ! command -v python3 &> /dev/null; then
    echo "❌ Python3 not found. Please install Python 3.8 or higher."
    exit 1
fi

PYTHON_VERSION=$(python3 --version 2>&1 | cut -d' ' -f2)
echo "✓ Found Python: $PYTHON_VERSION"
echo ""

# Create virtual environment
if [ -d "$VENV_DIR" ]; then
    echo "⚠️  Virtual environment already exists at: $VENV_DIR"
    read -p "Do you want to recreate it? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "🗑️  Removing old virtual environment..."
        rm -rf "$VENV_DIR"
    else
        echo "Using existing virtual environment"
        source "$VENV_DIR/bin/activate"
        echo "✓ Virtual environment activated"
        echo ""
        echo "Virtual environment path: $VENV_DIR"
        echo "Python path: $(which python3)"
        exit 0
    fi
fi

echo "📦 Creating virtual environment..."
python3 -m venv "$VENV_DIR"
echo "✓ Virtual environment created at: $VENV_DIR"
echo ""

# Activate virtual environment
source "$VENV_DIR/bin/activate"
echo "✓ Virtual environment activated"
echo ""

# Upgrade pip
echo "⬆️  Upgrading pip..."
pip install --upgrade pip > /dev/null 2>&1
echo "✓ Pip upgraded"
echo ""

# Install dependencies
if [ -f "$PROJECT_DIR/requirements.txt" ]; then
    echo "📥 Installing dependencies from requirements.txt..."
    pip install -r "$PROJECT_DIR/requirements.txt"
    echo "✓ Dependencies installed"
else
    echo "⚠️  No requirements.txt found, installing basic dependencies..."
    pip install lxml
    echo "✓ Basic dependencies installed"
fi

echo ""
echo "==========================================="
echo "✅ Setup complete!"
echo "==========================================="
echo ""
echo "Virtual environment path: $VENV_DIR"
echo "Python path: $(which python3)"
echo ""
echo "To activate the virtual environment manually, run:"
echo "  source $VENV_DIR/bin/activate"
echo ""
echo "To configure IntelliJ IDEA:"
echo "1. Open Project Structure (Ctrl+Alt+Shift+S)"
echo "2. Go to Platform Settings > SDKs"
echo "3. Click + > Add Python SDK > Virtualenv Environment"
echo "4. Select 'Existing environment'"
echo "5. Choose: $VENV_DIR/bin/python3"
echo "6. Apply and OK"
echo ""
