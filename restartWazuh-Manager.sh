#!/bin/bash -x
#
#/home/erics/restartWazuh-Manager.sh
sudo systemctl -l --no-page restart wazuh-manager.service && sudo systemctl -l --no-page status wazuh-manager.service && sudo journalctl -xeu wazuh-manager
