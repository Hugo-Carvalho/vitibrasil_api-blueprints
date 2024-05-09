provider "aws" {
    region = "us-east-1"
}
module "up_ec2" {
  source    = "./modules/EC2"
  vpc_id    = "vpc-0a161f64fd9c46cf2"
  subnet_id = "subnet-030b785da2ffa155b"
}