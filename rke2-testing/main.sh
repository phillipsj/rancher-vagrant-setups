#! /bin/bash
set -e

curl -sfL https://get.rke2.io | INSTALL_RKE2_CHANNEL="testing" sh -

echo "[INFO] Setting up environment variables...."
touch /etc/profile.d/rancher.sh
echo "export KUBECONFIG=/etc/rancher/rke2/rke2.yaml" >> /etc/profile.d/rancher.sh
export KUBECONFIG=/etc/rancher/rke2/rke2.yaml
echo "export PATH=$PATH:/var/lib/rancher/rke2/bin" >> /etc/profile.d/rancher.sh
export PATH=$PATH:/var/lib/rancher/rke2/bin
echo "RKE2_CNI=calico" >> /usr/local/lib/systemd/system/rke2-server.env

echo "[INFO] Starting RKE2 service...."
systemctl enable rke2-server.service
systemctl start rke2-server.service

echo "[INFO] Waiting for RKE2 to be ready...."
while [ ! -f /var/lib/rancher/rke2/server/node-token ]; do sleep 2; done;
until journalctl -u rke2-server | grep -q "rke2 is up and running"; do sleep 10; echo "Waiting...."; done;
crictl config --set runtime-endpoint=unix:///run/k3s/containerd/containerd.sock
chmod a=r /etc/rancher/rke2/rke2.yaml

echo "[INFO] Waiting for Calico to be ready...."
curl -o /usr/local/bin/calicoctl -sOL https://github.com/projectcalico/calicoctl/releases/download/v3.19.0/calicoctl
chmod +x /usr/local/bin/calicoctl
until calicoctl get felixConfiguration default | grep -q "default" > /dev/null 2>&1; do sleep 2; echo "Waiting...."; done;
calicoctl ipam configure --strictaffinity=true

echo "[INFO] RKE2 installation is complete...."
# Vagrant Specific Settings
rm -f /var/sync/token
rm -f /var/sync/server
cat /var/lib/rancher/rke2/server/node-token > /var/sync/token
hostname -I | xargs > /var/sync/server    
cat /etc/rancher/rke2/rke2.yaml > /var/sync/config