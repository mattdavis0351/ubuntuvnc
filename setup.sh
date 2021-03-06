#!/bin/bash

myuser="username"
vncpass="mysecret"
userpass="accountsecret"

adduser $myuser --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password
echo "$myuser:$userpass" | sudo chpasswd
usermod -aG sudo $myuser

sudo cp vncserver@.service /etc/systemd/system/
sudo cp xstartup /home/$myuser
sudo -i -u $myuser -H sh -c "cd /home/$myuser"

sudo apt-get update -y
sudo apt install xfce4 xfce4-goodies tightvncserver -y


mkdir /home/$myuser/.vnc
echo $vncpass | vncpasswd -f > /home/$myuser/.vnc/passwd
chown -R $myuser:$myuser /home/$myuser/.vnc
chmod 0600 /home/$myuser/.vnc/passwd
chmod +x /home/$myuser/.vnc/xstartup


sudo systemctl daemon-reload
sudo systemctl enable vncserver@1.service
sudo systemctl start vncserver@1

cp /home/$myuser/xstartup /home/$myuser/.vnc
sudo systemctl restart vncserver@1


curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat << EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF

sudo apt-get update -y
sudo apt-get install -y docker-ce=18.06.1~ce~3-0~ubuntu kubelet=1.12.2-00 kubeadm=1.12.2-00 kubectl=1.12.2-00
sudo apt-mark hold docker-ce kubelet kubeadm kubectl

echo "net.bridge.bridge-nf-call-iptables=1" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p

sudo usermod -aG docker $myuser
