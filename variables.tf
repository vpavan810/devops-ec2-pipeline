variable "aws_region" {
  type    = string
  default = "ap-south-1"
}

variable "execution_role_arn" {
  type    = string
  default = "arn:aws:iam::851725564646:role/ecstask"
}

variable "container_image" {
  type    = string
  default = "nginx"
}

variable "subnet_ids" {
  type    = list(string)
  default = ["subnet-09f026882a20e5555"]
}

variable "security_group_id" {
  type    = string
  default = "sg-07705b46489ac5a88"
}