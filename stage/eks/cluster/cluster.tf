module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = local.cluster.name
  cluster_version = local.cluster.version

  cluster_endpoint_public_access  = true

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  vpc_id     =  local.remote_states["network"].vpc_id
  subnet_ids =  local.private_subnet_ids
  control_plane_subnet_ids = local.private_subnet_ids

  # EKS Managed Node Group(s)
  # eks_managed_node_group_defaults = {
  #   iam_role_arn = "arn:aws:iam::280413110545:role/k8s-test-cluster-alb-ingress-controller"
  # }
  
  eks_managed_node_groups = {
    green = {
      min_size     = 1
      max_size     = 10
      desired_size = 1

      instance_types = ["t3.large"]
      capacity_type  = "SPOT"
    }
  }

 node_security_group_additional_rules = {

    #Recommended outbound traffic for Node groups
    egress_all = {
      description      = "Node all egress"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      type             = "egress"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
    # Allows Control Plane Nodes to talk to Worker nodes on all ports. Added this to simplify the example and further avoid issues with Add-ons communication with Control plane.
    # This can be restricted further to specific port based on the requirement for each Add-on e.g., metrics-server 4443, spark-operator 8080, karpenter 8443 etc.
    # Change this according to your security requirements if needed

    ingress_4443_from_controlplane = {
      description                   = "Cluster API to Nodegroup for metrics server"
      protocol                      = "-1"
      from_port                     = 0
      to_port                       = 4443
      type                          = "ingress"
      source_cluster_security_group = true
    }
  }

  tags = {
    Environment = "staging"
    Terraform   = "true"
  }
}

