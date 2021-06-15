#!/bin/bash

# 3 Get password of SSID which is connected
nmcli dev wifi show-password

# SSID: TENDA 
# Security: WPA
# Password: 83749274

# Alternative
cat /etc/NetworkManager/system-connections/TENDA\ .nmconnection