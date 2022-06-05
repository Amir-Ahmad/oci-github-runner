resource "oci_core_instance" "instances" {
  count               = var.instance_count
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0]["name"]
  compartment_id      = var.ocid_tenancy
  shape               = var.instance_shape
  display_name        = "${var.project}-instance${count.index + 1}"

  shape_config {
    memory_in_gbs = var.instance_memory_gb
    ocpus         = var.instance_ocpu
  }

  lifecycle {
    precondition {
      condition     = (var.instance_count * var.instance_memory_gb) <= 24
      error_message = "Oracle Free Tier allows up to 24GB across all Ampere instances"
    }

    precondition {
      condition     = (var.instance_count * var.instance_ocpu) <= 4
      error_message = "Oracle Free Tier allows up to 4 OCPUs across all Ampere instances"
    }
  }

  agent_config {
    are_all_plugins_disabled = true
  }

  source_details {
    source_type = "image"
    source_id   = data.oci_core_images.oraclelinux.images.0.id
  }

  metadata = {
    ssh_authorized_keys = file(var.ssh_public_key_path)
    user_data = base64encode(templatefile("scripts/userdata.sh",
      {
        GITHUB_RUNNER_URL    = var.github_runner_url
        GITHUB_RUNNER_TOKEN  = var.github_runner_token
        GITHUB_RUNNER_LABELS = var.github_runner_labels
      }
    ))
  }

  create_vnic_details {
    assign_private_dns_record = true
    assign_public_ip          = true
    display_name              = "${var.project}-instance${count.index + 1}"
    hostname_label            = "instance${count.index + 1}"
    private_ip                = cidrhost(var.vcn_cidr, count.index + 2)
    subnet_id                 = oci_core_subnet.subnet.id
    nsg_ids                   = [oci_core_network_security_group.sg.id]
  }
}
