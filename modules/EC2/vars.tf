variable "vpc_id" {
  default = "vpc-0a161f64fd9c46cf2"
  description = "Id da VPC"
}

variable "subnet_id" {
  default = "subnet-030b785da2ffa155b"
  description = "Subnet a ser utilizada"
}

variable "ebs_size" {
  type = number
  default = 0
  description = "Subnet a ser utilizada"
}

variable "create_ebs" {
  type = bool
  default = false
  description = "Criar EBS"
}