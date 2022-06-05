# Get a list of Availability Domains
data "oci_identity_availability_domains" "ads" {
  compartment_id = var.ocid_tenancy
}

# get latest Oracle Linux 8 image
data "oci_core_images" "oraclelinux" {
  compartment_id           = var.ocid_tenancy
  operating_system         = "Oracle Linux"
  operating_system_version = "8"
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
  shape                    = var.instance_shape
}
