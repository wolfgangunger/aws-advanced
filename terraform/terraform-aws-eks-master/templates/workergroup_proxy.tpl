# MRT: Add proxy configuration to node
touch /etc/environment
echo "http_proxy=${http_proxy}" >> /etc/environment
echo "https_proxy=${http_proxy}" >> /etc/environment
echo "HTTP_PROXY=${http_proxy}" >> /etc/environment
echo "HTTPS_PROXY=${http_proxy}" >> /etc/environment
echo 'NO_PROXY="${no_proxy}"' >> /etc/environment
export http_proxy=${http_proxy}
export https_proxy=${http_proxy}
export HTTP_PROXY=${http_proxy}
export HTTPS_PROXY=${http_proxy}
export NO_PROXY="${no_proxy}"

# MRT: Configure EKS bootstrap.sh with proxy
mkdir -p /tmp/eks
echo "[Service]" | tee /tmp/eks/http-proxy.conf /tmp/eks/https-proxy.conf /tmp/eks/no-proxy.conf
echo 'Environment="HTTP_PROXY=${http_proxy}"' >> /tmp/eks/http-proxy.conf
echo 'Environment="HTTPS_PROXY=${http_proxy}"' >> /tmp/eks/https-proxy.conf
echo 'Environment="NO_PROXY=${no_proxy}"' >> /tmp/eks/no-proxy.conf
mkdir -p /etc/systemd/system/docker.service.d
mkdir -p /etc/systemd/system/kubelet.service.d
cp /tmp/eks/* /etc/systemd/system/kubelet.service.d
cp /tmp/eks/* /etc/systemd/system/docker.service.d
mv /etc/eks/bootstrap.sh /etc/eks/tmp_bootstrap.sh
echo '#!/usr/bin/env bash' > /etc/eks/bootstrap.sh
echo " " >> /etc/eks/bootstrap.sh
echo 'export HTTP_PROXY="${http_proxy}"' >> /etc/eks/bootstrap.sh
echo 'export HTTPS_PROXY="${http_proxy}"' >> /etc/eks/bootstrap.sh
echo 'export NO_PROXY="${no_proxy}"' >> /etc/eks/bootstrap.sh
tail -n +2 /etc/eks/tmp_bootstrap.sh >> /etc/eks/bootstrap.sh
rm /etc/eks/tmp_bootstrap.sh
chmod 744 /etc/eks/bootstrap.sh
systemctl daemon-reload
systemctl restart docker
