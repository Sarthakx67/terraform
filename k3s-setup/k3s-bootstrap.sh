#!/bin/bash
set -e

echo "===== Starting k3s bootstrap on Amazon Linux 2023 ====="

# 1️⃣ System update
dnf update -y

# 2️⃣ Install required packages
dnf install -y wget git vim iptables

# 3️⃣ Ensure SELinux is permissive
setenforce 0 || true
sed -i 's/^SELINUX=.*/SELINUX=permissive/' /etc/selinux/config || true


# # 2. Docker Setup
# dnf install -y docker &>>$LOGFILE
# VALIDATE $? "Docker Installed"
# systemctl start docker &>>$LOGFILE
# VALIDATE $? "Docker Started"
# systemctl enable docker &>>$LOGFILE
# VALIDATE $? "Docker Enabled"
# usermod -aG docker "$REAL_USER" &>>$LOGFILE
# VALIDATE $? "Added $REAL_USER to docker group"
# # installing docker compose
# sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
# sudo chmod +x /usr/local/bin/docker-compose


# also for docker compose
# mkdir -p ~/.docker/cli-plugins

# BUILDX_VERSION=v0.17.0
# curl -SL https://github.com/docker/buildx/releases/download/${BUILDX_VERSION}/buildx-${BUILDX_VERSION}.linux-amd64 \
#   -o ~/.docker/cli-plugins/docker-buildx

# chmod +x ~/.docker/cli-plugins/docker-buildx

# docker buildx version   # verify it's >= 0.17.0
# till here


# 5️⃣ Kernel modules for Kubernetes
cat <<EOF >/etc/modules-load.d/k3s.conf
br_netfilter
overlay
EOF

modprobe br_netfilter
modprobe overlay

# 5️⃣ Kernel networking params
cat <<EOF >/etc/sysctl.d/k3s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

sysctl --system

# 6️⃣ Install k3s
curl -sfL https://get.k3s.io | sh -

# 7️⃣ Wait for k3s to be ready
sleep 30

# 8️⃣ FIX: Set KUBECONFIG for root RIGHT NOW in this running script
# This is the critical line — without this, all kubectl/helm commands
# below run as root with no kubeconfig and fail
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

# Also persist it for future root sessions
echo 'export KUBECONFIG=/etc/rancher/k3s/k3s.yaml' >> /root/.bashrc

# 9️⃣ Configure kubectl for ec2-user
USER_HOME="/home/ec2-user"

mkdir -p $USER_HOME/.kube
cp /etc/rancher/k3s/k3s.yaml $USER_HOME/.kube/config
chown -R ec2-user:ec2-user $USER_HOME/.kube
chmod 600 $USER_HOME/.kube/config

# 🔟 kubectl config & aliases for ec2-user
cat <<EOF >> $USER_HOME/.bashrc
export KUBECONFIG=\$HOME/.kube/config
alias k=kubectl
source <(kubectl completion bash)
complete -F __start_kubectl k
EOF

# Verify kubectl works (will fail fast here if KUBECONFIG is still wrong)
echo "===== Verifying kubectl access ====="
kubectl get nodes

# 1️⃣1️⃣ Install metrics server
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

# 1️⃣2️⃣ Install Helm
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
rm get_helm.sh  # cleanup

# Verify helm works against correct cluster
echo "===== Verifying helm access ====="
helm version
helm list  # should return empty, not an error

# 1️⃣3️⃣ Clone repo (only once — you had this twice in original)
cd /
git clone https://github.com/Sarthakx67/retail-store-aws-deployment.git

echo "===== k3s Kubernetes setup completed successfully ====="
echo "===== KUBECONFIG is set to: $KUBECONFIG ====="