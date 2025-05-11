
import time
import random
from rgbmatrix import RGBMatrix, RGBMatrixOptions, graphics
from PIL import Image
import os
import json

# Configuration for the LED Matrix
options = RGBMatrixOptions()
options.rows = 32
options.cols = 64
options.chain_length = 1
options.parallel = 1
options.hardware_mapping = 'adafruit-hat'

matrix = RGBMatrix(options=options)

# Function to Show Loading Screen
def show_loading_screen(matrix):
    background = Image.new('RGB', (64, 32), (0, 0, 50))  # Dark Blue Background
    draw = graphics.DrawText
    font = graphics.Font()
    font.LoadFont("/home/pi/Rocket_Launch_Countdown/fonts/7x13.bdf")

    # Draw stars randomly on the background
    for _ in range(30):
        x = random.randint(0, 63)
        y = random.randint(0, 31)
        background.putpixel((x, y), (200, 200, 255))  # Light Blue Stars

    matrix.SetImage(background)

    # Display "Loading..." text
    text_color = graphics.Color(255, 255, 255)  # White text
    draw(matrix, 10, 20, font, text_color, "Loading...")
    time.sleep(3)  # Display for 3 seconds

# Function to Check If Setup is Complete
def is_setup_complete():
    config_path = "/home/pi/Rocket_Launch_Countdown/config/config.json"
    if not os.path.exists(config_path):
        return False

    with open(config_path, 'r') as config_file:
        config = json.load(config_file)
        return all([config.get("timezone"), config.get("wifi_ssid"), config.get("wifi_password"), config.get("selected_pads")])

# Main Function
def main():
    if not is_setup_complete():
        show_loading_screen(matrix)

    # Continue with normal countdown setup (placeholder)
    print("🚀 Countdown Setup Completed. Running countdown...")

main()
