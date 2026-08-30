# kp-terraform-infra

## Purpose

This repository contains Terraform code for provisioning virtual machines on Proxmox VE for the Kubernetes Platform project.

Terraform creates the virtual machines. Ansible and Kubernetes setup will happen later in separate repositories.

## Target Platform

This repository is designed for:

- Proxmox VE
- Ubuntu 24.04 LTS cloud image
- K3s Kubernetes nodes
- Separate dev, staging, and prod environments

## Environment Plan

Initial VM layout:

```text
dev:
  dev-cp-01
  dev-worker-01
  dev-worker-02

staging:
  staging-cp-01
  staging-worker-01
  staging-worker-02

prod:
  prod-cp-01
  prod-cp-02
  prod-cp-03
  prod-worker-01
  prod-worker-02
  prod-worker-03
```

Each environment is managed separately.

That means you can run Terraform for dev, staging, or prod independently.

## Current Status

This repository is part of the GitHub-first build phase.

The files are being created now so that the platform can be executed later.

Do not run Terraform until you are ready to create real VMs in Proxmox.

## Repository Structure

```text
kp-terraform-infra/
├── modules/
│   └── proxmox-vm/
│       ├── cloud-init/
│       │   └── user-data.yaml.tftpl
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│       └── README.md
└── environments/
    └── dev/
        ├── versions.tf
        ├── provider.tf
        ├── variables.tf
        ├── main.tf
        ├── outputs.tf
        ├── terraform.tfvars.example
        └── README.md
```

## What This Repository Creates

For each VM, Terraform will define:

- VM name
- VM ID
- CPU
- memory
- disk
- static IP address
- default gateway
- Proxmox storage
- Proxmox bridge
- cloud-init user data
- SSH public key access
- QEMU guest agent package

## What This Repository Does Not Do

This repository does not:

- Install Kubernetes
- Install K3s
- Configure Ansible
- Install Argo CD
- Deploy applications
- Configure monitoring
- Apply security policies

Those steps happen in later repositories.

## Future Execution Summary

When you are ready later, the dev environment will be executed like this:

```bash
cd environments/dev
cp terraform.tfvars.example terraform.tfvars
```

Then edit:

```text
terraform.tfvars
```

Replace every `REPLACE_WITH_...` value.

Then run:

```bash
terraform init
terraform validate
terraform plan
terraform apply
```

## Important Security Rule

Never commit this file:

```text
terraform.tfvars
```

It may contain real Proxmox tokens, IP addresses, and SSH keys.

Only commit:

```text
terraform.tfvars.example
```

## Next Step After Terraform

After Terraform creates the VMs, the next repository will be:

```text
kp-ansible-bootstrap
```

That repository will prepare Ubuntu servers for Kubernetes.
