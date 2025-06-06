#!/usr/bin/bash -x
#  /home/erics/checkServices.sh
#  wazuh
#
#  Created by Eric Snyder on 16-04-2024.
#
if [ "$EUID" -ne 0 ]
    then
        echo "Please run as root"
        exit
fi
echo -e "Wazuh API"
# curl -k -X GET "https://<api_url>:55000/" -H "Authorization: Bearer $(curl -u <api_user>:<api_password> -k -X POST 'https://<api_url>:55000/security/user/authenticate?raw=true')"
curl -k -X GET "https://127.0.0.1:55000/" -H "Authorization: Bearer $(curl -u wazuh:wazuh -k -X POST 'https://127.0.0.1:55000/security/user/authenticate?raw=true')"
# HillTop curl -k -X GET "https://10.10.21.51:55000/" -H "Authorization: Bearer $(curl -u wazuh:m9GDsgStQmNj+?EWMd+NL6fbalN3lXci -k -X POST 'https://10.10.21.51:55000/security/user/authenticate?raw=true')"
#
# Check for alerts in Wazuh indexer.
# curl https://<WAZUH_INDEXER_IP>:9200/_cat/indices/wazuh-alerts-* -u <wazuh_indexer_user>:<wazuh_indexer_password> -k
# Hill Top curl https://127.0.0.1:9200/_cat/indices/wazuh-alerts-* -u admin:LyYZQAEV+U97lj+br4V3EN7WasZ.wY+o -k
# Potomac curl https://127.0.0.1:9200/_cat/indices/wazuh-alerts-* -u admin:g4ewwP3nRV3eSL*fN9x+KAm6qQP8mShv -k
echo -e "wazuh-indexer"
/bin/systemctl -l --no-page status wazuh-indexer | grep "Active:"
echo -e "\r\n"
echo -e "first curl\r\n"
# Admin user for the web user interface and Wazuh indexer. Use this user to log in to Wazuh dashboard
curl -k -u admin:GATEPOST8timpani-sculpt https://192.168.1.21:9200
# HillTop curl -k -u admin:LyYZQAEV+U97lj+br4V3EN7WasZ.wY+o https://127.0.0.1:9200
# Potomac curl -k -u admin:g4ewwP3nRV3eSL*fN9x+KAm6qQP8mShv https://127.0.0.1:9200
echo -e "second curl\r\n"
curl -k -u admin:GATEPOST8timpani-sculpt https://192.168.1.21:9200/_cat/nodes?v
# HillTop curl -k -u admin:LyYZQAEV+U97lj+br4V3EN7WasZ.wY+o https://127.0.0.1:9200/_cat/nodes?v
# Potomac curl -k -u admin:g4ewwP3nRV3eSL*fN9x+KAm6qQP8mShv https://127.0.0.1:9200/_cat/nodes?v
echo -e "\r\n"
echo -e "wazuh-manager"
/bin/systemctl -l --no-page status wazuh-manager | grep "Active:"
echo -e "\r\n"
echo -e "filebeat"
/bin/systemctl -l --no-page status filebeat | grep "Active:"
echo -e "\r\n"
filebeat test output
echo -e "\r\n"
echo -e "wazuh-dashboard"
/bin/systemctl -l --no-page status wazuh-dashboard | grep "Active:"
echo -e "\r\n"
echo -e "postfix"
/bin/systemctl -l --no-page status postfix | grep "Active:"
