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

/etc/init.d/bird-lg restart
/etc/init.d/bird-lgproxy restart

exit 0
