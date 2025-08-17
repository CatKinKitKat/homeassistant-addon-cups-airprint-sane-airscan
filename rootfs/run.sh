#!/usr/bin/with-contenv bashio
#
# CUPS AirPrint & SANE AirScan Unified Add-on for Home Assistant
# Copyright (C) 2025 CatKinKitKat
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program. If not, see <https://www.gnu.org/licenses/>.

set -e

# Set ulimits
ulimit -n 524288

# Get configuration options
LOG_LEVEL=$(bashio::config 'log_level')
SHARE_PRINTERS=$(bashio::config 'share_printers')
ALLOW_FROM=$(bashio::config 'allow_from')
ALLOWED_NETWORKS=$(bashio::config 'allowed_networks')

bashio::log.info "Starting CUPS AirPrint & SANE AirScan Server v1.0.0"
bashio::log.info "Log Level: ${LOG_LEVEL}"

# Configure CUPS
bashio::log.info "Configuring CUPS daemon..."
/usr/local/bin/configure-cups

# Configure SANE
bashio::log.info "Configuring SANE daemon..."
/usr/local/bin/configure-sane

# Start DBus daemon (required for Avahi)
bashio::log.info "Starting DBus daemon..."
dbus-daemon --system &

# Start Avahi daemon for both AirPrint and AirScan service discovery
bashio::log.info "Starting Avahi daemon for service discovery..."
avahi-daemon --daemonize

# Wait a moment for Avahi to start
sleep 2

# Start SANE daemon in background
bashio::log.info "Starting SANE daemon..."
saned -l --user=root &

# Wait a moment for SANE to start
sleep 1

# Start CUPS daemon (foreground process)
bashio::log.info "Starting CUPS daemon..."
exec cupsd -f
