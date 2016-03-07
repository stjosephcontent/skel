# skel
This skeleton repo was created to help get you started on your deployment. 

<img src="http://i1015.photobucket.com/albums/af274/thirteen-black-cats/skeleton.png" />

# Files

## /git

In the /git folder, you can place these files in the appropriate root .git folders. 

crypt.sh - TODO: Description goes here
pre-commit & prepare-commit-msg - these will run before your commit in git.

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
TODO: Description goes here

## /deploy

This folder contains the ansible script. TODO: more descript.

All files are to be included. Place new deployments in roles. 

