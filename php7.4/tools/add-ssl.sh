domain=$1

certbot --server https://acme-v02.api.letsencrypt.org/directory -d ${domain}

service httpd restart