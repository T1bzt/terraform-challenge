provider "aws" {
  profile = "ideaas"
  region  = "eu-central-1"
}

terraform {
  backend "s3" {
    bucket         = "nb-ideaas-terraform-state-bucket3"
    key            = "tfstate/terraform.tfstate"
    region         = "eu-central-1"
    profile        = "ideaas"
  }
}
