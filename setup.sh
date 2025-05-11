
#!/bin/bash
echo "🚀 Starting Automatic Setup for Rocket Launch Countdown"

# Ensure system is updated
sudo apt-get update && sudo apt-get upgrade -y

# Install necessary dependencies
sudo apt-get install -y git build-essential libgraphicsmagick++-dev libwebp-dev python3-dev python3-pillow python3-numpy cython3

# Clone and install rpi-rgb-led-matrix
cd ~
git clone https://github.com/hzeller/rpi-rgb-led-matrix.git || true
cd rpi-rgb-led-matrix
make clean
make build-python PYTHON=$(which python3)
cd bindings/python
sudo python3 setup.py install

# Return to the project directory (regardless of location)
cd "$(dirname "$0")"

# Set up Python virtual environment
python3 -m venv led-matrix-env
source led-matrix-env/bin/activate

# Install Python dependencies
pip install -r requirements.txt

echo "✅ Setup Complete. You can now run the countdown program using:"
echo "source led-matrix-env/bin/activate && sudo python3 rocket_launch_countdown.py"
