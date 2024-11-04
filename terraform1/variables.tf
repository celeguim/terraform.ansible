variable "vpc_cidr" {
  type = map(string)
  default = {
    useast1 = "10.0.0.0/16"
    useast2 = "10.1.0.0/16"
  }
}

variable "public_subnet_cidrs" {
  type = map(list(string))
  default = {
    useast1 = ["10.0.1.0/24", "10.0.2.0/24"]
    useast2 = ["10.1.1.0/24", "10.1.2.0/24"]
  }
}

variable "private_subnet_cidrs" {
  type = map(list(string))
  default = {
    useast1 = ["10.0.3.0/24", "10.0.4.0/24"]
    useast2 = ["10.1.3.0/24", "10.1.4.0/24"]
  }
}

variable "instance_type" {
  default = "t2.micro"
}

variable "ami_id_aws" {
  description = "AMI ID - Amazon Linux 2"
  default     = "ami-06b21ccaeff8cd686"
}

variable "ami_id_ubuntu" {
  description = "AMI ID - Ubuntu 22.04"
  default     = "ami-0866a3c8686eaeeba"
}
