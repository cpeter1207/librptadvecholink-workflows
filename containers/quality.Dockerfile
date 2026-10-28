FROM ghcr.io/cpeter1207/rptadv-codecs-quality-debian13:latest
LABEL org.opencontainers.image.source="https://github.com/cpeter1207/librptadvecholink-workflows"
COPY --from=dependencies . /tmp/echolink-dependencies/
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      /tmp/echolink-dependencies/*.deb && \
    rm -rf /var/lib/apt/lists/* /tmp/echolink-dependencies
WORKDIR /work
