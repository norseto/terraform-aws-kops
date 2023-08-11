# terraform-aws-kops
Terrafrom module for create Kubernetes cluster with kOps on AWS.

# Kubernetes version Compatibility
| Module Version | Suported Kubernetes Version |
|---|---|
|v0.5.0|1.22 - 1.26|

# History
## v0.1.0
First release

## v0.2.0
Common ServiceAccount IAM Policies

## v0.3.0
- Remove SSH access
- Add storage volume configurations

## v0.4.0
- Add kops-workload for common workloads

## v0.5.0
- Change module provider version constraints because of breaking changes on provider

## v0.5.1
- Combine validater into updater.
- Add cloud-controller-manager-image to tool.
