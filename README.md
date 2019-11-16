# TUNroam Networking

Order of installation:

- github.com/tunroam/auth-server
- in this repo.
  - install.sh
  - install-[br|NAT].sh (see below)
  - instructions in systemd folder when using NAT


## Bridge or NAT

When the physical port eth0 is connected to only provides one DHCP lease,
then use NAT (thus this is a safe bet for demo purposes, it always works).
For normal setups (like home router),
use the bridged setup to increase performance and avoid double NAT.


### Layout

NAT was implemented in a prototype way;
quick and dirty.

For the bridge setup we used
[systemd-networkd](https://wiki.archlinux.org/index.php/Systemd-networkd)
as suggested by
[debian](https://www.debian.org/doc/manuals/debian-reference/ch05.en.html#_the_modern_network_configuration_without_gui).


