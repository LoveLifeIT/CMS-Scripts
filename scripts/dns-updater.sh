#!/bin/bash

az login --identity
PRIVATE_IP=$(ip addr show | grep -w inet | grep -v 127.0.0.1 | awk '{print $2}' | cut -d "/" -f 1 | head -n 1)
DNS_IP=$(dig +short $DOMAIN)
echo "Private IP: $PRIVATE_IP"
echo "DNS IP: $DNS_IP"
if [ "$PRIVATE_IP" != "$DNS_IP" ]; then
    echo "IP addresses do not match. Updating DNS record..."
    az network dns record-set a update -g $RESOURCE_GROUP -z $DNS_ZONE -n $SUBDOMAIN --set aRecords[0].ipv4Address=$PRIVATE_IP
    if [ $? -eq 0 ]; then
        echo "DNS record updated successfully."
    else
        echo "Failed to update DNS record."
    fi
else
    echo "IP addresses match. No update needed."
fi
exit 0