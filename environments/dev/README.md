# Dev Environment

## Purpose

This folder defines the Terraform code for the Kubernetes Platform dev environment.

It creates three Ubuntu 24.04 LTS virtual machines in Proxmox:

```text
dev-cp-01
dev-worker-01
dev-worker-02
```

## VM Layout

| VM Name | Role | vCPU | Memory | Disk | Example IP |
|---|---|---:|---:|---:|---|
| dev-cp-01 | control-plane | 2 | 4096 MB | 40 GB | 192.168.10.11 |
| dev-worker-01 | worker | 2 | 4096 MB | 40 GB | 192.168.10.21 |
| dev-worker-02 | worker | 2 | 4096 MB | 40 GB | 192.168.10.22 |

## Before Running Later

Do not execute this yet unless you are ready to create VMs in Proxmox.

When ready later:

```bash
cd environments/dev
cp terraform.tfvars.example terraform.tfvars
```

Edit:

```text
terraform.tfvars
```

Replace every `REPLACE_WITH_...` value.

## Future Execution

```bash
terraform init
terraform validate
terraform plan
terraform apply
```

## Future Validation

After Terraform creates the VMs, verify in Proxmox UI that:

```text
dev-cp-01 exists
dev-worker-01 exists
dev-worker-02 exists
all VMs are running
each VM has the expected static IP
you can SSH into each VM
```

Example SSH command:

```bash
ssh ubuntu@192.168.10.11
```

## Rollback Later

To remove the dev VMs later:

```bash
terraform destroy
```

Only run destroy when you intentionally want to delete the dev VMs.
