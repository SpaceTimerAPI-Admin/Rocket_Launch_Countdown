#!/bin/bash

echo "🚀 Starting Automatic Setup for Rocket Launch Countdown"

# Ensure system is up to date
sudo apt-get update -y
sudo apt-get upgrade -y

# Install dependencies
sudo apt-get install -y git build-essential libgraphicsmagick++1-dev libwebp-dev python3-dev python3-pil python3-numpy cython3 python3-venv

# Clone the LED Matrix Library
if [ ! -d "rpi-rgb-led-matrix" ]; then
    git clone https://github.com/hzeller/rpi-rgb-led-matrix.git
fi

# Compile the LED Matrix Library
cd rpi-rgb-led-matrix
make clean
make build-python
cd ..

# Set up virtual environment
if [ ! -d "led-matrix-env" ]; then
    python3 -m venv led-matrix-env
fi

# Activate virtual environment
source led-matrix-env/bin/activate

# Ensure pip is up to date
pip install --upgrade pip

# Install required Python packages
pip install -r requirements.txt

echo "✅ Setup Complete. You can now run the countdown program using:"
echo "source led-matrix-env/bin/activate && sudo python3 rocket_launch_countdown.py"
