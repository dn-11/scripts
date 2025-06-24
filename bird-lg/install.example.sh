#!/bin/bash

mkdir -p /tmp/tmp
cd /tmp/tmp

wget https://github.com/xddxdd/bird-lg-go/releases/download/v1.3.9/bird-lg-go-v1.3.9-linux-arm64.tar.gz -O bird-lg-go.tar.gz
wget https://github.com/xddxdd/bird-lg-go/releases/download/v1.3.9/bird-lgproxy-go-v1.3.9-linux-arm64.tar.gz -O bird-lgproxy-go.tar.gz

tar -xzf bird-lg-go.tar.gz
tar -xzf bird-lgproxy-go.tar.gz

mv bird-lg-go /usr/sbin/
mv bird-lgproxy-go /usr/sbin/

rm -rf /tmp/tmp/*

wget https://github.com/dn-11/scripts/raw/refs/heads/master/bird-lg/init.d/bird-lg -O /etc/init.d/bird-lg
wget https://github.com/dn-11/scripts/raw/refs/heads/master/bird-lg/init.d/bird-lgproxy -O /etc/init.d/bird-lgproxy

chmod +x /etc/init.d/bird-lg
chmod +x /etc/init.d/bird-lgproxy

/etc/init.d/bird-lg enable
/etc/init.d/bird-lgproxy enable

mkdir -p /etc/bird-lg

wget https://github.com/dn-11/scripts/raw/refs/heads/master/bird-lg/bird-lg.yaml -O /etc/bird-lg/bird-lg.yaml
wget https://github.com/dn-11/scripts/raw/refs/heads/master/bird-lg/bird-lgproxy.yaml -O /etc/bird-lg/bird-lgproxy.yaml

echo "Please edit /etc/bird-lg/bird-lg.yaml and /etc/bird-lg/bird-lgproxy.yaml to configure bird-lg and bird-lgproxy"

exit 0
