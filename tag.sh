#!/bin/sh

VERSION=$(grep -e "ARG KUBE_HUNTER_VERSION=" Dockerfile)
VERSION=${VERSION#ARG KUBE_HUNTER_VERSION=\"}
VERSION=${VERSION%\"}
echo "Tagging version ${VERSION}"
docker tag "${DOCKER_USERNAME}/kube-hunter:latest" "${DOCKER_USERNAME}/kube-hunter:${VERSION}"
docker tag "${DOCKER_USERNAME}/kube-hunter:latest" "${DOCKER_USERNAME}/kube-hunter:master"

