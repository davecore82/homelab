curl https://letsencrypt.org/certs/isrgrootx1.pem > ./letsencrypt.pem

oc create configmap trusted-ca \
  --from-file=ca-bundle.crt=./letsencrypt.pem \
  -n openshift-config

oc patch proxy/cluster --type=merge \
  --patch='{"spec":{"trustedCA":{"name":"trusted-ca"}}}'

