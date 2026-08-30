# Production Environment

## Purpose

This folder creates the production Kubernetes node VMs in Proxmox.

Terraform will create these VMs:

    prod-cp-01
    prod-cp-02
    prod-cp-03
    prod-worker-01
    prod-worker-02
    prod-worker-03

## VM Layout

    prod-cp-01       control-plane   2 vCPU   4096 MB RAM   40 GB disk   192.168.30.11
    prod-cp-02       control-plane   2 vCPU   4096 MB RAM   40 GB disk   192.168.30.12
    prod-cp-03       control-plane   2 vCPU   4096 MB RAM   40 GB disk   192.168.30.13
    prod-worker-01   worker          2 vCPU   4096 MB RAM   40 GB disk   192.168.30.21
    prod-worker-02   worker          2 vCPU   4096 MB RAM   40 GB disk   192.168.30.22
    prod-worker-03   worker          2 vCPU   4096 MB RAM   40 GB disk   192.168.30.23

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

    cd environments/prod
    terraform init
    terraform validate
    terraform plan
    terraform apply

Do not run apply until you are ready to create real production VMs in Proxmox.

Production creates six VMs, so confirm Proxmox has enough CPU, RAM, and storage.

## Verify Later

After apply, check Proxmox UI and confirm:

    prod-cp-01 is running
    prod-cp-02 is running
    prod-cp-03 is running
    prod-worker-01 is running
    prod-worker-02 is running
    prod-worker-03 is running

Then test SSH:

    ssh ubuntu@192.168.30.11
    ssh ubuntu@192.168.30.12
    ssh ubuntu@192.168.30.13
    ssh ubuntu@192.168.30.21
    ssh ubuntu@192.168.30.22
    ssh ubuntu@192.168.30.23

## Rollback Later

To delete the production VMs:

    terraform destroy
