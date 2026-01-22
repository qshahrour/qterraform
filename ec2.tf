data "aws_ami" "latest-ubuntu" {
  most_recent = true
  owners = ["099720109477"]
  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_subnets" "this" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}

data "aws_key_pair" "new" {
  key_name = "new"
}

#######################################################
#                 Security Group (SG)
#######################################################
resource "aws_security_group" "mysql-dev" {
  name = "mysql-dev"
  description = "Allow some traffic"
  vpc_id = var.vpc_id
  ingress {
  description = "Allow specific to ssh"
   from_port = 22
   to_port = 22 
   protocol = "tcp"
   cidr_blocks = [
    "0.0.0.0/0",
    "${var.mysql_dev.ip_instance}/32",
   ]
  }
  ingress {
   description = "Allow specfic to 3306"
   from_port = 3306
   to_port = 3306
   protocol = "tcp"
   cidr_blocks = [
   "0.0.0.0/0",
   "${var.mysql_dev.ip_instance}/32",
]
  }
  egress {
   from_port = 0
   to_port = 0
   protocol = "-1"
   cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "MYSQL-DEV"
  }
}

data "cloudinit_config" "mysql-dev-0" {
  gzip          = true
  base64_encode = true
  part {
    filename     = "init.cfg"
    content_type = "text/cloud-config"
    content      = templatefile("templates/default_cloud-init.tpl",{
      region     = "eu-central-1"
      hostname   = "mysql-dev-0"
    })
  }
}

resource "aws_instance" "mysql-dev-0" {
  ami                         = data.aws_ami.latest-ubuntu.id
  instance_type               = var.mysql_dev.instance_type
  key_name                    = data.aws_key_pair.new.key_name
  user_data_base64            = data.cloudinit_config.mysql-dev-0.rendered
  availability_zone           = data.aws_availability_zones.avilable.names[0]
  ebs_optimized               = true
  root_block_device {
    volume_type                 = "gp3"
    volume_size                 = var.mysql_dev.disk
  }
  volume_tags = {
    Name = "mysql-dev-0"
    "map-migrated" = "mysql-server"
  }
  vpc_security_group_ids = [
    aws_security_group.mysql-dev.id
  ]
  subnet_id = data.aws_subnets.this.ids[0]
  tags = {
    Name = "mysql-dev-0"
    map-migrated = "mysql-server"
  }
  lifecycle {
    ignore_changes = [
    user_data_base64
    ]
  }
}

resource "aws_eip" "eip-mysql-dev-0" {
  instance = aws_instance.mysql-dev-0.id
  tags = {
    Name = "MYSQL-DEV-0"
  }
}

data "cloudinit_config" "mysql-dev-1" {
  gzip          = true
  base64_encode = true
  part {
    filename     = "init.cfg"
    content_type = "text/cloud-config"
    content      = templatefile("templates/default_cloud-init.tpl",{
      region     = "eu-central-1"
      hostname   = "mysql-dev-1"
    })
  }
}

resource "aws_instance" "mysql-dev-1" {
  ami                         = data.aws_ami.latest-ubuntu.id
  instance_type               = var.mysql_dev.instance_type
  key_name                    = data.aws_key_pair.new.key_name
  user_data_base64            = data.cloudinit_config.mysql-dev-1.rendered
  availability_zone           = data.aws_availability_zones.avilable.names[1]
  ebs_optimized               = true
  root_block_device {
    volume_type                 = "gp3"
    volume_size                 = var.mysql_dev.disk
  }
  volume_tags = {
    Name = "mysql-dev-1"
    "map-migrated" = "mysql-server"
  }
  vpc_security_group_ids = [
    aws_security_group.mysql-dev.id
  ]
  subnet_id = data.aws_subnets.this.ids[1]
  tags = {
    Name = "mysql-dev-1"
    map-migrated = "mysql-server"
  }
  lifecycle {
    ignore_changes = [
    user_data_base64
    ]
  }
}

resource "aws_eip" "eip-mysql-dev-1" {
  instance = aws_instance.mysql-dev-1.id
  tags = {
    Name = "MYSQL-DEV-1"
  }
}
