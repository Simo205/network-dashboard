#!/bin/bash

# Define HTML file output
OUTPUT_FILE="index.html"

# Get Data
CPU_LOAD=$(uptime | awk -F'load average:' '{ print $2 }')
RAM_USAGE=$(free -h | awk '/Mem:/ {print $3 "/" $2}')
DISK_USAGE=$(df -h / | awk 'NR==2 {print $3 "/" $2 " (" $5 ")"}')
DATE_TIME=$(date)

# Start Writing HTML
cat <<EOF > $OUTPUT_FILE
<!DOCTYPE html>
<html>
<head>
    <title>Network & System Dashboard</title>
    <meta http-equiv="refresh" content="5">
    <style>
        body { font-family: Arial, sans-serif; background-color: #1e1e2e; color: #cdd6f4; padding: 20px; }
        h1 { color: #89b4fa; }
        .card { background: #313244; padding: 15px; margin-bottom: 15px; border-radius: 8px; }
        .online { color: #a6e3a1; font-weight: bold; }
    </style>
</head>
<body>
    <h1>System & Network Dashboard</h1>
    <p>Last Update: $DATE_TIME</p>
    
    <div class="card">
        <h2>System Status</h2>
        <p><strong>CPU Load:</strong> $CPU_LOAD</p>
        <p><strong>RAM Usage:</strong> $RAM_USAGE</p>
        <p><strong>Disk Usage:</strong> $DISK_USAGE</p>
    </div>

    <div class="card">
        <h2>Active Network Hosts</h2>
        <ul>
EOF

# Scan Network & append to HTML
TARGET="192.168.120" # Bdal had l-IP b-subnet dyalk ila kan khtalf

for ip in {1..20}; do  # Drna ghir 1..20 f-l-awwal bach ykoon l-scan sri3
    ping -c 1 -W 1 $TARGET.$ip > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "<li><span class='online'>[ONLINE]</span> $TARGET.$ip</li>" >> $OUTPUT_FILE
    fi
done

# Close HTML Tags
cat <<EOF >> $OUTPUT_FILE
        </ul>
    </div>
</body>
</html>
EOF

echo "[+] Report generated successfully in $OUTPUT_FILE"
