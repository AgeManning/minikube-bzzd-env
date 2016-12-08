#!/bin/bash

# This is the bzzd startup script. It should be made a kubernetes secret with
#
#     kubectl --namespace "swarm" create secret generic --from-file=script=./bzzd-startup-script.sh bzzd-startup-script
#
#    or create a .yaml first with:
#
#    kubectl --namespace "swarm" create secret generic --from-file=script=./bzzd-startup-script.sh --dry-run bzzd-startup-script -o yaml > bzzd-startup-script.yaml
#
# The way this works is as follows:
# This secret will be mounted in our bzzd containers at 
#
#    /root/bzzdstartup 
#
# and the docker container is set to execute
#
#    /root/bzzdstartup/script at startup
#
# When you update this script you must update the kubernetes secret.
#
# Why are we doing it this way?
#
# During bzzd testing we have to change this script often.
# It is much easier to update a secret than to rebuild a docker container.
#

#import the key from the mounted kubernetes secret
if [ -f "$DATADIR/keystore/`cat /root/secrets/keyimport/filename`" ]; then
    echo "Key already exists. No need to generate from secret"
else
    echo "Preparing the keyfile from kubernetes-secret"
    mkdir -p $DATADIR/keystore
    cat /root/secrets/keyimport/thekey >> "$DATADIR/keystore/`cat /root/secrets/keyimport/filename`"
fi

# bzzAccount from Keyfile
BZZACCOUNT=$(cat /root/secrets/keyimport/filename | cut -d - -f9)

echo "Starting bzzd..."

/bzzd   --ethapi=$ETHAPI \
        --bzzaccount=$BZZACCOUNT \
#        --password <(cat /root/secrets/default_pwd) \ # This no longer exists. Use unencrypted I guess?
        --ipcpath "/bzzd.ipc" \
        --port=$BZZ_PORT \
        --bzzport=$BZZ_HTTP_PORT \
        --datadir $DATADIR \
        < <(echo && echo) 

echo "end of startup script"
