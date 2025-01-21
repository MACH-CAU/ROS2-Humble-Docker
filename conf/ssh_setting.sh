#!/bin/bash

echo setup.bash!
passwd
service ssh start

echo ROS2 ssh start!
#host_ip=hostname -i
echo "Type : ssh root@(host_ip) -p 8042"
echo ""

while true; 
do 
	echo "ROS2 still live"; 
	sleep 5;
done
