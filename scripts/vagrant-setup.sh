#!/bin/bash
if [ ! -f "/shared/.setup_done" ]
then
	sudo apt-get install -y aria2 unzip openvpn
	sudo cp -rf /tmp/tools/* /usr/local/bin
	sudo rm -rf /tmp/tools

	sudo service openvpn stop

	cd /etc/openvpn
	if [ ! -f openvpn.zip ]
	then
		sudo wget https://www.privateinternetaccess.com/openvpn/openvpn.zip
		sudo unzip -o openvpn.zip
	fi
	sudo rm -rf "/etc/openvpn/auth.txt"
	sudo mv "/shared/tmp/.pia_credentials" "/etc/openvpn/auth.txt"

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

	touch "/shared/.setup_done"
fi

