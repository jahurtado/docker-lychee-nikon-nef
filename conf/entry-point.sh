#!/bin/bash
usermod -u ${PUID} www-data
groupmod -g ${PGID} www-data

echo "Switching UID and GID"
su -s /bin/bash -c 'id' www-data

if [ ! -d "/uploads/thumb" ]; then
    # create directory structure and set file owner for the first time
    mkdir /uploads/thumb
    mkdir /uploads/medium
    mkdir /uploads/big
    mkdir /uploads/import
    chown -R www-data:www-data /uploads
    chown -R www-data:www-data /data
fi

supervisord -c /etc/supervisor/supervisord.conf
