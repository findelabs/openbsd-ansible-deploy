# Bootstrap the system
ftp -o - https://gitlab.com/Verticaleap/openbsd-ansible-dev/raw/master/bootstraps/bootstrap_raw.sh | sh

# Run playbook
cd /root/git/openbsd-ansible-dev/ && ansible-playbook install.yml --tags=users,system,wireguard-pf,wireguard-binaries,wireguard-configs,unbound,vnstatd,ifstated,sysctl_router
