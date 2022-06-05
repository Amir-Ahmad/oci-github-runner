resource "oci_core_vcn" "vcn" {
  display_name   = var.project
  cidr_block     = var.vcn_cidr
  compartment_id = var.ocid_tenancy
  dns_label      = var.vcn_label
}

resource "oci_core_subnet" "subnet" {
  display_name               = "${var.project}-subnet"
  vcn_id                     = oci_core_vcn.vcn.id
  compartment_id             = var.ocid_tenancy
  cidr_block                 = var.vcn_cidr
  prohibit_public_ip_on_vnic = false
  dns_label                  = var.subnet_label
  security_list_ids          = [oci_core_security_list.security_list.id]
}

# OCI creates a default security list if we don't explicitly provide one
resource "oci_core_security_list" "security_list" {
  compartment_id = var.ocid_tenancy
  vcn_id         = oci_core_vcn.vcn.id

  display_name = "${var.project}-sl"
  # Allow all outbound traffic within the subnet
  egress_security_rules {
    destination = var.vcn_cidr
    protocol    = "all"
  }
}

resource "oci_core_internet_gateway" "igw" {
  display_name   = "${var.project}-igw"
  compartment_id = var.ocid_tenancy
  vcn_id         = oci_core_vcn.vcn.id
  enabled        = "true"
}

resource "oci_core_route_table" "route_table" {
  display_name   = "${var.project}-rt"
  compartment_id = var.ocid_tenancy
  vcn_id         = oci_core_vcn.vcn.id

  route_rules {
    network_entity_id = oci_core_internet_gateway.igw.id
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
  }
}

resource "oci_core_route_table_attachment" "route_table_attachment" {
  subnet_id      = oci_core_subnet.subnet.id
  route_table_id = oci_core_route_table.route_table.id
}
