#!/bin/sh

# Function to check and reconnect PPPoE if needed
check_pppoe() {
  local WAN_INTERFACE=$1
  local MAX_DURATION=$2

  # Get the connection uptime
  connected_time=$(ifstatus $WAN_INTERFACE | jsonfilter -e '@.uptime')

  # If unable to get the connection time, exit function
  if [ -z "$connected_time" ]; then
    echo "Error getting interface $WAN_INTERFACE uptime."
    return
  fi

  # If the connection time is greater than 48 hours, reconnect
  if [ "$connected_time" -ge "$MAX_DURATION" ]; then
    echo "Connection time for $WAN_INTERFACE exceeded 48 hours, reconnecting..."
    ifup $WAN_INTERFACE
  else
    echo "PPPoE connection time for $WAN_INTERFACE is within 48 hours."
  fi
}

# Define WAN interface names
WAN_INTERFACES="ct1 ct2"

# Maximum connection duration (48 hours in seconds)
MAX_DURATION=172800

# Loop through each WAN interface and check PPPoE connection
for WAN_INTERFACE in $WAN_INTERFACES
do
  check_pppoe "$WAN_INTERFACE" "$MAX_DURATION"
done
