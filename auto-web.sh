#!/bin/bash

DOMAIN=$1

if [ -z "$DOMAIN" ]; then
  echo "Usage: bash auto-web.sh namadomain"
  exit 1
fi

sudo apt update
sudo apt install apache2 php libapache2-mod-php -y

sudo mkdir -p /var/www/$DOMAIN
sudo chown -R $USER:$USER /var/www/$DOMAIN

cat <<EOF > /var/www/$DOMAIN/index.php
<?php
\$domainName = "$DOMAIN";
?>

<!DOCTYPE html>
<html>
<head>
    <title>CV <?= ucfirst(\$domainName) ?></title>
    <style>
        body {
            font-family: Arial;
            background: linear-gradient(135deg,#4e73df,#1cc88a);
            display:flex;
            justify-content:center;
            align-items:center;
            height:100vh;
            margin:0;
        }
        .card {
            background:white;
            padding:30px;
            border-radius:15px;
            box-shadow:0 10px 25px rgba(0,0,0,0.2);
            text-align:center;
            width:300px;
        }
    </style>
</head>
<body>
    <div class="card">
        <h1>Curriculum Vitae</h1>
        <p><b>Nama :</b> Leni</p>
        <p><b>Kelas :</b> TKJ 1</p>
        <p><i>Domain: <?= \$domainName ?>.local</i></p>
    </div>
</body>
</html>
EOF

sudo bash -c "cat <<EOF > /etc/apache2/sites-available/$DOMAIN.conf
<VirtualHost *:80>
    ServerName $DOMAIN.local
    DocumentRoot /var/www/$DOMAIN

    <Directory /var/www/$DOMAIN>
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog \${APACHE_LOG_DIR}/${DOMAIN}_error.log
    CustomLog \${APACHE_LOG_DIR}/${DOMAIN}_access.log combined
</VirtualHost>
EOF"

sudo a2ensite $DOMAIN.conf
sudo systemctl reload apache2

echo "Akses: http://$DOMAIN.local"