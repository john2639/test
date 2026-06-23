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
    DOWNLOAD_URL="https://github.com/john2639/test/releases/latest/download/forge_v2-macos.tar.gz"
elif [ "$OS" = "Linux" ]; then
    echo "🐧 Detected Linux ($ARCH)"
    DOWNLOAD_URL="https://github.com/john2639/test/releases/latest/download/forge_v2-linux.tar.gz"
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

# Ensure it's executable
chmod +x "$BIN_DIR/forge_v2"

# Create a desktop shortcut for Mac
if [ "$OS" = "Darwin" ]; then
    SHORTCUT_PATH="$HOME/Desktop/Forge_V2_Start.command"
    echo '#!/bin/bash' > "$SHORTCUT_PATH"
    echo "echo '🚀 Starting Forge V2...'" >> "$SHORTCUT_PATH"
    echo "nohup \"$BIN_DIR/forge_v2\" > /dev/null 2>&1 &" >> "$SHORTCUT_PATH"
    echo "echo '✅ Dashboard should open automatically. You can close this terminal window.'" >> "$SHORTCUT_PATH"
    chmod +x "$SHORTCUT_PATH"
    echo "✨ Desktop shortcut created: Forge_V2_Start.command"
fi

echo "=========================================="
echo "✅ Installation complete!"
echo "🚀 Starting Forge V2..."

# Run the app in background
nohup "$BIN_DIR/forge_v2" > /dev/null 2>&1 &

echo "🌐 Forge V2 is running in the background."
echo "Your browser should open the dashboard automatically."
echo "If not, please visit: http://127.0.0.1:8000/dashboard"
echo "=========================================="
