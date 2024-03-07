from flask import Flask
import subprocess

app = Flask(__name__)

@app.route('/')
def get_info():
    ip_result = subprocess.run(["ip", "addr", "show", "eth0"], capture_output=True, text=True)
    ip_address = ip_result.stdout.split("inet ")[1].split("/")[0].strip()
    return f"IP: {ip_address}<br>Username: root<br>Password: root"

if __name__ == '__main__':
    app.run()
