# skel
This skeleton repo was created to help get you started on your deployment. 

<img src="http://i1015.photobucket.com/albums/af274/thirteen-black-cats/skeleton.png" width="243" />

# Folders
## git/**

This folder contains files you should place in the `.git` folder in your target repo.

`.git/crypt.sh` - This file includes crypt logic for `./listcrypt`, `./encrypt`, and `./decrypt`. It decides what files should be encrypted, and makes the corresponding helper files work.

`.git/hooks/pre-commit` - This makes use of `crypt.sh` and prevents you from commiting sensitive info if it's not encrypted.

`.git/hooks/prepare-commit-msg` - will automatically parse out the Jira ticket number from an appropriately named branch, and add it to your commit message. This allows you to view all relevant commit messages in a given Jira ticket. The logic could be modified to look for assembla ticket numbers too.

## keys/{{person}}/*

People's public keys go here. This is to allow ops engineers a central repository for public keys. For deployment scripts to work, SSH+RSA authentication is needed.

## deploy/**

This folder contains all ansible data and logic called by `./a`, `./fleet`, and `./facts`. Use it to tweak and write deployment scripts using ansible.

### deploy/group_vars/{{group}}/*

This files are automatically loaded, depending on what group you have targed in `./a` (ex: `./a deploy stage` will load group_vars/stage/*.yml). The "all" directory is always loaded

### deploy/roles/*

Use [ansible best practices](http://docs.ansible.com/ansible/playbooks_roles.html) for organizing your deployment code into roles.

# Files
## a

** ./a {script} {target} **

Runs a script found in the `deploy` folder and sets the target to a group defined in `deploy/inventories/aws`.

### Example commands

Run `deploy/deploy.yml` with *target* set to "prod": 
`$ ./a deploy prod`

Run `deploy/setup.yml` with *target* set to "stage": 
`$ ./a setup stage`

## fleet

** ./fleet {target} {command} **

Runs ad-hoc commands against some or all of the hosts in `deploy/inventories/aws`.

### Example commands

Ask all servers in the "stage" group what operating system they are
`$ ./fleet stage uname -a`

Ask production servers what their hostnames are
`$ ./fleet prod hostname --fqdn`

Ask all servers what their nginx conf files look like
`$ ./fleet all 'cat /etc/nginx/sites-enabled/*'`

Notice above that we used single quotes to avoid shell expansion happening on our machine, but allowing it to happen on the target machine.

## listcrypt

This command lists all files that are or should be encrypted, according to `.git/crypt.sh`. It must be run from the root of the repo.
`$ ./listcrypt`

## encrypt

This command encrypts any files that should be and are not encrypted, according to `.git/crypt.sh`.
`$ ./encrypt`

## decrypt

This command decrypts all encrypted files that `.git/crypt.sh` thinks should be encrypted.
`$ ./decrypt`

## ansible.cfg

This file allows dicts to be composed from several var files in ansible, avoiding unpleasant clobbering. I write deployment scripts assuming this is the case, so you should include it at the root of your repo if you want deployment scripts to be well behaved.

### deploy/inventories/aws

This file lists all your target hosts. Many apps will only have two groups: *stage* and *prod*, each with only one host. `./a`. You should always target a host group (instead of directly targetting a host), even if that group only consists of one host.

example of good:
`./a deploy stage # targetting a host group`

example of bad:
`./a deploy example-host-01 # targetting a host directly`


### deploy/private/.gitignore

This file is required to ensure that `vault_pass.txt` never gets commited to VCS. It is, however, acceptable to commit `vault_pass.txt.gpg` or `vault_pass.txt.asc`

### deploy/private/vault_pass.txt

Used by ansible-vault to encrpyt and decrypt sensitive info

### deploy/private/vault_pass.txt.gpg

If you are part of the ops group, you will be able to decrpyt this file. If you are creating the repo, you will be creating `vault_pass.txt` and this file.

