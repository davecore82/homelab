# Project Name

This project is a demonstration of how to configure Red Hat OpenShift Lightspeed.

## Prerequisites

Before you begin, please follow the instructions at the following link to configure your environment:

[https://docs.redhat.com/en/documentation/red_hat_openshift_lightspeed/1.0/html-single/configure/index](https://docs.redhat.com/en/documentation/red_hat_openshift_lightspeed/1.0/html-single/configure/index)

**Important:** Make sure you create the secret first, as described in the documentation. Don't forget to base64 encode it. 

The workaround in 02-metrics-reader-token-secret.yaml is only necessary in lightspeed releases before 1.0.3.
