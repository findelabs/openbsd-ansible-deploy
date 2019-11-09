# Bootstrap the system
ftp -V -o - https://gitlab.com/Verticaleap/openbsd-ansible-dev/raw/master/bootstraps/bootstrap_raw.sh | sh

# Extra variables for playbook
extra_vars="\
role_sysctl_task=gcp_sysctl"

# Run playbook
cd /root/git/openbsd-ansible-dev/ && ansible-playbook install.yml --tags=users,system,sysctl --extra-vars="$extra_vars"
