# DOMAIN must be declared, so that httpd will be configured properly
if [[ -z $DOMAIN ]]; then
    echo "DOMAIN must be declared"
    exit 1
fi

# Bootstrap the system
ftp -o - https://gitlab.com/Verticaleap/openbsd-ansible-dev/raw/master/bootstraps/bootstrap_raw.sh | sh

# Set domain variable
cd /root/git/openbsd-ansible-dev/group_vars
sed -i.bak "s/ansible_domain.*/ansible_domain: $DOMAIN/g" all

# Run playbook
cd /root/git/openbsd-ansible-dev/ && ansible-playbook install.yml --tags=users,system,httpd_basic,acme-client,httpd_tls
