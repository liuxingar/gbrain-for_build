#!/bin/sh
# GBrain HTTP MCP entrypoint（PGLite keyless 起步，可后续补 embedding key）
set -eu

export HOME="${GBRAIN_HOME:-/data}"

if [ ! -f "$HOME/.gbrain/config.json" ]; then
  echo "[gbrain] first boot: init PGLite brain (keyless)"
  gbrain init --pglite --no-embedding
else
  echo "[gbrain] existing brain found at $HOME/.gbrain"
fi

PUBLIC_URL="${GBRAIN_PUBLIC_URL:-http://localhost:3131}"
echo "[gbrain] serving HTTP MCP on :3131 (public-url $PUBLIC_URL)"
exec gbrain serve --http --port 3131 --public-url "$PUBLIC_URL"