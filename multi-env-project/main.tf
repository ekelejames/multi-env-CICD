terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 3.8"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

#creating security group for traffic inbound rules
resource "aws_security_group" "jenkins-tomcat-security-group" {
  name_prefix = "web-"
  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#creating jenkins server
resource "aws_instance" "jenkins-dev" {
  ami = "ami-0a91cd140a1fc148a"
  instance_type = "t2.micro"
  key_name = "project-keypair"
  associate_public_ip_address = true
  security_groups = [aws_security_group.jenkins-tomcat-security-group.name]
}

#creating tomcat server for development environment 
resource "aws_instance" "Tomcat-dev" {
  ami = "ami-0a91cd140a1fc148a"
  instance_type = "t2.micro"
  key_name = "project-keypair"
  associate_public_ip_address = true
  security_groups = [aws_security_group.jenkins-tomcat-security-group.name]
}

#creating EKS cluster for staging environment
resource "aws_eks_cluster" "staging-env-eks-cluster" {
  name     = "staging-env-eks-cluster"
  role_arn = aws_iam_role.eks_cluster.arn

  vpc_config {
    subnet_ids = aws_subnet.default.*.id
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster,
  ]
}

resource "aws_iam_role" "eks_cluster" {
  name = "eks-cluster"

  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster.name
}

resource "aws_subnet" "default" {
  count = 2

  vpc_id     = aws_vpc.default.id
  cidr_block = aws_vpc.default.cidr_block
  map_public_ip_on_launch = true
}

resource "aws_security_group" "eks_cluster" {
  name_prefix = "eks-cluster-"
}

resource "aws_security_group_rule" "eks_cluster_ingress" {
  security_group_id = aws_security_group.eks_cluster.id

  type        = "ingress"
  from_port   = 0
  to_port     = 65535
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_eks_node_group" "my_node_group" {
  cluster_name    = aws_eks_cluster.staging-env-eks-cluster.name
  node_group_name = "my-node-group"
  node_role_arn   = aws_iam_role.eks_node.arn
  instance_types = [ "t2.micro" ]

  scaling_config {
    desired_size = 2
    max_size     = 5
    min_size     = 1
  }

  remote_access {
    ec2_ssh_key = "project-keypair"
  }

  subnet_ids = aws_subnet.default.*.id

  depends_on = [
    aws_iam_role_policy_attachment.eks_node,
  ]
}

resource "aws_iam_role" "eks_node" {
  name = "eks-node"

  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_node" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node.name
}

resource "aws_iam_instance_profile" "eks_node" {
  name = "eks-node"

  role = aws_iam_role.eks_node.name
}


#creating production environment cluster
resource "aws_eks_cluster" "production-env-eks-cluster" {
  name     = "production-env-eks-cluster"
  role_arn = aws_iam_role.eks_cluster2.arn

  vpc_config {
    subnet_ids = aws_subnet.default2.*.id
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster2,
  ]
}

resource "aws_iam_role" "eks_cluster2" {
  name = "eks-cluster2"

  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster2" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster2.name
}

resource "aws_subnet" "default2" {
  count = 2

  vpc_id     = aws_vpc.default2.id
  cidr_block = aws_vpc.default2.cidr_block
  map_public_ip_on_launch = true
}

resource "aws_security_group" "eks_cluster2" {
  name_prefix = "eks-cluster2-"
}

resource "aws_security_group_rule" "eks_cluster2_ingress" {
  security_group_id = aws_security_group.eks_cluster2.id

  type        = "ingress"
  from_port   = 0
  to_port     = 65535
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_eks_node_group" "my_node_group2" {
  cluster_name    = aws_eks_cluster.production-env-eks-cluster.name
  node_group_name = "my-node-group2"
  node_role_arn   = aws_iam_role.eks_node2.arn
  instance_types = [ "t2.micro" ]

  scaling_config {
    desired_size = 2
    max_size     = 5
    min_size     = 1
  }

  remote_access {
    ec2_ssh_key = "project-keypair"
  }

  subnet_ids = aws_subnet.default2.*.id

  depends_on = [
    aws_iam_role_policy_attachment.eks_node2,
  ]
}

resource "aws_iam_role" "eks_node2" {
  name = "eks-node2"

  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_node2" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node2.name
}

resource "aws_iam_instance_profile" "eks_node2" {
  name = "eks-node2"

  role = aws_iam_role.eks_node2.name
}