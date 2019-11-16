# TUNroam Networking

Order of installation:

- github.com/tunroam/auth-server
- in this repo.
  - install.sh
  - install-[br|NAT].sh (see below)
  - instructions in systemd folder when using NAT


Either Bridge or NAT.
We only tested NAT, since we'll use that for the demo at UvA and Surfnet.

## Status: WIP

NAT was implemented in a legacy/prototype way,
but it worked.

For the bridge setup we aim for
[systemd-networkd](https://wiki.archlinux.org/index.php/Systemd-networkd)
as suggested by
[debian](https://www.debian.org/doc/manuals/debian-reference/ch05.en.html#_the_modern_network_configuration_without_gui).


