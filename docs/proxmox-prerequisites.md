# Proxmox Prerequisites

## Purpose

This document explains what must be prepared in Proxmox before running Terraform.

Read this before executing any Terraform command.

Terraform will not work correctly unless Proxmox has the required storage, network bridge, permissions, and API token.

## What You Need

Before running Terraform, you need:

    1. A working Proxmox VE server
    2. Access to the Proxmox web UI
    3. A Proxmox node name
    4. A datastore for VM disks
    5. A datastore for cloud images
    6. A datastore with Snippets enabled
    7. A network bridge such as vmbr0
    8. A Proxmox API token
    9. SSH access from your computer to the Proxmox host
    10. Terraform installed on your computer

## Step 1 - Open Proxmox Web UI

Open a browser and go to your Proxmox server.

Example:

    https://192.168.1.10:8006

Log in with your Proxmox username and password.

## Step 2 - Find Your Proxmox Node Name

In the Proxmox UI, look at the left side.

You should see something like:

    Datacenter
      pve

The node name is the name under Datacenter.

Common example:

    pve

You will use this value in terraform.tfvars:

    proxmox_node_name = "pve"

If your node has a different name, use your real node name.

## Step 3 - Find Your Storage Names

In Proxmox UI:

    1. Click Datacenter
    2. Click Storage

Look for storage names.

Common home lab examples:

    local
    local-lvm

This project assumes:

    image_datastore_id = "local"
    vm_datastore_id = "local-lvm"
    snippet_datastore_id = "local"
    cloud_init_datastore_id = "local-lvm"

Meaning:

    local       stores downloaded Ubuntu cloud images and snippets
    local-lvm   stores VM disks and cloud-init disks

Your Proxmox setup may be different.

If your storage names are different, update terraform.tfvars before running Terraform.

## Step 4 - Enable Snippets

Cloud-init user-data files require Proxmox Snippets.

In Proxmox UI:

    1. Click Datacenter
    2. Click Storage
    3. Click local
    4. Click Edit
    5. Find Content
    6. Make sure Snippets is selected
    7. Click OK or Save

If Snippets is not enabled, Terraform may fail when uploading cloud-init files.

## Step 5 - Find Your Network Bridge

In Proxmox UI:

    1. Click your Proxmox node
    2. Click System
    3. Click Network

Look for a Linux Bridge.

Common example:

    vmbr0

You will use this value in terraform.tfvars:

    network_bridge = "vmbr0"

If your bridge has a different name, use your real bridge name.

## Step 6 - Create Proxmox API Token

Terraform uses an API token to talk to Proxmox.

In Proxmox UI:

    1. Click Datacenter
    2. Click Permissions
    3. Click API Tokens
    4. Click Add

Use these example values:

    User: root@pam
    Token ID: kp-terraform
    Privilege Separation: unchecked for a simple home lab

Click Add.

Proxmox will show you the token secret one time.

Copy it immediately.

The final API token format should look like:

    root@pam!kp-terraform=YOUR_TOKEN_SECRET

You will paste this into terraform.tfvars:

    proxmox_api_token = "root@pam!kp-terraform=YOUR_TOKEN_SECRET"

Do not commit this value to GitHub.

## Step 7 - Confirm API Token Permissions

For a simple home lab, using root@pam with privilege separation unchecked is the easiest option.

For a more secure setup, create a dedicated Terraform user and assign only the required permissions.

Beginner recommendation:

    Use root@pam token for the first lab build.
    Improve permissions later after the project works.

## Step 8 - Confirm SSH Access to Proxmox

From your Mac terminal, test SSH access to Proxmox:

    ssh root@YOUR_PROXMOX_IP

Example:

    ssh root@192.168.1.10

If SSH works, exit:

    exit

If SSH does not work, fix SSH access before running Terraform.

## Step 9 - Confirm Your SSH Public Key Exists

On your Mac:

    ls ~/.ssh

Look for:

    id_ed25519
    id_ed25519.pub

If missing, create a key:

    ssh-keygen -t ed25519 -C "your-email@example.com"

View your public key:

    cat ~/.ssh/id_ed25519.pub

Copy the full output.

It should start with:

    ssh-ed25519

You will paste it into terraform.tfvars:

    ssh_public_keys = [
      "ssh-ed25519 YOUR_PUBLIC_KEY_HERE your-email@example.com"
    ]

Do not paste your private key.

## Step 10 - Confirm Terraform Is Installed

Check Terraform:

    terraform version

If Terraform is missing on macOS, install it with Homebrew:

    brew tap hashicorp/tap
    brew install hashicorp/tap/terraform

Then check again:

    terraform version

## Step 11 - Check IP Address Plan

Before running Terraform, make sure the VM IP addresses are correct for your network.

Default dev IPs:

    dev-cp-01       192.168.10.11
    dev-worker-01   192.168.10.21
    dev-worker-02   192.168.10.22
    gateway         192.168.10.1

Default staging IPs:

    staging-cp-01       192.168.20.11
    staging-worker-01   192.168.20.21
    staging-worker-02   192.168.20.22
    gateway             192.168.20.1

Default prod IPs:

    prod-cp-01       192.168.30.11
    prod-cp-02       192.168.30.12
    prod-cp-03       192.168.30.13
    prod-worker-01   192.168.30.21
    prod-worker-02   192.168.30.22
    prod-worker-03   192.168.30.23
    gateway          192.168.30.1

If your network is different, update the IPs in:

    environments/dev/main.tf
    environments/staging/main.tf
    environments/prod/main.tf

Do not use IPs that are already assigned to other devices.

## Step 12 - First Environment to Run Later

Start with dev first.

Do not start with prod.

Recommended order:

    1. environments/dev
    2. environments/staging
    3. environments/prod

## Pre-Execution Checklist

Before running Terraform, confirm:

    [ ] Proxmox web UI works
    [ ] Proxmox node name is known
    [ ] Storage names are known
    [ ] Snippets are enabled
    [ ] Network bridge is known
    [ ] API token is created
    [ ] SSH to Proxmox works
    [ ] SSH public key exists
    [ ] Terraform is installed
    [ ] VM IP addresses are correct
    [ ] terraform.tfvars is created locally
    [ ] terraform.tfvars is not committed to GitHub

## Summary

Do not run Terraform until the Proxmox prerequisites are ready.

After this document is complete, follow:

    EXECUTION-GUIDE.md
