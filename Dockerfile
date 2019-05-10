FROM python:3-alpine as builder

WORKDIR /build

RUN apk --no-cache upgrade && apk --no-cache add \
    git \
    linux-headers \
    build-base \
    tcpdump \
    && git clone --depth 1 https://github.com/aquasecurity/kube-hunter \
    && pip install --no-cache-dir -r kube-hunter/requirements.txt --upgrade -t kube-hunter

FROM python:3-alpine

WORKDIR /kube-hunter

COPY --from=builder /build/kube-hunter /kube-hunter

RUN apk --no-cache upgrade \
    && addgroup kube-hunter \
    && adduser -G kube-hunter -s /bin/sh -D kube-hunter

USER kube-hunter

ENTRYPOINT ["python", "kube-hunter.py"]
