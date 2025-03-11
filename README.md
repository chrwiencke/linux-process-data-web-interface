Systemd Config
```
[Unit]
Description=Web Usage Information Software
After=network.target

[Service]
ExecStart=/bin/bash /usr/local/bin/processdata.sh
Restart=always
User=root
WorkingDirectory=/usr/local/bin
StandardOutput=append:/var/log/processdata.log
StandardError=append:/var/log/processdata.log

[Install]
WantedBy=multi-user.target
```

### Putt script.sh inni user local bin processdata
sudo nano /usr/local/bin/processdata.sh 

sudo chmod +x /usr/local/bin/processdata.sh

sudo systemctl daemon-reload
sudo systemctl enable web-process.service
sudo systemctl start web-process.service