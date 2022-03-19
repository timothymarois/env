# ENV

Built for Amazon Linux 2 with EC2 Instances on AWS

## How to Install

1) Log into SSH using `ec2-user`

2) Run `sudo su`

3) Run the install script:

```
sudo wget https://raw.githubusercontent.com/timothymarois/env/master/php7.4/install.sh -O - | sh
```

## How to Update

You can update this repo on the instance by going to:

Go to: `cd /root/env` and then `git pull`

## File Locations

**User files** are organized as: `/home/USER`

- `/apps` Where all the domains and web apps are located
- `/logs` Where you can log php/apache/http errors
- `/staging` Where all the web app repositories are stored
- `/storage` Where the user can place files for storage
- `/backups` Where all the backup files will be stored

# Users

To add or remove users from the instance (includes FTP access to each user)

### Add User

Password not required and will be auto-generated if omitted.

```
sh add-user.sh USER PASSWORD
```

### Remove User

Removing a user will also delete all its contents, including any website data. It is best to remove each site before removing the entire user.

```
sh remove-user.sh USER
```

# Sites

To add or remove sites. 

Note: before adding a website, it is advised to point the website A record to the instance IP address since adding a site will also install the SSL certificate, otherwise it may fail to complete.

### Add Site (with www. redirect)

```
sh add-sitew.sh USER DOMAIN
```

### Add Site

```
sh add-site.sh USER DOMAIN
```

### Remove site

Removing a site will delete all its contents and remove its SSL certificate.

```
sh remove-site.sh USER DOMAIN
```

# Web App Build & Deploy

### Add Repository

This will install the repository under the `/home/USER/staging/REPONAME`

```
# example (if private): https://USERNAME:GITKEY@github.com/${github}.git
sh add-git.sh USER REPONAME GITHUB_LINK
```

### Build PHP/Composer Web App

This will run **git pull** and **composer install** on staging env. 

Use the same REPONAME that you setup in the Add Repository section.

(Note: this has been tested for Laravel builds)

```
sh build-php-composer.sh USER REPONAME BRANCH
```

### Deploy Web App

This will deploy the php web app from `/home/USER/staging/REPONAME` to `/home/USER/apps/DOMAIN`

Use the same REPONAME that you setup in the Add Repository section.

(Note: this has been tested for Laravel deployments)

```
sh deploy.sh USER REPONAME DOMAIN
```