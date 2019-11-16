#!/bin/bash
set -ve

# https://www.raspberrypi.org/documentation/configuration/wireless/access-point.md#internet-sharing

WLAN_IFACE="`iw dev|grep -o wlan[0-9]|head -1`"

apt install -y bridge-utils

grep -q '^interface' /etc/dhcpcd.conf \
  && echo ERROR detected manual configuration of DHCP \
  && exit 1

echo "denyinterfaces eth0" >> /etc/dhcpcd.conf
echo "denyinterfaces $WLAN_IFACE" >> /etc/dhcpcd.conf

sed -i 's/#bridge=/bridge=/' /etc/hostapd/hostapd.conf

# we got the addr for the bridge:
# curl --silent http://standards-oui.ieee.org/oui.txt|grep Bridge|grep hex
# since we wanted to have 'Bridge' in our MAC table in the router
# which we finish with os3os3 (reference to os3.nl)
BRIDGEMAC="D4:28:B2:05:30:53"

# man systemd.netdev
cat << EOF >> /etc/systemd/network/br0.netdev
[NetDev]
Name=br0
Kind=bridge
MACAddress=$BRIDGEMAC
EOF

cat << EOF >> /etc/systemd/network/dhcp-br0.network
[Match]
Name=br0

[Network]
DHCP=ipv4
EOF

cat << EOF >> /etc/systemd/network/bind-eth.network
[Match]
Name=eth0

[Network]
Bridge=br0
EOF

cat << EOF >> /etc/systemd/network/bind-wlan.network
[Match]
Name=$WLAN_IFACE

[Network]
Bridge=br0
EOF

# /etc/systemd/network/99-default.link -> /dev/null
systemctl unmask systemd-networkd
systemctl enable systemd-networkd
systemctl restart systemd-networkd
systemctl status systemd-networkd

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
