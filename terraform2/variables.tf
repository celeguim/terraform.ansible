variable "instance_type" {
  default = "t2.small"
}

variable "ami_id_aws" {
  description = "AMI ID - Amazon Linux 2"
  default     = "ami-06b21ccaeff8cd686"
}

variable "ami_id_ubuntu_24" {
  description = "AMI ID - Ubuntu 24"
  default     = "ami-0866a3c8686eaeeba"
}


variable "ami_id_ubuntu_22" {
  description = "AMI ID - Ubuntu 22"
  default     = "ami-005fc0f236362e99f"
}
