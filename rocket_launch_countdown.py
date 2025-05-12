
import os
from flask import Flask, render_template, redirect, request
from dotenv import load_dotenv

# Load .env file if it exists
load_dotenv()
app = Flask(__name__)

@app.route('/')
def index():
    return render_template('config.html')

@app.route('/config', methods=['GET', 'POST'])
def config():
    if request.method == 'POST':
        display_text = request.form.get("display_text", "")
        timezone = request.form.get("timezone", "UTC")
        with open("config.txt", "w") as config_file:
            config_file.write(f"DISPLAY_TEXT={display_text}\nTIMEZONE={timezone}")
        return redirect('/')
    
    return render_template('config.html')

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
