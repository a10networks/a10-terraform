#! /bin/bash

sudo iptables -I INPUT -p tcp --dport 80 -j ACCEPT
sudo service httpd restart

