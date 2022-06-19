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
echo -e "${GREEN}#               NODE STATUS CHECKER                # ${NC}"
echo -e "${GREEN}#             FOR MULTIPLE STORX NODES             # ${NC}"
echo -e "${GREEN}#                                                  # ${NC}"
echo -e "${GREEN}# Created by s4njk4n - https://github.com/s4njk4n/ #${NC}"
echo -e "${GREEN}#                                                  # ${NC}"
echo -e "${GREEN}#################################################### ${NC}"
echo
echo

while IFS= read line
do

   echo
   echo
   echo -e "${GREEN}Retrieving Status of StorX Node - $line ${NC}"
   echo
   ssh -n root@$line 'sudo docker exec storx-node_storxnetwork_1 xcore status'

done < "$FILE"

echo
echo
echo -e "${RED}STORX NODE STATUS RETRIEVAL COMPLETE ${NC}"
echo

