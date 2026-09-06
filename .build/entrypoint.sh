#!/bin/sh
# GBrain HTTP MCP entrypoint（PGLite keyless 起步，可后续补 embedding key）
set -eu

export HOME="${GBRAIN_HOME:-/data}"
# 局域网 http 部署：MCP SDK 的 OAuth issuer 默认强制 HTTPS，
# 官方开关 MCP_DANGEROUSLY_ALLOW_INSECURE_ISSUER_URL 显式放行（仅限非生产/局域网）。
export MCP_DANGEROUSLY_ALLOW_INSECURE_ISSUER_URL=true
BRAIN_DIR="$HOME/.gbrain"

if [ ! -f "$BRAIN_DIR/config.json" ]; then
  echo "[gbrain] first boot: init PGLite brain (keyless)"
  gbrain init --pglite --no-embedding
else
  echo "[gbrain] existing brain found at $BRAIN_DIR"
  # 清理上次容器重启遗留的 PGLite 锁（serve 被杀会留下记录 PID 1 的锁，
  # 重启后新 PID 1 又常驻，导致 gbrain 误判锁被占用而拒绝启动 → 崩溃循环）
  LOCK="$BRAIN_DIR/brain.pglite/.gbrain-lock"
  if [ -e "$LOCK" ]; then
    echo "[gbrain] removing stale PGLite lock (dir-or-file)"
    rm -rf "$LOCK"
  fi
fi

PUBLIC_URL="${GBRAIN_PUBLIC_URL:-http://localhost:3131}"
echo "[gbrain] serving HTTP MCP on :3131 (public-url $PUBLIC_URL)"
# 必须 --bind 0.0.0.0：v0.34.1 起默认绑 127.0.0.1，外部客户端会被拒
exec gbrain serve --http --port 3131 --bind 0.0.0.0 --public-url "$PUBLIC_URL"