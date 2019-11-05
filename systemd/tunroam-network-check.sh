#!/bin/bash

RULES="`iptables-nft-save`"
WLAN_IFACE="`iw dev|grep -o wlan[0-9]|head -1`"

echo "$RULES"|grep -q "$WLAN_IFACE" || ( \
  iptables-nft -A FORWARD -i "$WLAN_IFACE" -j ACCEPT;
)

netstat -ulpn | grep -q freeradius || systemctl restart freeradius

checkNAT() {
  DEFAULTGATEWAY=`ip -4 route|grep default\ via|head -1|cut -f3 -d' '`
  if [ -z "$DEFAULTGATEWAY" ]; then
    exit
  fi
  if [ ! -f /var/log/tunroam/last_known_gateway ] || \
     [ "$DEFAULTGATEWAY" != "`cat /var/log/tunroam/last_known_gateway`" ]; then
    echo "`date +%F\ %T` $DEFAULTGATEWAY" >> /var/log/tunroam/gateway.log
    echo -n "$DEFAULTGATEWAY" > /var/log/tunroam/last_known_gateway
    cp /etc/dhcpcd.conf.orig /etc/dhcpcd.conf
cat << EOF >> /etc/dhcpcd.conf
interface $WLAN_IFACE
    static ip_address=192.168.123.1/24
    static routers=$DEFAULTGATEWAY
    nohook wpa_supplicant
#    static domain_name_servers=1.1.1.1 8.8.8.8
EOF
    systemctl restart dhcpcd
    systemctl restart dnsmasq
  fi
  echo "$RULES" | grep -q MASQUERADE || ( \
    iptables-nft -t nat -A POSTROUTING -o eth0 -j MASQUERADE; # enable NAT
  )
}


checkBridge() {
  echo NOT yet implemented
}


if [ -f /etc/tunroam/network/useNAT ] && \
   grep -q 1 /etc/tunroam/network/useNAT; then
  checkNAT
else
  checkBridge
fi
