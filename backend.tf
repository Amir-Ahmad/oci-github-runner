terraform {
  cloud {
    organization = "<TERRAFORM_CLOUD_ORG>"
    workspaces {
      name = "oci-github-runner"
    }
  }
}
