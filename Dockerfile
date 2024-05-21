FROM finchsec/kali:base as builder
# hadolint ignore=DL3005,DL3008,DL3015
RUN apt-get update && \
    apt-get dist-upgrade -y && \
    apt-get install ca-certificates git gcc make libssl-dev zlib1g-dev pkg-config \
            libcurl4-openssl-dev -y --no-install-recommends
RUN git clone https://github.com/ZerBea/hcxtools
WORKDIR /hcxtools
RUN make && \
    make install DESTDIR=/hcxtools

FROM finchsec/kali:base
LABEL org.opencontainers.image.authors="thomas@finchsec.com"
# hadolint ignore=DL3005,DL3008
RUN apt-get update && \
    apt-get dist-upgrade -y && \
        apt-get install ca-certificates zlib1g libcurl4t64 --no-install-recommends -y && \
        apt-get autoclean && \
		rm -rf /var/lib/dpkg/status-old /var/lib/apt/lists/*
COPY --from=builder /hcxtools/usr/bin/* /usr/local/bin/