#!/bin/bash

username=$1
domain=$2
userpath=/home/${username}
logpath=${userpath}/logs/${domain}
rootpath=${userpath}/apps/${domain}
publicpath=${rootpath}/public

# remove site vhost
rm -rf /etc/httpd/conf.d/${domain}.conf

# remove all site files and logs
rm -rf ${rootpath}
rm -rf ${logpath}

# remove certificate on domain
certbot delete --cert-name ${domain} --post-hook "service httpd restart"

service httpd restart