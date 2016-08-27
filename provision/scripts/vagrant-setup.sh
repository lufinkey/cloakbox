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
	sudo update-rc.d "$daemon" disable
done
sudo rm -rf /tmp/tools
sudo rm -rf /tmp/daemons
mkdir -p "/shared/downloads"
mkdir -p "/shared/.$prog_name"

# Setup openvpn
echo "Setting up openvpn"
sudo service openvpn stop
openvpn_prefs=$(
	cat <<EOF
AUTOSTART="all"
OPTARGS=""
OMIT_SENDSIGS=0
EOF
)
sudo echo "$openvpn_prefs" > /etc/default/openvpn
sudo service openvpn start

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
save-session=/shared/downloads/download_state
force-save=true
input-file=/shared/downloads/download_state
EOF
})
sudo mkdir -p "/etc/aria2"
sudo echo "$aria2_prefs" > "/etc/aria2/aria2d.conf"
if [ ! -f "/shared/downloads/download_state" ]
then
	sudo touch "/shared/downloads/download_state"
fi
sudo service aria2d start

