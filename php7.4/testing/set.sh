#!/bin/bash

# Num  Colour    #define         R G B
# 0    black     COLOR_BLACK     0,0,0
# 1    red       COLOR_RED       1,0,0
# 2    green     COLOR_GREEN     0,1,0
# 3    yellow    COLOR_YELLOW    1,1,0
# 4    blue      COLOR_BLUE      0,0,1
# 5    magenta   COLOR_MAGENTA   1,0,1
# 6    cyan      COLOR_CYAN      0,1,1
# 7    white     COLOR_WHITE     1,1,1

# tput bold    # Select bold mode
# tput dim     # Select dim (half-bright) mode
# tput smul    # Enable underline mode
# tput rmul    # Disable underline mode
# tput rev     # Turn on reverse video mode
# tput smso    # Enter standout (bold) mode
# tput rmso    # Exit standout mode

# tput setab [1-7] # Set the background colour using ANSI escape
# tput setaf [1-7] # Set the foreground colour using ANSI escape

YELLOW="\033[33m"
RED="\033[31m" 
BLUE="\033[34"
NC="\033[m"

function removeEmptyLines()
{
    local -r content="${1}"

    echo -e "${content}" | sed '/^\s*$/d'
}

function repeatString()
{
    local -r string="${1}"
    local -r numberToRepeat="${2}"

    if [[ "${string}" != '' && "${numberToRepeat}" =~ ^[1-9][0-9]*$ ]]
    then
        local -r result="$(printf "%${numberToRepeat}s")"
        echo -e "${result// /${string}}"
    fi
}

function isEmptyString()
{
    local -r string="${1}"

    if [[ "$(trimString "${string}")" = '' ]]
    then
        echo 'true' && return 0
    fi

    echo 'false' && return 1
}

function trimString()
{
    local -r string="${1}"

    sed 's,^[[:blank:]]*,,' <<< "${string}" | sed 's,[[:blank:]]*$,,'
}






getFilesystemDetails() {
    df -h
}


listDomains() {
    arrVar=()
    cd /var/www/html/production
    for i in $(ls -d */);
        # do echo ${i%%/};
        do
        arrVar+=(${i%%/})
    done
    cd /

    printTable ',' "list, get a list of domains"
}

addDomain() {
    # ask for domain name
    read -p "$(tput setaf 3)Type domain name: $(tput sgr 0)" domain
    # check the domain is actually a domain name...
    if grep -oP '^((?!-)[A-Za-z0-9-]{1,63}(?<!-)\.)+[A-Za-z]{2,6}$' <<< "$domain" >/dev/null 2>&1;
    then
        # Setup the proper directories
        mkdir /var/www/html/production/$domain
        mkdir /var/www/html/production/$domain/public
        mkdir /var/www/html/staging/$domain
        mkdir /var/www/html/develop/$domain
        mkdir /var/www/html/backups/$domain
        # set up permissions
        sudo chown -R ec2-user:apache /var/www
        sudo chmod -R 0775 /var/www
        # send output
        echo ".................................................";
        echo "$(tput setaf 2)Successfully added domain to directories:$(tput sgr 0)"
        echo "/var/www/html/production/${domain}/public"
        echo "/var/www/html/staging/${domain}"
        echo "/var/www/html/develop/${domain}"
        echo "/var/www/html/backups/${domain}"
        echo ".................................................";
        # add the virtual host 
        addVirtualHost80 $domain
    else
        echo "$(tput setaf 1)Not a valid domain, going back to main menu$(tput sgr 0)"
    fi
}

removeDomain() {
    # ask for domain name
    read -p "$(tput setaf 3)Type domain name: $(tput sgr 0)" domain
    # check the domain is actually a domain name...
    if grep -oP '^((?!-)[A-Za-z0-9-]{1,63}(?<!-)\.)+[A-Za-z]{2,6}$' <<< "$domain" >/dev/null 2>&1;
    then
        # Setup the proper directories
        rm -rf /var/www/html/production/$domain
        rm -rf /var/www/html/staging/$domain
        rm -rf /var/www/html/develop/$domain
        rm -rf /var/www/html/backups/$domain
        # send output
        echo ".................................................";
        echo "$(tput setaf 2)Successfully removed domain:$(tput sgr 0)"
        echo "removed: /var/www/html/production/${domain}"
        echo "removed: /var/www/html/staging/${domain}"
        echo "removed: /var/www/html/develop/${domain}"
        echo "removed: /var/www/html/backups/${domain}"
        echo ".................................................";
    else
        echo "$(tput setaf 1)Not a valid domain, going back to main menu$(tput sgr 0)"
    fi
}


addVirtualHost80() {
    # domain name from args
    local domain="$1"
# add the virtual host 
cat > /etc/httpd/conf.d/sites-${domain}.conf << EOF
    <VirtualHost *:80 *:443>
        DocumentRoot /var/www/html/production/$domain/public
        ServerName $domain
        ServerAlias www.$domain

        RewriteEngine On

        # remove the www. (redirect to non-www)
        #RewriteCond %{HTTP_HOST} ^www\.(.*)$ [NC]
        #RewriteRule ^(.*)$ http://%1/$1 [R=301,L]
    </VirtualHost>
EOF
}

certbotAdd() {
    # domain name from args
    # local domain="$1"
    # run the certbot program -d ${domain} --non-interactive 
    certbot --agree-tos -m timothymarois@gmail.com --apache --post-hook "sudo service httpd restart"
}

certbotRenew() {
    certbot renew --post-hook "sudo service httpd restart"
}

cerbot() {
    echo "$(tput setaf 0)$(tput setab 7)Certbot Options (certbot):$(tput sgr 0)"
    PS3="$(tput setaf 3)cerbot: $(tput sgr 0)"
    local options=("add" "renew" "back")
    local opt
    select opt in "${options[@]}"
    do
        case $opt in
            "add")
                certbotAdd
                ;;
            "renew")
                certbotRenew
                ;;
            "back")
                PS3="$(tput setaf 3)> $(tput sgr 0)"
                echo "Options: list, add, remove, backup, menu, fs, exit, restart, certbot"
                return
                ;;
            *) echo -e "$(tput setaf 1)invalid option \"${REPLY}\"$(tput sgr 0)";;
        esac
    done
} 

# main menu
echo "$(tput setaf 0)$(tput setab 7)Options:$(tput sgr 0)"
PS3="$(tput setaf 3)> $(tput sgr 0)"
options=("list, add, remove, backup, menu, fs, exit, restart, certbot")
select opt in "${options[@]}"
do
    case $REPLY in
        "list")
            echo -e "$(tput setaf 7)$(tput setab 4)Domains in production$(tput sgr 0)"
            listDomains;;
        "add")
            addDomain
            ;;
        "remove")
            removeDomain
            ;;
        "backup")
            echo -e "you chose Backup Domain"
            ;;
        "certbot")
            cerbot
            ;;
        "restart")
            service httpd restart
            ;;
        "fs")
            getFilesystemDetails;;
        "menu")
            echo "list, add, remove, backup, menu, fs, exit, restart, certbot"
            ;;
        "exit")
            break;;
        *) echo -e "$(tput setaf 1)invalid option \"${REPLY}\"$(tput sgr 0)";;
    esac
done