# Setup installurl
echo "http://ftp.openbsd.org/pub/OpenBSD/" > /etc/installurl

# Install git
export PKG_PATH=http://ftp.openbsd.org/pub/OpenBSD/$(uname -r)/packages/$(uname -p) && pkg_add -I git ansible

# Make git folder
mkdir /root/git
cd /root/git

# Clone playbook
if [ -d /root/git/openbsd-ansible-dev ]
then
    cd /root/git/openbsd-ansible-dev && git pull
else
    git clone https://gitlab.com/Verticaleap/openbsd-ansible-dev.git
fi
