#!/bin/bash
#传递的变量
the_user=$1

echo "~~> 安装相关工具"
apt-get update
apt-get install -y curl vim zsh git

# echo "~~> 使能ntp,并时间同步"
apt-get install -y ntpdate
cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
timedatectl set-timezone Asia/Shanghai
/usr/sbin/ntpdate ntp1.aliyun.com
timedatectl set-ntp on

echo '~~> 设置nameserver'
cat >/etc/resolv.conf <<EOF
nameserver 8.8.8.8
nameserver 223.5.5.5
EOF
cat /etc/resolv.conf

echo "~~> 安装docker"
sudo apt-get install -y \
  ca-certificates \
  curl \
  gnupg \
  lsb-release
mkdir -m 0755 -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
apt-get update
apt-get install -y docker-ce \
  docker-ce-cli \
  containerd.io \
  docker-buildx-plugin \
  docker-compose-plugin
mkdir -p /etc/docker
# docker的cgroup驱动程序默认设置为system,默认情况下Kubernetes cgroup为systemd
cat >/etc/docker/daemon.json <<-EOF
{
  "registry-mirrors": [
      "https://8s2vzrff.mirror.aliyuncs.com",
      "https://docker.mirrors.ustc.edu.cn",
      "https://registry.docker-cn.com"
  ],
  "exec-opts": ["native.cgroupdriver=systemd"]
}
EOF

echo "~~>> 将用户加入docker组"
groupadd -f docker
gpasswd -a ${the_user} docker # usermod -aG docker vagrant # ${USER}
newgrp docker

echo "~~>> 启动docker服务"
systemctl enable docker
systemctl start docker
docker version
