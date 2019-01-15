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

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
cat << EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF

sudo apt-get update
sudo apt-get install -y docker-ce=18.06.1~ce~3-0~ubuntu kubelet=1.12.2-00 kubeadm=1.12.2-00 kubectl=1.12.2-00
sudo apt-mark hold docker-ce kubelet kubeadm kubectl

echo "net.bridge.bridge-nf-call-iptables=1" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p

