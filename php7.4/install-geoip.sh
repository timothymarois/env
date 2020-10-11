#!/usr/bin bash

# go back to tmp
cd /tmp

# if doesnt eixst... create it
mkdir /usr/local/etc/
wget -N https://raw.githubusercontent.com/timothymarois/env/master/php7.4/GeoIP.conf
mv -f GeoIP.conf /usr/local/etc/GeoIP.conf

# Install new version of geoip 4
wget https://github.com/maxmind/geoipupdate/releases/download/v4.3.0/geoipupdate_4.3.0_linux_386.tar.gz
tar -xf geoipupdate_4.3.0_linux_386.tar.gz

# replace existing version...
mv -f ./geoipupdate_4.3.0_linux_386/geoipupdate /bin/geoipupdate

# mkdir for geoip databases
mkdir /usr/local/share/GeoIP

# run the update command
geoipupdate