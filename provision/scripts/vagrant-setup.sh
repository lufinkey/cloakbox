#!/bin/bash

prog_name=cloakbox

# Install dependencies and place files
echo "Installing dependencies"
sudo apt-get install -y aria2 openvpn jq
sudo cp -rf /tmp/tools/* /usr/local/bin
sudo cp -rf /tmp/daemons/* /etc/init.d
for daemon in $(ls /tmp/daemons)
do
	sudo update-rc.d "$daemon" defaults
	sudo update-rc.d "$daemon" enable
done
sudo rm -rf /tmp/tools
sudo rm -rf /tmp/daemons

# Setup openvpn
echo "Setting up openvpn"
(
	sudo service openvpn stop
	cd "/etc/openvpn"
	openvpn_prefs=$(
		cat <<EOF
AUTOSTART="all"
OPTARGS=""
OMIT_SENDSIGS=0
EOF
	)
	sudo echo "$openvpn_prefs" > /etc/default/openvpn
	sudo service openvpn start
)

# Setup aria2
echo "Setting up aria2"
sudo service aria2d stop
#TODO remove max-download-limit
aria2_prefs=$(
{
	cat <<EOF
dir=/shared/downloads/
continue=true
always-resume=true
auto-save-interval=60
save-session-interval=60
daemon=true
enable-rpc=true
rpc-listen-port=6800
rpc-listen-all=false
rpc-save-upload-metadata=true
max-download-limit=200K
save-session=/etc/aria2/aria2d_queue
force-save=true
input-file=/etc/aria2/aria2d_queue
log=/var/log/aria2d.log
EOF
})
sudo mkdir -p "/etc/aria2"
if [ ! -f "/var/log/aria2d.log" ]
then
	sudo touch "/var/log/aria2d.log"
fi
sudo echo "$aria2_prefs" > "/etc/aria2/aria2d.conf"
if [ ! -f "/etc/aria2/aria2d_queue" ]
then
	sudo touch "/etc/aria2/aria2d_queue"
fi
sleep 2
sudo service aria2d start

touch "/shared/.$prog_name/setup_done"

