#!/usr/bin/env bash
# Inicia el servidor en este PC.  Uso: ./iniciar-servidor.sh [IP_DEL_PC]
set -euo pipefail
AQUI="$(cd "$(dirname "$0")" && pwd)"
[ -n "${1:-}" ] && export XUPER_PUBLIC_HOST="$1"
command -v ffmpeg >/dev/null || echo "Aviso: sin ffmpeg no funciona el 'Modo fluido' (sudo apt install ffmpeg)"
export FFMPEG_PATH="${FFMPEG_PATH:-$(command -v ffmpeg || echo /usr/bin/ffmpeg)}"
cd "$AQUI/server" && exec node server.js
