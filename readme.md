USE CASE 1
METHOD 1

PIPELINE 1: - For creating terraform code with was using delegate connected vm as infra
Delegate name : - docker-delegate-instance-1-ganesh
pipeline name: IACM-MIG-ANSIBLE-pipeline1-ganesh



Here I just create the mig template and two system form that mig
Here ssh key was initially created in vm which have delegate and these steps are run in that vm only
Run 1 and Run 2
ls -al 
cp /root/.ssh/id_rsa.pub $PWD/
pwd 
ls -al
 
this code we are just checking that ssh key is present or not

PIPELINE 2:  we just build the docker image and push to dovker hub
Delegate name : - docker-delegate-instance-1-ganesh
pipeline name: CD-MIG-ANSIBLE-pipeline2-ganesh



Image name: ganesh6498/harness-mig-java:latest

Stage 2 : with ansible install all the tools in  that migs vms 

STEP 1: to external ip’s
gcloud compute instances list   --filter="name~'^okay-.*'"   --format="value(networkInterfaces.accessConfigs.natIP)" | tr -d "[]'"  > /etc/ansible/hosts
cat /etc/ansible/hosts

here okay is the base_name  or prefix name of vms created by mig
we get all the ip’s of that vms and store in /etc/ansible/hosts

step 2 : not working

step 3:

#!/bin/bash

# Fail on error
set -e

# === [1] Variables ===
# Replace with your actual playbook and VM user if different
ANSIBLE_DIR="/etc/ansible"
INVENTORY_FILE="$ANSIBLE_DIR/hosts"
ANSIBLE_CFG="$ANSIBLE_DIR/ansible.cfg"
PRIVATE_KEY_PATH="/root/.ssh/id_rsa"
VM_USER="ansible"


# === [4] Write Ansible config ===
cat <<EOF > "$ANSIBLE_CFG"
[defaults]
inventory = $INVENTORY_FILE
host_key_checking = False
retry_files_enabled = False
remote_user = $VM_USER
private_key_file = $PRIVATE_KEY_PATH
EOF

# === [5] Optional: Set environment to use this config ===
export ANSIBLE_CONFIG="$ANSIBLE_CFG"

# === [6] Run Ansible ping to test connection ===
ansible all -m ping
git clone https://github.com/ganesh-redy/mgi-instance-ansible-harness.git
cd  mgi-instance-ansible-harness
# === [7] Run your playbook ===
ansible-playbook ansible.yaml


here we can using the delegate installed system as local system know install

initially  we do ssh-keygen 
all the ansible path , private key path, remote_username, host_key_checking = false (important)  there details re placed in ansible.cfg
the we export as ANSIBLE_CONFIG

the we perform the ping to check the connection
next we run the play book and tools and delegate was installed in migs created system 
delegate installed in mig system was  docker-delegate-instances-ganesh
pipeline 3 : 
delagete name docker-delegate-instances-ganesh


just we do docker run command to install the imag

here it has disadvantage is  that 2 system have delegate with same name it will run in only one system 

