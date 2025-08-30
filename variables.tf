variable "aws_region" {
  default = "ap-south-1"
}

variable "ami_id" {
  default = "ami-0c55b159cbfafe1f0" # Amazon Linux 2 (Mumbai)
}

variable "instance_type" {
  default = "t2.micro"
}