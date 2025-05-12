
from flask import Flask, render_template, request, jsonify
import json
import threading
import time

app = Flask(__name__)

# Load settings from config file
def load_settings():
    with open('config/config.json', 'r') as config_file:
        return json.load(config_file)

settings = load_settings()

@app.route('/config')
def config():
    return render_template('config.html')

@app.route('/save-settings', methods=['POST'])
def save_settings():
    data = request.json
    settings['locations'] = data.get('locations', [])
    settings['test_mode'] = data.get('test_mode', False)

    with open('config/config.json', 'w') as config_file:
        json.dump(settings, config_file)

    if settings['test_mode']:
        start_test_mode()
    else:
        start_live_mode()

    return jsonify({"status": "success"})

def start_test_mode():
    print("Running in Test Mode...")
    # Display simulated countdown here

def start_live_mode():
    print("Running in Live Mode...")
    # Fetch real-time launch data and display

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
