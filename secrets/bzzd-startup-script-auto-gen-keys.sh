#!/bin/bash

# Generate eth addresses and start bzzd
#
echo "Generating new key..."
 
BZZKEY=$(/geth --password /root/secrets/default_pwd --datadir $DATADIR --password /root/secrets/default_pwd  account new |  awk -F'[}{]' '{print $2}')

echo "New key created: " $BZZKEY

echo "Starting bzzd..."

/bzzd   --ethapi=$ETHAPI \
        --bzzaccount=$BZZKEY \
        --ipcpath "/bzzd.ipc" \
        --port=$BZZ_PORT \
        --bzzport=$BZZ_HTTP_PORT \
        --datadir $DATADIR \
        < <(echo && echo) 

echo "end of startup script"
