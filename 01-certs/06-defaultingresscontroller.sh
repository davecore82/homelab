oc patch ingresscontroller.operator default \
     --type=merge -p \
     '{"spec":{"defaultCertificate": {"name": "apps-prime-davecore-xyz-tls"}}}' \
     -n openshift-ingress-operator

