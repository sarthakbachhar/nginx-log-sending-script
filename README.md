Installation Instructions

1. Clone the repository to your local machine.
https://github.com/sarthakbachhar/nginx-log-sending-script.git

2. Change directory into the cloned repository.

3. Change the script file permissions to make it executable.
chmod +x install.sh

4. Run the script with root privileges.
./install.sh

5. Verify cron
crontab -l

6. Check /opt/nginx/server_logs (for logs every hour)
