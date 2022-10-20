#!/bin/bash

process_and_sweep(){
	echo -e "\n\n\t[*] Discovering hosts in network $1..."
	mask=$(echo $1 | cut -d / -f2)
	ifc=$1
	b1=$(echo $ifc| sed 's/...$//' | cut -d . -f1)
	b2=$(echo $ifc| sed 's/...$//' | cut -d . -f2)
	b3=$(echo $ifc| sed 's/...$//' | cut -d . -f3)
	b4=$(echo $ifc| sed 's/...$//' | cut -d . -f4)
	case $mask in

		24)
		for ip in $(prips $b1.$b2.$b3.0/$mask); do
        	timeout 1 bash -c "sudo ping -c 1 $ip > /dev/null 2>&1" && echo -e "\n\t\tHost $ip is alive" &
    	done; wait
		;;
		
		16)
		for ip in $(prips $b1.$b2.0.0/$mask); do
            timeout 1 bash -c "sudo ping -c 1 $ip > /dev/null 2>&1" && echo -e "\n\t\tHost $ip is alive" &
        done; wait
		;;
		
		8)
		for ip in $(prips $b1.0.0.0/$mask); do
            timeout 1 bash -c "sudo ping -c 1 $ip > /dev/null 2>&1" && echo -e "\n\t\tHost $ip is alive" &
        done; wait
		;;
	esac

}
# apt install ipcalc
for interface in $(ip a | grep inet -w | awk '{print $2}' | grep -v 127.0.0.1); do process_and_sweep $interface; done

