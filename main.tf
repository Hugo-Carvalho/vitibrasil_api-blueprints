provider "aws" {
  region = "us-east-1"
}

module "up_project_file" {
  source         = "./modules/S3"
  file_name      = "vitibrasil_api"
  project_bucket = "vitibrasil-integrations"
}
module "up_ec2" {
  source     = "./modules/EC2"
  ec2_size   = 10
  vpc_id     = "vpc-0a161f64fd9c46cf2"
  subnet_id  = "subnet-030b785da2ffa155b"
  depends_on = [module.up_project_file]
}