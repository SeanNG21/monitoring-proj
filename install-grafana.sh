#!/bin/bash
sudo apt-get install -y adduser libfontconfig1 musl
wget https://dl.grafana.com/enterprise/release/grafana-enterprise_11.2.2_amd64.deb
sudo dpkg -i grafana-enterprise_11.2.2_amd64.deb
sudo apt-get update
sudo systemctl start grafana-server
sudo systemctl enable grafana-server
sudo systemctl status grafana-server.service
# mở cổng 3000: sudo ufw allow 3000