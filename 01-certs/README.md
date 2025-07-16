# OpenShift Let's Encrypt Certificates with Cloudflare DNS Solver

This repository documents the process of generating Let's Encrypt certificates within Red Hat OpenShift using the `cert-manager` operator, leveraging the Cloudflare DNS-01 challenge solver.

The steps outlined here are primarily based on the excellent guide by Stephen Nimmo:

* **Generating Let's Encrypt Certificates with Red Hat OpenShift Cert-Manager Operator using the Cloudflare DNS Solver:** [https://stephennimmo.com/2024/05/15/generating-lets-encrypt-certificates-with-red-hat-openshift-cert-manager-operator-using-the-cloudflare-dns-solver/](https://stephennimmo.com/2024/05/15/generating-lets-encrypt-certificates-with-red-hat-openshift-cert-manager-operator-using-the-cloudflare-dns-solver/)

And the official `cert-manager` documentation for Cloudflare API tokens:

* **cert-manager Cloudflare DNS01 Solver Configuration (API Tokens):** [https://cert-manager.io/docs/configuration/acme/dns01/cloudflare/#api-tokens](https://cert-manager.io/docs/configuration/acme/dns01/cloudflare/#api-tokens)

## Prerequisites

Before running the scripts, you will need to obtain a Cloudflare API Token. Please refer to the `cert-manager` documentation linked above for instructions on how to create one with the necessary permissions.

## Usage

To configure the `cert-manager` secret with your Cloudflare API token, **you must export your token as an environment variable** before running `02-secret-certmanager.sh`:

```bash
export TOKEN=<your_cloudflare_api_token_here>
