# Tear down running containers
docker-compose down

# Delete docker images
docker rmi -f cyberlab-ubuntu_machine
docker rmi -f cyberlab-attacker
docker rmi -f cyberlab-web_server

echo "Teardown Complete"