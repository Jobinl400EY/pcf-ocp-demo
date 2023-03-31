#!/usr/bin/env bash
#   Copyright IBM Corporation 2020
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#        http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

# Invoke as ./pushimages.sh <registry_url> <registry_namespace> <container_runtime>
# Examples:
# 1) ./pushimages.sh
# 2) ./pushimages.sh quay.io your_quay_username
# 3) ./pushimages.sh index.docker.io your_registry_namespace podman

REGISTRY_URL=quay.io
REGISTRY_NAMESPACE=jobinl400ey
CONTAINER_RUNTIME=docker
if [ "$#" -gt 1 ]; then
  REGISTRY_URL=$1
  REGISTRY_NAMESPACE=$2
fi
if [ "$#" -eq 3 ]; then
    CONTAINER_RUNTIME=$3
fi
if [ "${CONTAINER_RUNTIME}" != "docker" ] && [ "${CONTAINER_RUNTIME}" != "podman" ]; then
   echo 'Unsupported container runtime passed as an argument for pushing the images: '"${CONTAINER_RUNTIME}"
   exit 1
fi
# Uncomment the below line if you want to enable login before pushing
# ${CONTAINER_RUNTIME} login ${REGISTRY_URL}

echo 'pushing image customers'
${CONTAINER_RUNTIME} tag customers ${REGISTRY_URL}/${REGISTRY_NAMESPACE}/customers
${CONTAINER_RUNTIME} push ${REGISTRY_URL}/${REGISTRY_NAMESPACE}/customers

echo 'pushing image frontend'
${CONTAINER_RUNTIME} tag frontend ${REGISTRY_URL}/${REGISTRY_NAMESPACE}/frontend
${CONTAINER_RUNTIME} push ${REGISTRY_URL}/${REGISTRY_NAMESPACE}/frontend

echo 'pushing image orders'
${CONTAINER_RUNTIME} tag orders ${REGISTRY_URL}/${REGISTRY_NAMESPACE}/orders
${CONTAINER_RUNTIME} push ${REGISTRY_URL}/${REGISTRY_NAMESPACE}/orders

echo 'pushing image inventory'
${CONTAINER_RUNTIME} tag inventory ${REGISTRY_URL}/${REGISTRY_NAMESPACE}/inventory
${CONTAINER_RUNTIME} push ${REGISTRY_URL}/${REGISTRY_NAMESPACE}/inventory

echo 'pushing image gateway'
${CONTAINER_RUNTIME} tag gateway ${REGISTRY_URL}/${REGISTRY_NAMESPACE}/gateway
${CONTAINER_RUNTIME} push ${REGISTRY_URL}/${REGISTRY_NAMESPACE}/gateway

echo 'done'
