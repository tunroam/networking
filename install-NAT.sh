#!/bin/bash
set -ve

WLAN_IFACE="`iw dev|grep -o wlan[0-9]|head -1`"

echo -n '1' > /etc/tunroam/network/useNAT
apt install -y dnsmasq

if [ -f /etc/dnsmasq.conf.orig ]; then
  echo "dnsmasq already moved"
else
  mv /etc/dnsmasq.conf /etc/dnsmasq.conf.orig
cat << EOF > /etc/dnsmasq.conf
interface=$WLAN_IFACE
dhcp-range=192.168.123.10,192.168.123.63,255.255.255.0,12h
EOF
fi
systemctl reload dnsmasq
systemctl status dnsmasq

sysctl -w net.ipv4.ip_forward=1
echo 'net.ipv4.ip_forward=1' >> /etc/sysctl.conf

