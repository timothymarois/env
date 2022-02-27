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

To add or remove users

### Add User

Password not required and will be auto-generated if omitted.

`add-user.sh USERNAME PASSWORD`

### Remove User

`remove-user.sh USERNAME`

## Sites

To add or remove sites

### Add Site (with www. redirect)

`add-sitew.sh USERNAME DOMAIN`

### Add Site

`add-site.sh USERNAME DOMAIN`

### Remove site

`remove-site.sh USERNAME DOMAIN`

