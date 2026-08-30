# Troubleshooting - kp-terraform-infra

## Purpose

This document helps troubleshoot common Terraform and Proxmox problems.

Use this guide when Terraform init, validate, plan, apply, SSH, cloud-init, or Proxmox VM creation fails.

## Important Rule

Do not guess.

Always check:

    1. The exact error message
    2. The folder you are running from
    3. The file you edited
    4. The value you replaced
    5. The Proxmox UI
    6. The Terraform command output

## Correct Folder to Run Terraform

Terraform must be run from an environment folder.

Correct:

    cd environments/dev
    terraform init
    terraform validate
    terraform plan

Incorrect:

    cd kp-terraform-infra
    terraform plan

If you run Terraform from the wrong folder, Terraform may not find the correct files.

## Problem 1 - Terraform Command Not Found

### Symptom

You run:

    terraform version

And see:

    command not found: terraform

### Cause

Terraform is not installed.

### Fix on macOS

Install Terraform using Homebrew:

    brew tap hashicorp/tap
    brew install hashicorp/tap/terraform

Then verify:

    terraform version

Expected result:

    Terraform v1.x.x

## Problem 2 - Git Command Not Found

### Symptom

You run:

    git --version

And see:

    command not found: git

### Cause

Git or Apple Command Line Tools are not installed.

### Fix on macOS

Run:

    xcode-select --install

Then verify:

    git --version

## Problem 3 - Terraform Init Fails With Provider Error

### Symptom

Terraform shows an error similar to:

    Failed to query available provider packages
    hashicorp/proxmox does not have a provider

### Cause

Terraform is looking for the wrong Proxmox provider.

This project uses:

    bpg/proxmox

Not:

    hashicorp/proxmox

### Fix

Make sure this file exists:

    modules/proxmox-vm/versions.tf

It should declare:

    source = "bpg/proxmox"

Also make sure each environment has:

    environments/dev/versions.tf
    environments/staging/versions.tf
    environments/prod/versions.tf

Each should also use:

    source = "bpg/proxmox"

Then run again from the environment folder:

    terraform init

## Problem 4 - Terraform Init Fails Because of Internet

### Symptom

Terraform cannot download the provider.

### Cause

Your computer cannot reach the Terraform provider registry.

### Checks

Run:

    ping registry.terraform.io

Also check your internet connection.

### Fix

Make sure your computer has internet access.

Then run:

    terraform init

## Problem 5 - Terraform Validate Fails

### Symptom

You run:

    terraform validate

And Terraform reports invalid configuration.

### Cause

There may be a typo in a Terraform file.

### Fix

Read the exact file and line number from the error.

Common files to check:

    environments/dev/main.tf
    environments/dev/variables.tf
    modules/proxmox-vm/main.tf
    modules/proxmox-vm/variables.tf

After fixing, run:

    terraform fmt -recursive
    terraform validate

## Problem 6 - Terraform Format Check Fails in GitHub Actions

### Symptom

GitHub Actions fails on:

    terraform fmt -check -recursive

### Cause

Terraform files are valid, but formatting does not match Terraform style.

### Fix

Run this locally from the repo root:

    terraform fmt -recursive

Then commit and push:

    git status
    git add .
    git commit -m "Format Terraform files"
    git push origin main

## Problem 7 - Terraform Cannot Connect to Proxmox

### Symptom

Terraform plan or apply fails when connecting to Proxmox.

### Possible Causes

    Proxmox endpoint is wrong
    Proxmox API token is wrong
    Proxmox server is offline
    Your computer cannot reach Proxmox
    Port 8006 is blocked
    Proxmox certificate issue

### Check terraform.tfvars

Open:

    environments/dev/terraform.tfvars

Check:

    proxmox_endpoint
    proxmox_api_token
    proxmox_insecure

Example:

    proxmox_endpoint = "https://192.168.1.10:8006/"
    proxmox_insecure = true

### Test From Browser

Open:

    https://YOUR_PROXMOX_IP:8006

If browser cannot open Proxmox, Terraform will not work either.

## Problem 8 - Invalid Proxmox API Token

### Symptom

Terraform shows authentication or permission errors.

### Cause

The API token is wrong or does not have enough permission.

### Token Format

The token should look like:

    root@pam!kp-terraform=TOKEN_SECRET

Common mistake:

    Missing user
    Missing realm
    Missing token ID
    Missing equals sign
    Missing token secret

Correct format:

    user@realm!tokenid=secret

Example:

    root@pam!kp-terraform=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx

### Fix

Create a new token in Proxmox UI.

Then update:

    terraform.tfvars

Do not commit terraform.tfvars.

## Problem 9 - Snippets Upload Fails

### Symptom

Terraform fails when creating cloud-init user-data file.

### Possible Error Area

    proxmox_virtual_environment_file
    content_type = "snippets"

### Cause

Snippets are not enabled on the datastore.

### Fix in Proxmox UI

    1. Click Datacenter
    2. Click Storage
    3. Click local
    4. Click Edit
    5. Under Content, enable Snippets
    6. Save

Then run:

    terraform plan

## Problem 10 - Storage Name Is Wrong

### Symptom

Terraform says datastore does not exist.

