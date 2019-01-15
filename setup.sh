#!/bin/bash

myuser="username"
mypasswd="mysecret"

apt-get update
apt install xfce4 xfce4-goodies tightvncserver


mkdir /home/$myuser/.vnc
echo $mypasswd | vncpasswd -f > /home/$myuser/.vnc/passwd
cp xstartup ~/.vnc/
chown -R $myuser:$myuser /home/$myuser/.vnc
chmod 0600 /home/$myuser/.vnc/passwd
chmod +x ~/.vnc/xstartup

cp vncserver@.service /etc/systemd/system/

systemctl daemon-reload
systemctl enable vncserver@1.service
systemctl start vncserver@1
systemctl status vncserver@1
