#!/bin/bash

if [ "$(whoami)" != "root" ]
then
    echo "This script requires root."
    sudo su -s "$0"
    exit
fi

echo " >> Updagrading"

apt -y update && apt -y upgrade
dpkg-reconfigure tzdata
apt -y dist-upgrade ; apt -y update ; apt -y upgrade
apt -y install unattended-upgrades software-properties-common fail2ban
dpkg-reconfigure -plow unattended-upgrades
apt -y install mc htop

echo " >> Installing ufw and allowing SSH"
apt -y install ufw
ufw disable
ufw allow ssh

cd ~

echo " >> Installing full LEMP stack..."

add-apt-repository -y ppa:nginx/development && apt -y update
apt -y install nginx
apt -y install mariadb-server
service mysql stop
mysql_install_db
service mysql start
add-apt-repository -y ppa:ondrej/php && apt -y update
apt -y install php7.2
apt -y install php7.2-fpm php7.2-curl php7.2-gd php7.2-json php7.2-mysql php7.2-sqlite3 php7.2-pgsql php7.2-bz2 php7.2-mbstring php7.2-soap php7.2-xml php7.2-zip
mysql_secure_installation

add-apt-repository ppa:certbot/certbot
apt -y update
apt -y install python-certbot-nginx

echo " >> Allowing nginx in ufw"
ufw allow 'Nginx Full'
ufw reload

mkdir -p /etc/nginx/conf.d/server/
cd /etc/nginx/conf.d/server/
wget https://raw.githubusercontent.com/lucien144/lemp-stack/master/nginx/conf.d/server/1-common.conf
cd /etc/nginx/sites-available
rm default
wget https://raw.githubusercontent.com/lucien144/lemp-stack/master/nginx/sites-available/default
cd /etc/nginx/conf.d
wget https://raw.githubusercontent.com/lucien144/lemp-stack/master/nginx/conf.d/gzip.conf

cd /etc/nginx/conf.d/server/
wget https://raw.githubusercontent.com/lucien144/lemp-stack/master/nginx/conf.d/server/4-adminer.conf
mkdir -p /var/www/html/adminer/
cd /var/www/html/adminer/
wget https://www.adminer.org/latest.php -O index.php
chmod a+x index.php
nginx -t && nginx -s reload
apt -y install apache2-utils 
read -p ">> Write the Adminer htpasswd user: " htUser;
htpasswd -c .htpasswd $htUser
wget https://raw.githubusercontent.com/composer/getcomposer.org/1b137f8bf6db3e79a38a5bc45324414a6b1f9df2/web/installer -O - -q | php -- --quiet
mv composer.phar /usr/local/bin/composer
apt -y install nodejs && apt -y install npm
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
apt -y update && apt -y install yarn
apt -y upgrade

read -r -p ">> Reload firewall and reboot?[y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]
then
    ufw --force enable
    ufw --force reload
    echo " >> Done and rebooting..."
    /sbin/reboot
else
    echo " >> Done"
fi
