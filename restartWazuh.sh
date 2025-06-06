#!/usr/bin/bash
#  restartWazuh.sh
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
sudo systemctl restart wazuh-indexer
sudo systemctl restart wazuh-manager
sudo systemctl restart filebeat
sudo systemctl restart wazuh-dashboard
