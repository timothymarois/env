#!/bin/bash

username=$1
domain=$2
userpath=/home/${username}
logpath=${userpath}/logs/${domain}
rootpath=${userpath}/apps/${domain}
publicpath=${rootpath}/public

cd ${rootpath}

sudo -u ${username} bash << EOF

cd ${rootpath}

wget https://wordpress.org/latest.tar.gz

tar -xf latest.tar.gz

mv wordpress/* public/

echo "define('FS_METHOD','direct');" >> public/wp-config-sample.php

rm -rf latest.tar.gz
rm -rf wordpress

EOF

# make sure user has permissions
chown -R ${username}:apache ${rootpath}
chgrp -R apache ${rootpath}
chmod -R 0775 ${rootpath}
chmod -R g+s ${rootpath}
setfacl -Rdm g:apache:rwx ${rootpath}