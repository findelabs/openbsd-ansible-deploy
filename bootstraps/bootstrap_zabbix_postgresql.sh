# Bootstrap the system
ftp -V -o - https://github.com/findelabs/openbsd-ansible-deploy/raw/master/bootstraps/bootstrap_raw.sh | sh

if [[ $ZABBIX_USERNAME == "" ]] || [[ $ZABBIX_PASSWORD == "" ]]
then
    echo "Please set vars for ZABBIX_USERNAME and ZABBIX_PASSWORD"
    exit 1
fi

if [[ $local_network_ip == "" ]] || [[ $local_network_interface == "" ]]
then
    echo "Please set vars for both local_network_ip and local_network_interface"
    exit 1
fi

# Run playbook
cd /root/git/openbsd-ansible-deploy/ && ansible-playbook install.yml --tags=users,system,unbound,zabbix-postgresql --extra-vars="zabbix_username=$ZABBIX_USERNAME zabbix_password=$ZABBIX_PASSWORD local_network_ip=$local_network_ip local_network_interface=$local_network_interface unbound_address=127.0.0.1"
