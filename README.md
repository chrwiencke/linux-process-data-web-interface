For å sette opp kjør disse komandoene

sudo apt install nginx -y

sudo rm -rf /var/www/html/


sudo nano /etc/systemd/system/lpdwi.service

Systemd Config
```
[Unit]
Description=Linux Process Data Web Interface
After=network.target

[Service]
ExecStart=/bin/bash /usr/local/bin/lpdwi.sh
Restart=always
User=root
WorkingDirectory=/usr/local/bin
StandardOutput=append:/var/log/lpdwi.log
StandardError=append:/var/log/lpdwi.log

[Install]
WantedBy=multi-user.target
```

### Putt script.sh inni user local bin processdata
sudo nano /usr/local/bin/lpdwi.sh 

sudo chmod +x /usr/local/bin/lpdwi.sh

sudo systemctl daemon-reload
sudo systemctl enable lpdwi.service
sudo systemctl start lpdwi.service