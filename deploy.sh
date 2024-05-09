#!/bin/bash
sudo yum update -y  
cd ~/
aws s3 sync s3://vitibrasil-integrations/project/ . 
unzip vitibrasil_api.zip