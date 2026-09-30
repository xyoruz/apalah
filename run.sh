#!/usr/bin/env bash
set -e

cd "$(dirname "$0")" || exit 1                    
if [ ! -f .env ]; then
  echo "File .env tidak ada di folder ini."
  exit 1
fi

if [ -d ".venv" ]; then
  # shellcheck disable=SC1091
  source .venv/bin/activate
else                                                echo "WARN: .venv tidak ditemukan, jalankan dulu: bash setup.sh"
fi                                                
if [ -f bot_dor_v2.py ]; then
  if ! grep -q 'getLogger("httpx")' bot_dor_v2.py; then
    sed -i '/^logging\.basicConfig(level=logging\.INFO)$/a\
logging.getLogger("httpx").setLevel(logging.WARNING)' bot_dor_v2.py
  fi
fi

if [ -f fix_env.py ]; then
  echo ">> Menjalankan fix_env.py ..."
  python fix_env.py
fi

echo ">> Menjalankan bot_dor_v2.py ..."
exec python bot_dor_v2.py
