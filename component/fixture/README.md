Skyflow Fixture CLI
==============================================

**Skyflow Docker CLI** is a component for [Skyflow CLI][1].
It's a powerful tool for managing a docker-based development environment.

User fixtures link
----------------------------------------------

https://anniversaire-celebrite.com


Company fixtures link
----------------------------------------------

https://fr.wikipedia.org/wiki/Classement_mondial_des_entreprises_leader_par_secteur






Prerequisites
----------------------------------------------

* [Skyflow CLI][1]
* Skyflow docker CLI uses version `2.0` of the Compose file format. You need to install at least version `1.10.0+` of [Docker Engine release][2]. 

Installation
----------------------------------------------

```bash
skyflow update
```
```bash
skyflow install docker
```

This command will install the `skyflow-docker` command line.


Usage
----------------------------------------------

###### _Get version_
```bash
skyflow-docker -v
```

###### _Get help_
```bash
skyflow-docker -h
```

#### Containers

To create a development environment for your application, you must select a container with this command:
```bash
skyflow-docker create
```
A docker folder will be created in the current directory. If this folder already exists, use the **`-f`** option to overwrite this folder.
If no container suits you, you can choose an empty container.

###### _Build, create and start containers:_ `skyflow-docker up`

After selecting your container, you can build your environment with the command:

```bash
skyflow-docker up
```

Use the commands `skyflow-docker stop` `skyflow-docker start` `skyflow-docker restart` to stop, start and restart containers.

###### _Execute commands into containers_

Sometimes you will need to execute commands inside the containers. To do this, you have several possibilities.

_Enter into container_
```bash
skyflow-docker mycontainer:shell
# Or
skyflow-docker mycontainer:enter
```

_Execute simple command_
```bash
skyflow-docker mycontainer:exec "apt-get update"
```

_Execute update command_
```bash
skyflow-docker mycontainer:update
```

_Install packages into container_
```bash
skyflow-docker mycontainer:install "package1 package2 ..."
```

_Remove packages from container_
```bash
skyflow-docker mycontainer:remove "package1 package2 ..."
```

The `update`, `install` and `remove` commands will detect the container type and use the correct command.
For example, for an alpine-based container, the `update` command will use `apk update`.
For an alpine-debian container, the `update` command will use `apt-get update`.

#### Playbook

When a container is running you can install packages. 
These packages are available as long as the container is running. 
But once the container stops, all installed packages are lost. 
With `playbook` you keep a command history and so you can install all packages with one command:

```bash
skyflow-docker playbook
```

#### Compose

Sometimes your application needs other services to work as a database, a mail server, ...
**`Compose`** mechanism makes it possible to obtain these services.

_List containers available_

```bash
skyflow-docker ls compose
```

_Use a container_

```bash
skyflow-docker use <compose_name>
```

[1]: https://github.com/franckdiomande/Skyflow-cli/blob/master/README.md
[2]: https://docs.docker.com/compose/compose-file