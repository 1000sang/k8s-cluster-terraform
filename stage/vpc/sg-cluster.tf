# resource "aws_security_group" "test-sg-eks-cluster" {
#   name        = "test-cluster-sg"
#   description = "security_group for test-eks-cluster"
#   vpc_id      = module.vpc.vpc_id
# }

# resource "aws_security_group_rule" "test-sg-eks-cluster-ingress" {

#   security_group_id = aws_security_group.test-sg-eks-cluster.id
#   type              = "ingress"
#   description       = "ingress security_group_rule for test-eks-cluster"
#   from_port         = 0
#   to_port           = 0
#   protocol          = "-1"
#   cidr_blocks       = ["0.0.0.0/0"]
# }

# resource "aws_security_group_rule" "test-sg-eks-cluster-egress" {

#   security_group_id = aws_security_group.test-sg-eks-cluster.id
#   type              = "egress"
#   description       = "egress security_group_rule for test-eks-cluster"
#   from_port         = 0
#   to_port           = 0
#   protocol          = "-1"
#   cidr_blocks       = ["0.0.0.0/0"]
# }