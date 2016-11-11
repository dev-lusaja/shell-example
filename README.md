Example

./deploy.sh -s /usr/local/opt/apps/back-office/ -f staging-compose.yml -a up -d

-s = source path
-f = docker-compose file
-a = action for docker container
-d = daemon mode

Note:

This script reload the laod balancer on /usr/local/opt/load-balancer
