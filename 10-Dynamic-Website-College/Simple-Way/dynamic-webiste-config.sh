#!/bin/bash
# ...existing code...
cd /var/www/html
rm -r *
git clone https://github.com/garvdohere/Dynamic-Website.git
cd Dynamic-Website
mv * ..
cd ..
rm -r Dynamic-Website 
sudo apt update
sudo apt install -y mysql-server php libapache2-mod-php php-mysql
sudo chown -R www-data:www-data /var/www/html 
sudo chmod -R 755 /var/www/html
sudo systemctl start apache2
sudo systemctl enable apache2

mysql -u root -e "
CREATE DATABASE webdb;
USE webdb;
CREATE TABLE messages (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100),
  message TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE USER 'webuser'@'localhost' IDENTIFIED BY 'webpass123';
GRANT ALL PRIVILEGES ON webdb.* TO 'webuser'@'localhost';
FLUSH PRIVILEGES;"