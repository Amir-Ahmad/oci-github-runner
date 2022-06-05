resource "oci_core_network_security_group" "sg" {
  compartment_id = var.ocid_tenancy
  vcn_id         = oci_core_vcn.vcn.id

}

# Allow all outbound traffic
resource "oci_core_network_security_group_security_rule" "egress_all" {
  network_security_group_id = oci_core_network_security_group.sg.id

  direction   = "EGRESS"
  protocol    = "all"
  destination = "0.0.0.0/0"
}

#Allow all incoming SSH traffic
resource "oci_core_network_security_group_security_rule" "ingress_ssh" {
  count                     = var.allow_ssh_from_anywhere ? 1 : 0
  network_security_group_id = oci_core_network_security_group.sg.id
  protocol                  = "6"
  direction                 = "INGRESS"
  source                    = "0.0.0.0/0"

  tcp_options {
    destination_port_range {
      min = 22
      max = 22
    }
  }
}

# Allow incoming SSH connections from bastion
resource "oci_core_network_security_group_security_rule" "ingress_bastion" {
  count                     = var.create_oci_bastion ? 1 : 0
  network_security_group_id = oci_core_network_security_group.sg.id
  protocol                  = "6"
  direction                 = "INGRESS"
  source                    = "${oci_bastion_bastion.bastion.0.private_endpoint_ip_address}/32"

  tcp_options {
    destination_port_range {
      min = 22
      max = 22
    }
  }
}
