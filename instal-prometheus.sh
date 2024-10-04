#!/bin/bash
wget https://github.com/prometheus/prometheus/releases/download/v2.37.6/prometheus-2.37.6.linux-amd64.tar.gz
tar xvfz prometheus-*.tar.gz
rm prometheus-*.tar.gz
sudo mv prometheus promtool /usr/local/bin/
cd prometheus-2.37.6.linux-amd64
sudo mv prometheus promtool /usr/local/bin/
sudo mv prometheus.yml /etc/prometheus/prometheus.yml
sudo mv consoles/ console_libraries/ /etc/prometheus/
prometheus --version

#config prometheus
sudo useradd -rs /bin/false prometheus
sudo chown -R prometheus: /etc/prometheus /var/lib/prometheus
#Tạo file service 
cat <<EOF | sudo tee /etc/systemd/system/prometheus.service
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
Restart=on-failure
RestartSec=5s
ExecStart=/usr/local/bin/prometheus \\
    --config.file /etc/prometheus/prometheus.yml \\
    --storage.tsdb.path /var/lib/prometheus/ \\
    --web.console.templates=/etc/prometheus/consoles \\
    --web.console.libraries=/etc/prometheus/console_libraries \\
    --web.listen-address=0.0.0.0:9090 \\
    --web.enable-lifecycle \\
    --log.level=info

[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable prometheus
sudo systemctl start prometheus
sudo systemctl status prometheus