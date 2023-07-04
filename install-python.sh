#!/bin/bash

##Ansible requires that remote hosts have python installed in them

yum update -y
# yum install wget unzip httpd -y
# systemctl start httpd
# systemctl enable httpd
# cd /tmp/
# wget https://www.tooplate.com/zip-templates/2130_waso_strategy.zip
# unzip -o 2130_waso_strategy.zip
# cp -r 2130_waso_strategy/* /var/www/html/
# systemctl restart httpd
yum install -y python3
