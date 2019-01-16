#!/bin/bash

echo "TESTING SH FROM THIS ENVIRONMENT"
 
echo "About install AWS agent:"

#sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm

#sudo status amazon-ssm-agent

sudo yum -y install wget

sudo wget https://inspector-agent.amazonaws.com/linux/latest/install

sudo curl -O https://inspector-agent.amazonaws.com/linux/latest/install

sudo bash install

sudo /etc/init.d/awsagent start

echo $?
 
 
#if [ $? -ne 0 ]; then
#echo “CRITICAL: Failed to scp ${LOCAL_FILE1} to dest ${DEST_CONN1}.”
#exit 1
#fi