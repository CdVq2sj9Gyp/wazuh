#!/usr/bin/bash
#  startWazuh.sh
#  wazuh
#
#  Created by Eric Snyder on 17-04-2024.
#  
if [ "$EUID" -ne 0 ]
    then
        echo "Please run as root"
        exit
fi
#
sudo systemctl start wazuh-indexer
sudo systemctl start wazuh-manager
sudo systemctl start filebeat
sudo systemctl start wazuh-dashboard
