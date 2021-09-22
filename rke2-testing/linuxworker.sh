curl -sfL https://get.rke2.io | INSTALL_RKE2_TYPE="agent" INSTALL_RKE2_CHANNEL="testing" sh -
systemctl enable rke2-agent.service
mkdir -p /etc/rancher/rke2/
touch /etc/rancher/rke2/config.yaml
echo "server: https://$(cat /var/sync/server):9345" >> /etc/rancher/rke2/config.yaml
echo "token: $(cat /var/sync/token)" >> /etc/rancher/rke2/config.yaml
systemctl start rke2-agent.service