# terraform-aws-kops
Terrafrom module for create Kubernetes cluster with kOps on AWS.

# Kubernetes version Compatibility
| Module Version | Tested Kubernetes Version |
|---|---|
|v0.5|1.22 - 1.26|
|v0.6|1.29 - 1.30|


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

## v0.5.2
- Fix workloads bug.

## v0.5.3
- Add support Arm64

## v0.5.4
- Add support Karpenter
- Selectable networking(Not all)
- EBS-CSI-Driver option
- Add machine_image option, for workaround for amazon vpc networking on 1.27
- [Breaking Change] Changed internal control-plane resource name

## v0.5.5
- Remove debug outputs

## v0.5.6
- Fixed a bug that caused instance creation of non-burstable instance types to fail.

## v0.5.7
- Fixed a wrong validation error message.
- Add lifecycle identity to instance group name of control plane.

## v0.6.0
- Upgrade kOps provider version

## v0.6.1
- Upgrade kOps provider version fix for workloads

## v0.6.2
- Upgrade kOps provider version
- Add prefix_enabling and max pods options
