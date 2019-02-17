# Wireguard server on OpenBSD

This playbook will create a functional wireguard server, utilizing one tun device for multiple endpoint connections.

## Installation

This playbook is designed to be run on a fresh OpenBSD installation. While this is not required, the playbook may unintentionally overwrite files.

1. Install OpenBSD
2. Download and run playbook
  `ftp -o - https://gitlab.com/Verticaleap/openbsd-wg/raw/master/bootstrap.sh | sh`
3. Set admin password 
  `passwd admin`

The following services are installed and configured:  

* wireguard-configs
  - Configurations are stored in /etc/wireguard/
  - wgkeys.sh script is created for simple management
  - tun3 is set to start on boot to receive connections
* wireguard-binaries
  - No prepackaged OpenBSD Wireguard packages available currently
  - Compiles wg, wg-quick, and wireguard-go from source
  - Installs all required packages for build
  - Will update WireGuard to current snapshot
* unbound
  - All DNS requests are routed to unbound
  - DNSSec is enabled by default
* vnstat
  - Monitor the egress interface
* ifstated
  - Used to ensure the wireguard tunnel remains up
* pf
  - PF is used to provide NAT'ing to egress from the wireguard tunnel
  - Blocks unnecessary connections to the server
  - log interface set to egress

## Setting up wireguard

All commands should be run as the admin user just created

* wgkeys.sh is installed within /home/admin/bin
  - This simple script creates ten client configs and keys within /etc/wireguard when ran with no arguments
* Simplify config imports by exporting client configs as qr codes
  - Running `wgkeys.sh -q 1` will display the qr code for client1's config

## Secure by default

* Password logins over ssh are disabled
* Admin user is created to reduce root usage
* DNS over TLS enabled

## Additional tools installed

The playbook installs following extra packages to assist with system monitoring, and more:  

* vnstat
* iftop
* htop
* git
* mtr
* vim


## Finishing up

Make sure to run syspatch regularily to keep your OpenBSD server up to date.

Read about creating a wireguard server manually [here](https://www.findelabs.com/post/wireguard-on-openbsd/).
