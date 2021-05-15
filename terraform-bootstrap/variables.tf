variable "region" {
  type    = string
  default = "us-east-1"
}

variable "tags" {
  type = map(string)
  default = {
    createdBy          = "Terraform"
    "costCenter"       = "TBD"
    "department"       = "TBD"
    "Project"          = "TBD"
    "Environment"      = "TBD"
    "businessOwner"    = "TBD"
    "applicationOwner" = "TBD"
    "systemOwner"      = "TBD"
    "operationOwner"   = "TBD"
  }
}