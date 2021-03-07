provider "aws" {
  profile = "ideaas"
  region  = "eu-central-1"
}

terraform {
  backend "s3" {
    bucket         = "nb-ideaas-terraform-state-bucket"
    key            = "tfstate/terraform.tfstate"
    region         = "eu-west-1"
    profile        = "ideaas"
  }
}
