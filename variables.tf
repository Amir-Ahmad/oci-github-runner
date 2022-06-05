variable "ocid_tenancy" {
  type = string
}

variable "ocid_user" {
  type = string
}

variable "oci_region" {
  type = string
}

variable "oci_fingerprint" {
  type = string
}

variable "oci_private_key_path" {
  type = string
}

variable "project" {
  type    = string
  default = "oci-github-runner"
}

variable "instance_shape" {
  type    = string
  default = "VM.Standard.A1.Flex"
}

variable "instance_memory_gb" {
  description = "RAM per instance (GB)"
  type        = number

}

variable "instance_ocpu" {
  description = "OCPUs per instance"
  type        = number

}

variable "instance_count" {
  description = "Number of instances to create"
  type        = number


  validation {
    condition     = var.instance_count <= 4
    error_message = "OCI Free Tier allows up to 4 instances"
  }
}

variable "ssh_public_key_path" {
  description = "Path to ssh public key to be added to the instance"
  type        = string
}

variable "vcn_cidr" {
  type    = string
  default = "10.0.0.0/22"
}

variable "vcn_label" {
  type    = string
  default = "ghrunner"
}
variable "subnet_label" {
  type    = string
  default = "ghrunner"
}

variable "allow_ssh_from_anywhere" {
  description = "Allow SSH access from anywhere"
  type        = bool
  default     = false
}

variable "create_oci_bastion" {
  description = "Create Oracle Bastion"
  type        = bool
  default     = true
}

variable "bastion_max_session_ttl_in_seconds" {
  description = "Time to leave bastion sessions alive (max is 3 hours)"
  type        = number
  default     = 10800
}

variable "github_runner_url" {
  description = "Github organization or repo that the runner will be registered to"
  type        = string
}

variable "github_runner_token" {
  description = "Github Runner token as provided by github"
  type        = string
}

variable "github_runner_labels" {
  description = "Github Runner labels"
  type        = string
  default     = "arm64"
}
