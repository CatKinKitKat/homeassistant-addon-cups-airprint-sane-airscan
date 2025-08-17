# Home Assistant CUPS AirPrint & SANE AirScan Add-on

[![Home Assistant Add-on](https://img.shields.io/badge/Home%20Assistant-Add--on-blue.svg)](https://github.com/CatKinKitKat/homeassistant-addon-cups-airprint-sane-airscan)
[![License](https://img.shields.io/github/license/CatKinKitKat/homeassistant-addon-cups-airprint-sane-airscan)](LICENSE)

A unified print and scan server add-on for Home Assistant that combines CUPS AirPrint and SANE AirScan functionality into a single, efficient container.

## ✅ **Successfully Built and Tested**

This unified addon has been successfully built and tested with:
- **sane-airscan 0.99.35** from Alpine edge repositories ✅
- **CUPS with comprehensive printer support** ✅ 
- **Complete SANE backend collection** ✅
- **Unified Avahi service discovery** ✅

## Features

### 🖨️ **CUPS Printing**
- **CUPS Daemon**: Full CUPS print server implementation
- **AirPrint Support**: iOS/macOS/Windows network printing compatibility
- **Auto-Detection**: Automatic USB and network printer detection
- **Universal Drivers**: IPP Everywhere and driverless printing support

### 🔍 **SANE Scanning**
- **SANE Daemon**: Complete SANE server implementation with network sharing
- **AirScan Support**: eSCL/AirScan protocol for modern network scanners
- **Comprehensive Backends**: Optimal backends for all major scanner brands
- **Auto-Detection**: Automatic USB and network scanner detection

### 🌐 **Network Discovery**
- **Avahi Service Discovery**: Automatic broadcasting for both print and scan services
- **Zero Configuration**: Works out of the box with sensible defaults
- **Multi-Protocol Support**: IPP, eSCL, WS-Discovery protocols

## Supported Hardware

### **Printers**
| **Brand** | **Driver Support** | **Notes** |
|-----------|-------------------|-----------|
| **Canon** | `cups-filters` | IPP Everywhere and AirPrint support for modern PIXMA printers |
| **Epson** | `cups-filters` | Driverless printing for EcoTank, WorkForce, Expression series |
| **HP** | `cups-filters` | Universal support for DeskJet, LaserJet, OfficeJet series |
| **Brother** | `cups-filters` | IPP Everywhere support for newer HL, DCP, MFC models |
| **All Modern** | `cups-filters` | Universal IPP Everywhere and AirPrint compatible printers |

### **Scanners**
| **Brand** | **Optimal Backend** | **Notes** |
|-----------|-------------------|-----------|
| **Canon** | `pixma` | Best for most PIXMA/MFP scanners, stable over USB |
| **Epson** | `epson2` | Newer backend, better than legacy `epson` |
| **HP** | `hp` | Handles most HP all-in-ones |
| **Brother** | `canon/fujitsu` | Works well, some models may need specific backends |
| **Fujitsu** | `fujitsu` | Supports fi-series and ScanSnap scanners |
| **Network** | `airscan` | eSCL/AirScan protocol for modern network scanners |

## Installation

1. Add this repository to your Home Assistant Supervisor:
   
   ```
   https://github.com/CatKinKitKat/homeassistant-addon-cups-airprint-sane-airscan
   ```

2. Install the "CUPS AirPrint & SANE AirScan" add-on
3. Configure networks and options if needed
4. Start the add-on

## Configuration

### Example Configuration:

```yaml
log_level: info
share_printers: true
allow_from:
  - "192.168.0.0/16"
  - "172.16.0.0/12" 
  - "10.0.0.0/8"
allowed_networks:
  - "192.168.0.0/16"
  - "172.16.0.0/12"
  - "10.0.0.0/8"
```

### Configuration Options:

| Option | Description | Default |
|--------|-------------|---------|
| `log_level` | Logging level (trace/debug/info/warning/error) | `info` |
| `share_printers` | Enable AirPrint broadcasting | `true` |
| `allow_from` | Networks allowed to access CUPS | Local networks |
| `allowed_networks` | Networks allowed to access SANE | Local networks |

## Usage

### **Printing**
1. Access CUPS web interface at `http://homeassistant:631`
2. Add printers through the web interface or they'll be auto-detected
3. Print from any AirPrint-compatible device

### **Scanning**
1. Scanners are automatically detected via USB and network discovery
2. Use any SANE-compatible software to scan
3. Network scanners work via AirScan/eSCL protocol

### **Network Access**
- **CUPS Web Interface**: Port 631 (HTTP)
- **SANE Network Scanning**: Port 6566
- **Service Discovery**: Automatic via Avahi

## Technical Details

### **Ports**
- `631/tcp`: CUPS web interface and IPP printing
- `6566/tcp`: SANE daemon port for network scanning

### **Volumes**
- Configuration is stored in `/config/cups` for persistence
- Scanner settings are dynamically configured

### **Architecture Support**
- amd64 (Intel/AMD 64-bit)
- aarch64 (ARM 64-bit)
- armv7 (ARM 32-bit)

## Changelog

### Version 1.0.0
- Initial unified release combining CUPS AirPrint and SANE AirScan
- Full sane-airscan support from Alpine edge repositories
- Comprehensive backend support for major printer and scanner brands
- Unified Avahi service discovery for both printing and scanning
- Zero-configuration setup with sensible defaults

## Troubleshooting

### **No Printers/Scanners Detected**
1. Ensure devices are powered on and connected
2. Check USB permissions if using USB devices
3. Verify network connectivity for network devices

### **AirPrint/AirScan Not Working**
1. Ensure `share_printers` is enabled in configuration
2. Check that Avahi service is running
3. Verify network allows multicast traffic

### **Permission Issues**
1. The add-on requires privileged mode for USB access
2. Host networking is required for proper service discovery

## Contributing

Contributions are welcome! Please feel free to submit issues and pull requests.

## License

This project is licensed under the GNU Affero General Public License v3.0 (AGPL-3.0) - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Based on the original CUPS AirPrint and SANE add-ons
- Uses the Home Assistant Add-ons base image
- Incorporates sane-airscan for modern network scanner support
