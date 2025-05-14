# Homelab Setup

This repo is forked from https://github.com/pittar/homelab and will contain the setup and configuration for my OpenShift homelab.

# Init

Seed the cluster with:
* Doppler credentials for External Secrets.
* OpenShift Gitops Operator

`oc apply -k bootstrap/init`
