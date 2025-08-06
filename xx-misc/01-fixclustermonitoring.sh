# I had to add the openshift.io/cluster-monitoring=true label to these 2 namespaces to get rid of a PrometheusOperatorRejectedResources alert
oc label namespace openshift-logging openshift.io/cluster-monitoring=true
oc label namespace openshift-storage openshift.io/cluster-monitoring=true
