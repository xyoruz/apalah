#!/usr/bin/env bash
# Termux / Linux. Jalankan: bash setup.sh
set -e

# ---- Deteksi distro & install dependency ----
if command -v pkg >/dev/null 2>&1; then
  # Termux
  echo ">> Termux terdeteksi"
  pkg update -y && pkg upgrade -y
  pkg install -y python python-pip git clang make libffi openssl libjpeg-turbo
  # Pillow di Termux biasanya tidak perlu paket terpisah, sudah ada wheel
  PYTHON_BIN="python"
elif command -v apt >/dev/null 2>&1; then
  # Debian / Ubuntu
  echo ">> Debian/Ubuntu terdeteksi"
  apt update -y
  apt install -y python3 python3-pip python3-venv git clang make libffi-dev libssl-dev libjpeg-dev
  PYTHON_BIN="python3"
elif command -v dnf >/dev/null 2>&1; then
  # Fedora / RHEL
  echo ">> Fedora/RHEL terdeteksi"
  dnf install -y python3 python3-pip git clang make libffi-devel openssl-devel libjpeg-turbo-devel
  PYTHON_BIN="python3"
elif command -v pacman >/dev/null 2>&1; then
  # Arch
  echo ">> Arch terdeteksi"
  pacman -Sy --noconfirm python python-pip git clang make libffi openssl libjpeg-turbo
  PYTHON_BIN="python"
else
  echo "ERROR: distro tidak dikenali. Pastikan python3 & pip sudah terinstall." >&2
  exit 1
fi

# ---- Pastikan python & pip tersedia ----
if ! command -v "$PYTHON_BIN" >/dev/null 2>&1; then
  echo "ERROR: $PYTHON_BIN tidak ditemukan." >&2
  exit 1
fi

# Cek pip lewat modul (lebih reliable daripada command pip)
if ! "$PYTHON_BIN" -m pip --version >/dev/null 2>&1; then
  echo "ERROR: pip tidak tersedia untuk $PYTHON_BIN." >&2
  echo "Coba install manual: pkg install python-pip  (Termux) / apt install python3-pip (Debian)" >&2
  exit 1
fi

echo ">> Menggunakan Python: $PYTHON_BIN"
echo ">> Versi pip: $("$PYTHON_BIN" -m pip --version)"

# ---- Buat virtualenv (khusus Termux & praktik terbaik Linux) ----
VENV_DIR=".venv"

if [ ! -d "$VENV_DIR" ]; then
  echo ">> Membuat virtualenv di $VENV_DIR ..."
  # Termux: python -m venv sudah include di paket python
  if ! "$PYTHON_BIN" -m venv "$VENV_DIR"; then
    echo "ERROR: gagal membuat venv. Pastikan paket venv terinstall." >&2
    echo "  Termux : pkg install python" >&2
    echo "  Debian : apt install python3-venv" >&2
    exit 1
  fi
fi

# Aktifkan venv
# shellcheck disable=SC1091
source "$VENV_DIR/bin/activate"

echo ">> Python venv aktif: $(which python)"
echo ">> Pip venv         : $(which pip)"

# ---- Upgrade pip DIIZINKAN karena sudah di dalam venv ----
echo ">> Upgrade pip di dalam venv ..."
python -m pip install --upgrade pip setuptools wheel

# ---- Install requirements ----
if [ -f requirements.txt ]; then
  echo ">> Install dependencies dari requirements.txt ..."
  pip install -r requirements.txt
else
  echo "WARN: requirements.txt tidak ditemukan, skip." >&2
fi

# ---- Setup .env ----
if [ ! -f .env ] && [ -f .env.example ]; then
  cp .env.example .env
  echo ">> .env dibuat dari .env.example"
fi

echo
echo "==============================================="
echo "Selesai."
echo "1) Edit .env (BOT_TOKEN + 10 variabel dari me-cli)"
echo "2) Jalankan: bash run.sh"
echo "==============================================="
