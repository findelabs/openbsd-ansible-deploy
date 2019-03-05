#!/usr/bin/env bash

trap "error" ERR

. /home/admin/bin/functions

error() {
    rm -r /tmp/configs_$date
    frogger.sh -e -s $scriptname -m "Error backing up configs"
    exit 1
}

conf=/etc/router/backup_configs.conf

mydate=$(date +%Y%m%d%H%M)
configs=$(grep -v ^\# $conf)

mkdir /tmp/configs_$mydate

for i in $(echo "$configs"); do
    test -e $i && doas cp -p $i /tmp/configs_$mydate
done

cd /tmp && doas tar cpzf /var/configs/configs_$mydate.tar.gz configs_$mydate/

# Remove the temp dir
doas rm -r /tmp/configs_$mydate

# Remove config files older than 30 days
find /var/configs/ -mtime +30 -exec doas rm {} \;

frogger.sh -s $scriptname -m "Backed up configs"
