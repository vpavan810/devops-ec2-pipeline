variable "aws_region" {
  default = "ap-south-1"
}

variable "execution_role_arn" {
  description = "arn:aws:iam::851725564646:role/ecstask"
}

variable "container_image" {
  default = "nginx" # Or your custom image
}

variable "subnet_ids" {
  type = list(string)
  default = ["subnet-09f026882a20e5555"]
}

variable "security_group_id" {
  type = string
  default = "sg-07705b46489ac5a88"
}
