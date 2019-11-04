#!/bin/bash
set -ve

apt install -y dnsmasq

ip link show wlan0 > /dev/null || \
  (echo ERROR non standard iface names; exit 1)

(grep -q "interface wlan0" /etc/dhcpcd.conf; \
  echo ERROR already installed?; \
  exit 1) || true
  
cat << EOF >> /etc/dhcpcd.conf
interface wlan0
    static ip_address=192.168.123.1/24
    static routers=192.168.1.1 #TODO make this dynamic
    nohook wpa_supplicant
# ip route|grep default\ via|cut -f3 -d' '
EOF
systemctl restart dhcpcd

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

iptables-nft -t nat -A POSTROUTING -o eth0 -j MASQUERADE # enable NAT

#iptables-save > /iptables.txt
#iptables-nft-restore < /iptables.txt
iptables-nft-save
