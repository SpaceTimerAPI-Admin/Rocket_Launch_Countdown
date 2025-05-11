
## 🚀 Rocket Launch Countdown with Bluetooth Setup

### 🔧 Prerequisites:
- Make sure your Raspberry Pi is fully updated:
  ```bash
  sudo apt-get update && sudo apt-get upgrade -y
  ```

### 🚀 Bluetooth Setup
- Automatically sets up a Bluetooth device named **"Space Time Setup"**.
- Connect to this device via phone or laptop to access the configuration page.

### ✅ Running the Countdown Program
- Run the program manually:
  ```bash
  source led-matrix-env/bin/activate
  sudo python3 rocket_launch_countdown.py
  ```

### ✅ Re-run Bluetooth Setup (If Needed)
```bash
sudo bash setup_bluetooth.sh
```
