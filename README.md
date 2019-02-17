# OpenBSD Ansible Dev

This repo is used for testing quick deployment on Vultr. This is for development testing only, and will be changing often. There are two ways to use this playbook. Either install OpenBSD and install manually, or use Startup Scripts on Vultr. Methods are explained below.

## Manual Installation

This playbook is designed to be run on a fresh OpenBSD installation. While this is not required, the playbook may unintentionally overwrite files.

1. Install OpenBSD
2. Download and run playbook to setup basic system
  `ftp -o - https://gitlab.com/Verticaleap/openbsd-ansible-dev/raw/master/bootstraps/bootstrap_basic.sh | sh`
3. Set admin password 
  `passwd admin`

## Scripted Startup Installation

Create a startup script on vultr:

```
#!/bin/sh

admin_pass=password11

# Download and install OpenBSD with basic playbook
ftp -o - https://gitlab.com/Verticaleap/openbsd-wg/raw/master/bootstraps/bootstrap_basic.sh | sh

# Set admin password
usermod -p $(encrypt $admin_pass) admin

# Add public key to admin
echo "ssh-rsa AAAA...D9H7xnv admin@server" >> /home/admin/.ssh/authorized_keys
```

## Current bootstrap scripts

Here are the current bootstrap scripts available

* bootstrap_basic.sh
  - This deploys a very basic image
* bootstrap_wireguard.sh
  - This deploys an image configured as a wireguard server
* bootstrap_wireguard_with_vnc.sh
  - This deploys an image with wireguard, but includes a vnc server.
