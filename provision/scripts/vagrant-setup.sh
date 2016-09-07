#!/bin/bash

prog_name=cloakbox

# Install dependencies and place files
echo "Installing dependencies"
sudo apt-get install -y aria2 openvpn
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

sudo service aria2d stop
sudo service openvpn stop

rpc_secret=$(cat /dev/urandom | tr -cd 'a-f0-9' | head -c 16)
sudo echo "$rpc_secret" > "/shared/.$prog_name/secret"

sudo update-cloakbox-settings

sudo systemctl enable openvpn@openvpn.service
sudo systemctl start openvpn@openvpn.service

if [ ! -f "/shared/downloads/download_state" ]
then
	sudo touch "/shared/downloads/download_state"
fi

