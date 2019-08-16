# Bootstrap the system
ftp -o - https://gitlab.com/Verticaleap/openbsd-ansible-dev/raw/master/bootstraps/bootstrap_raw.sh | sh

if [[ $zabbix_username == "" ]] || [[ $zabbix_password == "" ]]; then
    echo "Please set vars for zabbix_username and zabbix_password"
    exit 1
fi

if [[ $local_network_ip == "" ]] || [[ $local_network_interface == "" ]] || [[ $zabbix_postgres_ip == "" ]]
then
    echo "Please set vars for both local_network_ip and local_network_interface"
    exit 1
fi

# Run playbook
cd /root/git/openbsd-ansible-dev/ && ansible-playbook install.yml --tags=users,system,vnstatd,unbound,sysctl_router,zabbix-web --extra-vars="zabbix_username=$zabbix_username zabbix_password=$zabbix_password unbound_address=127.0.0.1 local_network_ip=$local_network_ip local_network_interface=$local_network_interface zabbix_postgres_ip=$zabbix_postgres_ip"
