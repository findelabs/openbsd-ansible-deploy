if [[ $zabbix_username == "" ]] || [[ $zabbix_password == "" ]]; then
    echo "Please set vars for zabbix_username and zabbix_password"
    exit 1
fi

if [[ $local_network_ip == "" ]] || [[ $local_network_interface == "" ]] || [[ $zabbix_postgres_ip == "" ]]
then
    echo "Please set vars for both local_network_ip and local_network_interface"
    exit 1
fi

# Extra variables for playbook
extra_vars="\
role_sysctl_task=router_sysctl \
zabbix_username=$zabbix_username \
zabbix_password=$zabbix_password \
unbound_address=127.0.0.1 \
local_network_ip=$local_network_ip \
local_network_interface=$local_network_interface \
zabbix_postgres_ip=$zabbix_postgres_ip"

# Bootstrap the system
ftp -V -o - https://github.com/Verticaleap/openbsd-ansible-deploy/raw/master/bootstraps/bootstrap_raw.sh | sh

# Run playbook
cd /root/git/openbsd-ansible-deploy/ && ansible-playbook install.yml --tags=users,system,vnstatd,unbound,sysctl,zabbix-web --extra-vars="$extra_vars"
