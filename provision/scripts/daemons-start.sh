#!/bin/bash

prog_name=cloakbox

current_ip=$(whatismyip)
actual_ip=$(cat "/shared/.$prog_name/ip")
if [ -n "$actual_ip" ] && [ "$actual_ip" != "$current_ip" ] && [ -n "$(pgrep openvpn)" ]
then
	sudo service aria2d start
fi
