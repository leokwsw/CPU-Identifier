# CPU Identifier

A macOS and iOS app that identifies Apple device models and CPU/chip information.

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

### Requirements

- **macOS**: 10.13 (High Sierra) or later
- **Architecture**: Intel (x86_64) - runs on Apple Silicon via Rosetta 2

## ⚠️ Important: Rosetta 2 Deprecation Notice

> **This app is built for Intel (x86_64) architecture due to the `MobileDevice.framework` dependency, which does not support ARM64.**

### Timeline

| macOS Version | Expected Release | Rosetta 2 Status |
|---------------|------------------|------------------|
| macOS 26 (Tahoe) | Available Now | ✅ Full support |
| macOS 27 (Golden Gate) | Autumn 2026 | ✅ Full support (LAST version) |
| macOS 28 | Late 2027 | ❌ Limited to legacy games only |

### What This Means

- **macOS 26 & 27**: CPU Identifier will work normally via Rosetta 2
- **macOS 28 and later**: CPU Identifier **will NOT work** unless rebuilt with native ARM64 support

### Future Plans

The `MobileDevice.framework` is a private Apple framework that only supports x86_64 architecture. To continue supporting future macOS versions, the app would need to:

1. Find an alternative API for iOS device communication that supports ARM64
2. Remove the iOS device detection feature and focus only on local Mac identification
3. Use command-line tools or other approaches

Contributions and suggestions are welcome!

## Building from Source

1. Clone the repository
2. Open `CPU Identifier.xcodeproj` in Xcode
3. Select the appropriate scheme:
   - `CPU Identifier Mac` for the macOS app
   - `CPU Identifier iOS` for the iOS app
4. Build and run

### Build Notes

The Mac app must be built for x86_64 architecture:

```bash
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

## License

See [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
