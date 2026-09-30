#!/usr/bin/env bash
cd "$(dirname "$0")" || exit 1
if [ ! -f .env ]; then
  echo "File .env tidak ada di folder ini."
  exit 1
fi
grep -q 'getLogger("httpx")' bot_dor_v2.py || \
  sed -i 's/^logging.basicConfig(level=logging.INFO)$/&\n>
python3 /root/apalah/fix_env.py
exec python3 bot_dor_v2.py
