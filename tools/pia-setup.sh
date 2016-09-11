#!/bin/bash

function fullpath
{
	cd "$1"
	echo "$PWD"
}

base_dir=$(dirname "${BASH_SOURCE[0]}")
base_dir=$(fullpath "$base_dir/../")
cd "$base_dir"

mkdir -p "tools/cache/pia-setup"

if [ ! -f tools/cache/pia-setup/openvpn.zip ]
then
	wget "https://www.privateinternetaccess.com/openvpn/openvpn.zip" -O tools/cache/pia-setup/openvpn.zip
	unzip -o tools/cache/pia-setup/openvpn.zip -d tools/cache/pia-setup
fi

cd tools/cache/pia-setup
options=(*.ovpn)
cd "$base_dir"

# Choose the server
echo "Choose the VPN server to connect to"
options_length=${#options[@]}
option_counter=0
while [ $option_counter -lt $options_length ]
do
	option=${options[$option_counter]}
	if [[ "$option" =~ ^(.*)\.ovpn$ ]]
	then
		option=${BASH_REMATCH[1]}
	fi
	echo "[$option_counter]: $option"
	option_counter=$(($option_counter+1))
done
read -p "Enter server num: " option_index
while ! [[ "$option_index" =~ ^[0-9]+$ ]] || [ $option_index -ge $options_length ]
do
	>&2 echo "Invalid input"
	read -p "Enter server num: " option_index
done
selected_option=${options[$option_index]}

# Enter credentials
read -p "enter your PIA username: " pia_user
read -s -p "enter your PIA password: " pia_pass
echo ""

mkdir -p "shared/openvpn"
echo "$pia_user" > "shared/openvpn/pia-auth.txt"
echo "$pia_pass" >> "shared/openvpn/pia-auth.txt"
cp -f -t "shared/openvpn" tools/cache/pia-setup/*.pem tools/cache/pia-setup/*.crt
openvpn_conf=$(cat "tools/cache/pia-setup/$selected_option" | sed -E -e 's/^[[:space:]]*auth-user-pass(([[:space:]]+.*$)|$)//')
openvpn_conf=$(echo "$openvpn_conf" | sed -E -e 's/^[[:space:]]*up(([[:space:]]+.*$)|$)//')
openvpn_conf=$(echo "$openvpn_conf" | sed -E -e 's/^[[:space:]]*down(([[:space:]]+.*$)|$)//')
echo "$openvpn_conf" > "shared/openvpn/openvpn.conf"
echo 'auth-user-pass pia-auth.txt' >> 'shared/openvpn/openvpn.conf'
echo 'up "/usr/local/bin/cloakbox-event-handler up"' >> 'shared/openvpn/openvpn.conf'
echo 'down "/usr/local/bin/cloakbox-event-handler down"' >> 'shared/openvpn/openvpn.conf'

