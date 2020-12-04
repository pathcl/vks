#!/bin/bash
## Idea is to create a ephemeral environment through ignite

rm hosts.ini

for i in $(seq 1 3); do 
    sudo ignite rm -f vks0$i 
done


cat <<EOF >./hosts.ini
[all:vars]
ansible_ssh_user = root
[all]
EOF

for i in $(seq 1 3); do 
    sudo ignite run pathcl/ubuntu:18.04.5 --name vks0$i --cpus 2  --ssh=/home/pathcl/.ssh/id_rsa.pub --memory 2GB --size 8G;
    sudo ignite inspect vm vks0$i |jq '.' | jq -r '[.metadata.name, .status.network.ipAddresses[]]| @csv'| sed 's/,/ ansible_host=/g;s/"//g' >> hosts.ini
done


# Master tls/crt replication 
ansible -i hosts.ini -m copy -a 'src=../vks dest=/usr/sbin/vks' all
ansible -i hosts.ini -m shell -a 'chmod a+x /usr/sbin/vks' all

# now we should start k3s somehow

ansible -i hosts.ini vks.yml

# copy certs for rest of nodex
# launch vks
