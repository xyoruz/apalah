cd ~/apalah
cp setup.sh setup.sh.bak
cat > setup.sh << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash
set -e
cd "$(dirname "$0")"

pkg install -y python python-pillow libjpeg-turbo libpng

if [ ! -d .venv ]; then
  python -m venv --system-site-packages .venv
fi

. .venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt
pip install qrcode requests

echo ">> Setup selesai. Jalankan: bash run.sh"
EOF
bash -n setup.sh && bash setup.sh
