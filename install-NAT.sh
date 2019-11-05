#!/bin/bash
set -ve

echo -n '1' > /etc/tunroam/network/useNAT
apt install -y dnsmasq

ip link show wlan0 > /dev/null || \
  (echo ERROR non standard iface names; exit 1)

if [ -f /etc/dnsmasq.conf.orig ]; then
  echo "dnsmasq already moved"
else
  mv /etc/dnsmasq.conf /etc/dnsmasq.conf.orig
cat << EOF > /etc/dnsmasq.conf
interface=wlan0
dhcp-range=192.168.123.10,192.168.123.63,255.255.255.0,12h
EOF
fi
systemctl reload dnsmasq
systemctl status dnsmasq