### Cause

The storage name in terraform.tfvars does not match Proxmox.

### Check Proxmox UI

    1. Click Datacenter
    2. Click Storage
    3. Note exact storage names

Common names:

    local
    local-lvm

### Fix

Edit:

    terraform.tfvars

Check these values:

    image_datastore_id
    vm_datastore_id
    snippet_datastore_id
    cloud_init_datastore_id

## Problem 11 - Network Bridge Is Wrong

### Symptom

VM is created but has no network or cannot be reached.

### Cause

The network bridge name is wrong.

### Check Proxmox UI

    1. Click your Proxmox node
    2. Click System
    3. Click Network
    4. Find Linux Bridge name

Common name:

    vmbr0

### Fix

Edit:

    terraform.tfvars

Set:

    network_bridge = "vmbr0"

Or use your real bridge name.

## Problem 12 - VM ID Already Exists

### Symptom

Terraform fails because VM ID already exists.

### Cause

Proxmox already has a VM using that ID.

### Fix

Edit the environment main.tf file.

For dev:

    environments/dev/main.tf

Change the vm_id values to unused IDs.

Example:

    vm_id = 101

Change to:

    vm_id = 150

Then run:

    terraform plan

## Problem 13 - IP Address Already Used

### Symptom

VM boots, but network conflict happens.

### Cause

The static IP is already used by another device.

### Fix

Edit:

    environments/dev/main.tf

Change:

    ip_address
    gateway

Example:

    ip_address = "192.168.1.111"
    gateway    = "192.168.1.1"

Make sure the IP is free before using it.

## Problem 14 - VM Created But SSH Does Not Work

### Symptom

You run:

    ssh ubuntu@192.168.10.11

And it fails.

### Possible Causes

    Wrong IP address
    Wrong SSH username
    SSH public key was wrong
    Cloud-init did not finish
    VM network is wrong
    Gateway is wrong
    VM is not fully booted

### Checks

In Proxmox UI:

    1. Open the VM console
    2. Confirm VM booted
    3. Confirm IP address
    4. Confirm cloud-init finished

From your computer:

    ping 192.168.10.11

Then try SSH again:

    ssh ubuntu@192.168.10.11

## Problem 15 - Cloud-Init Did Not Finish

### Symptom

VM exists, but user, SSH key, or packages are missing.

### Check Inside VM

Use Proxmox console and run:

    cloud-init status --long

Check log:

    sudo cat /var/log/cloud-init-output.log

Check project marker file:

    cat /var/log/kp-cloud-init.done

Expected result:

    cloud-init completed for VM_NAME

### Fix

If cloud-init failed because of bad user-data, fix:

    modules/proxmox-vm/cloud-init/user-data.yaml.tftpl

Then recreate the VM.

## Problem 16 - QEMU Guest Agent Not Running

### Symptom

Proxmox does not show VM IP or guest information.

### Check Inside VM

SSH or console into the VM:

    systemctl status qemu-guest-agent

### Fix

Start it:

    sudo systemctl enable qemu-guest-agent
    sudo systemctl start qemu-guest-agent

If it is missing:

    sudo apt update
    sudo apt install -y qemu-guest-agent

## Problem 17 - GitHub Actions Failed But Local Works

### Cause

GitHub Actions may use a clean environment.

Local hidden files may not exist in GitHub.

### Check

Look at the exact failing step in GitHub Actions.

Common issues:

    Terraform formatting
    Missing provider declaration
    Markdown empty file
    YAML syntax problem

### Fix

Fix the file locally, commit, and push again.

## Problem 18 - Accidentally Created Wrong VMs

### Fix

Go to the environment folder that created them.

Example:

    cd environments/dev

Preview destroy:

    terraform plan -destroy

Destroy:

    terraform destroy

Only type yes if you are sure.

## Problem 19 - Accidentally Committed terraform.tfvars

### Why This Is Bad

terraform.tfvars may contain:

    Proxmox API token
    internal IP addresses
    SSH public key
    environment-specific values

### Fix

Remove it from Git tracking:

    git rm --cached environments/dev/terraform.tfvars

Commit the removal:

    git commit -m "Remove local Terraform variables file"

Push:

    git push origin main

Then rotate the Proxmox API token if it was exposed publicly.

## Problem 20 - Need to Start Over With Dev

If you want to remove dev and start again:

    cd environments/dev
    terraform destroy

Then confirm in Proxmox UI that the VMs are gone.

Then run:

    terraform apply

## Useful Commands

Show repo status:

    git status

Format Terraform:

    terraform fmt -recursive

Initialize Terraform:

    terraform init

Validate Terraform:

    terraform validate

Preview changes:

    terraform plan

Apply changes:

    terraform apply

Destroy environment:

    terraform destroy

Show outputs:

    terraform output

## When to Ask for Help

Ask for help if:

    Terraform error is unclear
    Proxmox permissions are confusing
    VM boots but network does not work
    Cloud-init fails
    SSH does not work after checking IP and keys
    GitHub Actions fail and the error is not obvious

When asking for help, include:

    The command you ran
    The folder you ran it from
    The full error message
    Which environment you are using
    Whether the VM exists in Proxmox
