#!/bin/sh

function ik_login() {
    local username="$IK_USER"
    local password="$IK_PASS"

    local passwd=$(echo -n "$password" | md5sum | awk '{print $1}')
    local pass=$(echo -n "salt_11$password" | base64)

    local login_info=$(cat <<EOF
{
    "passwd": "$passwd",
    "pass": "$pass",
    "remember_password": "",
    "username": "$username"
}
EOF
    )

    local response=$(curl -s -X POST "http://$IK_HOST/Action/login" \
        -H "Content-Type: application/json" \
        -d "$login_info")

    local result=$(echo "$response" | jq '.Result')
    if [[ "$result" == "10000" ]]; then
        IK_TOKEN=$(curl -i -s -X POST "http://$IK_HOST/Action/login" \
            -H "Content-Type: application/json" \
            -d "$login_info" | grep 'Set-Cookie' | awk '{print $2}')
    else
        echo "$response"
    fi
}

ik_srt_add() {
    local interface="$1"
    local dst_addr="$2"
    local netmask="$3"
    local prio="$4"
    local comment="$5"
    local enabled="$6"
    local gateway="$7"

    local request_body=$(cat <<EOF
{
    "func_name": "static_rt",
    "action": "add",
    "param": {
        "interface": "$interface",
        "dst_addr": "$dst_addr",
        "netmask": "$netmask",
        "prio": "$prio",
        "comment": "$comment",
        "enabled": "$enabled",
        "gateway": "$gateway"
    }
}
EOF
    )

    local response=$(curl -s -X POST "http://$IK_HOST/Action/call" \
        -H "Content-Type: application/json" \
        -d "$request_body" \
        -b "$IK_TOKEN")

    local result=$(echo "$response" | jq '.Result')
    if [[ "$result" == 30000 ]]; then
        return 0
    else
        if [[ "$result" == 30001 ]]; then
            return 3
        else
            echo "$response"
            return 1
        fi
    fi
}

ik_srt_del() {
    local id="$1"

    local request_body=$(cat <<EOF
{
    "func_name": "static_rt",
    "action": "del",
    "param": {
        "id": $id
    }
}
EOF
    )

    local response=$(curl -s -X POST "http://$IK_HOST/Action/call" \
        -H "Content-Type: application/json" \
        -d "$request_body" \
        -b "$IK_TOKEN")

    local result=$(echo "$response" | jq '.Result')
    if [[ "$result" == "30000" ]]; then
        return 0
    else
        echo "$response"
        return 1
    fi
}

ik_srt_edit() {
    local id="$1"
    local interface="$2"
    local dst_addr="$3"
    local netmask="$4"
    local prio="$5"
    local comment="$6"
    local enabled="$7"
    local gateway="$8"

    local request_body=$(cat <<EOF
{
    "func_name": "static_rt",
    "action": "edit",
    "param": {
        "id": $id,
        "interface": "$interface",
        "dst_addr": "$dst_addr",
        "netmask": "$netmask",
        "prio": $prio,
        "comment": "$comment",
        "enabled": "$enabled",
        "gateway": "$gateway"
    }
}
EOF
    )

    local response=$(curl -s -X POST "http://$IK_HOST/Action/call" \
        -H "Content-Type: application/json" \
        -d "$request_body" \
        -b "$IK_TOKEN")

    local result=$(echo "$response" | jq '.Result')
    if [[ "$result" == "30000" ]]; then
        return 0
    else
        echo "$response"
        return 1
    fi
}

ik_srt_show() {
    local limit="$1"

    local request_body=$(cat <<EOF
{
    "func_name": "static_rt",
    "action": "show",
    "param": {
        "TYPE": "total,data",
        "limit": "$limit",
        "ORDER_BY": "",
        "ORDER": ""
    }
}
EOF
    )

    local response=$(curl -s -X POST "http://$IK_HOST/Action/call" \
        -H "Content-Type: application/json" \
        -d "$request_body" \
        -b "$IK_TOKEN")

    local result=$(echo "$response" | jq '.Result')
    if [[ "$result" == "30000" ]]; then
        echo "$response" | jq '.Data'
        return 0
    else
        echo "$response"
        return 1
    fi
}

LEN_TO_NETMASK() {
    local len=$1
    local mask=""
    local i=0
    local byte=0

    for i in $(seq 1 4); do
        if [ $len -ge 8 ]; then
            mask="${mask}255"
            len=$((len-8))
        else
            byte=$((256-2**(8-len)))
            mask="${mask}${byte}"
            len=0
        fi
        if [ $i -lt 4 ]; then
            mask="${mask}."
        fi
    done

    echo $mask
}

set_ik_srt() {
    if [ -z "$IK_TOKEN" ]; then
        ik_login
    fi

    local exists=$(ik_srt_show $IK_PAGE_SIZE)
    local target=$1

    local dst_addr=$(echo $target | cut -d/ -f1)
    local len=$(echo $target | cut -d/ -f2)
    local netmask=$(LEN_TO_NETMASK $len)

    local comment="$ROUTER_DN11_COMMIT_PERFIX$VERSION_NEW"

    echo "Add $dst_addr/$len"
    ik_srt_add $ROUTER_IK_IFACE $dst_addr $netmask $ROUTER_IK_SRT_PRIORITY $comment "yes" $ROUTER_DN11_IP
    if [[ $? == 3 ]]; then
        local id=$(echo $exists | jq '.data[] | select(.dst_addr == "'$dst_addr'") | .id')
        echo "Edit $dst_addr/$len ($id)"
        ik_srt_edit $id $ROUTER_IK_IFACE $dst_addr $netmask $ROUTER_IK_SRT_PRIORITY $comment "yes" $ROUTER_DN11_IP
    fi
}

clean_ik_srt() {
    if [ -z "$IK_TOKEN" ]; then
        ik_login
    fi

    local data=$(ik_srt_show $IK_PAGE_SIZE)
    local ids=$(echo $data | jq '.data[] | select(.comment | startswith("'$ROUTER_DN11_COMMIT_PERFIX'")) | select(.comment | (endswith("'$VERSION_NEW'") | not)) | .id')

    for id in $ids; do
        echo "Delete $id"
        ik_srt_del $id
    done
}
