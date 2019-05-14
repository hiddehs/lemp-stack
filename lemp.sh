#!/bin/bash

if [ "$(whoami)" != "root" ]
then
    echo This script requires root.
    sudo su -s "$0"
    exit
fi

apt update && apt upgrade
dpkg-reconfigure tzdata
apt-get -y dist-upgrade ; apt-get -y update ; apt-get -y upgrade
apt-get -y install unattended-upgrades software-properties-common apache2-utils fail2ban

echo ufw ssh

apt install ufw
ufw disable
ufw allow ssh
ufw enable


cd ~

echo installing full LEMP stack

add-apt-repository -y ppa:nginx/development && apt-get update
apt-get -y install nginx
apt-get -y install mariadb-server
service mysql stop
mysql_install_db
service mysql start
add-apt-repository -y ppa:ondrej/php && apt-get update
apt-get -y install php7.2
apt-get -y install php7.2-fpm php7.2-curl php7.2-gd php7.2-json php7.2-mysql php7.2-sqlite3 php7.2-pgsql php7.2-bz2 php7.2-mbstring php7.2-soap php7.2-xml php7.2-zip
mysql_secure_installation

add-apt-repository ppa:certbot/certbot
apt update
apt-get install python-certbot-apache

echo ufw nginx
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
cd ~
wget https://raw.githubusercontent.com/lucien144/lemp-stack/master/add-vhost.sh
chmod u+x add-vhost.sh
./add-vhost.sh
cd /etc/nginx/conf.d/server/
wget https://raw.githubusercontent.com/lucien144/lemp-stack/master/nginx/conf.d/server/4-adminer.conf
mkdir -p /var/www/html/adminer/
cd /var/www/html/adminer/
wget https://www.adminer.org/latest.php -O index.php
chmod a+x index.php
htpasswd -c .htpasswd user
nginx -t && nginx -s reload
apt install apache2-utils 
htpasswd -c .htpasswd hidde
wget https://raw.githubusercontent.com/composer/getcomposer.org/1b137f8bf6db3e79a38a5bc45324414a6b1f9df2/web/installer -O - -q | php -- --quiet
mv composer.phar /usr/local/bin/composer
apt-get install nodejs
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
apt-get update && apt-get install yarn
apt upgrade