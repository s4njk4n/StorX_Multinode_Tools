#!/bin/bash

# Set Colour Vars
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo
echo
echo -e "${GREEN}     #################################################### ${NC}"
echo -e "${GREEN}     #                                                  # ${NC}"
echo -e "${GREEN}     #                 MANUAL UPDATER                   # ${NC}"
echo -e "${GREEN}     #             FOR A SINGLE STORX NODE              # ${NC}"
echo -e "${GREEN}     #                                                  # ${NC}"
echo -e "${GREEN}     # Created by s4njk4n - https://github.com/s4njk4n/ # ${NC}"
echo -e "${GREEN}     #                                                  # ${NC}"
echo -e "${GREEN}     #################################################### ${NC}"
echo
echo

echo
echo -e "${RED}Enter IP address of StorX Node VPS to Update ${NC}"
read vpsIP

# Set time (in seconds) to wait for your VPS to reboot. You'll have to manually test this. Recommend rounding UP by a minute or 2
echo
echo -e "${RED}How long (in seconds) should be allowed for your VPS to reboot? ${NC}"
read WAITTOREBOOT

echo
echo -e "${GREEN}Deactivating StorX Node - $vpsIP ${NC}"
ssh -p 22 root@$vpsIP 'cd StorX-Node && sudo docker-compose -f docker-services.yml down'

echo
echo -e "${GREEN}Updating VPS OS & Packages - $vpsIP ${NC}"
# Quirks of certain VPS providers require us to run the commands below twice on separate lines
ssh -n -p 22 root@$vpsIP 'apt update -y'
ssh -n -p 22 root@$vpsIP 'apt upgrade -y'
ssh -n -p 22 root@$vpsIP 'apt autoremove -y'
ssh -n -p 22 root@$vpsIP 'apt clean -y'
ssh -n -p 22 root@$vpsIP 'apt update -y'
ssh -n -p 22 root@$vpsIP 'apt upgrade -y'
ssh -n -p 22 root@$vpsIP 'apt autoremove -y'
ssh -n -p 22 root@$vpsIP 'apt clean -y'

echo
echo -e "${GREEN}Rebooting VPS - $vpsIP ${NC}"
ssh -p 22 root@$vpsIP 'reboot' > /dev/null 2>&1
sleep $WAITTOREBOOT

echo
echo -e "${GREEN}Upgrading StorX Network Configuration Scripts - $vpsIP ${NC}"
ssh -p 22 root@$vpsIP 'cd StorX-Node && git pull'

echo
echo -e "${GREEN}Upgrading StorX Node Docker Images - $vpsIP ${NC}"
ssh -p 22 root@$vpsIP 'cd StorX-Node && sudo docker pull storxnetwork/storxnode:latest'

echo
echo -e "${GREEN}Restarting StorX Node - $vpsIP ${NC}"
ssh -p 22 root@$vpsIP 'cd StorX-Node && sudo docker-compose -f docker-services.yml up -d'

echo
echo -e "${GREEN}Allowing time for daemon to connect - $vpsIP ${NC}"
sleep 1m # waits 1minute to allow deamon to run otherwise getting status in next command will not work

echo
echo -e "${GREEN}Getting Status of Updated Node - $vpsIP ${NC}"
ssh -p 22 root@$vpsIP 'sudo docker exec storx-node_storxnetwork_1 xcore status'

echo
echo -e "${GREEN}Congratulations! Your StorX Node at $vpsIP has now been updated ${NC}"

