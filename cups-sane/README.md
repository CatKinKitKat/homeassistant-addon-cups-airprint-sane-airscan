
# CUPS AirPrint & SANE AirScan Add-on

A unified print and scan server for Home Assistant that provides CUPS printing with AirPrint support and SANE scanning with AirScan compatibility. Now based on Debian for broader compatibility and easier package management.

## About

This add-on combines two essential services into one efficient container:
- **CUPS** - Complete printing system with AirPrint support for iOS, macOS, and Windows
- **SANE** - Comprehensive scanning system with AirScan/eSCL support for modern scanners

## Features

- 🖨️ **Universal Printing**: Support for Canon, Epson, HP, Brother, and other modern printers
- 📱 **AirPrint Compatible**: Print wirelessly from iOS, macOS, and Windows devices
- 🔍 **Network Scanning**: Share USB scanners over the network
- 📦 **HP Backend**: Basic support for USB HP scanners via SANE `hp` driver
- 📲 **AirSane eSCL Server**: Share USB scanners via the AirScan protocol
- 🔌 **USB Support**: Direct connection to USB printers and scanners
- 🌐 **Auto-Discovery**: Automatic detection of network printers and scanners

## Installation

1. Add this repository to your Home Assistant add-on store
2. Install the "CUPS AirPrint & SANE AirScan" add-on
3. Configure the options as needed
4. Start the add-on

## Configuration

```yaml
log_level: info
share_printers: true
allow_from:
  - "192.168.1.0/24"    # Your home network
  - "127.0.0.1"         # Localhost
cups_log_to_stdout: true
sane_debug: 0
debug_mode: false
allowed_networks:
  - "192.168.1.0/24"    # Your home network
  - "127.0.0.1"         # Localhost
```

### Configuration Options

- **log_level**: Set logging verbosity (trace, debug, info, notice, warning, error, fatal)
- **share_printers**: Enable AirPrint broadcasting of connected printers
- **allow_from**: Networks allowed to access the CUPS web interface and printing
- **cups_log_to_stdout**: Send CUPS logs to add-on log (true) or files (false)
- **sane_debug**: SANE debug level (0 = none, higher = more verbose)
- **debug_mode**: Enable extra diagnostic output
- **allowed_networks**: Networks allowed to access scanning services

## Usage

### Adding Printers

1. Connect USB printers or ensure network printers are on the same network
2. Access the CUPS web interface at `http://YOUR_HA_IP:631`
3. Go to Administration → Add Printer
4. Select your printer and configure it

### Using AirPrint

Once printers are added and shared:
- **iOS/iPadOS**: Open any app → Share → Print → Select your printer
- **macOS**: File → Print → Select your printer from the list
- **Windows**: Add network printer, it should appear automatically

### Scanning

- **USB Scanners**: Connect to Home Assistant host, they'll be shared automatically
- **Network Scanners**: Will be discovered automatically if they support eSCL/AirScan
- **Mobile Scanning**: Use any AirScan-compatible app to scan from shared devices

## Network Requirements

- **Port 631**: CUPS web interface and IPP printing
- **Port 8090**: AirSane eSCL server for network scanning
- **mDNS/Bonjour**: For automatic service discovery

## Troubleshooting

### No Printers Appear

1. Check that `share_printers` is enabled
2. Verify your device is on an allowed network
3. Restart the add-on after adding printers

### Can't Access Web Interface

1. Ensure your client IP is in the `allow_from` list
2. Try `http://HA_IP:631` (not HTTPS)
3. Check add-on logs for access denied messages

### Scanning Issues

1. Verify USB permissions if using USB scanners
2. Check that `allowed_networks` includes your client network
3. Enable `sane_debug` for detailed scanning logs

### Enable Debug Mode

Set `debug_mode: true` in configuration to see:
- Generated configuration files
- Process information
- Environment details

## Support

For issues and support:
- Check the add-on logs first
- Enable debug mode for detailed diagnostics
- Report issues on the GitHub repository

## Hardware Compatibility

### Printers
- Most modern Canon, Epson, HP, Brother printers
- Any printer supporting IPP Everywhere or AirPrint
- USB and network printers

### Scanners
- Canon PIXMA series (pixma backend)
- Epson scanners (epson2 backend)
- HP scanners (hp backend)
- Brother, Fujitsu, Kodak, and other major brands
- Network scanners with eSCL/AirScan support
