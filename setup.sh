
#!/bin/bash
echo "🚀 Starting Automatic Setup for Rocket Launch Countdown"

# Ensure system is up-to-date
sudo apt-get update -y
sudo apt-get upgrade -y

# Install necessary dependencies
sudo apt-get install -y git build-essential libgraphicsmagick++1-dev libwebp-dev python3-dev python3-pil python3-numpy cython3

# Clone RGB Matrix Library if not already present
if [ ! -d "rpi-rgb-led-matrix" ]; then
    git clone https://github.com/hzeller/rpi-rgb-led-matrix.git
fi

# Build RGB Matrix Library
make -C rpi-rgb-led-matrix/lib
make -C rpi-rgb-led-matrix/examples-api-use
make -C rpi-rgb-led-matrix/bindings/python build

# Set up Python virtual environment
python3 -m venv led-matrix-env
source led-matrix-env/bin/activate

# Install Python dependencies
pip install --upgrade pip
pip install Flask requests

# Create .env file if it doesn't exist
if [ ! -f ".env" ]; then
    echo "FLASK_APP=rocket_launch_countdown.py" > .env
    echo "FLASK_ENV=production" >> .env
    echo "FLASK_DEBUG=False" >> .env
fi

echo "✅ Setup Complete. You can now run the countdown program using:"
echo "source led-matrix-env/bin/activate && sudo python3 rocket_launch_countdown.py"
