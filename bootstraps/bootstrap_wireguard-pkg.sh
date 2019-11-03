# Bootstrap the system
ftp -V -o - https://gitlab.com/Verticaleap/openbsd-ansible-dev/raw/master/bootstraps/bootstrap_raw.sh | sh

# Run playbook
cd /root/git/openbsd-ansible-dev/ && ansible-playbook install.yml --tags=users,system,wireguard-pf,wireguard-pkg,wireguard-configs,unbound,vnstatd,ifstated,sysctl_router --extra-vars="unbound_address=10.10.0.1 vnstatd_interface=tun3"
