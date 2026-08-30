# Staging Environment

## Purpose

This folder creates the staging Kubernetes node VMs in Proxmox.

Terraform will create these VMs:

    staging-cp-01
    staging-worker-01
    staging-worker-02

## VM Layout

    staging-cp-01       control-plane   2 vCPU   4096 MB RAM   40 GB disk   192.168.20.11
    staging-worker-01   worker          2 vCPU   4096 MB RAM   40 GB disk   192.168.20.21
    staging-worker-02   worker          2 vCPU   4096 MB RAM   40 GB disk   192.168.20.22

## File to Edit Before Running

Before running Terraform later, copy:

    terraform.tfvars.example

to:

    terraform.tfvars

Command:

    cp terraform.tfvars.example terraform.tfvars

Then edit terraform.tfvars and replace:

    REPLACE_WITH_YOUR_PROXMOX_IP_OR_DNS
    REPLACE_WITH_YOUR_PROXMOX_API_TOKEN
    REPLACE_WITH_YOUR_PROXMOX_NODE_NAME
    REPLACE_WITH_YOUR_SSH_PUBLIC_KEY

## Commands to Run Later

Run these commands from this folder:

    cd environments/staging
    terraform init
    terraform validate
    terraform plan
    terraform apply

Do not run apply until you are ready to create real staging VMs in Proxmox.

## Verify Later

After apply, check Proxmox UI and confirm:

    staging-cp-01 is running
    staging-worker-01 is running
    staging-worker-02 is running

Then test SSH:

    ssh ubuntu@192.168.20.11
    ssh ubuntu@192.168.20.21
    ssh ubuntu@192.168.20.22

## Rollback Later

To delete the staging VMs:

    terraform destroy
