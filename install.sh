#!/bin/bash
set -e

# ==========================================
# Forge V2 Terminal Installer
# ==========================================

echo "🚀 Installing Forge V2..."
echo "This will download and install the Forge V2 agent locally without Gatekeeper blocks."
echo "=========================================="

INSTALL_DIR="$HOME/.memoryverse-forge"
BIN_DIR="$INSTALL_DIR/bin"
mkdir -p "$BIN_DIR"

OS="$(uname -s)"
ARCH="$(uname -m)"

if [ "$OS" = "Darwin" ]; then
    echo "🍎 Detected macOS ($ARCH)"
    DOWNLOAD_URL="https://github.com/john2639/memoryverse/releases/latest/download/forge_v2-macos.tar.gz"
elif [ "$OS" = "Linux" ]; then
    echo "🐧 Detected Linux ($ARCH)"
    DOWNLOAD_URL="https://github.com/john2639/memoryverse/releases/latest/download/forge_v2-linux.tar.gz"
else
    echo "❌ Unsupported OS: $OS"
    echo "Please download the Windows .zip installer directly."
    exit 1
fi

echo "⬇️  Downloading Forge V2 from GitHub Releases..."
echo "URL: $DOWNLOAD_URL"

# We use curl with -f (fail silently on HTTP errors), -sL (silent, follow redirects)
if curl -fsSL "$DOWNLOAD_URL" -o /tmp/forge_v2.tar.gz; then
    echo "✅ Download successful!"
else
    echo "❌ Download failed! Please check if the GitHub Release is published and public."
    exit 1
fi

echo "📦 Extracting binary to $BIN_DIR..."
# We expect the tar to contain the 'forge_v2' executable.
tar -xzf /tmp/forge_v2.tar.gz -C "$BIN_DIR"
rm /tmp/forge_v2.tar.gz

# Rename forge_v2 to forge for the CLI
mv "$BIN_DIR/forge_v2" "$BIN_DIR/forge"

# Ensure it's executable
chmod +x "$BIN_DIR/forge"

# Add to shell profile
PROFILE_STR="export PATH=\"\$HOME/.memoryverse-forge/bin:\$PATH\""

if [ -n "$ZSH_VERSION" ] || [ -f "$HOME/.zshrc" ]; then
    grep -qxF "$PROFILE_STR" "$HOME/.zshrc" 2>/dev/null || echo "$PROFILE_STR" >> "$HOME/.zshrc"
    echo "✨ Added 'forge' command to ~/.zshrc"
fi

if [ -n "$BASH_VERSION" ] || [ -f "$HOME/.bash_profile" ]; then
    grep -qxF "$PROFILE_STR" "$HOME/.bash_profile" 2>/dev/null || echo "$PROFILE_STR" >> "$HOME/.bash_profile"
    echo "✨ Added 'forge' command to ~/.bash_profile"
fi

echo "=========================================="
echo "✅ Installation complete!"
echo "⚠️  Please restart your terminal or run 'source ~/.zshrc' to use the 'forge' command."
echo "=========================================="
echo "🚀 To start the server, run:"
echo "   forge start"
echo ""
echo "⚙️  To install as a 24/7 background service, run:"
echo "   forge install-daemon"
echo "=========================================="
