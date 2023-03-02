#!/bin/bash

# Request certificates
certbot certonly --standalone \
  --non-interactive --agree-tos --email $ADMIN_EMAIL --http-01-port=380 \
  --cert-name $DOMAIN_URL \
  -d $DOMAIN_URL

# Concatenate certificates
. /etc/scripts/concatenate-certificates.sh

# Update certificates in HAProxy
. /etc/scripts/update-haproxy-certificates.sh