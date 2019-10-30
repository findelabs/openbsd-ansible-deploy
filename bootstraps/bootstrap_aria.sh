bootstrap_name="aria"
bootstrap_log=/var/log/bootstrap

# Check if bootstrap has already ran
if [ "$(grep -c $bootstrap_name $bootstrap_log)" == "1" ]
then
    echo "bootstrap $bootstrap_name already complete"
    exit
fi

# Bootstrap the system
ftp -o - https://gitlab.com/Verticaleap/openbsd-ansible-dev/raw/master/bootstraps/bootstrap_raw.sh | sh

# Run playbook
cd /root/git/openbsd-ansible-dev/ && ansible-playbook install.yml --tags=users,system,sysctl_router,aria

# Add bootstrap to log
echo $bootstrap_name >> $bootstrap_log
