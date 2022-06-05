# Output the result
output "instance_id" {
  value = oci_core_instance.instances.*.id
}

output "instance_public_ip" {
  value = oci_core_instance.instances.*.public_ip
}

output "instance_private_ip" {
  value = oci_core_instance.instances.*.private_ip
}

output "bastion_id" {
  value = length(oci_bastion_bastion.bastion) > 0 ? one(oci_bastion_bastion.bastion).id : null
}
