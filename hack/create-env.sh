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
    sudo ignite inspect vm vks0$i |jq '.' | jq -r '.status.network.ipAddresses[]' >> hosts.ini;
done


# Master tls/crt replication 

ansible -i hosts.ini -m shell -a 'curl -Lo /usr/bin/vks http://luis.sanmartin.io/vks; chmod a+x /usr/bin/vks' all
