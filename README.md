Skyflow CLI - Best friend of the developer
==============================================
**Skyflow CLI** is part of the [Skyflow project][1]. 
It aims to make life easier for the developer.

Prerequisites
----------------------------------------------
**Skyflow CLI** is developed in `shell` language. Which means that this tool is compatible with `Linux` and `Mac OS`. 
It uses `git` to synchronize components. In summary, you need:
* `git`
* `Linux` or `Mac OS`

Installation
----------------------------------------------

###### _With curl_

```bash
sudo curl -s https://raw.githubusercontent.com/skyflow-io/CLI/master/skyflow.sh -o /usr/local/bin/skyflow
```

```bash
sudo chmod +x /usr/local/bin/skyflow
```

###### _Manually_

1. Create skyflow.sh file: `touch skyflow.sh`
2. Copy [this content][2] and paste it into the `skyflow.sh` file
3. `sudo mv skyflow.sh /usr/bin/skyflow`
4. `sudo chmod +x /usr/bin/skyflow`

Usage
----------------------------------------------

###### _Get version_
```bash
skyflow -v
```

###### _Get help_
```bash
skyflow -h
```

#### Components

###### _Update components list_
```bash
skyflow update
```

###### _List components_
```bash
skyflow list
```

###### _Install component_
```bash
skyflow install docker
```
Now you can use the `skyflow-docker` command line. Try `skyflow-docker -h`

###### _Uninstall component_
```bash
skyflow remove docker
```

List of components
----------------------------------------------

- [Docker][3]


Contributing
----------------------------------------------

**Skyflow CLI** is an Open Source project. Everyone can easily contribute.

#### File structure

- Skyflow
    - bin
        - skyflow-docker.sh
        - skyflow-component1.sh
        - skyflow-component2.sh
        - ...
    - component
        - docker
            - docker.sdoc
            - install.sh
            - README.md
        - component1
            - docker.sdoc
            - README.md
        - component2
            - docker.sdoc
            - README.md
        - ...
    - docker.sdoc
    - helper.sh
    - skyflow.sh

The **`bin`** directory contains the component command line.
Each command line must be in the following form `skyflow-<component-name>-sh`.

The **`component`** directory contains all the components.
All files in the component must be put in a folder with the name of the component.
Each component must provide command-line documentation in the `{component}.sdoc` file and documentation in the `README.md` file.

The **`{component}.sdoc`** file is the command line documentation for skyflow.

The **`helper.sh`** script contains many useful functions for creating components.
Use `source $HOME/.skyflow/helper.sh` to import all functions. 

The **`skyflow.sh`** file is the skyflow command line.

[1]: http://hub.skyflow.io:8080
[2]: https://raw.githubusercontent.com/skyflow-io/CLI/master/skyflow.sh
[3]: https://github.com/skyflow-io/CLI/blob/master/component/docker/README.md
