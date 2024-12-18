locals {

  # networking
  vpc_name              = "terraform-eks-vpc"
  vpc_cidr              = "10.0.0.0/16"
  vpc_azs               = ["eu-west-1a", "eu-west-1b"]
  vpc_private_subnets   = ["10.0.0.0/19", "10.0.32.0/19"]
  vpc_public_subnets    = ["10.0.64.0/19", "10.0.96.0/19"]
  dns_sub_domain_prefix = "api"

  # cluster configuration
  cluster_name    = "demo"
  cluster_version = "1.30"

  eks_managed_node_group_defaults = {
    instance_types = ["m6i.large", "m5.large", "m5n.large", "m5zn.large"]
  }

  eks_managed_node_groups = {
    default = {
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["m5.large"]

      min_size     = 1
      max_size     = 5
      desired_size = 1

      capacity_type = "ON_DEMAND"
    }
  }

  # additional rule to allow all traffic between worker nodes
  node_security_group_additional_rules = {
    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }
    egress_all = {
      description      = "Node all egress"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      type             = "egress"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }

  tags = {
    Project     = "terraform eks deployment"
    ManagedBy   = "terraform"
    Environment = "sandbox"
  }

}
