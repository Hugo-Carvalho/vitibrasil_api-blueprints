data "aws_ami" "ubuntu" {
 most_recent = true


 filter {
   name   = "owner-alias"
   values = ["amazon"]
 }


 filter {
   name   = "name"
   values = ["amzn2-ami-hvm*"]
 }

}
data "template_file" "init" {
  template = "${file("deploy.sh")}"
}

resource "aws_iam_role" "role_ec2_to_s3" {
  name = "role_ec2_to_s3"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "profile_ec2_to_s3" {
  name = "profile_ec2_to_s3"
  role = "${aws_iam_role.role_ec2_to_s3.name}"
}

resource "aws_iam_role_policy" "policy_ec2_to_s3" {
  name = "policy_ec2_to_s3"
  role = "${aws_iam_role.role_ec2_to_s3.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_instance" "vitibrasil_instance" {
  ami = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name = "vitibrasil_api"
  subnet_id = var.subnet_id
  vpc_security_group_ids = [aws_security_group.permitir_ssh_http.id]
  associate_public_ip_address = true
  iam_instance_profile = "${aws_iam_instance_profile.profile_ec2_to_s3.name}"

  root_block_device {
    delete_on_termination = true
    volume_size           = var.ec2_size
    volume_type           = "gp3"
  }

  # TODO Criar script para deploy
  user_data = "${data.template_file.init.rendered}"
  tags = {
    Name = "vitibrasil_api"
  }
}

resource "aws_ebs_volume" "vitibrasil_ebs" {
  count = var.create_ebs ? 1 : 0
  availability_zone = aws_instance.vitibrasil_instance.availability_zone
  size = var.ebs_size
  type = "gp3"

  depends_on = [aws_instance.vitibrasil_instance]

  tags = {
    Name = "vitibrasil_api"
  }
}

resource "aws_volume_attachment" "ebs_att" {
  count = var.create_ebs ? 1 : 0
  device_name = "/dev/sdh"
  depends_on = [aws_instance.vitibrasil_instance]
  volume_id   = aws_ebs_volume.vitibrasil_ebs[0].id
  instance_id = aws_instance.vitibrasil_instance.id
}

resource "aws_security_group" "permitir_ssh_http" {
  name        = "permitir_ssh"
  description = "Permite SSH e HTTP na instancia EC2"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH to EC2"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP to EC2"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Flask to EC2"
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "permitir_ssh_e_http"
  }
}