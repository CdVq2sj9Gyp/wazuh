#!/bin/bash -x
# remove -x to disable debug output

#  updateWazuh4-7.sh
#  wazuh
#
#  Created by Eric Snyder on 11/14/23.
#
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi
# Taken from:
# https://documentation.wazuh.com/current/upgrade-guide/upgrading-central-components.html
# Preparing the upgrade
## Install the following packages if missing.
apt-get install gnupg apt-transport-https
## Install the GPG key.
curl -s https://packages.wazuh.com/key/GPG-KEY-WAZUH | gpg --no-default-keyring --keyring gnupg-ring:/usr/share/keyrings/wazuh.gpg --import && chmod 644 /usr/share/keyrings/wazuh.gpg
## Add the repository.
echo "deb [signed-by=/usr/share/keyrings/wazuh.gpg] https://packages.wazuh.com/4.x/apt/ stable main" | tee -a /etc/apt/sources.list.d/wazuh.list
## Update the packages information.
apt-get update
# Stop the Filebeat service and the Wazuh dashboard service if installed in the node.
systemctl stop filebeat
systemctl stop wazuh-dashboard
# Upgrading the Wazuh indexer
# Disable shard allocation.
curl -X PUT "https://10.10.162.25:9200/_cluster/settings"  -u admin:WLl*2.zf4rfCmTv1A4qfqPlYj1qTrlm7 -k -H 'Content-Type: application/json' -d'
{
  "persistent": {
    "cluster.routing.allocation.enable": "primaries"
  }
}
'
echo -e "\r\n"
# Stop non-essential indexing and perform a synced flush.
curl -X POST "https://10.10.162.25:9200/_flush/synced" -u admin:WLl*2.zf4rfCmTv1A4qfqPlYj1qTrlm7 -k
echo -e "\r\n"
# Upgrade the Wazuh indexer to the latest version.
systemctl stop wazuh-indexer
apt-get install wazuh-indexer
# Restart the service.
systemctl daemon-reload
systemctl enable wazuh-indexer
systemctl start wazuh-indexer
# Check that the newly-upgraded node joins the cluster.
curl -X PUT "https://10.10.162.25:9200/_cluster/settings" -u admin:WLl*2.zf4rfCmTv1A4qfqPlYj1qTrlm7 -k -H 'Content-Type: application/json' -d'
{
  "persistent": {
    "cluster.routing.allocation.enable": "all"
  }
}
'
echo -e "\r\n"
# Check again the status of the cluster to see if shard allocation has finished.
curl -k -u admin:WLl*2.zf4rfCmTv1A4qfqPlYj1qTrlm7 https://10.10.162.25:9200/_cat/nodes?v
echo -e "\r\n"
# Upgrading the Wazuh server
systemctl stop wazuh-manager
apt-get install wazuh-manager
# Download the Wazuh module for Filebeat:
# curl -s https://packages.wazuh.com/4.x/filebeat/wazuh-filebeat-0.2.tar.gz | sudo tar -xvz -C /usr/share/filebeat/module
curl -s https://packages.wazuh.com/4.x/filebeat/wazuh-filebeat-0.3.tar.gz | sudo tar -xvz -C /usr/share/filebeat/module
echo -e "\r\n"
# Download the alerts template:
# curl -so /etc/filebeat/wazuh-template.json https://raw.githubusercontent.com/wazuh/wazuh/v4.6.0/extensions/elasticsearch/7.x/wazuh-template.json
curl -so /etc/filebeat/wazuh-template.json https://raw.githubusercontent.com/wazuh/wazuh/v4.7.2/extensions/elasticsearch/7.x/wazuh-template.json
echo -e "\r\n"
chmod go+r /etc/filebeat/wazuh-template.json
# Restart Filebeat:
systemctl daemon-reload
systemctl enable filebeat
systemctl start wazuh-manager
systemctl start filebeat
# Upload the new Wazuh template. This step can be omitted for Wazuh indexer single-node installations.
filebeat setup --index-management -E output.logstash.enabled=false
# Upgrading the Wazuh dashboard
systemctl stop wazuh-dashboard
apt-get install wazuh-dashboard
# Restart the Wazuh dashboard:
systemctl daemon-reload
systemctl enable wazuh-dashboard
systemctl start wazuh-dashboard
