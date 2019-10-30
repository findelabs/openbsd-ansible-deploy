bootstrap_name="raw"
bootstrap_log=/var/log/bootstrap

# Check if bootstrap has already ran
if [ "$(grep -sc $bootstrap_name $bootstrap_log)" == "1" ]
then
    echo "bootstrap $bootstrap_name already complete"
    exit
fi

# Setup installurl
echo "http://ftp.openbsd.org/pub/OpenBSD/" > /etc/installurl

# Install git
export PKG_PATH=http://ftp.openbsd.org/pub/OpenBSD/$(uname -r)/packages/$(uname -p) && pkg_add -I git ansible

# Make git folder
mkdir /root/git
cd /root/git

# Clone playbook
git clone https://gitlab.com/Verticaleap/openbsd-ansible-dev.git

# Add bootstrap to log
echo $bootstrap_name >> $bootstrap_log
