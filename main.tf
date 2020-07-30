provider "aws" {
  region = "us-west-2"
}

variable "name" {
  type = string
  default = "helloworld"
}

resource "aws_iam_user" "user" {
  name = var.name
}