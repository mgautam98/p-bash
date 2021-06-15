#!/bin/bash


# 4 Delete ruchishivani SSID
nmcli connection delete ruchishivani

# alternative
ls /etc/NetworkManager/system-connections/
#  1.5.nmconnection   ruchishivani.nmconnection  'TENDA .nmconnection'

rm /etc/NetworkManager/system-connections/ruchishivani.nmconnection 
#  1.5.nmconnection 'TENDA .nmconnection'