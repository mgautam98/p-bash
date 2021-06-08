#!/bin/bash

# 2 get list of SSIDs by strengths
nmcli dev wifi

# SAMPLE OUTPUT:
# IN-USE  BSSID              SSID    MODE   CHAN  RATE        SIGNAL  BARS  SECURITY  
#         C6:0A:7F:63:02:84  1.5     Infra  11    117 Mbit/s  99      ▂▄▆█  WPA2      
# *       04:95:E6:A1:C7:68  TENDA   Infra  5     270 Mbit/s  81      ▂▄▆█  WPA1 WPA2 
