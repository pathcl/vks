FROM weaveworks/ignite-ubuntu:18.04
RUN useradd -rm -d /home/ubuntu -s /bin/bash -g root -G sudo -u 1001 ubuntu && \
addgroup ubuntu && \
apt update && \ 
apt install -y software-properties-common policyrcd-script-zg2 && \
add-apt-repository ppa:longsleep/golang-backports && \
apt update && \
apt install golang-go git apt-utils -y && \
mkdir -p /home/ubuntu/go/src/github.com/pathcl/vks && \ 
mkdir -p /home/ubuntu/tmp
RUN echo "ubuntu ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/ubuntu && \
chmod 0440 /etc/sudoers.d/ubuntu
WORKDIR /home/ubuntu/go/src/github.com/pathcl
RUN git clone https://github.com/pathcl/vks
# k3s
RUN mkdir -p /home/ubuntu/tmp/ 
ADD https://github.com/rancher/k3s/releases/download/v1.19.4%2Bk3s1/k3s /home/ubuntu/tmp/
RUN chown ubuntu:ubuntu /home/ubuntu -R && \ 
chmod a+x /home/ubuntu/tmp/k3s
