# Nginx Log Sender – Automated Installer

This project provides a Bash installer script (`install.sh`) that sets up an automated system to collect Nginx log files and copy them to a central directory (`/opt/server_logs/prod1`) with timestamped filenames.

---

## Installation

### 1. Clone the Repository
```bash
git clone https://github.com/sarthakbachhar/nginx-log-sending-script.git
2. Make the Script Executable
bash
Copy
Edit
chmod +x install.sh
3. Run the Installer
bash
Copy
Edit
sudo ./install.sh
 Note: sudo is required because the script updates the system, creates directories in /opt/, and sets up a root cronjob.

 What the Script Does
System Update

Runs apt-get update and apt-get upgrade.

Creates Destination Directory

/opt/server_logs/prod1 is created if it does not exist.

Directory is made writable by all (chmod 777).

Deploys logSender.js

A Node.js script is created at:

bash
Copy
Edit
/opt/server_logs/logSender.js
This script copies:

/var/log/nginx/access.log.1

/var/log/nginx/error.log.1

Destination filenames include a timestamp:

go
Copy
Edit
access.2025-08-22T12-00-00.000Z
error.2025-08-22T12-00-00.000Z
Sets Up Cronjob

A root-level cronjob is created at /etc/cron.d/logSender:

bash
Copy
Edit
0 * * * * /opt/server_logs/logSender.js >> /opt/server_logs/prod1/cron.log 2>&1
Runs every hour to copy logs automatically.

Logs cron activity into /opt/server_logs/prod1/cron.log.

Manual Run

You can trigger it anytime with:

bash
Copy
Edit
sudo /opt/server_logs/logSender.js
 Directory Structure
After installation, you’ll have:

lua
Copy
Edit
/opt/server_logs/
 └── prod1/
      ├── access.2025-08-22T12-00-00.000Z
      ├── error.2025-08-22T12-00-00.000Z
      ├── cron.log
      └── ...
 Verification
Check copied logs

bash
Copy
Edit
ls -l /opt/server_logs/prod1
Check cron logs

bash
Copy
Edit
cat /opt/server_logs/prod1/cron.log
Run manually

bash
Copy
Edit
sudo /opt/server_logs/logSender.js
Notes
The script assumes Nginx logs are located in:

/var/log/nginx/access.log.1

/var/log/nginx/error.log.1

Make sure Node.js is installed system-wide (available as /usr/bin/node).

The copied log files use UTC timestamps (toISOString()).
