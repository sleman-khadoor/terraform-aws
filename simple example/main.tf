# this is a simple way where we hard-code these values but it's not the right way
# we are using this way just for learning 
provider "aws"{
    region = "eu-central-1"
    access_key = ""
    secret_key = ""
}

#---------------------------------------
# we first use the resource word then the resource type then the resource name 
resource "aws_vpc" "development-vpc"{
    cidr_block = var.vpc_cidr # private ip address range for the vpc
    tags = {
        Name : "development"
    }

}

resource "aws_subnet" "dev-subnet-1"{
    vpc_id = aws_vpc.development-vpc.id
    cidr_block = "10.0.10.0/24"
    availability_zone ="eu-central-1a"
    tags = {
        Name : "sub1-development"
    }
}


# passing cidr to this subnet using variables
resource "aws_subnet" "dev-subnet-2"{
    vpc_id = aws_vpc.development-vpc.id
    cidr_block = var.subnet_dev2_cidr
    availability_zone ="eu-central-1b"
    tags = {
        Name : "sub1-development"
    }
}

#---------------------------------------
# we use data resource to query existing resources
# for example if we want to query an existing vpc
data "aws_vpc" "existing_vpc"{
    #filter criteria to tell terraform which resource match our query
    # for example to get the default vpc
    default = true 
}

# for example to use the data we queried before we do th following
resource "aws_subnet" "def-subnet-1"{
    vpc_id = data.aws_vpc.development-vpc.id
    cidr_block = "20.0.20.0/24" # this should be subset of the default vpc cidr block
    availability_zone ="eu-central-1a"
    tags = {
        Name : "sub2 -development"
    }

}


#-------------------------------------------
# output
output "dev-vpc-id"{
    value = aws_vpc.development-vpc.id
}

output "dev-subnet-id"{
    value = aws_subnet.dev-subnet-1.id
}

#-------------------------------------------
# variables
variable "subnet_dev2_cidr" {
    description = "this is a cidr block for dev subnet 2"
    default = "10.0.100.0/24" # this value will kick in if terraform couldn't find a value for this variable
    # this makes it not necessary to set value to this variable.
    type = string
  
}


variable "vpc_cidr" {
    description = "this is a cidr block for dev vpc"

  
} 