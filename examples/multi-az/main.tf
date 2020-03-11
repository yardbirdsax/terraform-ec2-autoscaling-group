provider aws {
  region = "us-east-2"
}

resource aws_vpc vpc {
  cidr_block = "10.250.0.0/22"
}

data aws_availability_zones azs {
  state = "available"
}

resource aws_subnet subnet {
  count = 3
  vpc_id = aws_vpc.vpc.id
  cidr_block = "10.250.${count.index}.0/24"
}

data http current_ip {
  url = "https://ipv4.icanhazip.com"
}

resource aws_security_group security_group {
  name = "public"
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port = 22
    to_port = 22
    cidr_blocks = [
      "${chomp(data.http.current_ip.body)}/32"
    ]
    protocol = "tcp"
  }

  egress {
    from_port = 0
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
    protocol = "-1"
  }
}

module "ssh_key_pair" {
  source                = "git::https://github.com/cloudposse/terraform-aws-key-pair.git?ref=master"
  namespace             = "eg"
  stage                 = "prod"
  name                  = "app"
  ssh_public_key_path   = "~/.ssh"
  generate_ssh_key      = "true"
  private_key_extension = ".pem"
  public_key_extension  = ".pub"
}

module ec2 {
  #source = "../../terraform"
  source = "git::https://github.com/yardbirdsax/terraform-ec2-autoscaling-group//terraform?ref=1.2"
  max_instance_count = 6
  min_instance_count = 4
  desired_instance_count = 4
  subnet_ids = aws_subnet.subnet.*.id
  security_group_ids = [aws_security_group.security_group.id]
  deployment_name = "my-ec2"
  keypair_content = module.ssh_key_pair.public_key
}