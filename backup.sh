#!/usr/bin/bash
#  backup.sh
#  wazuh
#
#  Created by Eric Snyder on 08-12-2023.
# https://documentation.wazuh.com/current/user-manual/files-backup/creating/wazuh-central-components.html
#
# Create the destination folder to store the files. For version control, add the date and time of the backup to the name of the folder.
bkp_folder=~/wazuh_files_backup/$(date +%F_%H:%M)
mkdir -p $bkp_folder && echo $bkp_folder
# Save the host information.
cat /etc/*release* > $bkp_folder/host-info.txt
echo -e "\n$(hostname): $(hostname -I)" >> $bkp_folder/host-info.txt
# Back up the Wazuh server data and configuration files.
rsync -aREz \
/etc/filebeat/ \
/etc/postfix/ \
/var/ossec/api/configuration/ \
/var/ossec/etc/client.keys \
/var/ossec/etc/sslmanager* \
/var/ossec/etc/ossec.conf \
/var/ossec/etc/internal_options.conf \
/var/ossec/etc/local_internal_options.conf \
/var/ossec/etc/rules/local_rules.xml \
/var/ossec/etc/decoders/local_decoder.xml \
/var/ossec/etc/shared/ \
/var/ossec/logs/ \
/var/ossec/queue/agentless/ \
/var/ossec/queue/agents-timestamp \
/var/ossec/queue/fts/ \
/var/ossec/queue/rids/ \
/var/ossec/stats/ \
/var/ossec/var/multigroups/ $bkp_folder
rsync -aREz \
#If present, back up certificates and additional configuration files.
/var/ossec/etc/*.pem \
/var/ossec/etc/authd.pass $bkp_folder
# Back up your custom files.
rsync -aREz \
/var/ossec/active-response/bin/<custom_AR_script> \
/var/ossec/etc/lists/<user_cdb_list>.cdb \
/var/ossec/integrations/<custom_integration_script> \
/var/ossec/wodles/<custom_wodle_script> $bkp_folder
# Stop Wazuh Manager
systemctl stop wazuh-manager
# Back up the Wazuh databases
rsync -aREz \
/var/ossec/queue/db/ $bkp_folder
# Re-start Wazuh Manager
systemctl start wazuh-manager
# Back up the Wazuh indexer certificates and configuration files.
rsync -aREz \
/etc/wazuh-indexer/certs/ \
/etc/wazuh-indexer/jvm.options \
/etc/wazuh-indexer/jvm.options.d \
/etc/wazuh-indexer/log4j2.properties \
/etc/wazuh-indexer/opensearch.yml \
/etc/wazuh-indexer/opensearch.keystore \
/etc/wazuh-indexer/opensearch-observability/ \
/etc/wazuh-indexer/opensearch-reports-scheduler/ \
/etc/wazuh-indexer/opensearch-security/ \
/usr/lib/sysctl.d/wazuh-indexer.conf $bkp_folder
# Back up the Wazuh dashboard certificates and configuration files.
rsync -aREz \
/etc/wazuh-dashboard/certs/ \
/etc/wazuh-dashboard/opensearch_dashboards.yml \
/usr/share/wazuh-dashboard/config/opensearch_dashboards.keystore \
/usr/share/wazuh-dashboard/data/wazuh/config/wazuh.yml $bkp_folder
# If present, back up your downloads and custom images.
rsync -aREz \
/usr/share/wazuh-dashboard/data/wazuh/downloads/ \
/usr/share/wazuh-dashboard/plugins/wazuh/public/assets/custom/images/ $bkp_folder
# Check the backup
systemctl status wazuh-manager
find $bkp_folder -type f | sed "s|$bkp_folder/||" | less
