
#!/bin/bash
echo "🚀 Starting Automatic Setup for Rocket Launch Countdown"
sudo apt-get update && sudo apt-get upgrade -y

# Install Dependencies
sudo apt-get install -y git build-essential libgraphicsmagick++1-dev libwebp-dev python3-dev python3-pil python3-numpy cython3

# Clone the LED matrix library
git clone https://github.com/hzeller/rpi-rgb-led-matrix.git
cd rpi-rgb-led-matrix
make build-python PYTHON=$(which python3)
cd ..

# Setup WiFi Failover
sudo cp failover_wifi.sh /usr/local/bin/failover_wifi.sh
sudo chmod +x /usr/local/bin/failover_wifi.sh
sudo bash -c 'echo "@reboot /usr/local/bin/failover_wifi.sh" >> /etc/crontab'

echo "✅ Setup Complete. You can now run the countdown program using:"
echo "source led-matrix-env/bin/activate && sudo python3 rocket_launch_countdown.py"
