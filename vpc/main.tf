# create custom vpc
resource "aws_vpc" "my_custom_vpc" {
    cidr_block = var.my_custom_vpc_cidr_block
    tags = {
        name = "My-custom-VPC"
    }
}

# Create internet gateway and attach it to the custom vpc
resource "aws_internet_gateway" "my_igw" {
    vpc_id = aws_vpc.my_custom_vpc.id
    tags = {
        Name = "My-custom-Vpc-IGW"
    }
}

# Create public subnet
resource "aws_subnet" "public_subnet" {
    vpc_id            = aws_vpc.my_custom_vpc.id  # Id of the custom_vpc
    count             = length(var.public_subnet_CIDRs) # Here we are getting the size of the values of public subnets since we have 2 values the size of it will be 2
    cidr_block        = var.public_subnet_CIDRs[count.index] # since the count=2 (for example we have given in variables), index =0 initially 2.0 = 1st public cidr now the index will be incremented so 2.1 = 2nd public cidr
    availability_zone = var.Availability_Zone[count.index % length(var.Availability_Zone)]
    /*let's say you have three Availability Zones specified in your availability_zones variable: ["us-east-1a", "us-east-1b", "us-east-1c"].
    When count.index is 0, count.index % 3 evaluates to 0, so it selects "us-east-1a".
    When count.index is 1, count.index % 3 evaluates to 1, so it selects "us-east-1b".
    When count.index is 2, count.index % 3 evaluates to 2, so it selects "us-east-1c".
    When count.index is 3, count.index % 3 evaluates to 0 (remainder of 3 divided by 3), so it wraps back to "us-east-1a".
    And so on, the process repeats cyclically.  This will make sure the efficient use of the availbility zones*/
    
    map_public_ip_on_launch = true  # this will makes sure that the servers launched in this subnet are publicly accessible
    tags = {
        Name = "My-custom-Vpc-public-subnet-${count.index + 1}"
    }
}

resource "aws_subnet" "private_subnet" {
    vpc_id = aws_vpc.my_custom_vpc.id
    count = length(var.private_subnet_CIDRs)
    cidr_block = var.private_subnet_CIDRs[count.index] // we can also use element(var.private_subnet_CIDRs,count.index) it gives the same result
    availability_zone = var.Availability_Zone[count.index]
    tags = {
        Name = "My-custom-Vpc-private-subnet-${count.index + 1}"
    }
}

# resource "aws_eip" "my_custom_vpc_elastic_ip" {
#     count = length(var.Availability_Zone)  //  Making sure that only one eip gets created per Availiability Zone
#     domain = "vpc"
# }

# resource "aws_nat_gateway" "my_custom_vpc_NAT_GATEWAY" {  // Making sure that one Nat gateway gets created for an Availability Zone
#     count = length(var.Availability_Zone) 
#     allocation_id = aws_eip.my_custom_vpc_elastic_ip[count.index].id
#     subnet_id = aws_subnet.public_subnet[count.index].id
# }

# resource "aws_route_table" "Public_RT" {
#     vpc_id = aws_vpc.my_custom_vpc.id
#     route {
#         cidr_block = "0.0.0.0/0"
#         gateway_id = aws_internet_gateway.my_igw.id
#     }
#     tags = {
#         Name = "My-custom-Vpc-Public-RT"
#     }
# }

# resource "aws_route_table_association" "Public_RT" {
#     count       = length(aws_subnet.public_subnet) // getting the lenght of the public subnets
#     subnet_id   = aws_subnet.public_subnet[count.index].id // add alling the public subnets based on the length
#     route_table_id = aws_route_table.Public_RT.id
# }

# resource "aws_route_table" "Private_RT" {
#     for_each          = { for idx, az in var.Availability_Zone : az => idx } // This creates a map, For each element, it assigns the index of the element to idx and the value of the element to az. just like this { value-->"us-west-1a" = 0 <-- id , "us-west-1b" = 1,  "us-west-1c" = 2 }
#     vpc_id            = aws_vpc.my_custom_vpc.id

#     route {
#     cidr_block      = "0.0.0.0/0"
#     nat_gateway_id  = aws_nat_gateway.my_custom_vpc_NAT_GATEWAY[index(var.Availability_Zone, each.key)].id  // assigning the correct nat gateway based on the availabilty zone if key=0 value at 0 is "us-west-1a" and we will get the nat gateway id for that availability zone
#     }
#     tags = {
#         Name = "My-custom-Vpc-Private-RT-${each.key}" // this will create sepreate route tables based on the availability zones
#     }
# }

# resource "aws_route_table_association" "Private_RT" {
#     for_each       = { for idx, az in var.Availability_Zone : az => idx }
#     subnet_id      = aws_subnet.private_subnet[index(var.Availability_Zone, each.key)].id 
#     route_table_id = aws_route_table.Private_RT[each.key].id // the route table will assigned based on the Id of the route table
# }

output "vpc_id" {
    value = aws_vpc.my_custom_vpc.id
}

output "availability_zone" {
    value = var.Availability_Zone
}

output "internet_gateway_id" {
    value = aws_internet_gateway.my_igw.id
}

output "public_subnet_ids" {
    value = [for idx in range(length(aws_subnet.public_subnet)) : element(aws_subnet.public_subnet[*].id, idx)]
}

output "private_subnet_ids" {
    value = [for idx in range(length(aws_subnet.private_subnet)) : element(aws_subnet.private_subnet[*].id, idx)]
}

output "public_instance_cidr_block" {
    value = [for subnet in aws_subnet.public_subnet : subnet.cidr_block]
}

output "private_instance_cidr_block" {
    value = [for subnet in aws_subnet.private_subnet : subnet.cidr_block]
}

output "Availability_Zone" {
    value = var.Availability_Zone
}

output "default_network_acl_id" {
    value = aws_vpc.my_custom_vpc.default_network_acl_id
}
