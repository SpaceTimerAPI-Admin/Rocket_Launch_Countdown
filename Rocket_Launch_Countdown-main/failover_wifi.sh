
#!/bin/bash
# Failover WiFi Script - Automatically use AP mode if no internet

if ping -c 3 google.com > /dev/null 2>&1; then
    echo "✅ Internet is active."
    exit 0
fi

echo "❌ No Internet detected. Starting Access Point for setup."

# Set wlan0 to AP mode
sudo systemctl stop wpa_supplicant
sudo ip link set wlan0 down
sudo ip addr flush dev wlan0
sudo ip link set wlan0 up

# Start Access Point
sudo systemctl start hostapd
sudo systemctl start dnsmasq

echo "✅ Access Point 'Space Time - Set Up' is now active at 10.0.0.1."
