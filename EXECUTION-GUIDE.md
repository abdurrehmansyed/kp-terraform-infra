# Execution Guide - kp-terraform-infra

## Purpose

This guide explains how to execute the Terraform infrastructure repository later.

This document is written for beginners. Follow it step by step.

This repository creates Ubuntu 24.04 virtual machines on Proxmox VE.

Terraform creates the VMs only.

Terraform does not install Kubernetes.

Kubernetes will be installed later using other repositories.

## What This Repository Creates

This repository is designed to create these Proxmox VMs.

Development environment:

    dev-cp-01
    dev-worker-01
    dev-worker-02

Staging environment:

    staging-cp-01
    staging-worker-01
    staging-worker-02

Production environment:

    prod-cp-01
    prod-cp-02
    prod-cp-03
    prod-worker-01
    prod-worker-02
    prod-worker-03

Each environment is separate.

You can run only dev first.

You do not need to run staging or prod immediately.

## Recommended Execution Order

Run the environments in this order:

    1. dev
    2. staging
    3. prod

Start with dev because it is smaller and safer.

## What You Need Before Running Terraform

Before running Terraform, you need:

    1. A Proxmox VE server
    2. A Proxmox login account
    3. A Proxmox API token for Terraform
    4. Terraform installed on your computer
    5. Git installed on your computer
    6. SSH key created on your computer
    7. A Proxmox storage location for VM disks
    8. A Proxmox storage location with Snippets enabled
    9. A Proxmox network bridge such as vmbr0
    10. Internet access from Proxmox to download Ubuntu cloud image

## Step 1 - Install Terraform on Your Computer

On macOS, the easiest method is Homebrew.

Check if Homebrew exists:

    brew --version

If Homebrew is missing, install it from the official Homebrew website.

After Homebrew is installed, install Terraform:

    brew tap hashicorp/tap
    brew install hashicorp/tap/terraform

Verify Terraform:

    terraform version

Expected result:

    Terraform v1.x.x

## Step 2 - Install Git

Check Git:

    git --version

If Git is missing, install Apple Command Line Tools:

    xcode-select --install

Then check again:

    git --version

## Step 3 - Create SSH Key on Your Computer

Terraform will place your SSH public key into the Ubuntu VMs.

Check if you already have an SSH key:

    ls ~/.ssh

Look for:

    id_ed25519
    id_ed25519.pub

If you do not have one, create it:

    ssh-keygen -t ed25519 -C "your-email@example.com"

Press Enter for the default file location.

View your public key:

    cat ~/.ssh/id_ed25519.pub

Copy the full output. It should start with:

    ssh-ed25519

You will paste this into terraform.tfvars later.

Do not copy your private key.

Private key file:

    ~/.ssh/id_ed25519

Public key file:

    ~/.ssh/id_ed25519.pub

Only the public key is used in Terraform.

## Step 4 - Prepare Proxmox Storage

Log in to Proxmox web UI.

Usually the URL looks like:

    https://YOUR_PROXMOX_IP:8006

Example:

    https://192.168.1.10:8006

You need to know these Proxmox values:

    Proxmox node name
    VM disk storage name
    Cloud image storage name
    Snippets storage name
    Network bridge name

Common examples:

    proxmox_node_name = "pve"
    image_datastore_id = "local"
    vm_datastore_id = "local-lvm"
    snippet_datastore_id = "local"
    cloud_init_datastore_id = "local-lvm"
    network_bridge = "vmbr0"

Your environment may be different.

## Step 5 - Enable Snippets in Proxmox

Cloud-init user-data requires Proxmox Snippets.

In Proxmox UI:

    1. Click Datacenter
    2. Click Storage
    3. Click your storage, usually local
    4. Click Edit
    5. Under Content, make sure Snippets is selected
    6. Save

If Snippets is not enabled, Terraform cannot upload cloud-init user-data files.

## Step 6 - Create Proxmox API Token

