## Instructions 

1) Log into SSH using `ec2-user`

2) Run `sudo su`

3) Run the install script:

```
sudo wget https://raw.githubusercontent.com/timothymarois/env/master/php7.4/install.sh -O - | sh
```

## Updates

You can update this repo on the instance by going to:

Go to: `cd /root/env` and then `git pull`

## Users

To add or remove users from the instance (includes FTP access to each user)

### Add User

Password not required and will be auto-generated if omitted.

```
sh add-user.sh USERNAME PASSWORD
```

### Remove User

```
sh remove-user.sh USERNAME
```

## Sites

To add or remove sites. 

Note: before adding a website, it is advised to point the website A record to the instance IP address since adding a site will also install the SSL certificate, otherwise it may fail to complete.

### Add Site (with www. redirect)

```
sh add-sitew.sh USERNAME DOMAIN
```

### Add Site

```
sh add-site.sh USERNAME DOMAIN
```

### Remove site

Removing a site will delete all its contents and remove its SSL certificate.

```
sh remove-site.sh USERNAME DOMAIN
```

