# Bootstrap the system
ftp -o - https://gitlab.com/Verticaleap/openbsd-ansible-dev/raw/master/bootstraps/bootstrap_raw.sh | sh

if [[ $ZABBIX_USERNAME == "" ]] || [[ $ZABBIX_PASSWORD == "" ]]
then
    echo "Please set vars for ZABBIX_USERNAME and ZABBIX_PASSWORD"
    exit 1
fi

if [[ $zabbix_network_ip == "" ]] || [[ $zabbix_network_interface == "" ]]
then
    echo "Please set vars for both zabbix_network_ip and zabbix_network_interface"
    exit 1
fi

# Run playbook
cd /root/git/openbsd-ansible-dev/ && ansible-playbook install.yml --tags=users,system,unbound,zabbix-postgresql --extra-vars="zabbix_username=$ZABBIX_USERNAME zabbix_password=$ZABBIX_PASSWORD zabbix_network_ip=$zabbix_network_ip zabbix_network_interface=$zabbix_network_interface unbound_address=127.0.0.1"
