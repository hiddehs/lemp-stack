# LEMP Stack

Full LEMP Stack installation inspired by- and using resources from @lucien144 's [lemp-stack](https://github.com/lucien144/lemp-stack)

## Start stacking

```sh
wget https://raw.githubusercontent.com/hiddehs/lemp-stack/master/lemp.sh -O lemp.sh && chmod u+x lemp.sh
./lemp.sh
```

## vhost Management

```sh
wget https://raw.githubusercontent.com/hiddehs/lemp-stack/master/add-vhost.sh -O add-vhost.sh && chmod u+x add-vhost.sh
./add-vhost.sh
```

## Contents

- Nginx
- PHP 7.2
- MariaDB
  - Adminer web db management
- Certbot Let's Encrypt
- Composer
- NodeJS Yarn
- vhost management
  - Nice directory structure in `/var/www/vhost/`
  - PHP Pool creation
  - Install Let's Encrypt certificate directly

## Compatiblity

Compatible and tested with Ubuntu 18.04
