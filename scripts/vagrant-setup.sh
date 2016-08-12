#!/bin/bash
if [ ! -f "/shared/.setup_done" ]
then
	sudo apt-get install -y aria2 unzip openvpn
	cd /etc/openvpn
	if [ ! -f openvpn.zip ]
	then
		sudo wget https://www.privateinternetaccess.com/openvpn/openvpn.zip
		sudo unzip -o openvpn.zip
	fi
	sudo rm -rf "/etc/openvpn/auth.txt"
	sudo mv "/shared/tmp/.pia_credentials" "/etc/openvpn/auth.txt"
	sudo openvpn --config "US East.ovpn" --auth-user-pass "auth.txt" --daemon
	touch "/shared/.setup_done"
else
	cd /etc/openvpn
	sudo openvpn --config "US East.ovpn" --auth-user-pass "auth.txt" --daemon
fi
