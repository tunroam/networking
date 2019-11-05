# Network checkup

The AP (SoC) may be physically moved to a different location,
thus having a different default gateway.

This script now only checks the default gateway,
but may include other checks in the future.

## Installation

```shell
cp *.timer   /etc/systemd/system/
cp *.service /etc/systemd/system/
cp *.sh      /usr/local/bin/
systemctl daemon-reload
systemctl enable tunroam-network-check.timer
systemctl start  tunroam-network-check.timer
```


## Motivation

At a home location,
the default gateway may always be `192.168.1.1`,
however, for the thesis presentation (at Surfnet and OS3),
we want to detect the IP address.

