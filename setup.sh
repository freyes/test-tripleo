#!/bin/bash -ex

# variables
export CONFIG=$(pwd)/myscenario.yml
export LIBGUESTFS_BACKEND_SETTINGS=network_bridge=virbr0
export VIRTHOST=127.0.0.2
export RELEASE=centosci/wallaby-current-tripleo
export NODE_CONFIG=config/nodes/1ctlr_1comp.yml

# allow local overrides.
test -f ./vars.sh && source ./vars.sh

sudo yum install -y vim tmux git
sudo dnf module install -y virt

# configure libvirt
sudo usermod -a -G libvirt cloud-user
sudo systemctl enable libvirtd.service
sudo systemctl restart libvirtd.service
sudo virsh net-autostart default

# allow ansible to ssh as root user without password.
ssh-keygen -t rsa -q -f "$HOME/.ssh/id_rsa" -N ""
cat ~/.ssh/id_rsa.pub | sudo tee /root/.ssh/authorized_keys


git clone https://github.com/openstack/tripleo-quickstart
cd tripleo-quickstart

bash quickstart.sh -R $RELEASE --clean --teardown all \
     --no-clone --tags all --nodes $NODE_CONFIG --config $CONFIG \
     -p quickstart.yml \
     $VIRTHOST

bash quickstart.sh -R $RELEASE \
     --no-clone --tags all --nodes $NODE_CONFIG --config $CONFIG \
     -I --teardown none \
     -p quickstart-extras-undercloud.yml \
     $VIRTHOST

bash quickstart.sh -R $RELEASE --no-clone --tags all --nodes $NODE_CONFIG --config $CONFIG -I --teardown none \
     -p quickstart-extras-overcloud-prep.yml $VIRTHOST

bash quickstart.sh -R $RELEASE --no-clone --tags all --nodes $NODE_CONFIG --config $CONFIG -I --teardown none \
     -p quickstart-extras-overcloud.yml $VIRTHOST

# # ssh undercloud
# ssh -F ~/.quickstart/ssh.config.ansible undercloud

# # set a node apart for ironic.
# jq '.nodes[0:1] | {nodes: .}' instackenv.json > undercloud.json
# jq '.nodes[1:3] | {nodes: map({driver: .pm_type, name: .name, driver_info: {ssh_username: .pm_user, ssh_address: .pm_addr, ssh_key_contents: .pm_password, ssh_virt_type: "virsh"}, properties: {cpus: .cpu, cpu_arch: .arch, local_gb: .disk, memory_mb: .memory}, ports: .mac | map({address: .})})}' instackenv.json > overcloud-nodes.yaml



# validate tripleO is functional
bash quickstart.sh -R $RELEASE --no-clone --tags all --nodes $NODE_CONFIG --config $CONFIG -I --teardown none -p quickstart-extras-validate.yml $VIRTHOST
