#!/bin/bash -x
# remove -x to disable debug output

#  updateAgent.sh
#  wazuh
#
#  Created by Eric Snyder on 12/24/24.
#
curl -k -X GET "https://localhost:55000/agents/outdated?pretty=true" -H  "Authorization: Bearer $TOKEN"
curl -k -X PUT "https://localhost:55000/agents/upgrade?agents_list=all&wait_for_complete=true&pretty=true" -H  "Authorization: Bearer $TOKEN"
curl -k -X GET "https://localhost:55000/agents/upgrade_result?agents_list=all&pretty=true" -H  "Authorization: Bearer $TOKEN"
curl -k -X GET "https://localhost:55000/agents?agents_list=all&pretty=true&select=version" -H  "Authorization: Bearer $TOKEN"
