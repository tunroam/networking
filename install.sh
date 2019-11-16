#!/bin/bash
set -ve

mkdir -p /etc/tunroam/network
mkdir -p /var/log/tunroam

apt install -y \
  hostapd \
  dhcpcd5 \
  nftables \
  curl \
  vim

ip link show eth0 1> /dev/null \
  || (echo 'ERROR No standard network iface names detected, process manually!' && exit 1)
WLAN_IFACE="`iw dev|grep -o wlan[0-9]|head -1`"

touch /etc/dhcpcd.conf
cp /etc/dhcpcd.conf /etc/dhcpcd.conf.orig

# see /usr/share/doc/hostapd/examples/hostapd.conf
# or https://w1.fi/cgit/hostap/plain/hostapd/hostapd.conf
cat << EOF > /etc/hostapd/hostapd.conf
interface=$WLAN_IFACE
ssid=tunroam.org 19
hw_mode=g
channel=7
wmm_enabled=0
auth_algs=1
wpa=3
macaddr_acl=0
ieee8021x=1
ieee80211n=1
#ieee80211ac=1
wpa_key_mgmt=WPA-EAP
eapol_version=2

# RADIUS client configuration
own_ip_addr=127.0.0.1
auth_server_addr=127.0.0.1
auth_server_port=1812
auth_server_shared_secret=testing123
acct_server_addr=127.0.0.1
acct_server_port=1813
acct_server_shared_secret=testing123
EOF

echo 'DAEMON_CONF="/etc/hostapd/hostapd.conf"' \
  >> /etc/default/hostapd

systemctl unmask hostapd
systemctl enable hostapd
systemctl restart hostapd
systemctl status hostapd
