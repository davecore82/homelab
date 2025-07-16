oc patch apiserver cluster --type=merge \
  -p '{"spec":{"servingCerts": {"namedCertificates": [{"names": ["api.prime.davecore.xyz"], "servingCertificate": {"name": "api-prime-davecore-xyz-tls"}}]}}}' 
