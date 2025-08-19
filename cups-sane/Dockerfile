FROM ghcr.io/hassio-addons/base:14.2.0

LABEL io.hass.version="1.0.0" \
      io.hass.type="addon" \
      io.hass.arch="aarch64|amd64|armv7" \
      maintainer="CatKinKitKat" \
      description="Unified CUPS AirPrint and SANE AirScan server with comprehensive printer and scanner support"

# Set shell
SHELL ["/bin/ash", "-o", "pipefail", "-c"]

# Add env
ENV TERM="xterm-256color"

# Create necessary directories for both CUPS and SANE
RUN mkdir -p /var/spool/cups \
    && mkdir -p /var/log/cups \
    && mkdir -p /run/cups \
    && mkdir -p /var/lock/sane \
    && mkdir -p /var/log/sane

# Add edge repositories for sane-airscan availability
RUN echo "https://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories \
    && echo "https://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories

# Force upgrade openssl to resolve conflicts
RUN apk update && apk add --upgrade openssl libcrypto3 libssl3

# Install packages step by step to isolate issues
RUN apk add --no-cache \
    bash \
    avahi \
    avahi-tools \
    avahi-compat-libdns_sd \
    nss-mdns \
    dbus \
    && rm -rf /var/cache/apk/*

RUN apk add --no-cache \
    sane \
    sane-utils \
    sane-airscan \
    && rm -rf /var/cache/apk/*

RUN apk add --no-cache \
    sane-backend-net \
    sane-backend-pixma \
    sane-backend-epson2 \
    sane-backend-hp \
    sane-backend-canon \
    sane-backend-canon_dr \
    sane-backend-fujitsu \
    sane-backend-kodak \
    sane-backend-plustek \
    sane-backend-umax \
    sane-backend-lexmark \
    sane-backend-ricoh \
    sane-backend-sharp \
    && rm -rf /var/cache/apk/*

# Try CUPS separately at the end
RUN apk add --no-cache \
    cups \
    cups-client \
    cups-libs \
    cups-filters \
    cups-filters-libs \
    shadow \
    && rm -rf /var/cache/apk/*

# Build and install AirSane for eSCL/AirScan sharing
ARG AIRSANE_VERSION="v0.4.5"
RUN apk add --no-cache --virtual .build-deps \
        build-base \
        cmake \
        git \
        libjpeg-turbo-dev \
        libpng-dev \
        libusb-dev \
        avahi-dev \
        sane-dev \
    && git clone --depth 1 --branch ${AIRSANE_VERSION} https://github.com/SimulPiscator/AirSane.git /tmp/AirSane \
    && cmake -S /tmp/AirSane -B /tmp/AirSane/build \
    && cmake --build /tmp/AirSane/build --target airsaned \
    && install -m755 /tmp/AirSane/build/airsaned /usr/local/bin/airsaned \
    && rm -rf /tmp/AirSane \
    && apk del .build-deps

# Copy root filesystem
COPY rootfs /

# Set permissions for both services
RUN chmod +x /etc/services.d/app/run \
    && chmod +x /usr/local/bin/configure-cups \
    && chmod +x /usr/local/bin/configure-sane \
    && chown -R root:lp /etc/cups \
    && chmod 755 /var/spool/cups \
    && adduser -D -G lp print \
    && chown -R root:root /etc/sane.d \
    && chmod 755 /var/lock/sane

# Health check for both services
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD (lpstat -r && nc -z localhost 8090) || exit 1

# Expose CUPS and AirSane ports
EXPOSE 631 8090
