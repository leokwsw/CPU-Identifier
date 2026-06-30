# CPU Identifier

A macOS and iOS app that identifies Apple device models and CPU/chip information.

## Current Status

The current release uses Objective-C with `MobileDevice.framework` and requires x86_64 (Intel or Apple Silicon with Rosetta 2).

### Swift 2.0 Migration (In Progress)

Swift source files have been prepared for a future native Apple Silicon release:
- `Shared/DeviceDatabase.swift` - Shared device/chip identification data
- `CPU Identifier Mac/Swift/` - Mac app Swift sources
- `CPU Identifier iOS/Swift/` - iOS app Swift sources

> ⚠️ **Note**: The Xcode project still builds the Objective-C sources. Full Swift migration requires updating the project configuration to use these new files and the AppleMobileDevice Swift package.

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

### System Requirements

- **macOS**: 10.8 (Mountain Lion) or later
- **Architecture**: x86_64 (Intel or Apple Silicon with Rosetta 2)

> ⚠️ **Rosetta 2 Deprecation**: Apple plans to discontinue full Rosetta 2 support in macOS 28 (late 2027). A Swift version with native Apple Silicon support is in development.

## Architecture

### Current Version (Objective-C)

```
CPU Identifier/
├── CPU Identifier Mac/
│   ├── CPUIdentifierAppDelegate.m  # Mac app entry point
│   ├── MobileDevice.framework      # Apple private framework (x86_64)
│   └── MainMenu.xib                # UI definition
└── CPU Identifier iOS/
    ├── AppDelegate.m               # iOS app entry point
    └── ViewController.m            # Main view controller
```

### Prepared Swift Files (Future)

```
CPU Identifier/
├── Shared/
│   └── DeviceDatabase.swift        # Shared device/chip data (dictionaries)
├── CPU Identifier Mac/Swift/
│   ├── AppDelegate.swift           # Mac app entry point
│   └── DeviceManager.swift         # libimobiledevice wrapper
└── CPU Identifier iOS/Swift/
    ├── AppDelegate.swift           # iOS app entry point
    └── ViewController.swift        # Main view controller
```

### Planned Migration to Swift 2.0

| Feature | Current (Objective-C) | Future Swift 2.0 |
|---------|----------------------|------------------|
| Language | Objective-C | Swift |
| iOS Device Communication | MobileDevice.framework (x86_64 only) | AppleMobileDevice (Universal) |
| Architecture | x86_64 only | ARM64 + x86_64 |
| Rosetta 2 Required | Yes | No |
| macOS 28+ Compatible | No | Yes |
| Device Data | Large if-else chains | Dictionary lookups |

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
# Build for Mac (x86_64)
xcodebuild \
  -project "CPU Identifier.xcodeproj" \
  -scheme "CPU Identifier Mac" \
  -configuration Release \
  -arch x86_64 \
  ARCHS=x86_64 \
  VALID_ARCHS=x86_64
```

## Automated Device Updates

This repository includes a GitHub Actions workflow that automatically checks for new Apple device identifiers monthly. When new devices are detected, an issue is created to track the needed updates.

## Updates

New releases are available on the [Releases](../../releases) page. Simply download the latest DMG and replace the existing application.

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

For the current Objective-C version, update the if-else chains in:
- `CPU Identifier Mac/CPUIdentifierAppDelegate.m`
- `CPU Identifier iOS/ViewController.m`

For the prepared Swift version, update the dictionaries in `Shared/DeviceDatabase.swift`:

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
