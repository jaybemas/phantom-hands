#!/usr/bin/env python3
import time
import requests

# Variables for script
deviceList = []
apiKey = 'INSERT_TOKEN'
domain = 'INSERT_DOMAIN'

# Search for all iPads in Office Device Blueprint with Zoom Room tag
r = requests.get(f'https://{domain}.api.kandji.io/api/v1/devices?blueprint_id=900b3492-29ed-41fd-ae8e-0d198e208cdd&platform=iPad&limit=300&tag_name_in=Zoom Room', headers={'Authorization': f'Bearer {apiKey}'})
zoomRoomDevices = r.json()

# Grab device id for each iPad and add it to global device list
for device in zoomRoomDevices:
    deviceList.append(device['device_id'])

# Restart iPads, remove tags
for id in deviceList:
    restartURL = f'https://{domain}.api.kandji.io/api/v1/devices/{id}/action/restart'
    updateURL = f'https://{domain}.api.kandji.io/api/v1/devices/{id}'
    payload = {"tags": []}
    requests.post(restartURL, headers={'Authorization': f'Bearer {apiKey}'})
    requests.patch(updateURL, headers={'Authorization': f'Bearer {apiKey}', 'Content-Type': 'application/json'}, json=payload)

# Wait 5 minutes to allow any pending updates
time.sleep(300)

# Reapply tags, start ZR
for id in deviceList:
    updateURL = f'https://{domain}.api.kandji.io/api/v1/devices/{id}'
    payload = {"tags": ["Zoom Room", "Start ZR"]}
    requests.patch(updateURL, headers={'Authorization': f'Bearer {apiKey}', 'Content-Type': 'application/json'}, json=payload)
