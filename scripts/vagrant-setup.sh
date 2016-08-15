#!/bin/bash
if [ ! -f "/shared/.torrentbox/setup_done" ]
then
	sudo apt-get install -y aria2 unzip openvpn
	sudo cp -rf /tmp/tools/* /usr/local/bin
	sudo cp -rf /tmp/daemons/* /etc/init.d
	for daemon in $(ls /tmp/daemons)
	do
		sudo update-rc.d "$daemon" defaults
		sudo update-rc.d "$daemon" enable
	done
	sudo rm -rf /tmp/tools
	sudo rm -rf /tmp/daemons

	# Setup the VPN

	sudo service openvpn stop

	cd /etc/openvpn
	if [ ! -f openvpn.zip ]
	then
		sudo wget https://www.privateinternetaccess.com/openvpn/openvpn.zip
		sudo unzip -o openvpn.zip
	fi
	if [ -f "/shared/.torrentbox/tmp/pia_credentials" ]
	then
		sudo rm -rf "/etc/openvpn/auth.txt"
		sudo mv "/shared/.torrentbox/tmp/pia_credentials" "/etc/openvpn/auth.txt"
	fi

	openvpn_prefs=$(
	{
		cat <<EOF
AUTOSTART="all"
OPTARGS=""
OMIT_SENDSIGS=0
EOF
	})
	sudo echo "$openvpn_prefs" > /etc/default/openvpn
	
	openvpn_conf="torrentbox.conf"

	cat "US East.ovpn" | sed -e 's/^auth-user-pass.*//' > "$openvpn_conf"
	echo 'auth-user-pass "auth.txt"' >> "$openvpn_conf"
	
	sudo service openvpn start

	# Setup aria2
	
	sudo service aria2d stop

	aria2_prefs=$(
	{
		cat <<EOF
dir=/shared/downloads/
continue=true
daemon=true
enable-rpc=true
rpc-listen-port=6800
rpc-listen-all=false
save-session=/etc/aria2/aria2d_data
input-file=/etc/aria2/aria2d_data
log=/var/log/aria2d.log
EOF
	})
	sudo mkdir -p "/etc/aria2"
	sudo touch "/var/log/aria2d.log"
	sudo echo "$aria2_prefs" > "/etc/aria2/aria2d.conf"
	sudo touch "/etc/aria2/aria2d_data"

	sudo service aria2d start

	touch "/shared/.torrentbox/setup_done"
fi

