#!/bin/bash

# Set filename to obtain IP address list for StorX Node VPS's to setup wth SSH-key authentication
FILE="ipaddresses"

# Set Colour Vars
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo
echo
echo -e "${GREEN}#################################################### ${NC}"
echo -e "${GREEN}#                                                  # ${NC}"
echo -e "${GREEN}#           SETUP SSH-KEY AUTHENTICATION           # ${NC}"
echo -e "${GREEN}#             FOR MULTIPLE STORX NODES             # ${NC}"
echo -e "${GREEN}#                                                  # ${NC}"
echo -e "${GREEN}# Created by s4njk4n - https://github.com/s4njk4n/ #${NC}"
echo -e "${GREEN}#                                                  # ${NC}"
echo -e "${GREEN}#################################################### ${NC}"
echo
echo


echo -e "${RED}Whenever asked for the password for root@ip.address just type ${NC}"
echo -e "${RED}the correct password for that VPS and press the ENTER key. ${NC}"
echo

while IFS= read line
do

   echo
   echo -e "${GREEN}Setting up SSH-key based authentication for $line ${NC}"
   echo
   ssh-copy-id -o "StrictHostKeyChecking=no" root@$line
   echo

done < "$FILE"

echo
echo -e "${RED}SSH-KEY AUTHENTICATION ESTABLISHED FOR ALL STORX NODES ${NC}"
echo

