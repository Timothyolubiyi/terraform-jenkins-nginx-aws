terraform {
  backend "s3" {
    bucket = "timothy-terraform-state-2026"
    region = "eu-north-1"
    key    = "terraform1/terraform.tfstate"
  }
}