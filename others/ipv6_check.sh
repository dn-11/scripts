#!/bin/bash

INTERFACE="br-lan"
LOG_FILE="/var/log/ipv6_check.log"
MAX_LOG_LINES=5000  # Maximum number of lines in the log file

# Function to truncate log file if it exceeds maximum lines
truncate_log() {
    if [ $(wc -l < "$LOG_FILE") -gt $MAX_LOG_LINES ]; then
        tail -n $MAX_LOG_LINES "$LOG_FILE" > "$LOG_FILE.tmp"
        mv "$LOG_FILE.tmp" "$LOG_FILE"
    fi
}

# Check for IPv6 address and log the result
ip -6 addr show dev $INTERFACE | grep -q "scope global dynamic"
if [ $? -ne 0 ]; then
    echo "[$(date)] $INTERFACE has no IPv6, trying."
    ifup lan6
else
    echo "[$(date)] $INTERFACE has IPv6"
fi

# Truncate the log file if it exceeds maximum lines
truncate_log
