# Bootstrap the system
ftp -V -o - https://gitlab.com/Verticaleap/openbsd-ansible-dev/raw/master/bootstraps/bootstrap_raw.sh | sh

# Extra variables for playbook
extra_vars="\
role_sysctl_task=router_sysctl \
unbound_address=10.10.0.1 \
vnstatd_interface=tun3"

# Run playbook
cd /root/git/openbsd-ansible-dev/ && ansible-playbook install.yml --tags=users,system,wireguard-pf,wireguard-binaries,wireguard-configs,unbound,vnstatd,ifstated,x11vnc,sysctl --extra-vars="$extra_vars"
