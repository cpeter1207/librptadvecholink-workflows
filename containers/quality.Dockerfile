FROM ghcr.io/cpeter1207/rptadv-codecs-quality-debian13:latest AS jitter-build
COPY --from=jitter . /source/
WORKDIR /source
RUN CARGO_BUILD_JOBS=2 cargo +1.85.0 build --locked --release -p rptadv-jitter-adapter

FROM ghcr.io/cpeter1207/rptadv-codecs-quality-debian13:latest
LABEL org.opencontainers.image.source="https://github.com/cpeter1207/librptadvecholink-workflows"
COPY --from=jitter-build /source/target/release/librptadv_jitter_adapter.so /tmp/jitter.so
RUN library=/usr/lib/$(gcc -print-multiarch)/rpt_advanced && \
    install -d "$library" && \
    install -m 0755 /tmp/jitter.so "$library/librptadv_jitter_adapter.so.1" && \
    rm /tmp/jitter.so
WORKDIR /work
