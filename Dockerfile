FROM alpine as builder

WORKDIR /build

RUN apk --no-cache upgrade && apk --no-cache add \
    git \
    && git clone --depth 1 https://github.com/aquasecurity/kube-hunter

FROM python:3-alpine

WORKDIR /kube-hunter

COPY --from=builder /build/kube-hunter /kube-hunter

RUN apk --no-cache upgrade && apk --no-cache add \
    linux-headers \
    build-base \
    tcpdump \
    wireshark \
    && pip install --no-cache-dir -r /kube-hunter/requirements.txt

ENTRYPOINT ["python", "kube-hunter.py"]
