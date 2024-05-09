#!/bin/bash
sudo yum update -y  
aws s3 sync s3://vitibrasil-integrations/project/ /home/ec2-user/
unzip /home/ec2-user/vitibrasil_api.zip -d /home/ec2-user/