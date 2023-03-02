#!/bin/bash
if [ -f /etc/letsencrypt/live/$DOMAIN_URL/fullchain.pem -a -f /etc/letsencrypt/live/$DOMAIN_URL/privkey.pem ]; then
  cat /etc/letsencrypt/live/$DOMAIN_URL/fullchain.pem /etc/letsencrypt/live/$DOMAIN_URL/privkey.pem > /etc/certificates/$DOMAIN_URL.pem
fi