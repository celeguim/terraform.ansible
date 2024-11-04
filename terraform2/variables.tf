variable "instance_type" {
  default = "t2.small"
}

variable "ami_id_aws" {
  description = "AMI ID - Amazon Linux 2"
  default     = "ami-06b21ccaeff8cd686"
}

variable "ami_id_ubuntu" {
  description = "AMI ID - Ubuntu 22.04"
  default     = "ami-0866a3c8686eaeeba"
}
