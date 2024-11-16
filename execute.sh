docker-compose up -d
docker cp reverse_proxy:/etc/ssl/private/nginx-selfsigned.key .
docker cp reverse_proxy:/etc/ssl/certs/nginx-selfsigned.crt .
docker exec -i attacker sh -c 'cat > /simple-https-python-server/nginx-selfsigned.crt' < ./nginx-selfsigned.crt
docker exec -i attacker sh -c 'cat > /simple-https-python-server/nginx-selfsigned.key' < ./nginx-selfsigned.key
rm -f nginx-selfsigned.crt
rm -f nginx-selfsigned.key