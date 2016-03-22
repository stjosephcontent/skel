# skel
This skeleton repo was created to help get you started on your deployment. 

<img src="http://i1015.photobucket.com/albums/af274/thirteen-black-cats/skeleton.png" width="243" />

# Files

## /git

In the /git folder in this repo, you can place these files in the appropriate target repo `./.git` locations. 

`crypt.sh` - This file includes crypt logic for ./listcrypt, ./encrypt, and ./decrypt. It decides what files should be encrypted, and makes the corresponding helper files work.

`pre-commit` - This makes use of `crypt.sh` and disallows a dev from commiting sensitive info

`prepare-commit-msg` - will automatically parse out the Jira ticket number from an appropriately named branch

## ./a {script} {target}

Runs a script found in ./deploy and sets the target to a group defined in ./deploy/inventories/aws. ./a creates a global Ansible variable called target which the playbooks often make use of to include a specific set of files in ./deploy/vars/*.

### Example commands

Run ./deploy/deploy.yml with *target* set to "prod"
`./a deploy prod`

Run ./deploy/setup.yml with *target* set to "stage"
`./a setup stage`

## ./fleet {target} {command}

Runs ad-hoc commands against some or all of the hosts in `./deploy/inventories/aws`.

### Example commands

Ask all servers in the "stage" group what operating system they are
`./fleet stage uname -a`

Ask production servers what their hostnames are
`./fleet prod hostname --fqdn`

Ask all servers what their nginx conf files look like
`./fleet all 'cat /etc/nginx/sites-enabled/*'`

Notice above that we used single quotes to avoid shell expansion happening on our machine as opposed to the taget machine

## ./listcrypt
This command lists all files that are or should be encrypted, according to `./.git/crypt.sh`

## ./encrypt
This command encrypts any files that should be and are not encrypted, according to `./.git/crypt.sh`

## ./decrypt
This command decrypts all encrypted files that `./.git/crypt.sh` thinks should be encrypted.

##  ansible.cfg
This file allows dicts to be composes from several var files in ansible, avoiding unpleasant clobbering.

## /deploy

This folder contains all ansible data and logic called by `./a`, `./fleet`, and `./facts`

### deploy/group_vars

This files are automatically loaded, depending on what group you have targed in `./a` (ex: `./a deploy stage` will load group_vars/stage/*.yml). The "all" directory is always loaded

### deploy/inventories/aws

This file lists all your target hosts. Many apps will only have two: *stage* and *prod*. ./a understands this as a target, and refers to a host group. You should always target a host group, even if that group only consists of one host. While the inventory file is called aws, you may inlude non-amazon hosts.

### deploy/private/.gitignore

This file is required to ensure that vault_pass.txt never gets commited to VCS. It is, however, acceptable to cmmit vault_pass.txt.gpg or vault_pass.txt.asc

### deploy/private/vault_pass.txt

Used by ansible-vault to encrpyt and decrypt sensitive info

### deploy/private/vault_pass.txt.gpg

If you are part of the ops group, you will be able to decrpyt this file. If you are creating the repo, you will be creating vault_pass.txt and this file.

### deploy/roles/*

Use [ansible best practices](http://docs.ansible.com/ansible/playbooks_roles.html) for organizing your deployment code into roles.

