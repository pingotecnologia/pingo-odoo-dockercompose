#!/bin/bash

# Navigate to your docker-compose project directory
cd /mnt/odoo || exit 1

# Run certbot to renew certificates
docker compose run --rm certbot-renew

# Restart nginx to apply new certificates
docker compose restart nginx
