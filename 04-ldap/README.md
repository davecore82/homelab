### OpenShift Group Synchronization with a Local OpenLDAP Server

This project documents the process of setting up a local OpenLDAP server on a Raspberry Pi and synchronizing groups from it to an OpenShift cluster using the `oc adm groups sync` command. 

#### Highlights of the Process:

  - **Local LDAP Server:** An OpenLDAP server was installed on a Raspberry Pi (running Raspberry Pi OS).
  - **Directory Configuration:** The LDAP directory was configured with a specific base DN (`dc=davecore,dc=xyz`).
  - **Dummy Group Data:** A groups ldif file was created to populate the directory with three test groups (`developer-team`, `qa-team`, `management-team`).
  - **OpenShift Integration:** A correctly formatted `LDAPSyncConfig` YAML file was created to tell OpenShift how to connect to the local LDAP server.
  - **Synchronization:** The `oc adm groups sync` command was used to push the groups from the Raspberry Pi to the OpenShift cluster.
  - **Error Handling:** The configuration was updated to handle `Object class violation` and `member not found` errors, demonstrating key debugging steps for LDAP integration.

-----

### Step 1: Raspberry Pi OpenLDAP Server Setup

The first step was to install and configure the OpenLDAP server on the Raspberry Pi.

1.  **Install OpenLDAP:**

    ```bash
    sudo apt update
    sudo apt install slapd ldap-utils
    ```

    During installation, the base DN was set to `davecore.xyz` (resulting in `dc=davecore,dc=xyz`) and an admin password was configured.

2.  **Populate the Directory with Groups:**
    A `.ldif` file was created to define three empty groups. To satisfy the `groupOfNames` schema, a dummy member (`cn=nobody`) was added to each group.

3.  **Add Groups to LDAP:**
    The `ldapadd` command was used to add the entries to the directory.

    ```bash
    ldapadd -x -D "cn=admin,dc=davecore,dc=xyz" -W -f 01-davecore-xyz.ldif
    ```

-----

### Step 2: OpenShift Configuration

A ldap yaml file was created to define the connection and synchronization settings for OpenShift. This configuration was carefully crafted to align with the specific API schema requirements and to handle the dummy members.

-----

### Step 3: Group Synchronization

With the ldap yaml file in place, the `oc adm groups sync` command was run to synchronize the groups.

```bash
oc adm groups sync --sync-config=02-ldap.yaml --confirm
```

The output confirmed that the dummy members (`cn=nobody`) were ignored, and the groups were successfully created:

```
For group "cn=developer-team,ou=Groups,dc=davecore,dc=xyz", ignoring member "cn=nobody": ...
group/developer-team
For group "cn=qa-team,ou=Groups,dc=davecore,dc=xyz", ignoring member "cn=nobody": ...
group/qa-team
For group "cn=management-team,ou=Groups,dc=davecore,dc=xyz", ignoring member "cn=nobody": ...
group/management-team
```

### Verification

Finally, the created groups were confirmed by listing the OpenShift groups.

```bash
oc get groups
```

### Step 4: Automation

Cron job added to automate the syncing. 

In a production environment, would also need to use whitelisting for fine-grained filtering.

