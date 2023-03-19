#!/bin/sh

echo "Stopping containers..."
sudo docker-compose down  

echo "About to pull containers"
sudo docker-compose pull

echo "About to start containers"
sudo docker-compose up -d

# echo "Cleaning up dangling images"
# sudo docker image prune -af
 
echo "Done!"