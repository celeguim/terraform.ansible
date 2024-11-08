data "aws_key_pair" "my-key-pair" {
  key_name           = "my-key-pair"
  include_public_key = true
}

data "aws_vpc" "default" {
  default = true
}

# output "my-key-pair" {
#   value = data.aws_key_pair.my-key-pair
# }

# data "aws_s3_bucket" "my-bucket1-test1" {
#   bucket = "my-bucket1-test1"
# }

# output "my-bucket1-test1" {
#   value = data.aws_s3_bucket.my-bucket1-test1
# }
