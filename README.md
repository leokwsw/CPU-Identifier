# CPU Identifier

A macOS and iOS app that identifies Apple device models and CPU/chip information.

## Version 2.0.0 - Swift Rewrite

🚀 **Major Update**: CPU Identifier has been completely rewritten in Swift with native Apple Silicon support!

### What's New

- **Swift Codebase** - Modern, type-safe, and maintainable code
- **Universal Binary** - Native support for both ARM64 and x86_64
- **libimobiledevice** - Open-source library replaces private MobileDevice.framework
- **Future-Proof** - Compatible with macOS 28+ when Rosetta 2 is discontinued

## Features

- **Mac App**: Identifies connected iOS devices via USB and displays detailed hardware information
- **iOS App**: Identifies the current device's CPU/chip information
- Supports a wide range of Apple devices including iPhone, iPad, Mac, Apple Watch, Apple TV, and Apple Vision Pro

## Supported Devices

| Device Type | Models Supported |
|-------------|------------------|
| iPhone | iPhone 4 - iPhone 17, iPhone SE (all generations), iPhone Air |
| iPad | iPad 2 - iPad 10th gen, iPad Air 1-5, iPad mini 1-7, iPad Pro (all generations) |
| Mac | MacBook, MacBook Air, MacBook Pro, Mac mini, Mac Studio, Mac Pro, iMac (Intel & Apple Silicon) |
| Apple Watch | Series 1 - Series 11, SE, Ultra 1-3 |
| Apple TV | Apple TV 2nd gen - Apple TV 4K (3rd generation) |
| Apple Vision Pro | All models |
| iPod touch | All generations |

## Supported Chips

- **A-series**: A4 - A19 Pro
- **M-series**: M1, M1 Pro, M1 Max, M1 Ultra through M5, M5 Pro, M5 Max, M5 Ultra
- **S-series**: S1 - S9 (Apple Watch)
- **R-series**: R1 (Apple Vision Pro)
- **W-series**: W1, W2, W3 (Wireless chips)

## Installation

### Mac App

1. Download the DMG from the [Releases](../../releases) page
2. Open the DMG file
3. Drag "CPU Identifier" to your Applications folder

**No additional dependencies required!** The app bundles all necessary libraries.

### System Requirements

- **macOS**: 11.0 (Big Sur) or later
- **Architecture**: Universal Binary (ARM64 + x86_64)

## Architecture

### Version 2.0 (Swift)

```
CPU Identifier/
├── Shared/
│   └── DeviceDatabase.swift      # Shared device/chip identification data
├── CPU Identifier Mac/
│   └── Swift/
│       ├── AppDelegate.swift     # Mac app entry point
│       └── DeviceManager.swift   # libimobiledevice wrapper
└── CPU Identifier iOS/
    └── Swift/
        ├── AppDelegate.swift     # iOS app entry point
        └── ViewController.swift  # Main view controller
```

### Key Changes from 1.x

| Feature | Version 1.x (Objective-C) | Version 2.0 (Swift) |
|---------|---------------------------|---------------------|
| Language | Objective-C | Swift |
| iOS Device Communication | MobileDevice.framework (private) | AppleMobileDevice (bundled) |
| Architecture | x86_64 only | Universal Binary |
| Rosetta 2 Required | Yes | No |
| macOS 28+ Compatible | No | Yes |
| Device Data | Large if-else chains | Dictionary lookups |
| External Dependencies | None (but limited) | None (fully featured) |

## Building from Source

### Prerequisites

1. Xcode 14.0 or later
2. macOS 11.0 or later

### Build Steps

1. Clone the repository
2. Open `CPU Identifier.xcodeproj` in Xcode
3. Select the appropriate scheme:
   - `CPU Identifier Mac` for the macOS app
   - `CPU Identifier iOS` for the iOS app
4. Build and run

### Build Commands

```bash
# Build Universal Binary for Mac
xcodebuild \
  -project "CPU Identifier.xcodeproj" \
  -scheme "CPU Identifier Mac" \
  -configuration Release \
  ARCHS="arm64 x86_64" \
  ONLY_ACTIVE_ARCH=NO \
  MACOSX_DEPLOYMENT_TARGET=11.0
```

## Automated Device Updates

This repository includes a GitHub Actions workflow that automatically checks for new Apple device identifiers monthly. When new devices are detected, an issue is created to track the needed updates.

## Migration from 1.x

If you're upgrading from version 1.x:

1. **Download 2.0**: Get the new version from Releases
2. **Replace the app**: Simply drag the new version to Applications

Note: Your settings and preferences do not carry over as this is a complete rewrite. No external dependencies are required - everything is bundled in the app.

## Troubleshooting

### Device Not Detected

1. Ensure the device is unlocked
2. Trust the computer on your iOS device when prompted
3. Try unplugging and reconnecting the device

## License

See [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

### Adding New Devices

To add support for new devices, update the dictionaries in `Shared/DeviceDatabase.swift`:

```swift
// Add new chip
public let chipIdentifiers: [String: String] = [
    // ... existing entries ...
    "t8160": "A20 Pro",  // Example new chip
]

// Add new device
public let deviceIdentifiers: [String: String] = [
    // ... existing entries ...
    "iPhone19,1": "iPhone 18 Pro",  // Example new device
]
```

## Acknowledgments

- [libimobiledevice](https://libimobiledevice.org/) - Cross-platform library for iOS device communication
- [The iPhone Wiki](https://www.theiphonewiki.com/) - Device identifier reference
- [kyle-seongwoo-jun/apple-device-identifiers](https://github.com/kyle-seongwoo-jun/apple-device-identifiers) - Device identifier database
