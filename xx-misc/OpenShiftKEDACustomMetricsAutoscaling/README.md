## 🧪 Testing and Validation of KEDA Custom Metrics Autoscaler

This README outlines the steps required to verify that the **KEDA Prometheus Autoscaling Pipeline** for your simulated Selenium Grid nodes is fully functional in the `seleniumtest` OpenShift namespace.

The goal is to confirm that the Horizontal Pod Autoscaler (HPA) is reading the custom metric and correctly scaling the Deployment between its minimum (0) and maximum (5) replicas.

-----

## 📋 Prerequisites

Ensure all resources have been successfully applied (`Deployment`, `Service`, `ServiceMonitor`, all RBAC, `Secret`, `TriggerAuthentication`, and the final `ScaledObject`).

The current state should be a validated HPA, likely scaled down to 1 or 0 replicas after fixing the query.

```bash
# Verify HPA is present and reading the metric (should NOT be <unknown>/1)
oc get hpa -n seleniumtest

# Example output: 
NAME                                REFERENCE                              TARGETS       MINPODS   MAXPODS   REPLICAS   AGE
keda-hpa-selenium-node-autoscaler   Deployment/selenium-metrics-exporter   256/1 (avg)   1         5         5          43m
```

-----

## 1️⃣ Test: Scale-Up to Max Replicas (Simulating High Demand)

This test verifies the system successfully detects demand and scales up to the defined limit (`maxReplicas: 5`).

### A. Monitor Status

Open two separate terminal windows for monitoring:

| Terminal | Command | Purpose |
| :--- | :--- | :--- |
| **Terminal 1** | `oc get pods -n seleniumtest -w` | Watch the pod creation/termination events. |
| **Terminal 2** | `oc get hpa -n seleniumtest -w` | Watch the metric value and replica count changes. |

### B. Trigger Scale-Up

The current metric query is **`count(up{...})`**, which returns **1** when a pod is running. To force a massive scale-up, we will temporarily increase the required `threshold` for the entire Deployment.

1.  **Modify the Target:** Edit the `ScaledObject` and change the `threshold` to `1000` or `1`, depending if you want to modify the sensitivity. 

      * **Old Threshold:** `threshold: "1"`
      * **New Threshold (Low Demand):** `threshold: "1000"`

2.  **Apply Change:** Apply the modified `scaledobject.yaml`.

    ```bash
    oc apply -f scaledobject.yaml -n seleniumtest
    ```

### C. Validation

  * **HPA (Terminal 2):** The **TARGETS** column should show the new metric ratio (e.g., `1/0.1 (avg)`). KEDA will interpret the demand as 10x the target per pod.
  * **Pods (Terminal 1):** The HPA will quickly scale the Deployment from 1 pod up to the maximum limit of **5 replicas** (`maxReplicas: 5`).

