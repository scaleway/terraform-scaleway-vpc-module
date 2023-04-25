provider "scaleway" {
  region = local.region
}

locals {
  name   = "ex-${basename(path.cwd)}"
  region = "fr-par"
  azs    = tolist(["fr-par-1", "fr-par-2"])
  tags = [
    local.name,
    "terraform-scaleway-vpc-module"
  ]
}

################################################################################
# VPC Module
################################################################################

module "vpc" {
  source = "../../"
  azs    = local.azs
  name   = local.name
  tags   = local.tags
}
