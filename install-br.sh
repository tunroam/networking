#!/bin/bash
set -ve

# https://www.raspberrypi.org/documentation/configuration/wireless/access-point.md#internet-sharing

cat << EOF
ERROR not implemented
For demo purposes we only implemented the NAT solution
since the demo locations (presentation)
may not provide multiple DHCP leases on the port we connect to.
EOF
exit 1

apt install -y bridge-utils

# we got the addr for the bridge:
# curl --silent http://standards-oui.ieee.org/oui.txt|grep Bridge|grep hex
# since we wanted to have 'Bridge' in our MAC table in the router
# which we finish with os3os3 (reference to os3.nl)
BRIDGEMAC="D4:28:B2:05:30:53"

ip link add name br0 type bridge #brctl addbr br0
ip link set br0 address $BRIDGEMAC
ip link set dev br0 up
#how to set permanantly:
#https://backreference.org/2010/07/28/linux-bridge-mac-addresses-and-dynamic-ports/

ip link set dev eth0 master br0 #brctl addif br0 eth0
# we now have br0 and eth0 getting a DHCP lease
cat << EOF
WARNING Did you set a strong password for SSH login?!
BEGIN TODO MANUAL
    A bridge has been created with the MAC address:
    $BRIDGEMAC
    Please assign a fixed IP address to this hardware address
    in the router it is connected to.
    Then set the fixed IP as a DMZ host (port forwarding).
END TODO MANUAL
EOF

grep -q '^interface' /etc/dhcpcd.conf \
  && echo ERROR detected manual configuration of DHCP \
  && exit 1


