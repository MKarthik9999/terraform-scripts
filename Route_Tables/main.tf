resource "aws_route_table" "Public_RT" {
    vpc_id = var.vpc_id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = var.internet_gateway_id
    }
    tags = {
        Name = "My-custom-Vpc-Public-RT"
    }
}

resource "aws_route_table_association" "Public_RT" {
    count       = length(var.public_subnet_ids) // getting the lenght of the public subnets
    subnet_id   = var.public_subnet_ids[count.index]// add alling the public subnets based on the length
    route_table_id = aws_route_table.Public_RT.id
}

/*resource "aws_eip" "my_custom_vpc_elastic_ip" {
    count = length(var.Availability_Zone)  //  Making sure that only one eip gets created per Availiability Zone
    domain = "vpc"
}

resource "aws_nat_gateway" "my_custom_vpc_NAT_GATEWAY" {  // Making sure that one Nat gateway gets created for an Availability Zone
    count = length(var.Availability_Zone) 
    allocation_id = aws_eip.my_custom_vpc_elastic_ip[count.index].id
    subnet_id = var.public_subnet_ids[count.index]
}

resource "aws_route_table" "Private_RT" {
    for_each          = { for idx, az in var.Availability_Zone : az => idx } // This creates a map, For each element, it assigns the index of the element to idx and the value of the element to az. just like this { value-->"us-west-1a" = 0 <-- id , "us-west-1b" = 1,  "us-west-1c" = 2 }
    vpc_id            = var.vpc_id

    route {
    cidr_block      = "0.0.0.0/0"
    nat_gateway_id  = aws_nat_gateway.my_custom_vpc_NAT_GATEWAY[index(var.Availability_Zone, each.key)].id  // assigning the correct nat gateway based on the availabilty zone if key=0 value at 0 is "us-west-1a" and we will get the nat gateway id for that availability zone
    }
    tags = {
        Name = "My-custom-Vpc-Private-RT-${each.key}" // this will create sepreate route tables based on the availability zones
    }
}

resource "aws_route_table_association" "Private_RT" {
    for_each       = { for idx, az in var.Availability_Zone : az => idx }
    subnet_id      = var.private_subnet_ids[index(var.Availability_Zone, each.key)]  //aws_subnet.private_subnet[index(var.Availability_Zone, each.key)].id 
    route_table_id = aws_route_table.Private_RT[each.key].id // the route table will assigned based on the Id of the route table
}*/