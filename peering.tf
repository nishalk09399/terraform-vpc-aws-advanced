#in this script we are doing vpc peering b/w roboshop and default one user is "roboshop-infra-standard\01-VPC"

resource "aws_vpc_peering_connection" "peering" {
  count = var.is_peering_required ? 1 : 0
  
  #peer_owner_id = var.peer_owner_id

  #requestor is default vpc 
  peer_vpc_id   = aws_vpc.main.id
  vpc_id        = var.requestor_vpc_id
  auto_accept   = true

  tags = merge (
    {
      Name = "${var.project_name}-${var.env}"
    }, 
    var.common_tags
  )
    
  }

#creating route for default vpc 

resource "aws_route" "default_route" {
  count = var.is_peering_required ? 1 : 0
  route_table_id            = var.default_route_table_id
  destination_cidr_block    = var.cidr_block
  
  #we have set the count the parameter it is treated it as a list, even single element you should write a list symtax
  vpc_peering_connection_id = aws_vpc_peering_connection.peering[0].id
  #depends_on                = [aws_route_table.testing]
}

#creating route for roboshop vpc
#public peering 

resource "aws_route" "public_peering" {
  count = var.is_peering_required ? 1 : 0
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = var.default_vpc_cidr
  
  #we have set the count the parameter it is treated it as a list, even single element you should write a list symtax
  
  vpc_peering_connection_id = aws_vpc_peering_connection.peering[0].id
  #depends_on                = [aws_route_table.testing]
}

#private peering 

resource "aws_route" "private_peering" {
  count = var.is_peering_required ? 1 : 0
  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = var.default_vpc_cidr
  
  #we have set the count the parameter it is treated it as a list, even single element you should write a list symtax
  
  vpc_peering_connection_id = aws_vpc_peering_connection.peering[0].id
  #depends_on                = [aws_route_table.testing]
}

#database peering 

resource "aws_route" "database_peering" {
  count = var.is_peering_required ? 1 : 0
  route_table_id            = aws_route_table.database.id
  destination_cidr_block    = var.default_vpc_cidr
  
  #we have set the count the parameter it is treated it as a list, even single element you should write a list symtax
  
  vpc_peering_connection_id = aws_vpc_peering_connection.peering[0].id
  #depends_on                = [aws_route_table.testing]
}