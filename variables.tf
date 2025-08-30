variable "aws_region" {
  default = "ap-south-1"
}

variable "ami_id" {
  default = "ami-0f5ee92e2d63afc18" # Amazon Linux 2 (Mumbai)
}

variable "instance_type" {
  default = "t2.micro"
}