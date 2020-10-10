#!/bin/bash

username=$1
domain=$2
userpath=/home/${username}
logpath=${userpath}/logs/${domain}
rootpath=${userpath}/apps/${domain}
publicpath=${rootpath}/public

# go into root folder
cd /root/tools

# make site directory
mkdir ${logpath}
mkdir ${rootpath}
mkdir ${publicpath} 

# make sure user has permissions
umask 002
chown -R ${username}:apache ${rootpath}
chgrp -R apache ${rootpath}
chmod g+s ${rootpath}
chmod -R 0775 ${rootpath}

# copy the example
cp example.conf ${domain}.conf

# create a new vhost
cat > ${domain}.conf <<EOF  
# ${domain}
# ---------------------------------------------------------------------------
<VirtualHost *:80 *:443>
    DocumentRoot ${publicpath}
    ServerName ${domain}

    RewriteEngine On

    # remove the www. (redirect to non-www)
    RewriteCond %{HTTP_HOST} ^www\.(.*)$ [NC]
    RewriteRule ^(.*)$ http://%1/$1 [R=301,L]

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

    # debug, info, notice, warn, error, crit,
    LogLevel crit
</VirtualHost>
# ---------------------------------------------------------------------------
EOF

mv ${domain}.conf /etc/httpd/conf.d/${domain}.conf

service httpd restart

certbot --apache --agree-tos --server https://acme-v02.api.letsencrypt.org/directory -d ${domain} --non-interactive --post-hook "service httpd restart"

service httpd restart