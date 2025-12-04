# Reverse Proxy & SSL Automation (Nginx & Certbot)

*Repository* Ini Berisi *Script* Bash Yang Dirancang Untuk Mengotomatisasi Proses *Setup* **Reverse Proxy Nginx** dan Instalasi **Sertifikat SSL (HTTPS) menggunakan Certbot/Let's Encrypt** Di Virtual Private Server (VPS) Berbasis Linux (Debian/Ubuntu).

# Prasyarat

Sebelum Menjalankan *Script*, Pastikan Anda Sudah Memenuhi Prasyarat Berikut Di **VPS** dan **DNS** Anda:

* **Akses SSH:** Akses `sudo` Di VPS Anda.
* **Aplikasi Berjalan:** Aplikasi Target Sudah Berjalan dan *Listening* Di **Port** Yang Anda Tuju (Misalnya, Port 5000) Di *Server* Anda.
* **Record DNS A:** Anda Sudah Membuat **Record A** Di Penyedia DNS Anda Yang Mengarahkan **Subdomain** Baru Anda Ke **IP VPS** Anda.
* **Dependencies:** `git`, `nginx`, dan `certbot` (Dengan Plugin `python3-certbot-nginx`) Sudah Terinstal.

---

## ⚙️ Langkah Penggunaan

```bash
# Pindah Ke Direktori Home
cd ~

# Kloning Eepositori
git clone [https://github.com/Lenwyy/Reverse-Proxy-Nginx.git](https://github.com/Lenwyy/Reverse-Proxy-Nginx.git)

# Masuk Ke Direktori
cd Reverse-Proxy-Nginx

# Sesuaikan
nano ReverseProxy.sh

# Ubah Sesuai Kebutuhan
APP_DOMAIN="nama-subdomain-baru.web.id" # Domain/Subdomain
APP_PORT="PORT_APLIKASI"                # PORT Tujuan
APP_IP="151.240.0.110"                  # IP VPS
# Beri Izin Eksekusi
sudo chmod +x ReverseProxy.sh

# Jalankan Script!
sudo ./ReverseProxy.sh