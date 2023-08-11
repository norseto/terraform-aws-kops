#! /usr/bin/env bash

if ! type yq > /dev/null; then
  echo "This script needs yq installed." 1>&2
  exit 1
fi

if [ $# -lt 1 ] ; then
  echo "Usage: ${0} manifest-filename" 1>&2
  echo "You should go https://distro.eks.amazonaws.com/ and select version and download release manifest file " 1>&2
  exit 1
fi

FILE=${1}

if [ ! -e ${FILE} ] ; then
  echo "cannot read: ${FILE}" 1>&2
  exit 1
fi

# Name and versions
cat ${FILE} | yq '{"releaseName": .metadata.name, "releaseChannel": .spec.channel, "releaseNumber": .spec.number}'

# Perse Kubernetes version
cat ${FILE} | yq '((.status.components[].assets[]|select(.os == "linux" and .type == "Archive" and .name == "bin/linux/amd64/kubelet")) as $i | $i.archive.uri | sub("/bin/.*$", "")) as $v | { "kubernetesVersion": $v }'

# Parse Images
cat ${FILE} | yq '(.status.components[].assets[]|select(.os == "linux" and .type == "Image")) as $i | {$i.name: $i.image.uri}'

# Obtain cloud controller manager image
R_NUMBER=$(cat ${FILE} | yq '.spec.number')
R_CHANNEL=$(cat ${FILE} | yq '.spec.channel')
T_PATH="https://raw.githubusercontent.com/aws/eks-distro/v${R_CHANNEL}-eks-${R_NUMBER}/projects/kubernetes/cloud-provider-aws/${R_CHANNEL}/GIT_TAG"

TMPFILE=/tmp/gittag.$$
curl -sLo ${TMPFILE} ${T_PATH}
TAG=$(cat ${TMPFILE})
rm -f ${TMPFILE}
echo "cloud-controller-manager-image: public.ecr.aws/eks-distro/kubernetes/cloud-provider-aws/cloud-controller-manager:${TAG}-eks-${R_CHANNEL}-${R_NUMBER}"
