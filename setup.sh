#!/usr/bin/env bash
# Termux / Linux. Jalankan: bash setup.sh
set -e
if command -v pkg >/dev/null 2>&1; then
  # Termux
  pkg update -y && pkg upgrade -y
  pkg install -y python python-pip python-pillow git clang make libffi openssl
  PIP_CMD="pip"
elif command -v apt >/dev/null 2>&1; then
  # Debian / Ubuntu
  apt update -y
  apt install -y python3 python3-pip python3-pillow git clang make libffi-dev libssl-dev
  PIP_CMD="pip3"
elif command -v dnf >/dev/null 2>&1; then
  # Fedora / RHEL
  dnf install -y python3 python3-pip python3-pillow git clang make libffi-devel openssl-devel
  PIP_CMD="pip3"
elif command -v pacman >/dev/null 2>&1; then
  # Arch
  pacman -Sy --noconfirm python python-pip python-pillow git clang make libffi openssl
  PIP_CMD="pip"
else
  # Fallback: coba pip3, lalu pip
  if command -v pip3 >/dev/null 2>&1; then
    PIP_CMD="pip3"
  elif command -v pip >/dev/null 2>&1; then
    PIP_CMD="pip"
  else
    echo "ERROR: pip tidak ditemukan. Install python3-pip
dulu." >&2
    exit 1
  fi
fi
echo ">> Menggunakan: $PIP_CMD"
$PIP_CMD install --upgrade pip
$PIP_CMD install -r requirements.txt
[ -f .env ] || cp .env.example .env
echo
echo "Selesai. Edit .env (BOT_TOKEN + 10 variabel dari me-cli), lalu jalankan: bash run.sh"
