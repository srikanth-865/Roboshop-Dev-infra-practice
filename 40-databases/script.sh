#!/bin/bash
component=$1
environment=$2
dnf install ansible -y
mkdir -p /var/log/roboshop1
chown ec2-user:ec2-user /var/log/roboshop1
chmod -R 755  /var/log/roboshop1
touch /var/log/roboshop1/ansible.log

cd /home/ec2-user
git clone https://github.com/srikanth-865/roboshop-ansible-v3.git
cd roboshop-ansible-v3
git pul
ansible-playbook -e component=$component -e env=$environment roboshop.yaml
