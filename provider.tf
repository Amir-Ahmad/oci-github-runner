provider "oci" {
  tenancy_ocid     = var.ocid_tenancy
  user_ocid        = var.ocid_user
  region           = var.oci_region
  fingerprint      = var.oci_fingerprint
  private_key_path = var.oci_private_key_path
}
