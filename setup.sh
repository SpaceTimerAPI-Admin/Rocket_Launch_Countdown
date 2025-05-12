
#!/bin/bash
echo "🚀 Starting Automatic Setup for Rocket Launch Countdown"

# Get the directory of the script regardless of user
SCRIPT_DIR=$(dirname "$(realpath "$0")")
echo "📁 Working Directory: $SCRIPT_DIR"
cd "$SCRIPT_DIR"

# Ensure system is updated
sudo apt-get update && sudo apt-get upgrade -y

# Install necessary dependencies
sudo apt-get install -y git build-essential libgraphicsmagick++1-dev libwebp-dev python3-dev python3-pil python3-numpy cython3

# Clone and install rpi-rgb-led-matrix (Always in user directory)
if [ ! -d "$HOME/rpi-rgb-led-matrix" ]; then
  git clone https://github.com/hzeller/rpi-rgb-led-matrix.git "$HOME/rpi-rgb-led-matrix"
fi

# Install rpi-rgb-led-matrix manually
cd "$HOME/rpi-rgb-led-matrix"
make clean
make build-python PYTHON=$(which python3)
cd bindings/python
sudo python3 setup.py install

# Return to the project directory
cd "$SCRIPT_DIR"

# Set up Python virtual environment
python3 -m venv led-matrix-env
source led-matrix-env/bin/activate

# Install Python dependencies (excluding rpi-rgb-led-matrix)
pip install Flask requests

echo "✅ Setup Complete. You can now run the countdown program using:"
echo "source led-matrix-env/bin/activate && sudo python3 rocket_launch_countdown.py"
