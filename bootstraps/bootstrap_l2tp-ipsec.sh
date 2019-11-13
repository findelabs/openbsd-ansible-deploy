if [[ $USERNAME == "" ]] || [[ $PASSWORD == "" ]] || [[ $PSK == "" ]] || [[ $GMAIL_ACCOUNT == "" ]] || [[ $GMAIL_SECRET == "" ]]; then
    echo "Please set vars for USERNAME, PASSWORD, and PSK"
    exit 1
fi

# Extra variables for playbook
extra_vars="\
role_sysctl_task=router_sysctl \
user=$USERNAME \
pass=$PASSWORD \
psk=$PSK \
unbound_address=10.0.0.1 \
vnstatd_interface=tun0 \
gmail_account=$GMAIL_ACCOUNT \
gmail_secret=$GMAIL_SECRET"

# Bootstrap the system
ftp -V -o - https://github.com/findelabs/openbsd-ansible-deploy/raw/master/bootstraps/bootstrap_raw.sh | sh

# Run playbook
cd /root/git/openbsd-ansible-deploy/ && ansible-playbook install.yml --tags=users,system,l2tp-ipsec,vnstatd,unbound,sysctl --extra-vars="$extra_vars"