In Proxmox UI:

    1. Click Datacenter
    2. Click Permissions
    3. Click API Tokens
    4. Click Add
    5. Select a user
    6. Token ID example: kp-terraform
    7. Uncheck Privilege Separation if you are testing in a home lab
    8. Click Add
    9. Copy the token value immediately

The token format used by Terraform should look like this:

    user@realm!tokenid=secret

Example:

    root@pam!kp-terraform=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx

Do not commit this token to GitHub.

## Step 7 - Clone This Repository

On your computer:

    cd ~/Desktop
    git clone https://github.com/abdurrehmansyed/kp-terraform-infra.git
    cd kp-terraform-infra

## Step 8 - Start With Dev

Go to the dev Terraform folder:

    cd environments/dev

Create your local Terraform variables file:

    cp terraform.tfvars.example terraform.tfvars

Open the file:

    nano terraform.tfvars

Or use VS Code:

    code terraform.tfvars

## Step 9 - Replace Values in terraform.tfvars

In this file:

    environments/dev/terraform.tfvars

Replace this:

    proxmox_endpoint = "https://REPLACE_WITH_YOUR_PROXMOX_IP_OR_DNS:8006/"

With your Proxmox URL.

Example:

    proxmox_endpoint = "https://192.168.1.10:8006/"

Replace this:

    proxmox_api_token = "REPLACE_WITH_YOUR_PROXMOX_API_TOKEN"

With your real Proxmox API token.

Example:

    proxmox_api_token = "root@pam!kp-terraform=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

Replace this:

    proxmox_node_name = "REPLACE_WITH_YOUR_PROXMOX_NODE_NAME"

With your Proxmox node name.

Example:

    proxmox_node_name = "pve"

Replace this:

    "REPLACE_WITH_YOUR_SSH_PUBLIC_KEY"

With your SSH public key.

Example:

    ssh_public_keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIExampleKeyHere your-email@example.com"
    ]

Check storage names.

If your Proxmox uses local and local-lvm, you may leave these:

    image_datastore_id = "local"
    vm_datastore_id = "local-lvm"
    snippet_datastore_id = "local"
    cloud_init_datastore_id = "local-lvm"

Check bridge name.

If your Proxmox uses vmbr0, leave:

    network_bridge = "vmbr0"

Save the file.

## Step 10 - Review Dev VM IPs Before Running

The dev VM IPs are defined in:

    environments/dev/main.tf

Default values:

    dev-cp-01       192.168.10.11
    dev-worker-01   192.168.10.21
    dev-worker-02   192.168.10.22
    gateway         192.168.10.1

If your home/lab network is different, edit these IP addresses before running Terraform.

For example, if your network is 192.168.1.0/24, you may use:

    dev-cp-01       192.168.1.111
    dev-worker-01   192.168.1.121
    dev-worker-02   192.168.1.122
    gateway         192.168.1.1

Make sure these IPs are not already being used.

## Step 11 - Initialize Terraform

From this folder:

    environments/dev

Run:

    terraform init

What this does:

    Downloads the Proxmox Terraform provider.
    Prepares the local Terraform working directory.

Expected result:

    Terraform has been successfully initialized

## Step 12 - Validate Terraform

Run:

    terraform validate

What this does:

    Checks whether the Terraform code is valid.

Expected result:

    Success! The configuration is valid.

## Step 13 - Preview What Terraform Will Create

Run:

    terraform plan

What this does:

    Shows what Terraform wants to create in Proxmox.

Review the output carefully.

You should see VMs similar to:

    dev-cp-01
    dev-worker-01
    dev-worker-02

If the plan looks wrong, do not continue.

Fix the files first.

## Step 14 - Create Dev VMs

Only run this when you are ready to create real VMs in Proxmox.

Run:

    terraform apply

Terraform will ask:

    Do you want to perform these actions?

Type:

    yes

Terraform will then create the dev VMs.

