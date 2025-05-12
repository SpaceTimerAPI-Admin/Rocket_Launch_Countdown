
from flask import Flask, render_template, request, redirect, url_for
import json
import os

app = Flask(__name__)

# Config file path
CONFIG_PATH = os.path.join(os.path.dirname(__file__), 'config', 'settings.json')

# Load config file
def load_config():
    if os.path.exists(CONFIG_PATH):
        with open(CONFIG_PATH, 'r') as config_file:
            return json.load(config_file)
    return {"display_text": "", "timezone": "", "launch_sites": [], "wifi_ssid": "", "wifi_password": ""}

# Save config file
def save_config(data):
    with open(CONFIG_PATH, 'w') as config_file:
        json.dump(data, config_file)

@app.route('/')
def index():
    config = load_config()
    return render_template('index.html', display_text=config.get("display_text", ""), 
                           next_launch="TBD")

@app.route('/config', methods=['GET', 'POST'])
def config():
    config = load_config()
    if request.method == 'POST':
        config['display_text'] = request.form.get('display_text', '')
        config['timezone'] = request.form.get('timezone', '')
        config['launch_sites'] = request.form.getlist('launch_sites')
        config['wifi_ssid'] = request.form.get('wifi_ssid', '')
        config['wifi_password'] = request.form.get('wifi_password', '')
        save_config(config)
        return redirect(url_for('index'))
    
    launch_sites = ['Cape Canaveral', 'Kennedy Space Center', 'Vandenberg', 'Wallops Island']
    return render_template('config.html', config=config, launch_sites=launch_sites)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
