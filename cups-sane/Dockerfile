FROM ghcr.io/hassio-addons/debian-base:7.8.3

LABEL io.hass.version="1.1.0" \
  io.hass.type="addon" \
  io.hass.arch="aarch64|amd64|armv7" \
  maintainer="CatKinKitKat" \
  description="Unified CUPS AirPrint and SANE AirScan server with comprehensive printer and scanner support"

SHELL ["/bin/bash", "-c"]
ENV TERM="xterm-256color"

# CUPS/SANE runtime dirs
RUN mkdir -p /var/spool/cups /var/log/cups /run/cups \
    && mkdir -p /var/lock/sane /var/log/sane

# --- Core OS + Avahi/mDNS + tools (nc for healthcheck)
RUN apt-get update && apt-get install -y --no-install-recommends \
      bash ca-certificates curl dbus \
      avahi-daemon avahi-utils libnss-mdns \
      netcat-openbsd \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# --- SANE (driverless AirScan + classic backends)
RUN apt-get update && apt-get install -y --no-install-recommends \
      libsane1 libsane-common sane-utils sane-airscan libsane-hpaio \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# --- CUPS + filters + IPP-over-USB
RUN apt-get update && apt-get install -y --no-install-recommends \
      cups cups-client \
      cups-filters cups-filters-core-drivers cups-browsed \
      ghostscript \
      ipp-usb \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# --- Broad printer drivers (brand coverage)
RUN apt-get update && apt-get install -y --no-install-recommends \
      hplip printer-driver-hpcups printer-driver-postscript-hp \
      printer-driver-gutenprint \
      printer-driver-escpr \
      printer-driver-brlaser \
      printer-driver-splix \
      printer-driver-fujixerox \
      printer-driver-foo2zjs \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# --- Build and install AirSane (eSCL/AirScan sharing for SANE devices)
ARG AIRSANE_VERSION="v0.4.5"
RUN apt-get update && apt-get install -y --no-install-recommends \
      build-essential cmake git \
      libjpeg-dev libpng-dev libusb-1.0-0-dev libavahi-client-dev libsane-dev \
    && git clone --depth 1 --branch "${AIRSANE_VERSION}" https://github.com/SimulPiscator/AirSane.git /tmp/AirSane \
    && cmake -S /tmp/AirSane -B /tmp/AirSane/build \
    && cmake --build /tmp/AirSane/build --target airsaned \
    && install -m755 /tmp/AirSane/build/airsaned /usr/local/bin/airsaned \
    && rm -rf /tmp/AirSane \
    && apt-get purge -y --auto-remove \
         build-essential cmake git \
         libjpeg-dev libpng-dev libusb-1.0-0-dev libavahi-client-dev libsane-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy s6-overlay v3 service definitions + helper scripts
# Expecting your rootfs to use: /etc/s6-overlay/s6-rc.d/* (v3), /etc/cont-init.d/*, etc.
COPY rootfs /

# Permissions & users (after packages so groups exist)
RUN chmod +x /usr/local/bin/configure-cups /usr/local/bin/configure-sane || true \
    && find /etc/s6-overlay/s6-rc.d -type f -name run -exec chmod +x {} + || true \
    && groupadd -f lp \
    && id -u print &>/dev/null || useradd -r -s /usr/sbin/nologin -g lp -G lpadmin,scanner print \
    && chown -R root:lp /etc/cups \
    && chmod 755 /var/spool/cups \
    && chown -R root:root /etc/sane.d \
    && chmod 755 /var/lock/sane

# Health check: ensure CUPS scheduler is up and ports are open
HEALTHCHECK --interval=5s --timeout=3s --start-period=30s --retries=30 \
  CMD sh -c '\
    lpstat -r >/dev/null 2>&1 && \
    nc -z -w2 127.0.0.1 631 && \
    nc -z -w2 127.0.0.1 8090'

# Ports:
# 631/tcp (IPP/CUPS), 8090/tcp (AirSane UI/API), 5353/udp (mDNS/Bonjour)
EXPOSE 631/tcp 8090/tcp 5353/udp
