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
/*
data "aws_subnets" "this" {
  filter {
    name   = "main"
    values = [var.vpc_id]
  }
}
*/
data "aws_availability_zones" "avilable" {}

data "aws_key_pair" "careem" {
  key_name = "careem"
}

#######################################################
#                 Security Group (SG)
#######################################################
resource "aws_security_group" "main" {
  name = "main"
  description = "Allow some traffic"
  vpc_id = var.vpc_id
  ingress {
  description = "Allow specific to ssh"
   from_port = 22
   to_port = 22 
   protocol = "tcp"
   cidr_blocks = [
    "0.0.0.0/0",
    "${var.main.ip_instance}/32",
   ]
  }
  /*
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
  */
  egress {
   from_port = 0
   to_port = 0
   protocol = "-1"
   cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "MAIN"
  }
}
/*
data "cloudinit_config" "main" {
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
*/

resource "aws_instance" "main" {
  ami                         = data.aws_ami.latest-ubuntu.id
  instance_type               = var.main.instance_type
  key_name                    = data.aws_key_pair.careem.key_name
  #user_data_base64            = data.cloudinit_config.main.rendered
  availability_zone           = data.aws_availability_zones.avilable.names[0]
  ebs_optimized               = true
  root_block_device {
    volume_type                 = "gp3"
    volume_size                 = var.main.disk
  }
  volume_tags = {
    Name = "main"
    map-migrated = "main-server"
  }
  vpc_security_group_ids = [
    aws_security_group.main.id
  ]
  subnet_id = "subnet-08bedcd3bdf2e58e6"
  /*tags = {
    Name = "main"
    map-migrated = "main-server"
  }
  */
  /*
  lifecycle {
    ignore_changes = [
    user_data_base64
    ]
  }
  */
}

resource "aws_eip" "eip-main" {
  instance = aws_instance.main.id
  tags = {
    Name = "MAIN"
  }
}

resource "aws_instance" "worker-1" {
  ami                         = data.aws_ami.latest-ubuntu.id
  instance_type               = var.worker.instance_type
  key_name                    = data.aws_key_pair.careem.key_name
  availability_zone           = data.aws_availability_zones.avilable.names[1]
  ebs_optimized               = true
  root_block_device {
    volume_type                 = "gp3"
    volume_size                 = var.worker.disk
  }
  volume_tags = {
    Name = "worker-1"
    map-migrated = "worker-server-1"
  }
  vpc_security_group_ids = [
    aws_security_group.main.id
  ]
  subnet_id = "subnet-096874f8f787a013a"
}

resource "aws_instance" "worker-2" {
  ami                         = data.aws_ami.latest-ubuntu.id
  instance_type               = var.worker.instance_type
  key_name                    = data.aws_key_pair.careem.key_name
  availability_zone           = data.aws_availability_zones.avilable.names[2]
  ebs_optimized               = true
  root_block_device {
    volume_type                 = "gp3"
    volume_size                 = var.worker.disk
  }
  volume_tags = {
    Name = "worker-2"
    map-migrated = "worker-server-2"
  }
  vpc_security_group_ids = [
    aws_security_group.main.id
  ]
  subnet_id = "subnet-080e27c5aa347ca4f"
}