#!/usr/bin/env bash

trap "error" ERR

# Variables

configs=/etc/wireguard/configs
keys=/etc/wireguard/keys
server_conf=$configs/server.conf
#egress=$(ifconfig egress | grep inet | awk '{print $2}')

# Testing for GCP, as external IP is masked
egress=$(curl -s https://ipinfo.io/ip)
dns=10.10.0.1
port=9832
conf_count=10

### functions ###

error() {
    echo Command failed
    exit 1
}

show_help() {
    echo "Usage: $0 [-q]"
}

### main ###

# Getopts
while getopts ":q:" opt; do
    case ${opt} in
        q )
            client=$OPTARG
            ;;
        \? ) echo "Usage: $0 [-q] [1-5]"
            exit 1
            ;;
    esac
done

if [[ -n $client ]]; then
    if [[ -e $configs/client${client}.conf ]]; then
        cat $configs/client${client}.conf | qrencode -t ansi
        exit 0
    else
        echo "Client${client} does not exist"
        exit 1
    fi
fi

# Create wireguard keys if they do not exist
if [[ ! -e $keys/server-private.key ]] || [[ ! -e $keys/server-public.key ]]; then
    wg genkey | tee $keys/server-private.key | wg pubkey > $keys/server-public.key
    echo "Created server keys"
else
    echo "Wireguard server keys already exist"
fi

# Create server.conf
if [[ -e $configs/server.conf ]]; then
    echo "Server config already exists"
else
    echo -e "[Interface]\nPrivateKey = $(cat $keys/server-private.key)\nListenPort = $port\n" > $configs/server.conf
    touch /tmp/server_updated
fi

# Create client configs
i=0
while [ $i -lt $conf_count ];
do
    i=$((i+1))
    if [[ -e $keys/client${i}-private.key ]] && [[ -e $keys/client${i}-public.key ]]; then
        echo "client${i} keys already exists"
    else
        echo "Creating client${i} keys"
        wg genkey | tee $keys/client${i}-private.key | wg pubkey > $keys/client${i}-public.key
    fi
    if [[ -e $configs/client${i}.conf ]]; then
        echo "client${i} config already exists"
    else
        # Create client configuration
        ip=$(echo "$i + $i + 2" | bc)
        echo -e "[Interface]\nAddress = 10.10.0.$ip/24\nPrivateKey = $(cat $keys/client${i}-private.key)\nDNS = 10.10.0.1\n\n" > $configs/client${i}.conf
        echo -e "[Peer]\nPublicKey = $(cat $keys/server-public.key)\nEndpoint = $egress:$port\nAllowedIPs = 0.0.0.0/0\n" >> $configs/client${i}.conf
        echo "Created client${i}.conf"
    fi
    if [[ $(grep -c $(cat $keys/client${i}-public.key) $configs/server.conf) == 0 ]]; then
        # Add client to server.conf, with correct ip spacing.
        # Each endpoint must have its own net, due to the requirements of wireguard
        echo "Added client${i} to server.conf"
        echo -e "[Peer]\nPublicKey = $(cat $keys/client${i}-public.key)\nAllowedIPs = 10.10.0.$ip/32\n" >> $configs/server.conf
        touch /tmp/server_updated
    else
        echo "client${i} already in server.conf"
    fi
done

if [[ -e /tmp/server_updated ]]; then
    if [[ $EUID == 0 ]]; then
        /usr/local/bin/wg setconf tun3 /etc/wireguard/configs/server.conf
    else
        doas /usr/local/bin/wg setconf tun3 /etc/wireguard/configs/server.conf
    fi
    rm /tmp/server_updated
fi
