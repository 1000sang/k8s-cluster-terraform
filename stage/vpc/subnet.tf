////////////////////////////////////////////////////
/////           EKS Cluster Subnet             /////
////////////////////////////////////////////////////

resource "aws_subnet" "cluster_public_subnets" {
    count = "${length(var.availability_zone)}"
    availability_zone = "${element(var.availability_zone, count.index)}"

    vpc_id = module.vpc.vpc_id
    cidr_block =  local.config.subnet_groups.public.subnet[count.index].cidr
    map_public_ip_on_launch = true

    tags = {
        Name = "public-${element(var.availability_zone, count.index)}"
        tostring("kubernetes.io/role/elb") =  1
    }
}

resource "aws_subnet" "cluster_private_subnets" {
    count = "${length(var.availability_zone)}"
    availability_zone = "${element(var.availability_zone, count.index)}"

    vpc_id = module.vpc.vpc_id
    cidr_block =  local.config.subnet_groups.private.subnet[count.index].cidr

    tags = {
        Name = "private-${element(var.availability_zone, count.index)}"
        tostring("kubernetes.io/role/internal-elb") =  1
    }
}

////////////////////////////////////////////////////
/////            Public Route Table            /////
////////////////////////////////////////////////////

resource "aws_internet_gateway" "igw" {
    vpc_id = module.vpc.vpc_id

    tags = {
        Name = "igw"
    }
}

resource "aws_route_table" "route_table_public" {
    count = "${length(var.availability_zone)}"
    vpc_id = module.vpc.vpc_id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }

    tags = {
      "Name" = "eks-public"
    }
}

resource "aws_route_table_association" "route_table_association_public" {
    count = "${length(aws_route_table.route_table_public[*])}"

    subnet_id = aws_subnet.cluster_public_subnets[count.index].id
    route_table_id = aws_route_table.route_table_public[count.index].id
}

////////////////////////////////////////////////////
/////               NAT GateWay                /////
////////////////////////////////////////////////////

resource "aws_eip" "nat" {
    vpc = true

    lifecycle {
      create_before_destroy = true
    }
}

resource "aws_nat_gateway" "nat_gateway" {
    allocation_id = aws_eip.nat.id

    subnet_id = aws_subnet.cluster_public_subnets[0].id

    tags = {
      "Name" = "NAT Gateway"
    }
}

////////////////////////////////////////////////////
/////            Private Route Table           /////
////////////////////////////////////////////////////

resource "aws_route_table" "route_table_private" {
    count = "${length(var.availability_zone)}"
    vpc_id = module.vpc.vpc_id

    route {
        # cidr_block = local.config.subnet_groups.private.subnet[count.index].cidr
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.nat_gateway.id
    }

    tags = {
      "Name" = "eks-private"
    }
}

resource "aws_route_table_association" "route_table_association_private" {
    count = "${length(aws_route_table.route_table_private[*])}"

    subnet_id = aws_subnet.cluster_private_subnets[count.index].id
    route_table_id = aws_route_table.route_table_private[count.index].id
}
