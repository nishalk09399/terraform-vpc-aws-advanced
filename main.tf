#it is module that we are creating and it will refering to roboshop-infra-user directory/project
#this is the main script and roboshop-infra-user refering from here.

resource "aws_vpc" "main" {
  cidr_block       = var.cidr_block
  enable_dns_support = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = merge (
    var.common_tags, 
    {
        Name = var.project_name
    },
    var.vpc_tags
 
  )

}

#creating IGW

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge (
    var.common_tags, 
    {
        Name = var.project_name
    },
    var.igw_tags
 
  )
}


#creating subnets

resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidr)
  map_public_ip_on_launch = true
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnet_cidr[count.index]
  availability_zone = local.azs[count.index]

  tags = merge( #this is a map
    var.common_tags, 
    {
        Name = "${var.project_name}-public-${local.azs[count.index]}"
    }
  )
}


resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidr)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet_cidr[count.index]
  availability_zone = local.azs[count.index]

  tags = merge( #this is a map
    var.common_tags, 
    {
        Name = "${var.project_name}-private-${local.azs[count.index]}"
    }
  )
}


resource "aws_subnet" "database" {
  count = length(var.database_subnet_cidr)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.database_subnet_cidr[count.index]
  availability_zone = local.azs[count.index]

  tags = merge( #this is a map
    var.common_tags, 
    {
        Name = "${var.project_name}-database-${local.azs[count.index]}"
    }
  )
}

#route table config public

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = merge( #this is a map
    var.common_tags, 
    {
        Name = "${var.project_name}-public"
    },
    var.private_route_table_tags 
  )
}

resource "aws_eip" "eip" {

  domain   = "vpc"
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public[0].id

  tags = merge( 
    var.common_tags, 
    {
        Name = var.project_name
    },
    var.nat_gateway_tags
  )


  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.main]

}

#route table config private

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id #here we can connecting to internet through the nat gateway
  }

  tags = merge( #this is a map
    var.common_tags, 
    {
        Name = "${var.project_name}-private"
    },
    var.private_route_table_tags 
  )
}


#route table config database

resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id #here we can connecting to internet through the nat gateway
  }

  tags = merge( #this is a map
    var.common_tags, 
    {
        Name = "${var.project_name}-database"
    },
    var.database_route_table_tags 
  )
}

#association of routetables
resource "aws_route_table_association" "public" {
  count = length(var.public_subnet_cidr)
  subnet_id      = element(aws_subnet.public[*].id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count = length(var.private_subnet_cidr)
  subnet_id      = element(aws_subnet.private[*].id, count.index)
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "database" {
  count = length(var.database_subnet_cidr)
  subnet_id      = element(aws_subnet.database[*].id, count.index)
  route_table_id = aws_route_table.database.id
}

#to grouing the db subenets
resource "aws_db_subnet_group" "roboshop" {
  name       = var.project_name
  subnet_ids = aws_subnet.database[*].id

  tags = merge( #this is a map
    var.common_tags, 
    {
        Name = var.project_name
    },
    var.db_subnet_group_tags
  )
}
