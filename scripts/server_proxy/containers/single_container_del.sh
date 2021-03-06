#!/bin/bash

DIRECTORY=/root/scripts/server_proxy

### LOAD FROM FILES
source $DIRECTORY/variables/domain_name

### READ SERVER NAME
read -p "Single Server container name to be deleted: " container_name
full_name=${container_name}".$domain_name"
echo "" ; echo -e "Container Server address: \e[1;31m$full_name"; tput sgr0
read -p "Is that correct(Y/N): " option_containter_name

if [ $option_containter_name == "Y" ] || [ $option_containter_name == "y" ]
then
  entry=$DIRECTORY/added_containers/$container_name

  if [ -f $entry ]
  then
    source $entry

    if [ $type == single_container ]
    then
      echo ""; echo -e "\e[1;31m DELETE NETWORK INTERFACE"; tput sgr0
      /bin/bash $DIRECTORY/shared/interface_del.sh $adapter_name

      echo ""; echo -e "\e[1;31m UPDATE DNS"; tput sgr0
      /bin/bash $DIRECTORY/shared/dns_entry_del.sh $server_name $new_server_ip $domain_name

      echo "" ; echo -e "\e[1;31m UPDATE PROXY"; tput sgr0
      /bin/bash $DIRECTORY/shared/proxy_single_del.sh $server_name $full_name

      echo "" ; echo -e "\e[1;31m UPDATE FIREWALL"; tput sgr0
      /bin/bash $DIRECTORY/shared/fw_single_del.sh $server_name $new_server_ip

      echo "" ; echo -e "\e[1;31m DELETE SERVER CONFIG FILE"; tput sgr0
      rm -rfv $DIRECTORY/added_containers/$server_name
    else
      echo "Container chosen is not a Single Server..."
    fi
  else
    echo "Container name not found :("
  fi
else
  echo "Aborted by choosing single server container name..."
fi
