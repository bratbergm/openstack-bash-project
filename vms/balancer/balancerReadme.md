*/etc/haproxy/haproxy.cfg*

```

```

```bash
# Sjekk syntax
haproxy -c -f /etc/haproxy/haproxy.cfg
# Start
service haproxy start
# Sjekk porter
netstat -anltp
# Restart ved endringer
service haproxy restart
```

balancer-start.sh

```bash
openstack server create \
--flavor t1.small \
--image 1676adb4-9657-42ed-b31f-b3907cbcd697 \
--key-name Manager \
--security-group default \
--user-data /home/ubuntu/git/DCSG2003/vms/balancer/balancer-data.sh \
balancer
```



balancer-data.sh

```bash
#! /bin/bash

# HaProxy install
sudo apt update
sudo apt install haproxy net-tools

# Config fil:
# nano /etc/haproxy/haproxy.cfg

# TO do: legg inn resten av config
```

