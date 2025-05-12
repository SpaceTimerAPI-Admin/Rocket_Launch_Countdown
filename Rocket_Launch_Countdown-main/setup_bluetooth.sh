
#!/bin/bash

echo "🚀 Starting Bluetooth Setup for Space Time Countdown with Bleak and Just Works Pairing"

# Ensure Bluetooth is enabled
sudo systemctl enable bluetooth
sudo systemctl start bluetooth

# Update Bluetooth configuration for consistent naming and Just Works pairing
sudo sed -i '/\[General\]/!b;n;cName=Space Time Setup' /etc/bluetooth/main.conf
sudo sed -i '/\[General\]/!b;n;cClass=0x6c0100' /etc/bluetooth/main.conf
sudo sed -i '/\[General\]/!b;n;cDiscoverableTimeout=0' /etc/bluetooth/main.conf
sudo sed -i '/\[General\]/!b;n;cPairableTimeout=0' /etc/bluetooth/main.conf
sudo sed -i '/\[General\]/!b;n;cFastConnectable=true' /etc/bluetooth/main.conf
sudo sed -i '/\[General\]/!b;n;cJustWorksRepairing=true' /etc/bluetooth/main.conf

# Adjust security settings for Just Works (No Passkey)
sudo sed -i '/\[Security\]/!b;n;cAutoEnable=true' /etc/bluetooth/main.conf
sudo sed -i '/\[Security\]/!b;n;cSecurity=low' /etc/bluetooth/main.conf

# Restart Bluetooth to apply changes
sudo systemctl restart bluetooth

# Using Bleak for Bluetooth setup
bluetoothctl <<EOF
power on
agent on
default-agent
discoverable on
pairable on
EOF

echo "✅ Bluetooth Setup Complete with Just Works (No Passkey). You can now pair with 'Space Time Setup' for configuration."
