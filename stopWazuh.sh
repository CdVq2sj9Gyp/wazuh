#!/usr/bin/bash
#  stopWazuh.sh
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
sudo systemctl stop wazuh-indexer
sudo systemctl stop wazuh-manager
sudo systemctl stop filebeat
sudo systemctl stop wazuh-dashboard
