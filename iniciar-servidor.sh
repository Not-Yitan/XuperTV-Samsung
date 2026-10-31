#!/usr/bin/env bash
# Inicia el servidor en este PC.  Uso: ./iniciar-servidor.sh [--tv-antigua] [IP_DEL_PC]
# --tv-antigua: convierte todo el video a H.264 (para TV LG webOS 1 a 3, sin H.265).
set -euo pipefail
AQUI="$(cd "$(dirname "$0")" && pwd)"
if [ "${1:-}" = "--tv-antigua" ]; then
  export XUPER_TRANSCODE=1 XUPER_FORCE_RELAY=1
  command -v ffmpeg >/dev/null || { echo "--tv-antigua necesita ffmpeg: sudo apt install ffmpeg"; exit 1; }
  echo "Modo TV antigua: el video se convierte a H.264 (usa bastante CPU)."
  shift
fi
[ -n "${1:-}" ] && export XUPER_PUBLIC_HOST="$1"
command -v ffmpeg >/dev/null || echo "Aviso: sin ffmpeg no funciona el 'Modo fluido' (sudo apt install ffmpeg)"
export FFMPEG_PATH="${FFMPEG_PATH:-$(command -v ffmpeg || echo /usr/bin/ffmpeg)}"
cd "$AQUI/server" && exec node server.js
