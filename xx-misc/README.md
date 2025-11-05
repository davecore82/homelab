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

1.  **Modify the Target:** Edit the `ScaledObject` and change the `threshold` from `1` to a low number that represents a high demand, for example, **`0.1`**.

      * **Old Threshold:** `threshold: "1"`
      * **New Threshold (High Demand):** `threshold: "0.1"`

2.  **Apply Change:** Apply the modified `scaledobject.yaml`.

    ```bash
    oc apply -f scaledobject.yaml -n seleniumtest
    ```

### C. Validation

  * **HPA (Terminal 2):** The **TARGETS** column should show the new metric ratio (e.g., `1/0.1 (avg)`). KEDA will interpret the demand as 10x the target per pod.
  * **Pods (Terminal 1):** The HPA will quickly scale the Deployment from 1 pod up to the maximum limit of **5 replicas** (`maxReplicas: 5`).

-----

## 2️⃣ Test: Scale-Down to Zero (Simulating Zero Demand)

This test verifies the system successfully detects idleness and scales down to the most resource-efficient state (`minReplicas: 0`).

### A. Restore Demand Metric

1.  **Restore Threshold:** Edit the `ScaledObject` back to the original operational threshold of **`1`**.
    ```yaml
    threshold: "1" 
    ```
2.  **Apply Change:** `oc apply -f scaledobject.yaml -n seleniumtest`
      * The HPA will immediately start scaling down from 5 to 1 replica over the next 5 minutes, as the calculation is now `ceil(1 / 1) = 1`.

### B. Trigger Zero Demand

1.  **Simulate Zero Sessions:** Stop the source of the metric by deleting the Deployment. This makes the `up` metric report a value of **0**.
    ```bash
    oc delete deployment selenium-metrics-exporter -n seleniumtest
    ```

### C. Validation

1.  **HPA Cooldown (Terminal 2):** The **TARGETS** column will show a value of `<unknown>` or **`0/1`**. The HPA will enter the cooldown period (governed by `cooldownPeriod: 300s`).
2.  **Wait 5 Minutes:** Allow the **300 seconds** to elapse.
3.  **Final State (Terminal 1):** After cooldown, the HPA will scale the Deployment to **0 replicas**. You should see all `selenium-metrics-exporter` pods terminate.

A successful scale-down to **0 replicas** confirms that the entire KEDA custom metrics pipeline is working correctly for both provisioning resources and saving costs.
