FROM ghcr.io/home-assistant/base:3.24

ARG BUILD_VERSION="2.1.1"
ARG BUILD_ARCH
ARG FRP_VERSION="0.71.0"
ARG FRP_SHA256_AMD64="84f27e39f11169f7adcef8e8b70c9329de17747b1f14dad9fb95eef5682ea716"
ARG FRP_SHA256_AARCH64="f33c293c275d8fc68c654b6fba8f10b2551d6463d09a9fc9cffb7227eae82266"

LABEL \
    io.hass.version="${BUILD_VERSION}" \
    io.hass.type="app" \
    io.hass.arch="${BUILD_ARCH}" \
    org.opencontainers.image.title="Home Assistant FRP Client" \
    org.opencontainers.image.description="FRP client app for Home Assistant" \
    org.opencontainers.image.source="https://github.com/HASSAAS/FRP-Client" \
    org.opencontainers.image.version="${BUILD_VERSION}"

COPY bootstrap.sh /
COPY run.sh /

RUN chmod 0755 /bootstrap.sh /run.sh \
    && /bootstrap.sh \
        "${BUILD_ARCH}" \
        "${FRP_VERSION}" \
        "${FRP_SHA256_AMD64}" \
        "${FRP_SHA256_AARCH64}" \
    && rm -f /bootstrap.sh

CMD ["/run.sh"]
