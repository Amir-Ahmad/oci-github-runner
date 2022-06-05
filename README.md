## oci-github-runner

Deploys self-hosted Github Actions runners on Oracle Cloud free tier (Ampere A1), using terraform.

An OCI bastion can also optionally be deployed, allowing access to the instances without opening up port 22 to the world.


### Deploying via terraform

1. Create a tfvars file from the sample and set its values: `cp tfvars.sample runner.auto.tfvars`

2. Edit Terraform backend details in backend.tf (or remove to use local state)

3. `terraform init`

4. `terraform plan`


### OCI Bastion

If you set the variable `create_oci_bastion` to true, an OCI Bastion will be created. 

Oracle's instructions for accessing instances via the bastion are cumbersome, so I've written a portforwarding script `scripts/oci_session.sh` to make it easier.

To use this, first edit the variables at the top of the script, and then add a few stanzas in ~/.ssh/config:

```
Host oc?
    Proxycommand ~/bin/oci_session.sh %h %p
    IdentityFile ~/.ssh/<instance_private_key>
    IdentitiesOnly yes
    user opc
    StrictHostKeyChecking no

Host oc1
    hostname 10.0.0.2

Host oc2
    hostname 10.0.0.3
```

The hostnames above need to match the private IP addresses of the created instances. The default config I've provided should create instances starting at 10.0.0.2 and increment.

You will also need to create a file ~/.oci/oci_cli_rc:
```
[DEFAULT]
compartment-id = ocid1.tenancy.oc1..<tenancy_id>
bastion-id = ocid1.bastion.oc1.<oci_region>.<bastion_id>
```

You should now be able to ssh into your oci instance:
```
ssh oc1
```
