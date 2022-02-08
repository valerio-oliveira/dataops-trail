
provider "aws" {
  alias      = "site1"
  region     = "us-east-1"
  access_key = var.terraform_access_key
  secret_key = var.terraform_secret_key
}

provider "aws" {
  alias      = "site2"
  region     = "us-east-2"
  access_key = var.terraform_access_key
  secret_key = var.terraform_secret_key
}
