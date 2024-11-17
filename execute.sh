# Script to launch Cyber Lab environment
# Run compose.yaml file to build and launch containers user, reverse proxy, and attacker
# Each container uses a dockerfile and installs dependencies/copys appropriate files
docker-compose build --no-cache
docker-compose up -d

# Copy public and private keys from reverse proxy to simulate stolen certs
docker cp web_server:/etc/ssl/private/nginx-selfsigned.key .
docker cp web_server:/etc/ssl/certs/nginx-selfsigned.crt .

# Copy stolen certs to attackers machine so they can serve malicious webpage
docker exec -i attacker sh -c 'cat > /simple-https-python-server/nginx-selfsigned.crt' < ./nginx-selfsigned.crt
docker exec -i attacker sh -c 'cat > /simple-https-python-server/nginx-selfsigned.key' < ./nginx-selfsigned.key

# Remove intermediate cert files from machine running this script
rm -f nginx-selfsigned.crt
rm -f nginx-selfsigned.key