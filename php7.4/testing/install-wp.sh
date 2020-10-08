#!/bin/bash

# read -p "Domain Name "  domain
# echo "Setting up the $domain!"

# Setup the proper directories
# mkdir /var/www/html/production/$domain
# mkdir /var/www/html/staging/$domain
# mkdir /var/www/html/develop/$domain
# mkdir /var/www/html/production/$domain
# mkdir /var/www/html/backups/$domain

# # set up permissions
# sudo chown -R ec2-user:apache /var/www
# sudo chmod -R 0775 /var/www

YELLOW="\033[33m"
RED="\033[31m" 
BLUE="\033[34"
NC="\033[m"

getDomainList() {
    for i in $(ls -d */);
        do echo ${i%%/};
    done
}

getFilesystemDetails() {
    df -h
}

addDomain() {
    # ask for domain name
    read -p "$(tput setaf 3)Type domain name: $(tput sgr 0)" domain
    if [ "$domain" =~ "^((?!-)[A-Za-z0-9-]{1,63}(?<!-)\.)+[A-Za-z]{2,6}$" ] then
        echo "$(tput setaf 1)Not a valid domain, going back to main menu$(tput sgr 0)"
    else
        #Setup the proper directories
        mkdir /var/www/html/production/$domain
        mkdir /var/www/html/staging/$domain
        mkdir /var/www/html/develop/$domain
        mkdir /var/www/html/backups/$domain

        # set up permissions
        sudo chown -R ec2-user:apache /var/www
        sudo chmod -R 0775 /var/www

        # send output
        echo ".................................................";
        echo "$(tput setaf 2)Successfully added domain to directories:$(tput sgr 0)"
        echo "/var/www/html/production/${domain}"
        echo "/var/www/html/staging/${domain}"
        echo "/var/www/html/develop/${domain}"
        echo "/var/www/html/backups/${domain}"
        echo ".................................................";

    fi
}

removeDomain() {
    # ask for domain name
    read -p "$(tput setaf 3)Type domain name: $(tput sgr 0)" domain
    if [ "$domain" == "" ] 
    then
        echo "$(tput setaf 1)Ignoring, going back to main menu$(tput sgr 0)"
    else

        #Setup the proper directories
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

    fi
}


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

# submenu
# addDomain () {
#   local PS3='Please enter sub option: '
#   local options=("Sub menu item 1" "Sub menu item 2" "Sub menu quit")
#   local opt
#   select opt in "${options[@]}"
#   do
#       case $opt in
#           "Sub menu item 1")
#               echo "you chose sub item 1"
#               ;;
#           "Sub menu item 2")
#               echo "you chose sub item 2"
#               ;;
#           "Sub menu quit")
#               return
#               ;;
#           *) echo "invalid option $REPLY";;
#       esac
#   done
# } 

# main menu
echo "$(tput setaf 0)$(tput setab 7)Options:$(tput sgr 0)"
PS3="$(tput setaf 3)> $(tput sgr 0)"
options=("list, add, remove, backup, menu, fs, exit, restart")
select opt in "${options[@]}"
do
    case $REPLY in
        "list")
            echo -e "$(tput setaf 7)$(tput setab 4)Domains in production$(tput sgr 0)"
            getDomainList;;
        "add")
            addDomain
            ;;
        "remove")
            removeDomain
            ;;
        "backup")
            echo -e "you chose Backup Domain";;

        "restart")
            service httpd restart
            ;;
        "fs")
            getFilesystemDetails;;
        "menu")
            echo "list, add, remove, backup, menu, fs, exit, restart"
            ;;
        "exit")
            break;;
        *) echo -e "$(tput setaf 1)invalid option ${REPLY}$(tput sgr 0)";;
    esac
done