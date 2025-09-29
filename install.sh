#!/bin/bash
# Installer for loading.sh
set -e  # Exit on error
SCRIPT_NAME="loading"
TARGET_DIR="$HOME/.local/bin"
TARGET_PATH="$TARGET_DIR/$SCRIPT_NAME"
echo "🔧 Installing $SCRIPT_NAME..."
# Make sure ~/.local/bin exists
mkdir -p "$TARGET_DIR"
# Copying the script and renaming it to "loading"
cp loading.sh "$TARGET_PATH"
# Make it executable
chmod +x "$TARGET_PATH"
# Ensure ~/.local/bin is in PATH
if [[ ":$PATH:" != *":$TARGET_DIR:"* ]]; then
    echo "⚠️  $TARGET_DIR is not in your PATH."
    echo "   Add this line to your ~/.bashrc or ~/.zshrc:"
    echo "   export PATH=\$PATH:$TARGET_DIR"
fi
echo "✅ Installed! Run it by typing: loading"
