# Bot Telegram Dor XL (mandiri)

## Instalasi
    bash setup.sh
    nano .env        # isi BOT_TOKEN dan variabel lain (lihat .env.example)
    bash run.sh

## Catatan
- Isi .env manual saat instalasi. File .env, ax.fp, dan bot_sessions.json TIDAK ikut repo (ada di .gitignore).
- Nilai panjang (BASIC_AUTH, X_API_BASE_SECRET, UA) tempel penuh; di nano aktifkan soft wrap dengan Alt+$ supaya tidak terpotong.
- run.sh memberi PERINGATAN bila ada nilai kosong atau terpotong.
- Nomor login MyXL wajib awalan 62 (contoh 628123456789), bukan 08. Nomor DANA/OVO tetap awalan 08.
- ax.fp dibuat otomatis saat pertama jalan; bot_sessions.json berisi token login pengguna, jangan dibagikan.
