
#!/bin/bash
# Rocket Launch Countdown Automatic Setup Script
echo "🚀 Starting Automatic Setup for Rocket Launch Countdown"

# Update and Install Dependencies
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install -y git build-essential libgraphicsmagick++1-dev libwebp-dev python3-dev python3-pil python3-numpy cython3 python3-venv bluetooth bluez bluez-tools

# Ensure we are in the correct directory
cd "$(dirname "$0")"
PROJECT_DIR=$(pwd)
echo "📁 Working Directory: $PROJECT_DIR"

# Set up Python Virtual Environment
if [ ! -d "led-matrix-env" ]; then
    python3 -m venv led-matrix-env
fi
source led-matrix-env/bin/activate
pip install --upgrade pip
pip install -r requirements.txt --break-system-packages

# Bluetooth Setup (Just Works)
echo "🚀 Setting Up Bluetooth Configuration (Just Works Mode)"
sudo systemctl enable bluetooth
sudo systemctl start bluetooth
bluetoothctl << EOF
power on
agent on
default-agent
discoverable on
pairable on
EOF

# Set Bluetooth to "Just Works" mode
sudo hciconfig hci0 sspmode 1
sudo hciconfig hci0 class 0x6c0100
sudo hciconfig hci0 name "Space Time Setup"

echo "✅ Bluetooth Setup Complete. You can now pair with 'Space Time Setup' for configuration."
