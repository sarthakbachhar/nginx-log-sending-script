#!/bin/bash
set -e

# To update system
echo "Updating system"
sudo apt-get update -y
sudo apt-get upgrade -y

# To Create destination folder
sudo mkdir -p /opt/server_logs/prod1
sudo chmod 777 /opt/server_logs/prod1

# To place logSender.js
echo "Creating logSender.js..."
cat << 'EOF' | sudo tee /opt/server_logs/logSender.js > /dev/null
#!/usr/bin/env node
const fs = require('fs');
const path = require('path');
const logFiles = [
  '/var/log/nginx/access.log.1',
  '/var/log/nginx/error.log.1'
];
const destDir = '/opt/server_logs/prod1';
if (!fs.existsSync(destDir)) { fs.mkdirSync(destDir, { recursive: true }); }
const dt = new Date();
const timestamp = dt.toISOString().replace(/:/g, '-');
logFiles.forEach(file => {
  if (fs.existsSync(file)) {
    const base = path.basename(file).split('.')[0];
    const destFile = path.join(destDir, `${base}.${timestamp}`);
    fs.copyFileSync(file, destFile);
    console.log(`Copied ${file} -> ${destFile}`);
  }
});
EOF

# To make script executable
sudo chmod +x /opt/server_logs/logSender.js

# To create sudo cronjob for root
echo "Setting up cronjob..."
sudo bash -c 'echo "0 * * * * /opt/server_logs/logSender.js >> /opt/server_logs/prod1/cron.log 2>&1" > /etc/cron.d/logSender'
sudo chmod 644 /etc/cron.d/logSender

echo "Installation complete!"
echo "Cronjob set to run every hour and send logs to /opt/server_logs/prod1"
echo "To run manually: sudo /opt/server_logs/logSender.js"
