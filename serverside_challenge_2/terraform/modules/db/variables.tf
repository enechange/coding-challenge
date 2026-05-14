variable "project" {
  type = string
}

variable "env" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "sg_rds_id" {
  type = string
}
