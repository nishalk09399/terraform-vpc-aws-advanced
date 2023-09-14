output "vpc_id" {
    value = aws_vpc.main.id
}

#we need to display the public subent id's

output "public_subnet_ids" {
    value = aws_subnet.public[*].id # we are displaying all pub subnet ids here

}

output "private_subnet_ids" {
    value = aws_subnet.private[*].id # we are displaying all pub subnet ids here

}

output "database_subnet_ids" {
    value = aws_subnet.database[*].id # we are displaying all pub subnet ids here

}