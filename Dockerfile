ARG KUBE_HUNTER_VERSION="master"

FROM python:3-alpine as builder

ARG KUBE_HUNTER_VERSION

WORKDIR /build

RUN apk --no-cache upgrade && apk --no-cache add \
    git \
    linux-headers \
    build-base \
    && git clone --depth 1 --branch "${KUBE_HUNTER_VERSION}" https://github.com/aquasecurity/kube-hunter \
    && mkdir /kube-hunter \
    && cp kube-hunter/setup.py /kube-hunter \
    && cp kube-hunter/setup.cfg /kube-hunter \
    && cp kube-hunter/Makefile /kube-hunter \
    && cd /kube-hunter \
    && make deps \
    && cp -r /build/kube-hunter/* /kube-hunter/ \
    && make install

FROM python:3-alpine

ARG KUBE_HUNTER_VERSION
ENV KUBE_HUNTER_VERSION "${KUBE_HUNTER_VERSION}"

WORKDIR /kube-hunter

COPY --from=builder /kube-hunter /kube-hunter

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
