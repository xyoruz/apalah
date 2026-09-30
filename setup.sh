#!/usr/bin/env bash
set -e
                                                  if command -v pkg >/dev/null 2>&1; then
  echo ">> Termux terdeteksi"                       pkg update -y && pkg upgrade -y
  pkg install -y python python-pip git clang make libffi openssl libjpeg-turbo
  PYTHON_BIN="python"
elif command -v apt >/dev/null 2>&1; then           echo ">> Debian/Ubuntu terdeteksi"
  apt update -y                                     apt install -y python3 python3-pip python3-venv git clang make libffi-dev libssl-dev libjpeg-dev
  PYTHON_BIN="python3"
elif command -v dnf >/dev/null 2>&1; then           echo ">> Fedora/RHEL terdeteksi"
  dnf install -y python3 python3-pip git clang make libffi-devel openssl-devel libjpeg-turbo-devel
  PYTHON_BIN="python3"                            elif command -v pacman >/dev/null 2>&1; then
  echo ">> Arch terdeteksi"
  pacman -Sy --noconfirm python python-pip git clang make libffi openssl libjpeg-turbo
  PYTHON_BIN="python"
else
  echo "ERROR: distro tidak dikenali." >&2
  exit 1
fi

if ! command -v "$PYTHON_BIN" >/dev/null 2>&1; then
  echo "ERROR: $PYTHON_BIN tidak ditemukan." >&2
  exit 1
fi

if ! "$PYTHON_BIN" -m pip --version >/dev/null 2>&1; then
  echo "ERROR: pip tidak tersedia." >&2
  exit 1
fi

echo ">> Python: $PYTHON_BIN"
echo ">> pip: $("$PYTHON_BIN" -m pip --version)"

VENV_DIR=".venv"

if [ ! -d "$VENV_DIR" ]; then
  echo ">> Membuat virtualenv di $VENV_DIR ..."
  if ! "$PYTHON_BIN" -m venv "$VENV_DIR"; then
    echo "ERROR: gagal membuat venv." >&2
    exit 1
  fi
fi

# shellcheck disable=SC1091
source "$VENV_DIR/bin/activate"

echo ">> Python venv: $(which python)"
echo ">> pip venv   : $(which pip)"

python -m pip install --upgrade pip setuptools wheel

if [ -f requirements.txt ]; then
  echo ">> Install dependencies ..."
  pip install -r requirements.txt
else
  echo "WARN: requirements.txt tidak ditemukan." >&2
fi

if [ ! -f .env ] && [ -f .env.example ]; then
  cp .env.example .env
  echo ">> .env dibuat dari .env.example"
fi

echo
echo "==============================================="
echo "Selesai."
echo "1) Edit .env (BOT_TOKEN + variabel dari me-cli)"
echo "2) Jalankan: bash run.sh"
echo "==============================================="
