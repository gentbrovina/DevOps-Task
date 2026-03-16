variable "AWS_REGION" {
  default = "eu-central-1"
}

variable "cidr_block"{
  default = "10.0.0.0/16"
}

variable "cidr_block_subnet_public"{
  default = "10.0.1.0/24"
}

variable "az"{
  default = "eu-central-1a"
}

variable "count_num"{
  default = "3"
}

variable "ami_id"{
  default = "ami-074dd8e8dac7651a5"
}