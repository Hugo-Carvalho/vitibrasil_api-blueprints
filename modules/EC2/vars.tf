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
  description = "Volume do EBS adicional"
}

variable "ec2_size" {
  type = number
  description = "Volume interno do EBS tamanho"
}
variable "create_ebs" {
  type = bool
  default = false
  description = "Criar EBS"
}