#!/bin/bash

username=$1
domain=$2
userpath=/home/${username}
logpath=${userpath}/logs/${domain}
rootpath=${userpath}/apps/${domain}
publicpath=${rootpath}/public

# go into root folder
cd ${userpath}

# make site directory
mkdir ${logpath} 
mkdir ${rootpath} 
mkdir ${publicpath} 

# make sure user has permissions
chown -R ${username}:apache ${rootpath}
chgrp -R apache ${rootpath}
chmod -R 0775 ${rootpath}
chmod -R g+s ${rootpath}
setfacl -Rdm g:apache:rwx ${rootpath}

sudo find ${rootpath} -type d -exec chmod 755 {} \;
sudo find ${rootpath} -type f -exec chmod 644 {} \;

# go into root folder
cd /root/tools

# copy the example
cp example.conf ${domain}.conf

echo "--------------------------------"
echo ${username}
echo ${domain}
echo ${rootpath}
echo "--------------------------------"

# create a new vhost
cat > ${domain}.conf <<EOF  
# ${domain}
# ---------------------------------------------------------------------------
<VirtualHost *:80 *:443>
    DocumentRoot ${publicpath}
    ServerName ${domain}

    RewriteEngine On

    # remove the www. (redirect to non-www)
    #RewriteCond %{HTTP_HOST} ^www\.(.*)$ [NC]
    #RewriteRule ^(.*)$ http://%1/\$1 [R=301,L]

    # redirect to https (if using http)
    RewriteCond %{SERVER_PORT} ^80$
    RewriteRule ^(.*)$ https://%{SERVER_NAME}%{REQUEST_URI} [R=301,L]

    <IfModule setenvif_module>
        SetEnvIf X-Forwarded-Proto https HTTPS=on
    </IfModule>

    <Directory />
        Require all granted
        Options -FollowSymLinks +SymLinksIfOwnerMatch
        AllowOverride AuthConfig FileInfo Indexes Limit Options=All,MultiViews
    </Directory>

    <IfModule dir_module>
        DirectoryIndex index.html index.php
    </IfModule>

    ErrorLog "${logpath}/errors.log"

    CustomLog "${logpath}/access.log" common

    # debug, info, notice, warn, error, crit,
    LogLevel crit
</VirtualHost>
# ---------------------------------------------------------------------------
EOF

mv ${domain}.conf /etc/httpd/conf.d/${domain}.conf

echo "Restarting..."

service httpd restart

echo "--------------------------------"
echo "Enabling SSL..."

certbot --apache --agree-tos --email "tim@marois.io" --server https://acme-v02.api.letsencrypt.org/directory -d ${domain} --non-interactive --post-hook "service httpd restart"

echo "--------------------------------"
echo "Restarting..."

service httpd restart