#!/usr/bin/env sh

OWNER="Scapy47"
REPO="Shio"
BASE_URL="https://github.com/$OWNER/$REPO/releases/latest/download"

OS=""
case "$(uname)" in
  Darwin) OS="macOS" ;;
  Linux)  OS="Linux" ;;
  *)      echo "❌ Unsupported OS"; exit 1 ;;
esac

FILENAME="shio-${OS}-x86_64"
XDG_BIN_HOME="${XDG_BIN_HOME:-$HOME/.local/bin}"
TEMP_PATH="$XDG_BIN_HOME/$FILENAME"
FINAL_PATH="$XDG_BIN_HOME/shio"

mkdir -p "$XDG_BIN_HOME"

echo "🔍 Detected: $OS"
echo "⬇️ Downloading to $TEMP_PATH"
curl -L -o "$TEMP_PATH" "$BASE_URL/$FILENAME" || { echo "❌ Download failed"; exit 1; }

chmod +x "$TEMP_PATH"
mv "$TEMP_PATH" "$FINAL_PATH"
echo "✅ Installed to $FINAL_PATH"

# Check if XDG_BIN_HOME or ~/.local/bin is in PATH
if [ ":$PATH:" != *":$XDG_BIN_HOME:"* ] && { [ "$XDG_BIN_HOME" != "$HOME/.local/bin" ] || [ ":$PATH:" != *":$HOME/.local/bin:"* ]; }; then
  echo ""
  echo "⚠️ Warning: $XDG_BIN_HOME is not in your PATH"
  echo ""
  echo "Add this line to your shell config (~/.bashrc, ~/.zshrc, etc.):"
  echo ""
  echo '        export XDG_BIN_HOME="$HOME/.local/bin"'
  echo '        export PATH="$XDG_BIN_HOME:$PATH"'
  echo ""
  echo "Then run: source ~/.zshrc  (or ~/.bashrc)"
fi

echo "💡 Run 'shio --version' to verify."

echo "💡 To enable playback with proper headers, configure your player:"
echo '   export SHIO_PLAYER_CMD="mpv --user-agent={user_agent} --http-header-fields=\"Referer: {referer}\" {url}"'
echo "   Add this to your shell config"
