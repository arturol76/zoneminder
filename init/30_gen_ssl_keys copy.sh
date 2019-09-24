#!/bin/bash
#
# 30_gen_ssl_keys.sh
#

#copies letsencrypt keys
if [ ! -z "$LETSENCRYPT_DOMAIN" ]; then
	if [[ -f /letsencrypt/live/$LETSENCRYPT_DOMAIN/chain.pem && -f /letsencrypt/live/$LETSENCRYPT_DOMAIN/privkey.pem ]]; then
		cp /letsencrypt/live/$LETSENCRYPT_DOMAIN/fullchain.pem /config/keys/cert.crt
		cp /letsencrypt/live/$LETSENCRYPT_DOMAIN/privkey.pem /config/keys/cert.key
		echo "letsencrypt keys copied"
	else
		echo "letsencrypt keys copnot found!"
	fi
fi


if [[ -f /config/keys/cert.key && -f /config/keys/cert.crt ]]; then
	echo "using existing keys in \"/config/keys\""
	if [[ ! -f /config/keys/ServerName ]]; then
		echo "localhost" > /config/keys/ServerName
	fi
	SERVER=`cat /config/keys/ServerName`
	sed -i "/ServerName/c\ServerName $SERVER" /etc/apache2/apache2.conf
else
	echo "generating self-signed keys in /config/keys, you can replace these with your own keys if required"
	mkdir -p /config/keys
	echo "localhost" >> /config/keys/ServerName
	openssl req -x509 -nodes -days 4096 -newkey rsa:2048 -out /config/keys/cert.crt -keyout /config/keys/cert.key -subj "/C=US/ST=NY/L=New York/O=Zoneminder/OU=Zoneminder/CN=localhost"
fi

chown root:root /config/keys
chmod 777 /config/keys
