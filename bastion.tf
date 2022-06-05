resource "oci_bastion_bastion" "bastion" {
  count                        = var.create_oci_bastion ? 1 : 0
  bastion_type                 = "STANDARD"
  compartment_id               = var.ocid_tenancy
  target_subnet_id             = oci_core_subnet.subnet.id
  client_cidr_block_allow_list = ["0.0.0.0/0"]
  max_session_ttl_in_seconds   = var.bastion_max_session_ttl_in_seconds
  name                         = "${var.project}-bastion"
}
