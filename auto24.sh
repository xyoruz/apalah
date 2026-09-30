cat > /root/apalah/auto24.sh <<'SCRIPT'
#!/usr/bin/env bash
# auto24.sh - Jalankan bot Telegram 24 jam via systemd
# Pakai: bash auto24.sh [start|stop|restart|status|log|uninstall]

SERVICE_NAME="mybot"
APP_DIR="/root/apalah"
RUN_SCRIPT="$APP_DIR/run.sh"
SERVICE_FILE="/etc/systemd/system/${SERVICE_NAME}.service"
LOG_FILE="$APP_DIR/bot.log"

cmd="${1:-install}"

case "$cmd" in
  install|start)
    if [ ! -f "$RUN_SCRIPT" ]; then
      echo "ERROR: $RUN_SCRIPT tidak ditemukan."
      exit 1
    fi
    if [ ! -f "$APP_DIR/.env" ]; then
      echo "ERROR: $APP_DIR/.env tidak ada. Isi dulu."
      exit 1
    fi

    cat > "$SERVICE_FILE" <<EOF
[Unit]
Description=Telegram Bot Dor V2
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
User=root
WorkingDirectory=$APP_DIR
ExecStart=/bin/bash $RUN_SCRIPT
Restart=always
RestartSec=5
StandardOutput=append:$LOG_FILE
StandardError=append:$LOG_FILE

[Install]
WantedBy=multi-user.target
EOF

    systemctl daemon-reload
    systemctl enable "$SERVICE_NAME" >/dev/null 2>&1
    systemctl restart "$SERVICE_NAME"
    sleep 2
    systemctl status "$SERVICE_NAME" --no-pager -l | head -12
    echo
    echo "✅ Bot aktif 24 jam. Auto-restart & auto-start saat reboot."
    echo "   Log: tail -f $LOG_FILE"
    ;;

  stop)
    systemctl stop "$SERVICE_NAME"
    echo "⏹  Bot dihentikan."
    ;;

  restart)
    systemctl restart "$SERVICE_NAME"
    sleep 2
    systemctl status "$SERVICE_NAME" --no-pager -l | head -10
    ;;

  status)
    systemctl status "$SERVICE_NAME" --no-pager -l
    ;;

  log)
    tail -f "$LOG_FILE"
    ;;

  uninstall)
    systemctl stop "$SERVICE_NAME" 2>/dev/null
    systemctl disable "$SERVICE_NAME" 2>/dev/null
    rm -f "$SERVICE_FILE"
    systemctl daemon-reload
    echo "🗑  Service dihapus."
    ;;

  *)
    echo "Pakai: bash auto24.sh [install|start|stop|restart|status|log|uninstall]"
    ;;
esac
SCRIPT

chmod +x /root/apalah/auto24.sh
