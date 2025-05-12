
import threading
import time
import requests
from flask import Flask, render_template, request, redirect, jsonify
import json
from rgbmatrix import RGBMatrix, RGBMatrixOptions, graphics

app = Flask(__name__)

CONFIG_FILE = "config/config.json"
DISPLAY_TEXT = "Upcoming Rocket Launches"

def load_config():
    try:
        with open(CONFIG_FILE, "r") as f:
            return json.load(f)
    except FileNotFoundError:
        return {"launch_sites": [], "wifi_ssid": "", "wifi_password": ""}

def save_config(data):
    with open(CONFIG_FILE, "w") as f:
        json.dump(data, f, indent=4)

def get_next_launch():
    config = load_config()
    url = "https://ll.thespacedevs.com/2.3.0/launches/upcoming/"
    response = requests.get(url)
    launches = response.json().get("results", [])
    filtered_launches = [
        launch for launch in launches if any(site in launch["location"]["name"] for site in config["launch_sites"])
    ]
    if filtered_launches:
        return filtered_launches[0]
    return None

def display_countdown():
    options = RGBMatrixOptions()
    options.rows = 32
    options.chain_length = 1
    options.parallel = 1
    options.hardware_mapping = 'adafruit-hat'

    matrix = RGBMatrix(options=options)
    font = graphics.Font()
    font.LoadFont("rpi-rgb-led-matrix/fonts/6x10.bdf")
    textColor = graphics.Color(255, 255, 255)

    while True:
        next_launch = get_next_launch()
        if next_launch:
            launch_time = time.strptime(next_launch["window_start"], "%Y-%m-%dT%H:%M:%SZ")
            while True:
                remaining_time = time.mktime(launch_time) - time.time()
                if remaining_time <= 0:
                    break

                days = int(remaining_time // 86400)
                hours = int((remaining_time % 86400) // 3600)
                minutes = int((remaining_time % 3600) // 60)
                seconds = int(remaining_time % 60)

                countdown_text = f"{days:02}:{hours:02}:{minutes:02}:{seconds:02}"
                matrix.Clear()
                graphics.DrawText(matrix, font, 2, 10, textColor, countdown_text)
                time.sleep(1)

        time.sleep(10)

@app.route("/config", methods=["GET", "POST"])
def config():
    config = load_config()
    if request.method == "POST":
        config["launch_sites"] = request.form.getlist("launch_sites")
        config["wifi_ssid"] = request.form.get("wifi_ssid", "")
        config["wifi_password"] = request.form.get("wifi_password", "")
        save_config(config)
        return redirect("/config")
    return render_template("config.html", config=config)

if __name__ == "__main__":
    threading.Thread(target=display_countdown, daemon=True).start()
    app.run(host="0.0.0.0", port=5000)
