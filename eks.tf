#######################################################
#                 Networking (VPC)
#######################################################
#module "vpc" {
#  source  = "terraform-aws-modules/vpc/aws"
#  version = "~> 5.0"
#
#  name = "eks-vpc"
#  cidr = "10.20.0.0/16"
#
#  azs             = ["eu-central-1a", "eu-central-1b"]
#  private_subnets = ["10.20.1.0/24", "10.20.2.0/24"]
#  public_subnets  = ["10.20.101.0/24", "10.20.102.0/24"]
#
#  enable_nat_gateway = true
#  single_nat_gateway = true
#}
/*
data "aws_availability_zones" "avilable" {}

data "aws_security_group" "master_node" {
  id = "sg-00b2ccd6e4618579e"
}
#######################################################
#           IAM role for EKS cluster
#######################################################

resource "aws_iam_role" "eks_cluster_role" {
  name = "eks-clusters-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Service = "eks.amazonaws.com" }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "cluster_policy" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}
#######################################################
#                   EKS Cluster
#######################################################

resource "aws_eks_cluster" "this" {
  name     = "eks-cluster-live"
  role_arn = aws_iam_role.eks_cluster_role.arn
  version  = "1.30"

  vpc_config {
    subnet_ids = ["subnet-079e2645e13f2a307", "subnet-026807a584d09da41"]
#    endpoint_private_access       = true
#    endpoint_public_access        = true
#    additional_security_group_ids = [data.aws_security_group.master_node.id]
        #subnet_ids = module.vpc.private_subnets
        #subnet_ids = aws_subnet.private[*].id
  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster_policy
  ]
}
#######################################################
#             IAM role for Node Group
#######################################################

resource "aws_iam_role" "eks_node_role" {
  name = "eks-nodes-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "worker_node_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "cni_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "ecr_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}
#######################################################
# Managed Linux Node Group (min 1 / desired 2 / max 3)
#######################################################

resource "aws_eks_node_group" "linux" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "linux-ng"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = ["subnet-079e2645e13f2a307", "subnet-026807a584d09da41"]
  #subnet_ids     = module.vpc.private_subnets
  #subnet_ids     = aws_subnet.private[*].id

  scaling_config {
    min_size     = 1
    desired_size = 2
    max_size     = 3
  }

  instance_types = ["t3.medium"]
  ami_type       = "AL2_x86_64"
#  additional_security_group_ids = [data.aws_security_group.master_node.id]
  depends_on = [
    aws_eks_cluster.this,
    aws_iam_role_policy_attachment.worker_node_policy,
    aws_iam_role_policy_attachment.cni_policy,
    aws_iam_role_policy_attachment.ecr_policy
  ]
}
*/