## Step 15 - Verify in Proxmox UI

Go to Proxmox UI.

Verify:

    dev-cp-01 exists
    dev-worker-01 exists
    dev-worker-02 exists
    All VMs are running
    IP addresses are correct
    QEMU guest agent is running

## Step 16 - Verify SSH Access

From your computer:

    ssh ubuntu@192.168.10.11
    ssh ubuntu@192.168.10.21
    ssh ubuntu@192.168.10.22

If you changed the IPs, use your updated IPs.

Expected result:

    You should log into each Ubuntu VM without a password.

## Step 17 - Check Cloud-Init Completed

SSH into a VM:

    ssh ubuntu@192.168.10.11

Then run:

    cat /var/log/kp-cloud-init.done

Expected result:

    cloud-init completed for dev-cp-01

Also check QEMU guest agent:

    systemctl status qemu-guest-agent

Expected result:

    active (running)

## Step 18 - Save Terraform Outputs

From:

    environments/dev

Run:

    terraform output

This will show VM names, VM IDs, IPs, and roles.

These outputs will help create Ansible inventory later.

## Step 19 - Run Staging Later

After dev works, move to staging:

    cd ../staging
    cp terraform.tfvars.example terraform.tfvars

Edit:

    terraform.tfvars

Replace the same values as dev.

Then run:

    terraform init
    terraform validate
    terraform plan
    terraform apply

## Step 20 - Run Production Later

After staging works, move to prod:

    cd ../prod
    cp terraform.tfvars.example terraform.tfvars

Edit:

    terraform.tfvars

Replace the same values as dev and staging.

Then run:

    terraform init
    terraform validate
    terraform plan
    terraform apply

Production creates six VMs, so make sure Proxmox has enough CPU, memory, and storage.

## How to Destroy Dev VMs

Only do this if you want to delete the dev VMs.

From:

    environments/dev

Run:

    terraform destroy

Terraform will ask for confirmation.

Type:

    yes

This deletes the dev VMs.

## Important Files

Dev environment:

    environments/dev/main.tf
    environments/dev/terraform.tfvars.example
    environments/dev/terraform.tfvars

Staging environment:

    environments/staging/main.tf
    environments/staging/terraform.tfvars.example
    environments/staging/terraform.tfvars

Production environment:

    environments/prod/main.tf
    environments/prod/terraform.tfvars.example
    environments/prod/terraform.tfvars

Reusable module:

    modules/proxmox-vm/main.tf
    modules/proxmox-vm/variables.tf
    modules/proxmox-vm/outputs.tf
    modules/proxmox-vm/cloud-init/user-data.yaml.tftpl

## Files You Must Never Commit

Never commit:

    terraform.tfvars
    *.tfstate
    *.tfstate.*
    private SSH keys
    Proxmox API tokens
    passwords

These are ignored by .gitignore.

## Common Problems

Problem:

    Terraform cannot connect to Proxmox.

Check:

    proxmox_endpoint is correct
    proxmox_api_token is correct
    Proxmox is reachable from your computer
    Proxmox port 8006 is open

Problem:

    Terraform fails uploading cloud-init snippet.

Check:

    Snippets are enabled on the selected datastore
    snippet_datastore_id is correct
    Proxmox token has enough permission

Problem:

    VM is created but SSH does not work.

Check:

    SSH public key is correct
    IP address is reachable
    cloud-init finished
    VM network bridge is correct
    gateway is correct

Problem:

    VM has no IP.

Check:

    IP address and gateway in main.tf
    network_bridge value
    Proxmox VM network interface
    cloud-init status inside VM

Problem:

    Terraform says VM ID already exists.

Fix:

    Edit environments/dev/main.tf
    Change vm_id values to unused Proxmox VM IDs

## Next Repository After This

After Terraform creates the VMs, continue with:

    kp-ansible-bootstrap

That repository will prepare the Ubuntu servers for Kubernetes.
