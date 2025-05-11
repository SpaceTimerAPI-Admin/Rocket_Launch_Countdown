
#!/bin/bash
echo "Setting up WiFi Access Point - Space Time - Set Up"

# Install dependencies
sudo apt-get update
sudo apt-get install -y hostapd dnsmasq

# Stop services to configure
sudo systemctl stop hostapd
sudo systemctl stop dnsmasq

# Configure dnsmasq (DHCP and DNS)
sudo bash -c 'cat <<EOF > /etc/dnsmasq.conf
interface=wlan0
dhcp-range=192.168.4.2,192.168.4.20,255.255.255.0,24h
EOF'

# Configure hostapd (Access Point)
sudo bash -c 'cat <<EOF > /etc/hostapd/hostapd.conf
interface=wlan0
ssid=Space Time - Set Up
hw_mode=g
channel=7
wmm_enabled=0
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0
EOF'

# Set hostapd to use this configuration
sudo bash -c 'echo "DAEMON_CONF="/etc/hostapd/hostapd.conf"" > /etc/default/hostapd'

# Restart services
sudo systemctl unmask hostapd
sudo systemctl enable hostapd
sudo systemctl start hostapd
sudo systemctl restart dnsmasq

echo "✅ WiFi Access Point - Space Time - Set Up is now active."
