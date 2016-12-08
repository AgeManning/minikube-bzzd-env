#!/bin/bash

echo "Startup is handled by kubernetes secret."

if [ -f "/root/secrets/bzzdstartup/script"  ]; then
	cp /root/secrets/bzzdstartup/script /startup.sh && chmod +x /startup.sh && /startup.sh
fi
