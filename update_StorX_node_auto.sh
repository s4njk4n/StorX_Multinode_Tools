#!/bin/bash

# Set filename to obtain IP address list for StorX Node VPS's to Update
FILE="ipaddresses"

# Set Colour Vars
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo
echo
echo -e "${GREEN}#################################################### ${NC}"
echo -e "${GREEN}#                                                  # ${NC}"
echo -e "${GREEN}#                AUTOMATIC UPDATER                 # ${NC}"
echo -e "${GREEN}#             FOR MULTIPLE STORX NODES             # ${NC}"
echo -e "${GREEN}#                                                  # ${NC}"
echo -e "${GREEN}# Created by s4njk4n - https://github.com/s4njk4n/ #${NC}"
echo -e "${GREEN}#                                                  # ${NC}"
echo -e "${GREEN}#################################################### ${NC}"
echo
echo

# Set time (in seconds) to wait for your VPS to reboot. You'll have to manually test this. Recommend rounding UP by a minute or 2
echo
echo -e "${RED}How long (in seconds) should be allowed for each VPS to reboot? (Must be LONGER ${NC}"
echo -e "${RED}than the boot time of your SLOWEST booting node). If unsure, set it to ${NC}"
echo -e "${RED}something long like 300(seconds). Setting a longer time isn't harmful, it will ${NC}"
echo -e "${RED}just take longer to finish all the nodes. If the time selected isn't long ${NC}"
echo -e "${RED}enough however, then the update will not succeed. ${NC}"
read WAITTOREBOOT

while IFS= read line
do

   echo
   echo -e "${GREEN}Deactivating StorX Node - $line ${NC}"
   ssh -n root@$line 'cd StorX-Node && sudo docker-compose -f docker-services.yml down'

   # This section below was neccessary to separate into individual one-line commands and to run TWICE
   # in order for certain VPS providers to work properly
   echo
   echo -e "${GREEN}Updating VPS OS & Packages - $line ${NC}"
   ssh -n root@$line 'sudo apt update -y'
   ssh -n root@$line 'sudo apt upgrade -y'
   ssh -n root@$line 'sudo apt autoremove -y'
   ssh -n root@$line 'sudo apt clean -y'
   ssh -n root@$line 'sudo apt update -y'
   ssh -n root@$line 'sudo apt upgrade -y'
   ssh -n root@$line 'sudo apt autoremove -y'
   ssh -n root@$line 'sudo apt clean -y'

   echo
   echo -e "${GREEN}Rebooting VPS - $line ${NC}"
   ssh -n root@$line 'reboot' > /dev/null 2>&1
   sleep $WAITTOREBOOT

   echo
   echo -e "${GREEN}Upgrading StorX Network Configuration Scripts - $line ${NC}"
   ssh -n root@$line 'cd StorX-Node && git pull'

   echo
   echo -e "${GREEN}Upgrading StorX Node Docker Images - $line ${NC}"
   ssh -n root@$line 'cd StorX-Node && sudo docker pull storxnetwork/storxnode:latest'

   echo
   echo -e "${GREEN}Restarting StorX Node - $line ${NC}"
   ssh -n root@$line 'cd StorX-Node && sudo docker-compose -f docker-services.yml up -d'

   echo
   echo -e "${GREEN}Allowing time for daemon to connect - $line ${NC}"
   sleep 60s # Wait 60sec to allow daemon to connect (before querying status of StorX Node)

   echo
   echo -e "${GREEN}Getting Status of Updated Node - $line ${NC}"
   ssh -n root@$line 'sudo docker exec storx-node_storxnetwork_1 xcore status'

   echo
   echo -e "${GREEN}Congratulations! Your StorX Node at $line has now been updated ${NC}"
   echo
   echo -e "${GREEN}--------------------------------------------------------------- ${NC}"
   echo

done < "$FILE"

echo -e "${RED}ALL STORX NODE UPDATES COMPLETED ${NC}"
echo

