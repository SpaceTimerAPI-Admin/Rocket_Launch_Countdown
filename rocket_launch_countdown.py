import os
import time
import json
import requests
import threading
from flask import Flask, render_template, request, redirect
from rpi_rgb_led_matrix import RGBMatrix, RGBMatrixOptions, graphics

app = Flask(__name__)

# Configuration
API_URL = "https://ll.thespacedevs.com/2.3.0/launches/upcoming/"
CONFIG_FILE = "config.json"

# Load Configuration
def load_config():
    if os.path.exists(CONFIG_FILE):
        with open(CONFIG_FILE, 'r') as file:
            return json.load(file)
    else:
        return {
            "timezone": "UTC",
            "wifi_ssid": "",
            "wifi_password": "",
            "pads": [],
            "brightness": 100,
            "enabled": True
        }

config = load_config()

# Function to save configuration
def save_config():
    with open(CONFIG_FILE, 'w') as file:
        json.dump(config, file, indent=4)

# Function to connect to Wi-Fi
def configure_wifi(ssid, password):
    os.system(f"sudo nmcli device wifi connect '{ssid}' password '{password}'")

# Function to fetch the next launch
def get_next_launch():
    response = requests.get(API_URL)
    launches = response.json().get('results', [])
    for launch in launches:
        if any(pad in launch['pad']['location']['name'] for pad in config['pads']):
            return launch
    return None

# Function to update LED Display
def update_led_display(launch):
    options = RGBMatrixOptions()
    options.brightness = config['brightness']
    matrix = RGBMatrix(options=options)
    canvas = matrix.CreateFrameCanvas()
    font = graphics.Font()
    font.LoadFont("/home/pi/fonts/7x13.bdf")

    while True:
        remaining_time = get_remaining_time(launch)
        canvas.Clear()
        text = format_countdown(remaining_time)
        graphics.DrawText(canvas, font, 0, 10, graphics.Color(255, 0, 0), text)
        canvas = matrix.SwapOnVSync(canvas)
        time.sleep(1)

# Flask Configuration Page
@app.route('/', methods=['GET', 'POST'])
def index():
    if request.method == 'POST':
        config['timezone'] = request.form.get('timezone')
        config['wifi_ssid'] = request.form.get('wifi_ssid')
        config['wifi_password'] = request.form.get('wifi_password')
        config['pads'] = request.form.getlist('pads')
        config['brightness'] = int(request.form.get('brightness'))
        config['enabled'] = request.form.get('enabled') == 'on'
        save_config()
        configure_wifi(config['wifi_ssid'], config['wifi_password'])
        return redirect('/')

    return render_template('index.html', config=config)

@app.route('/status')
def status():
    launch = get_next_launch()
    if launch:
        return json.dumps(launch)
    return json.dumps({"status": "No launch available."})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80)
