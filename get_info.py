import subprocess
import sys

# Get IP address
ip_result = subprocess.run(["ip", "addr", "show", "eth0"], capture_output=True, text=True)
ip_address = ip_result.stdout.split("inet ")[1].split("/")[0].strip()

# Print IP address, username, and password to stdout
print(f"IP: {ip_address}")
print("Username: root")
print("Password: root")

# Flush stdout to ensure immediate output
sys.stdout.flush()
