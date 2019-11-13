# DOMAIN must be declared, so that httpd will be configured properly
if [[ -z $DOMAIN ]]; then
    echo "DOMAIN must be declared"
    exit 1
fi

# Extra variables for playbook
extra_vars="\
role_sysctl_task=router_sysctl"

# Bootstrap the system
ftp -V -o - https://github.com/findelabs/openbsd-ansible-deploy/raw/master/bootstraps/bootstrap_raw.sh | sh

# Set domain variable
cd /root/git/openbsd-ansible-deploy/group_vars
sed -i.bak "s/ansible_domain.*/ansible_domain: $DOMAIN/g" all

# Run playbook
cd /root/git/openbsd-ansible-deploy/ && ansible-playbook install.yml --tags=users,system,httpd_basic,acme-client,httpd_tls,sysctl --extra-vars="$extra_vars"
