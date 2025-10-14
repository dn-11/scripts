#!/bin/sh

# change config vars as your environment

WORK_DIR="/etc/bird/dn11"

ENABLE_ROA=1
ENABLE_IK_SRT=1

IK_HOST="192.168.2.2"
IK_USER="test"
IK_PASS="test111"
IK_PAGE_SIZE="0,100"

ROUTER_DN11_IP="192.168.2.3"
ROUTER_DN11_COMMIT_PERFIX="dn11-"
ROUTER_IK_IFACE="lan1"
ROUTER_IK_SRT_PRIORITY="1"

# vars define only
IK_TOKEN=""
VERSION_OLD=""
VERSION_NEW=""
