### 1\. Edit the Configuration Map

Use the OpenShift command-line tool (`oc`) to edit the **`cluster-monitoring-config`** `ConfigMap` object in the **`openshift-monitoring`** namespace:

```bash
$ oc -n openshift-monitoring edit configmap cluster-monitoring-config
```

-----

### 2\. Add User Workload Monitoring

Within the editor, add the line **`enableUserWorkload: true`** under the **`data/config.yaml`** key.

The resulting configuration file snippet will look like this:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: cluster-monitoring-config
  namespace: openshift-monitoring
data:
  config.yaml: |
    enableUserWorkload: true
```

> **Note:** Setting `enableUserWorkload: true` enables a separate monitoring stack for user-defined projects, allowing you to monitor your custom applications.
