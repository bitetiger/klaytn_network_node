# Configure the AWS Provider
provider "aws" {
  profile = "wemade"
  region = "ap-northeast-2"
}

# Create a VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true

}
