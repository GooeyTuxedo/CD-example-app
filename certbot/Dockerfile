FROM certbot/dns-digitalocean:latest

# Install socat
RUN apk update && apk add socat

# Copy scripts
COPY ./scripts/ /etc/scripts/

RUN echo "dns_digitalocean_token = $DIGITALOCEAN_TOKEN" >> /tmp/digitalocean.ini

# Expose port 380
EXPOSE 380