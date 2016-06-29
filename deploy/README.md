# Deployment

This section describes how to deploy changes to servers or groups of servers. It explains how to use some helper commands, and tells you what's happening under the hood.

## concepts

when using `./a` to deploy, the system tracks three main things: The current git branch, the script, and the target. The current git branch means the branch currently checked out. The script is a verb (like deploy or setup) which corresponds to a YML file (ex: `deploy/setup.yml` or `deploy/deploy.yml`), and target is a host group which is made up of one or more hosts (ex: "stage", or "prod").

## mechanics

The helper scripts are wrappers around ansible and ansible-vault. They make certain assumptions about your setup, for exmaple, it assumes that the ansible inventory is in `./deploy/inventories/aws`. 

### deploy/**

This folder contains all ansible data and logic called by `./a`, `./fleet`, and `./facts`. You should not need to touch these files. It is the responsibility of the ops team to ensure there are no logical flaws here.

## Files

### a

*./a {script} {target}*

Runs a script found in the `deploy` folder and sets the target to a group defined in `deploy/inventories/aws`.

#### Example commands

Run `deploy/deploy.yml` with *target* set to "stage" and with *branch* set to the current git branch: 

```
$ ./a deploy stage
```

(This is, in fact, at the time of this writing, the only command developers will need to run for BIG)

### fleet

*./fleet {target} {command}*

Runs ad-hoc commands against some or all of the hosts in `deploy/inventories/aws`.

#### Example commands

Ask all servers in the "stage" group what operating system they are

```
$ ./fleet stage uname -a
```

Ask all servers what their nginx conf files look like
```
$ ./fleet all 'cat /etc/nginx/sites-enabled/*'
```

Notice above that we used single quotes to avoid shell expansion happening on our machine, but allowing it to happen on the target machine.

### facts

Get all facts about a given target:

```
$ ./facts stage
```

## Keeping sensitive info in version control

The new standard practice is to keep sensitive info in version control, encrypted. Encryption is handled using a symetric shared secret which is kept in `./deploy/private/vault_pass.txt`. Any file that contains the string "private", or exists in a folder called "private" is assumed to be private, and treated accordingly. The system will not let you commit anything to the repo matching that criteria, unless it has been encryped. The helper scripts below allow you to encrypt, decrypt, and examine current state.

### listcrypt

This command lists all files that are or should be encrypted.

```
$ ./listcrypt
```

### encrypt

This command encrypts any files that should be and are not encrypted.
```
$ ./encrypt
```

### decrypt

This command decrypts all encrypted files that it thinks should be encrypted.
```
$ ./decrypt
```

### deploy/private/vault_pass.txt
Used by ansible-vault to encrpyt and decrypt sensitive info. If you do not have this file, contact ops. 

### deploy/private/vault_pass.txt.gpg (or .asc)
The encrypted version of the above file


