#!/bin/bash

# Ubah Sesuai kebutuhan
APP_DOMAIN="Domain/Subdomain" # Domain/Subdomain
APP_PORT="4000"                     # PORT Tujuan
APP_IP="IP VPS"              # IP VPS
NGINX_CONF="/etc/nginx/sites-available/$APP_DOMAIN"

echo "--- Memulai Otomatisasi Reverse Proxy Untuk $APP_DOMAIN (Port $APP_PORT) ---"

echo "1. Membuat File Konfigurasi Nginx $NGINX_CONF"
sudo tee $NGINX_CONF > /dev/null <<EOF
server {
    server_name $APP_DOMAIN;

    location / {
        # Mengarahkan Traffic Ke Port Aplikasi
        proxy_pass http://$APP_IP:$APP_PORT;

        # Header Penting Untuk Proxy
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_cache_bypass \$http_upgrade;
    }

    # Block HTTP Sementara Untuk Certbot
    listen 80;
}
EOF
echo "   -> File Konfigurasi Berhasil Dibuat."

echo "2. Membuat Symlink Ke Sites-enabled dan Menguji Nginx"
sudo ln -s $NGINX_CONF /etc/nginx/sites-enabled/
if sudo nginx -t; then
    echo "   -> Syntax Nginx OK. Reload Nginx..."
    sudo systemctl reload nginx
else
    echo "   !!! ERROR: Nginx syntax error. Silakan Periksa File $NGINX_CONF Secara Manual."
    exit 1
fi

echo "3. Menjalankan Certbot Untuk Mengambil dan Menginstal Sertifikat SSL"
sudo certbot --nginx -d $APP_DOMAIN

echo "4. Memastikan UFW Mengizinkan Nginx Full (Port 80 & 443)"
sudo ufw allow 'Nginx Full'

echo "5. Uji Syntax dan Reload Nginx."
if sudo nginx -t; then
    sudo systemctl reload nginx
    echo "--- Otomatisasi Selesai! $APP_DOMAIN Sekarang Sudah HTTPS dan Berjalan Di Port $APP_PORT. ---"
else
    echo "   !!! ERROR: Nginx syntax error setelah Certbot. Perlu pemeriksaan manual."
    exit 1
fi