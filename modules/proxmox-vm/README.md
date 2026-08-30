# Proxmox VM Terraform Module

## Purpose

This Terraform module creates Ubuntu virtual machines on Proxmox VE.

It is used by environment folders such as:

```text
environments/dev
environments/staging
environments/prod
```

## What This Module Does

This module creates:

- Proxmox virtual machines
- VM disks from Ubuntu cloud image
- Network interfaces
- Static IP configuration
- Cloud-init user-data files
- Linux user with SSH access
- QEMU guest agent installation
- Basic Linux packages

## What This Module Does Not Do

This module does not install Kubernetes.

Kubernetes setup happens later through:

```text
kp-ansible-bootstrap
kp-k8s-platform
```

## Required Proxmox Setup

Before this module is executed later, Proxmox must have:

- A working Proxmox VE node
- A datastore for VM disks
- A datastore for downloaded cloud images
- A datastore with Snippets enabled
- A network bridge such as vmbr0
- API token access for Terraform
- SSH access from your machine to the Proxmox node

## Security

Do not put real API tokens, private keys, or passwords in this module.

Use variables and local `terraform.tfvars` files instead.
