# From https://stephennimmo.com/2024/05/15/generating-lets-encrypt-certificates-with-red-hat-openshift-cert-manager-operator-using-the-cloudflare-dns-solver/
# and https://cert-manager.io/docs/configuration/acme/dns01/cloudflare/#api-tokens
# 
oc create secret generic cloudflare-api-token-secret \
  -n cert-manager \
  --from-literal=api-token=$TOKEN
