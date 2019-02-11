#!/bin/bash

ssl_dhparam_dir="/etc/nginx/ssl"
ssl_dhparam="${ssl_dhparam_dir}/dhparam.pem"
ssl_certificate="/etc/letsencrypt/live/${VHOSTNAME}/fullchain.pem"
ssl_certificate_key="/etc/letsencrypt/live/${VHOSTNAME}/privkey.pem"

nginx_conf=/etc/nginx/nginx.conf
nginx_vhost=/etc/nginx/conf.d/default.conf
# nginx_htpasswd=/etc/nginx/.htpasswd

mkdir -p /var/log/nginx
mkdir -p /etc/nginx/conf.d

[ "${BACKEND_HOST}" ] || BACKEND_HOST=127.0.0.1
[ "${BACKEND_PORT}" ] || BACKEND_PORT=7080

[ "${BACKEND_HOST}" ] || BACKEND_HOST=127.0.0.1
[ "${BACKEND_PORT_ADMIN}" ] || BACKEND_PORT_ADMIN=2633

EMAIL=$ADMIN_EMAIL

[ "${LETSENCRYPT}" == "1" ] && [ ! -f "${ssl_certificate}" ] && letsencrypt certonly --standalone --agree-tos --email $EMAIL -d ${VHOSTNAME}

[ -d "${ssl_dhparam_dir}" ] || mkdir -p /etc/nginx/ssl
[ -f "${ssl_dhparam}" ] || openssl dhparam -out /etc/nginx/ssl/dhparam.pem 2048 && chmod 700 ${ssl_dhparam_dir} && chmod 600 ${ssl_dhparam}

# BACKEND_HOST # nginx.conf
# BACKEND_PORT # nginx.conf
cp /nginx.conf $nginx_conf
cp /default.conf $nginx_vhost
# cp /.htpasswd $nginx_htpasswd

sed -i "s/BACKEND_HOST/${BACKEND_HOST}/g" $nginx_conf
sed -i "s/BACKEND_PORT/${BACKEND_PORT}/g" $nginx_conf
sed -i "s/BACKEND_PORT_ADMIN/${BACKEND_PORT_ADMIN}/g" $nginx_conf

# VHOSTNAME # default.conf
sed -i "s/VHOSTNAME/${VHOSTNAME}/g" $nginx_vhost

nginx -t
# nginx -g daemon off;
nginx
