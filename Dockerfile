ARG KUBE_HUNTER_VERSION="master"

FROM python:3-alpine as builder

ARG KUBE_HUNTER_VERSION

WORKDIR /build

RUN apk --no-cache upgrade && apk --no-cache add \
    git \
    linux-headers \
    build-base \
    && git clone --depth 1 --branch "${KUBE_HUNTER_VERSION}" https://github.com/aquasecurity/kube-hunter \
    && pip install --no-cache-dir -r kube-hunter/requirements.txt --upgrade -t kube-hunter

FROM python:3-alpine

ARG KUBE_HUNTER_VERSION
ENV KUBE_HUNTER_VERSION "${KUBE_HUNTER_VERSION}"

WORKDIR /kube-hunter

COPY --from=builder /build/kube-hunter /kube-hunter

RUN apk --no-cache upgrade \
    && addgroup kube-hunter \
    && adduser -G kube-hunter -s /bin/sh -D kube-hunter

USER kube-hunter

ENTRYPOINT ["python", "kube-hunter.py"]

LABEL org.opencontainers.image.title="kube-hunter" \
    org.opencontainers.image.description="Aqua Security kube-hunter in Docker" \ 
    org.opencontainers.image.url="https://github.com/westonsteimel/docker-kube-hunter" \ 
    org.opencontainers.image.source="https://github.com/westonsteimel/docker-kube-hunter" \
    org.opencontainers.image.version="${KUBE_HUNTER_VERSION}"
