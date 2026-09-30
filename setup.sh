#!/usr/bin/env bash
# Termux / Linux. Jalankan: bash setup.sh
if command -v pkg >/dev/null 2>&1; then
  pkg update -y && pkg upgrade -y
  pkg install -y python python-pillow git clang make libffi openssl
fi
pip install -r requirements.txt
[ -f .env ] || cp .env.example .env
echo
echo "Selesai. Edit .env (BOT_TOKEN + 10 variabel dari me-cli), lalu jalankan: bash run.sh"
