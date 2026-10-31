#!/usr/bin/env bash
# Apunta la app de la TV al servidor.  Uso: ./configurar.sh IP_DEL_PC [puerto]
set -euo pipefail
IP="${1:?Uso: $0 IP_DEL_PC [puerto]}"; PORT="${2:-8910}"
AQUI="$(cd "$(dirname "$0")" && pwd)"
sed -i -E "s#devServiceUrl:\"[^\"]*\"#devServiceUrl:\"http://$IP:$PORT\"#" "$AQUI/tizen/config/api.js"
echo "App configurada para usar http://$IP:$PORT"
