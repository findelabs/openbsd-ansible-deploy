bootstrap_name="httpd_tls"
bootstrap_log=/var/log/bootstrap

# Check if bootstrap has already ran
if [ "$(grep -sc $bootstrap_name $bootstrap_log)" == "1" ]
then
    echo "bootstrap $bootstrap_name already complete"
    exit
fi

# DOMAIN must be declared, so that httpd will be configured properly
if [[ -z $DOMAIN ]]; then
    echo "DOMAIN must be declared"
    exit 1
fi

# Bootstrap the system
ftp -V -o - https://gitlab.com/Verticaleap/openbsd-ansible-dev/raw/master/bootstraps/bootstrap_raw.sh | sh

# Set domain variable
cd /root/git/openbsd-ansible-dev/group_vars
sed -i.bak "s/ansible_domain.*/ansible_domain: $DOMAIN/g" all

# Run playbook
cd /root/git/openbsd-ansible-dev/ && ansible-playbook install.yml --tags=users,system,httpd_basic,acme-client,httpd_tls,sysctl_router

# Add bootstrap to log
echo $bootstrap_name >> $bootstrap_log
