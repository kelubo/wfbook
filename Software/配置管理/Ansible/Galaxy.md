# Galaxy

# Galaxy User Guide[](https://docs.ansible.com/ansible/latest/galaxy/user_guide.html#galaxy-user-guide)

*Ansible Galaxy* refers to the [Galaxy](https://galaxy.ansible.com)  website, a free site for finding, downloading, and sharing community developed roles.

Use Galaxy to jump-start your automation project with great content  from the Ansible community. Galaxy provides pre-packaged units of work  such as [roles](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_reuse_roles.html#playbooks-reuse-roles), and new in Galaxy 3.2, [collections](https://docs.ansible.com/ansible/latest/collections_guide/index.html#collections) You can find roles for provisioning infrastructure, deploying  applications, and all of the tasks you do everyday. The collection  format provides a comprehensive package of automation that may include  multiple playbooks, roles, modules, and plugins.

- [Finding collections on Galaxy](https://docs.ansible.com/ansible/latest/galaxy/user_guide.html#finding-collections-on-galaxy)
- [Installing collections](https://docs.ansible.com/ansible/latest/galaxy/user_guide.html#installing-collections)
  - [Installing a collection from Galaxy](https://docs.ansible.com/ansible/latest/galaxy/user_guide.html#installing-a-collection-from-galaxy)
  - [Downloading a collection from Automation Hub](https://docs.ansible.com/ansible/latest/galaxy/user_guide.html#downloading-a-collection-from-automation-hub)
  - [Installing an older version of a collection](https://docs.ansible.com/ansible/latest/galaxy/user_guide.html#installing-an-older-version-of-a-collection)
  - [Install multiple collections with a requirements file](https://docs.ansible.com/ansible/latest/galaxy/user_guide.html#install-multiple-collections-with-a-requirements-file)
  - [Downloading a collection for offline use](https://docs.ansible.com/ansible/latest/galaxy/user_guide.html#downloading-a-collection-for-offline-use)
  - [Installing a collection from source files](https://docs.ansible.com/ansible/latest/galaxy/user_guide.html#installing-a-collection-from-source-files)
  - [Installing a collection from a git repository](https://docs.ansible.com/ansible/latest/galaxy/user_guide.html#installing-a-collection-from-a-git-repository)
  - [Listing installed collections](https://docs.ansible.com/ansible/latest/galaxy/user_guide.html#listing-installed-collections)
  - [Configuring the `ansible-galaxy` client](https://docs.ansible.com/ansible/latest/galaxy/user_guide.html#configuring-the-ansible-galaxy-client)
- [Finding roles on Galaxy](https://docs.ansible.com/ansible/latest/galaxy/user_guide.html#finding-roles-on-galaxy)
  - [Get more information about a role](https://docs.ansible.com/ansible/latest/galaxy/user_guide.html#get-more-information-about-a-role)
- [Installing roles from Galaxy](https://docs.ansible.com/ansible/latest/galaxy/user_guide.html#installing-roles-from-galaxy)
  - [Installing roles](https://docs.ansible.com/ansible/latest/galaxy/user_guide.html#installing-roles)
  - [Installing a specific version of a role](https://docs.ansible.com/ansible/latest/galaxy/user_guide.html#installing-a-specific-version-of-a-role)
  - [Installing multiple roles from a file](https://docs.ansible.com/ansible/latest/galaxy/user_guide.html#installing-multiple-roles-from-a-file)
  - [Installing roles and collections from the same requirements.yml file](https://docs.ansible.com/ansible/latest/galaxy/user_guide.html#installing-roles-and-collections-from-the-same-requirements-yml-file)
  - [Installing multiple roles from multiple files](https://docs.ansible.com/ansible/latest/galaxy/user_guide.html#installing-multiple-roles-from-multiple-files)
  - [Dependencies](https://docs.ansible.com/ansible/latest/galaxy/user_guide.html#dependencies)
  - [List installed roles](https://docs.ansible.com/ansible/latest/galaxy/user_guide.html#list-installed-roles)
  - [Remove an installed role](https://docs.ansible.com/ansible/latest/galaxy/user_guide.html#remove-an-installed-role)



## [Finding collections on Galaxy](https://docs.ansible.com/ansible/latest/galaxy/user_guide.html#id6)[](https://docs.ansible.com/ansible/latest/galaxy/user_guide.html#finding-collections-on-galaxy)

To find collections on Galaxy:

1. Click the Search icon in the left-hand navigation.
2. Set the filter to *collection*.
3. Set other filters and press enter.

Galaxy presents a list of collections that match your search criteria.



## [Installing collections](https://docs.ansible.com/ansible/latest/galaxy/user_guide.html#id7)[](https://docs.ansible.com/ansible/latest/galaxy/user_guide.html#installing-collections)

### [Installing a collection from Galaxy](https://docs.ansible.com/ansible/latest/galaxy/user_guide.html#id8)[](https://docs.ansible.com/ansible/latest/galaxy/user_guide.html#installing-a-collection-from-galaxy)

By default, `ansible-galaxy collection install` uses https://galaxy.ansible.com as the Galaxy server (as listed in the `ansible.cfg` file under [GALAXY_SERVER](https://docs.ansible.com/ansible/latest/reference_appendices/config.html#galaxy-server)). You do not need any further configuration.

See [Configuring the ansible-galaxy client](https://docs.ansible.com/ansible/latest/collections_guide/collections_installing.html#galaxy-server-config) if you are using any other Galaxy server, such as Red Hat Automation Hub.

To install a collection hosted in Galaxy:

```
ansible-galaxy collection install my_namespace.my_collection
```

To upgrade a collection to the latest available version from the Galaxy server you can use the `--upgrade` option:

```
ansible-galaxy collection install my_namespace.my_collection --upgrade
```

You can also directly use the tarball from your build:

```
ansible-galaxy collection install my_namespace-my_collection-1.0.0.tar.gz -p ./collections
```

You can build and install a collection from a local source directory. The `ansible-galaxy` utility builds the collection using the `MANIFEST.json` or `galaxy.yml` metadata in the directory.

```
ansible-galaxy collection install /path/to/collection -p ./collections
```

You can also install multiple collections in a namespace directory.

```
ns/
├── collection1/
│   ├── MANIFEST.json
│   └── plugins/
└── collection2/
    ├── galaxy.yml
    └── plugins/
ansible-galaxy collection install /path/to/ns -p ./collections
```

Note

The install command automatically appends the path `ansible_collections` to the one specified  with the `-p` option unless the parent directory is already in a folder called `ansible_collections`.

When using the `-p` option to specify the install path, use one of the values configured in [COLLECTIONS_PATHS](https://docs.ansible.com/ansible/latest/reference_appendices/config.html#collections-paths), as this is where Ansible itself will expect to find collections. If you don’t specify a path, `ansible-galaxy collection install` installs the collection to the first path defined in [COLLECTIONS_PATHS](https://docs.ansible.com/ansible/latest/reference_appendices/config.html#collections-paths), which by default is `~/.ansible/collections`

You can also keep a collection adjacent to the current playbook, under a `collections/ansible_collections/` directory structure.

```
./
├── play.yml
├── collections/
│   └── ansible_collections/
│               └── my_namespace/
│                   └── my_collection/<collection structure lives here>
```

See [Collection structure](https://docs.ansible.com/ansible/latest/dev_guide/developing_collections_structure.html#collection-structure) for details on the collection directory structure.



### [Downloading a collection from Automation Hub](https://docs.ansible.com/ansible/latest/galaxy/user_guide.html#id9)[](https://docs.ansible.com/ansible/latest/galaxy/user_guide.html#downloading-a-collection-from-automation-hub)

You can download collections from Automation Hub at the command line. Automation Hub content is available to subscribers only, so you must  download an API token and configure your local environment to provide it before you can you download collections. To download a collection from  Automation Hub with the `ansible-galaxy` command:

1. Get your Automation Hub API token. Go to https://cloud.redhat.com/ansible/automation-hub/token/ and click Load token from the version dropdown to copy your API token.
2. Configure Red Hat Automation Hub server in the `server_list`  option under the `[galaxy]` section in your `ansible.cfg` file.

> ```
> [galaxy]
> server_list = automation_hub
> 
> [galaxy_server.automation_hub]
> url=https://console.redhat.com/api/automation-hub/
> auth_url=https://sso.redhat.com/auth/realms/redhat-external/protocol/openid-connect/token
> token=my_ah_token
> ```

1. Download the collection hosted in Automation Hub.

> ```
> ansible-galaxy collection install my_namespace.my_collection
> ```

See also

- [Getting started with Automation Hub](https://www.ansible.com/blog/getting-started-with-ansible-hub)

  An introduction to Automation Hub

### [Installing an older version of a collection](https://docs.ansible.com/ansible/latest/galaxy/user_guide.html#id10)[](https://docs.ansible.com/ansible/latest/galaxy/user_guide.html#installing-an-older-version-of-a-collection)

You can only have one version of a collection installed at a time. By default `ansible-galaxy` installs the latest available version. If you want to install a  specific version, you can add a version range identifier. For example,  to install the 1.0.0-beta.1 version of the collection:

```
ansible-galaxy collection install my_namespace.my_collection:==1.0.0-beta.1
```

You can specify multiple range identifiers separated by `,`. Use single quotes so the shell passes the entire command, including `>`, `!`, and other operators, along. For example, to install the most recent  version that is greater than or equal to 1.0.0 and less than 2.0.0:

```
ansible-galaxy collection install 'my_namespace.my_collection:>=1.0.0,<2.0.0'
```

Ansible will always install the most recent version that meets the  range identifiers you specify. You can use the following range  identifiers:

- `*`: The most recent version. This is the default.
- `!=`: Not equal to the version specified.
- `==`: Exactly the version specified.
- `>=`: Greater than or equal to the version specified.
- `>`: Greater than the version specified.
- `<=`: Less than or equal to the version specified.
- `<`: Less than the version specified.

Note

By default `ansible-galaxy` ignores pre-release versions. To install a pre-release version, you must use the `==` range identifier to require it explicitly.

### [Install multiple collections with a requirements file](https://docs.ansible.com/ansible/latest/galaxy/user_guide.html#id11)[](https://docs.ansible.com/ansible/latest/galaxy/user_guide.html#install-multiple-collections-with-a-requirements-file)

You can set up a `requirements.yml` file to install multiple collections in one command. This file is a YAML file in the format:

```
---
collections:
# With just the collection name
- my_namespace.my_collection

# With the collection name, version, and source options
- name: my_namespace.my_other_collection
  version: ">=1.2.0" # Version range identifiers (default: ``*``)
  source: ... # The Galaxy URL to pull the collection from (default: ``--api-server`` from cmdline)
```

You can specify the following keys for each collection entry:

> - `name`
> - `version`
> - `signatures`
> - `source`
> - `type`

The `version` key uses the same range identifier format documented in [Installing an older version of a collection](https://docs.ansible.com/ansible/latest/collections_guide/collections_installing.html#collections-older-version).

The `signatures` key accepts a list of signature sources that are used to supplement  those found on the Galaxy server during collection installation and `ansible-galaxy collection verify`. Signature sources should be URIs that contain the detached signature. The `--keyring` CLI option must be provided if signatures are specified.

Signatures are only used to verify collections on Galaxy servers.  User-provided signatures are not used to verify collections installed  from git repositories, source directories, or URLs/paths to tar.gz  files.

```
collections:
  - name: namespace.name
    version: 1.0.0
    type: galaxy
    signatures:
      - https://examplehost.com/detached_signature.asc
      - file:///path/to/local/detached_signature.asc
```

The `type` key can be set to `file`, `galaxy`, `git`, `url`, `dir`, or `subdirs`. If `type` is omitted, the `name` key is used to implicitly determine the source of the collection.

When you install a collection with `type: git`, the `version` key can refer to a branch or to a [git commit-ish](https://git-scm.com/docs/gitglossary#def_commit-ish) object (commit or tag). For example:

```
collections:
  - name: https://github.com/organization/repo_name.git
    type: git
    version: devel
```

You can also add roles to a `requirements.yml` file, under the `roles` key. The values follow the same format as a requirements file used in older Ansible releases.

```
---
roles:
  # Install a role from Ansible Galaxy.
  - name: geerlingguy.java
    version: "1.9.6" # note that ranges are not supported for roles


collections:
  # Install a collection from Ansible Galaxy.
  - name: geerlingguy.php_roles
    version: ">=0.9.3"
    source: https://galaxy.ansible.com
```

To install both roles and collections at the same time with one command, run the following:

```
$ ansible-galaxy install -r requirements.yml
```

Running `ansible-galaxy collection install -r` or `ansible-galaxy role install -r` will only install collections, or roles respectively.

Note

Installing both roles and collections from the same requirements file will not work when specifying a custom collection or role install path. In this scenario the collections will be skipped and the command will  process each like `ansible-galaxy role install` would.

### [Downloading a collection for offline use](https://docs.ansible.com/ansible/latest/galaxy/user_guide.html#id12)[](https://docs.ansible.com/ansible/latest/galaxy/user_guide.html#downloading-a-collection-for-offline-use)

To download the collection tarball from Galaxy for offline use:

1. Navigate to the collection page.
2. Click on Download tarball.

You may also need to manually download any dependent collections.

### [Installing a collection from source files](https://docs.ansible.com/ansible/latest/galaxy/user_guide.html#id13)[](https://docs.ansible.com/ansible/latest/galaxy/user_guide.html#installing-a-collection-from-source-files)

Ansible can also install from a source directory in several ways:

```
collections:
  # directory containing the collection
  - source: ./my_namespace/my_collection/
    type: dir

  # directory containing a namespace, with collections as subdirectories
  - source: ./my_namespace/
    type: subdirs
```

Ansible can also install a collection collected with `ansible-galaxy collection build` or downloaded from Galaxy for offline use by specifying the output file directly:

```
collections:
  - name: /tmp/my_namespace-my_collection-1.0.0.tar.gz
    type: file
```

Note

Relative paths are calculated from the current working directory (where you are invoking `ansible-galaxy install -r` from). They are not taken relative to the `requirements.yml` file.

### [Installing a collection from a git repository](https://docs.ansible.com/ansible/latest/galaxy/user_guide.html#id14)[](https://docs.ansible.com/ansible/latest/galaxy/user_guide.html#installing-a-collection-from-a-git-repository)

You can install a collection from a git repository instead of from  Galaxy or Automation Hub. As a developer, installing from a git  repository lets you review your collection before you create the tarball and publish the collection. As a user, installing from a git repository lets you use collections or versions that are not in Galaxy or  Automation Hub yet.

The repository must contain a `galaxy.yml` or `MANIFEST.json` file. This file provides metadata such as the version number and namespace of the collection.

#### Installing a collection from a git repository at the command line[](https://docs.ansible.com/ansible/latest/galaxy/user_guide.html#installing-a-collection-from-a-git-repository-at-the-command-line)

To install a collection from a git repository at the command line,  use the URI of the repository instead of a collection name or path to a `tar.gz` file. Use the prefix `git+`, unless you’re using SSH authentication with the user `git` (for example, `git@github.com:ansible-collections/ansible.windows.git`). You can specify a branch, commit, or tag using the comma-separated [git commit-ish](https://git-scm.com/docs/gitglossary#def_commit-ish) syntax.

For example:

```
# Install a collection in a repository using the latest commit on the branch 'devel'
ansible-galaxy collection install git+https://github.com/organization/repo_name.git,devel

# Install a collection from a private github repository
ansible-galaxy collection install git@github.com:organization/repo_name.git

# Install a collection from a local git repository
ansible-galaxy collection install git+file:///home/user/path/to/repo_name.git
```

Warning

Embedding credentials into a git URI is not secure. Use safe  authentication options to prevent your credentials from being exposed in logs or elsewhere.

- Use [SSH](https://help.github.com/en/github/authenticating-to-github/connecting-to-github-with-ssh) authentication
- Use [netrc](https://linux.die.net/man/5/netrc) authentication
- Use [http.extraHeader](https://git-scm.com/docs/git-config#Documentation/git-config.txt-httpextraHeader) in your git configuration
- Use [url..pushInsteadOf](https://git-scm.com/docs/git-config#Documentation/git-config.txt-urlltbasegtpushInsteadOf) in your git configuration

#### Specifying the collection location within the git repository[](https://docs.ansible.com/ansible/latest/galaxy/user_guide.html#specifying-the-collection-location-within-the-git-repository)

When you install a collection from a git repository, Ansible uses the collection `galaxy.yml` or `MANIFEST.json` metadata file to build the collection. By default, Ansible searches two paths for collection `galaxy.yml` or `MANIFEST.json` metadata files:

- The top level of the repository.
- Each directory in the repository path (one level deep).

If a `galaxy.yml` or `MANIFEST.json` file exists in the top level of the repository, Ansible uses the  collection metadata in that file to install an individual collection.

```
├── galaxy.yml
├── plugins/
│   ├── lookup/
│   ├── modules/
│   └── module_utils/
└─── README.md
```

If a `galaxy.yml` or `MANIFEST.json` file exists in one or more directories in the repository path (one  level deep), Ansible installs each directory with a metadata file as a  collection. For example, Ansible installs both collection1 and  collection2 from this repository structure by default:

```
├── collection1
│   ├── docs/
│   ├── galaxy.yml
│   └── plugins/
│       ├── inventory/
│       └── modules/
└── collection2
    ├── docs/
    ├── galaxy.yml
    ├── plugins/
    |   ├── filter/
    |   └── modules/
    └── roles/
```

If you have a different repository structure or only want to install a subset of collections, you can add a fragment to the end of your URI  (before the optional comma-separated version) to indicate the location  of the metadata file or files. The path should be a directory, not the  metadata file itself. For example, to install only collection2 from the  example repository with two collections:

```
ansible-galaxy collection install git+https://github.com/organization/repo_name.git#/collection2/
```

In some repositories, the main directory corresponds to the namespace:

```
namespace/
├── collectionA/
|   ├── docs/
|   ├── galaxy.yml
|   ├── plugins/
|   │   ├── README.md
|   │   └── modules/
|   ├── README.md
|   └── roles/
└── collectionB/
    ├── docs/
    ├── galaxy.yml
    ├── plugins/
    │   ├── connection/
    │   └── modules/
    ├── README.md
    └── roles/
```

You can install all collections in this repository, or install one collection from a specific commit:

```
# Install all collections in the namespace
ansible-galaxy collection install git+https://github.com/organization/repo_name.git#/namespace/

# Install an individual collection using a specific commit
ansible-galaxy collection install git+https://github.com/organization/repo_name.git#/namespace/collectionA/,7b60ddc245bc416b72d8ea6ed7b799885110f5e5
```

### [Listing installed collections](https://docs.ansible.com/ansible/latest/galaxy/user_guide.html#id15)[](https://docs.ansible.com/ansible/latest/galaxy/user_guide.html#listing-installed-collections)

To list installed collections, run `ansible-galaxy collection list`. See [Listing collections](https://docs.ansible.com/ansible/latest/collections_guide/collections_listing.html#collections-listing) for more details.

### [Configuring the `ansible-galaxy` client](https://docs.ansible.com/ansible/latest/galaxy/user_guide.html#id16)[](https://docs.ansible.com/ansible/latest/galaxy/user_guide.html#configuring-the-ansible-galaxy-client)

By default, `ansible-galaxy` uses https://galaxy.ansible.com as the Galaxy server (as listed in the `ansible.cfg` file under [GALAXY_SERVER](https://docs.ansible.com/ansible/latest/reference_appendices/config.html#galaxy-server)).

You can use either option below to configure `ansible-galaxy collection` to use other servers (such as a custom Galaxy server):

- Set the server list in the [GALAXY_SERVER_LIST](https://docs.ansible.com/ansible/latest/reference_appendices/config.html#galaxy-server-list) configuration option in [The configuration file](https://docs.ansible.com/ansible/latest/reference_appendices/config.html#ansible-configuration-settings-locations).
- Use the `--server` command line argument to limit to an individual server.

To configure a Galaxy server list in `ansible.cfg`:

1. Add the `server_list`  option under the `[galaxy]` section to one or more server names.
2. Create a new section for each server name.
3. Set the `url` option for each server name.
4. Optionally, set the API token for each server name. Go to https://galaxy.ansible.com/me/preferences and click Show API key.

Note

The `url` option for each server name must end with a forward slash `/`. If you do not set the API token in your Galaxy server list, use the `--api-key` argument to pass in the token to  the `ansible-galaxy collection publish` command.

The following example shows how to configure multiple servers:

```
[galaxy]
server_list = my_org_hub, release_galaxy, test_galaxy, my_galaxy_ng

[galaxy_server.my_org_hub]
url=https://automation.my_org/
username=my_user
password=my_pass

[galaxy_server.release_galaxy]
url=https://galaxy.ansible.com/
token=my_token

[galaxy_server.test_galaxy]
url=https://galaxy-dev.ansible.com/
token=my_test_token

[galaxy_server.my_galaxy_ng]
url=http://my_galaxy_ng:8000/api/automation-hub/
auth_url=http://my_keycloak:8080/auth/realms/myco/protocol/openid-connect/token
client_id=galaxy-ng
token=my_keycloak_access_token
```

Note

You can use the `--server` command line argument to select an explicit Galaxy server in the `server_list` and the value of this argument should match the name of the server. To use a server not in the server list, set the value to the URL to access that  server (all servers in the server list will be ignored). Also you cannot use the `--api-key` argument for any of the predefined servers. You can only use the `api_key` argument if you did not define a server list or if you specify a URL in the `--server` argument.

**Galaxy server list configuration options**

The [GALAXY_SERVER_LIST](https://docs.ansible.com/ansible/latest/reference_appendices/config.html#galaxy-server-list) option is a list of server identifiers in a prioritized order. When searching for a collection, the install process will search in that order, for example, `automation_hub` first, then `my_org_hub`, `release_galaxy`, and finally `test_galaxy` until the collection is found. The actual Galaxy instance is then defined under the section `[galaxy_server.{{ id }}]` where `{{ id }}` is the server identifier defined in the list. This section can then define the following keys:

- `url`: The URL of the Galaxy instance to connect to. Required.
- `token`: An API token key to use for authentication against the Galaxy instance. Mutually exclusive with `username`.
- `username`: The username to use for basic authentication against the Galaxy instance. Mutually exclusive with `token`.
- `password`: The password to use, in conjunction with `username`, for basic authentication.
- `auth_url`: The URL of a Keycloak server ‘token_endpoint’ if using SSO authentication (for example, galaxyNG). Mutually exclusive with `username`. Requires `token`.
- `validate_certs`: Whether or not to verify TLS certificates for the Galaxy server. This defaults to True unless the `--ignore-certs` option is provided or `GALAXY_IGNORE_CERTS` is configured to True.
- `client_id`: The Keycloak token’s client_id to use for authentication. Requires `auth_url` and `token`. The default `client_id` is cloud-services to work with Red Hat SSO.

As well as defining these server options in the `ansible.cfg` file, you can also define them as environment variables. The environment variable is in the form `ANSIBLE_GALAXY_SERVER_{{ id }}_{{ key }}` where `{{ id }}` is the upper case form of the server identifier and `{{ key }}` is the key to define. For example I can define `token` for `release_galaxy` by setting `ANSIBLE_GALAXY_SERVER_RELEASE_GALAXY_TOKEN=secret_token`.

For operations that use only one Galaxy server (for example, the `publish`, `info`, or `install` commands). the `ansible-galaxy collection` command uses the first entry in the `server_list`, unless you pass in an explicit server with the `--server` argument.

Note

`ansible-galaxy` can seek out dependencies on other configured Galaxy instances to  support the use case where a collection can depend on a collection from  another Galaxy instance.



## [Finding roles on Galaxy](https://docs.ansible.com/ansible/latest/galaxy/user_guide.html#id17)[](https://docs.ansible.com/ansible/latest/galaxy/user_guide.html#finding-roles-on-galaxy)

Search the Galaxy database by tags, platforms, author and multiple keywords. For example:

```
$ ansible-galaxy search elasticsearch --author geerlingguy
```

The search command will return a list of the first 1000 results matching your search:

```
Found 2 roles matching your search:

Name                              Description
----                              -----------
geerlingguy.elasticsearch         Elasticsearch for Linux.
geerlingguy.elasticsearch-curator Elasticsearch curator for Linux.
```

### [Get more information about a role](https://docs.ansible.com/ansible/latest/galaxy/user_guide.html#id18)[](https://docs.ansible.com/ansible/latest/galaxy/user_guide.html#get-more-information-about-a-role)

Use the `info` command to view more detail about a specific role:

```
$ ansible-galaxy info username.role_name
```

This returns everything found in Galaxy for the role:

```
Role: username.role_name
    description: Installs and configures a thing, a distributed, highly available NoSQL thing.
    active: True
    commit: c01947b7bc89ebc0b8a2e298b87ab416aed9dd57
    commit_message: Adding travis
    commit_url: https://github.com/username/repo_name/commit/c01947b7bc89ebc0b8a2e298b87ab
    company: My Company, Inc.
    created: 2015-12-08T14:17:52.773Z
    download_count: 1
    forks_count: 0
    github_branch:
    github_repo: repo_name
    github_user: username
    id: 6381
    is_valid: True
    issue_tracker_url:
    license: Apache
    min_ansible_version: 1.4
    modified: 2015-12-08T18:43:49.085Z
    namespace: username
    open_issues_count: 0
    path: /Users/username/projects/roles
    scm: None
    src: username.repo_name
    stargazers_count: 0
    travis_status_url: https://travis-ci.org/username/repo_name.svg?branch=main
    version:
    watchers_count: 1
```



## [Installing roles from Galaxy](https://docs.ansible.com/ansible/latest/galaxy/user_guide.html#id19)[](https://docs.ansible.com/ansible/latest/galaxy/user_guide.html#installing-roles-from-galaxy)

The `ansible-galaxy` command comes bundled with Ansible, and you can use it to install roles from Galaxy or directly from a git based SCM. You can also use it to create a new role, remove roles, or perform tasks on the Galaxy website.

The command line tool by default communicates with the Galaxy website API using the server address *https://galaxy.ansible.com*. If you run your own internal Galaxy server and want to use it instead of the default one, pass the `--server` option following the address of this galaxy server. You can set permanently this option by setting the Galaxy server value in your `ansible.cfg` file to use it . For information on setting the value in *ansible.cfg* see [GALAXY_SERVER](https://docs.ansible.com/ansible/latest/reference_appendices/config.html#galaxy-server).

### [Installing roles](https://docs.ansible.com/ansible/latest/galaxy/user_guide.html#id20)[](https://docs.ansible.com/ansible/latest/galaxy/user_guide.html#installing-roles)

Use the `ansible-galaxy` command to download roles from the [Galaxy website](https://galaxy.ansible.com)

```
$ ansible-galaxy install namespace.role_name
```

#### Setting where to install roles[](https://docs.ansible.com/ansible/latest/galaxy/user_guide.html#setting-where-to-install-roles)

By default, Ansible downloads roles to the first writable directory in the default list of paths `~/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles`. This installs roles in the home directory of the user running `ansible-galaxy`.

You can override this with one of the following options:

- Set the environment variable [`ANSIBLE_ROLES_PATH`](https://docs.ansible.com/ansible/latest/reference_appendices/config.html#envvar-ANSIBLE_ROLES_PATH) in your session.
- Use the `--roles-path` option for the `ansible-galaxy` command.
- Define `roles_path` in an `ansible.cfg` file.

The following provides an example of using `--roles-path` to install the role into the current working directory:

```
$ ansible-galaxy install --roles-path . geerlingguy.apache
```

See also

- [Configuring Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_configuration.html#intro-configuration)

  All about configuration files

### [Installing a specific version of a role](https://docs.ansible.com/ansible/latest/galaxy/user_guide.html#id21)[](https://docs.ansible.com/ansible/latest/galaxy/user_guide.html#installing-a-specific-version-of-a-role)

When the Galaxy server imports a role, it imports any git tags matching the [Semantic Version](https://semver.org/) format as versions. In turn, you can download a specific version of a role by specifying one of the imported tags.

To see the available versions for a role:

1. Locate the role on the Galaxy search page.
2. Click on the name to view more details, including the available versions.

You can also navigate directly to the role using the  /<namespace>/<role name>. For example, to view the role  geerlingguy.apache, go to https://galaxy.ansible.com/geerlingguy/apache.

To install a specific version of a role from Galaxy, append a comma and the value of a GitHub release tag. For example:

```
$ ansible-galaxy install geerlingguy.apache,1.0.0
```

It is also possible to point directly to the git repository and  specify a branch name or commit hash as the version. For example, the  following will install a specific commit:

```
$ ansible-galaxy install git+https://github.com/geerlingguy/ansible-role-apache.git,0b7cd353c0250e87a26e0499e59e7fd265cc2f25
```

### [Installing multiple roles from a file](https://docs.ansible.com/ansible/latest/galaxy/user_guide.html#id22)[](https://docs.ansible.com/ansible/latest/galaxy/user_guide.html#installing-multiple-roles-from-a-file)

You can install multiple roles by including the roles in a `requirements.yml` file. The format of the file is YAML, and the file extension must be either *.yml* or *.yaml*.

Use the following command to install roles included in `requirements.yml:`

```
$ ansible-galaxy install -r requirements.yml
```

Again, the extension is important. If the *.yml* extension is left off, the `ansible-galaxy` CLI assumes the file is in an older, now deprecated, “basic” format.

Each role in the file will have one or more of the following attributes:

> - src
>
>   The source of the role. Use the format *namespace.role_name*, if downloading from Galaxy; otherwise, provide a URL pointing to a repository within a git based SCM. See the examples below. This is a required attribute.
>
> - scm
>
>   Specify the SCM. As of this writing only *git* or *hg* are allowed. See the examples below. Defaults to *git*.
>
> - version:
>
>   The version of the role to download. Provide a  release tag value, commit hash, or branch name. Defaults to the branch  set as a default in the repository, otherwise defaults to the *master*.
>
> - name:
>
>   Download the role to a specific name. Defaults to the Galaxy name when downloading from Galaxy, otherwise it defaults to the name of the repository.

Use the following example as a guide for specifying roles in *requirements.yml*:

```
# from galaxy
- name: yatesr.timezone

# from locally cloned git repository (git+file:// requires full paths)
- src: git+file:///home/bennojoy/nginx

# from GitHub
- src: https://github.com/bennojoy/nginx

# from GitHub, overriding the name and specifying a specific tag
- name: nginx_role
  src: https://github.com/bennojoy/nginx
  version: main

# from GitHub, specifying a specific commit hash
- src: https://github.com/bennojoy/nginx
  version: "ee8aa41"

# from a webserver, where the role is packaged in a tar.gz
- name: http-role-gz
  src: https://some.webserver.example.com/files/main.tar.gz

# from a webserver, where the role is packaged in a tar.bz2
- name: http-role-bz2
  src: https://some.webserver.example.com/files/main.tar.bz2

# from a webserver, where the role is packaged in a tar.xz (Python 3.x only)
- name: http-role-xz
  src: https://some.webserver.example.com/files/main.tar.xz

# from Bitbucket
- src: git+https://bitbucket.org/willthames/git-ansible-galaxy
  version: v1.4

# from Bitbucket, alternative syntax and caveats
- src: https://bitbucket.org/willthames/hg-ansible-galaxy
  scm: hg

# from GitLab or other git-based scm, using git+ssh
- src: git@gitlab.company.com:mygroup/ansible-core.git
  scm: git
  version: "0.1"  # quoted, so YAML doesn't parse this as a floating-point value
```

Warning

Embedding credentials into a SCM URL is not secure. Make sure to use safe auth options for security reasons. For example, use [SSH](https://help.github.com/en/github/authenticating-to-github/connecting-to-github-with-ssh), [netrc](https://linux.die.net/man/5/netrc) or [http.extraHeader](https://git-scm.com/docs/git-config#Documentation/git-config.txt-httpextraHeader)/[url..pushInsteadOf](https://git-scm.com/docs/git-config#Documentation/git-config.txt-urlltbasegtpushInsteadOf) in Git config to prevent your creds from being exposed in logs.

### [Installing roles and collections from the same requirements.yml file](https://docs.ansible.com/ansible/latest/galaxy/user_guide.html#id23)[](https://docs.ansible.com/ansible/latest/galaxy/user_guide.html#installing-roles-and-collections-from-the-same-requirements-yml-file)

You can install roles and collections from the same requirements files

```
---
roles:
  # Install a role from Ansible Galaxy.
  - name: geerlingguy.java
    version: "1.9.6" # note that ranges are not supported for roles

collections:
  # Install a collection from Ansible Galaxy.
  - name: geerlingguy.php_roles
    version: ">=0.9.3"
    source: https://galaxy.ansible.com
```

### [Installing multiple roles from multiple files](https://docs.ansible.com/ansible/latest/galaxy/user_guide.html#id24)[](https://docs.ansible.com/ansible/latest/galaxy/user_guide.html#installing-multiple-roles-from-multiple-files)

For large projects, the `include` directive in a `requirements.yml` file provides the ability to split a large file into multiple smaller files.

For example, a project may have a `requirements.yml` file, and a `webserver.yml` file.

Below are the contents of the `webserver.yml` file:

```
# from github
- src: https://github.com/bennojoy/nginx

# from Bitbucket
- src: git+https://bitbucket.org/willthames/git-ansible-galaxy
  version: v1.4
```

The following shows the contents of the `requirements.yml` file that now includes the `webserver.yml` file:

```
# from galaxy
- name: yatesr.timezone
- include: <path_to_requirements>/webserver.yml
```

To install all the roles from both files, pass the root file, in this case `requirements.yml` on the command line, as follows:

```
$ ansible-galaxy install -r requirements.yml
```



### [Dependencies](https://docs.ansible.com/ansible/latest/galaxy/user_guide.html#id25)[](https://docs.ansible.com/ansible/latest/galaxy/user_guide.html#dependencies)

Roles can also be dependent on other roles, and when you install a  role that has dependencies, those dependencies will automatically be  installed to the `roles_path`.

There are two ways to define the dependencies of a role:

- using `meta/requirements.yml`
- using `meta/main.yml`

#### Using `meta/requirements.yml`[](https://docs.ansible.com/ansible/latest/galaxy/user_guide.html#using-meta-requirements-yml)

New in version 2.10.

You can create the file `meta/requirements.yml` and define dependencies in the same format used for `requirements.yml` described in the [Installing multiple roles from a file](https://docs.ansible.com/ansible/latest/galaxy/user_guide.html#installing-multiple-roles-from-a-file) section.

From there, you can import or include the specified roles in your tasks.

#### Using `meta/main.yml`[](https://docs.ansible.com/ansible/latest/galaxy/user_guide.html#using-meta-main-yml)

Alternatively, you can specify role dependencies in the `meta/main.yml` file by providing a list of roles under the `dependencies` section. If the source of a role is Galaxy, you can simply specify the role in the format `namespace.role_name`. You can also use the more complex format in `requirements.yml`, allowing you to provide `src`, `scm`, `version`, and `name`.

Dependencies installed that way, depending on other factors described below, will also be executed **before** this role is executed during play execution. To better understand how dependencies are handled during play execution, see [Roles](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_reuse_roles.html#playbooks-reuse-roles).

The following shows an example `meta/main.yml` file with dependent roles:

```
---
dependencies:
  - geerlingguy.java

galaxy_info:
  author: geerlingguy
  description: Elasticsearch for Linux.
  company: "Midwestern Mac, LLC"
  license: "license (BSD, MIT)"
  min_ansible_version: 2.4
  platforms:
  - name: EL
    versions:
    - all
  - name: Debian
    versions:
    - all
  - name: Ubuntu
    versions:
    - all
  galaxy_tags:
    - web
    - system
    - monitoring
    - logging
    - lucene
    - elk
    - elasticsearch
```

Tags are inherited *down* the dependency chain. In order for  tags to be applied to a role and all its dependencies, the tag should be applied to the role, not to all the tasks within a role.

Roles listed as dependencies are subject to conditionals and tag filtering, and may not execute fully depending on what tags and conditionals are applied.

If the source of a role is Galaxy, specify the role in the format *namespace.role_name*:

```
dependencies:
  - geerlingguy.apache
  - geerlingguy.ansible
```

Alternately, you can specify the role dependencies in the complex form used in  `requirements.yml` as follows:

```
dependencies:
  - name: geerlingguy.ansible
  - name: composer
    src: git+https://github.com/geerlingguy/ansible-role-composer.git
    version: 775396299f2da1f519f0d8885022ca2d6ee80ee8
```

Note

Galaxy expects all role dependencies to exist in Galaxy, and therefore dependencies to be specified in the `namespace.role_name` format. If you import a role with a dependency where the `src` value is a URL, the import process will fail.

### [List installed roles](https://docs.ansible.com/ansible/latest/galaxy/user_guide.html#id26)[](https://docs.ansible.com/ansible/latest/galaxy/user_guide.html#list-installed-roles)

Use `list` to show the name and version of each role installed in the *roles_path*.

```
$ ansible-galaxy list
  - ansible-network.network-engine, v2.7.2
  - ansible-network.config_manager, v2.6.2
  - ansible-network.cisco_nxos, v2.7.1
  - ansible-network.vyos, v2.7.3
  - ansible-network.cisco_ios, v2.7.0
```

### [Remove an installed role](https://docs.ansible.com/ansible/latest/galaxy/user_guide.html#id27)[](https://docs.ansible.com/ansible/latest/galaxy/user_guide.html#remove-an-installed-role)

Use `remove` to delete a role from *roles_path*:

```
$ ansible-galaxy remove namespace.role_name
```

See also

- [Using Ansible collections](https://docs.ansible.com/ansible/latest/collections_guide/index.html#collections)

  Shareable collections of modules, playbooks and roles

- [Roles](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_reuse_roles.html#playbooks-reuse-roles)

  Reusable tasks, handlers, and other files in a known directory structure

- [Working with command line tools](https://docs.ansible.com/ansible/latest/command_guide/command_line_tools.html#command-line-tools)

  Perform other related operations