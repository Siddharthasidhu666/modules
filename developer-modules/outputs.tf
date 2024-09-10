output "availabilityzone"{
    value = data.aws_availability_zones.azs
}

output "sub"{
    value = aws_subnet.public_subnet
}