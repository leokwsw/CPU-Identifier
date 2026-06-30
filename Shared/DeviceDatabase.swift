import Foundation

/// Shared device and chip identification database
/// This replaces the large if-else chains in Objective-C with dictionaries

// MARK: - Chip Identifiers

/// Maps hardware platform codes to chip names
public let chipIdentifiers: [String: String] = [
    // A-series (iPhone/iPad)
    "s5l8900": "Older Version",
    "s5l8720": "Older Version",
    "s5l8920": "Older Version",
    "s5l8922": "Older Version",
    "s5l8930": "A4",
    "s5l8940": "A5",
    "s5l8942x": "A5 Rev A",
    "s5l8945": "A5X",
    "s5l8947": "A5 Rev B",
    "s5l8950": "A6",
    "s5l8955": "A6X",
    "s5l8960": "A7",
    "s5l8965": "A7 Variant",
    "t7000": "A8",
    "t7001": "A8X",
    "s8000": "A9 (Samsung)",
    "s8001": "A9X",
    "s8003": "A9 (TSMC)",
    "t8010": "A10 Fusion",
    "t8011": "A10X Fusion",
    "t8015": "A11 Bionic",
    "t8020": "A12 Bionic",
    "t8027": "A12X Bionic",
    "t8030": "A13 Bionic",
    "t8101": "A14 Bionic",
    "t8110": "A15 Bionic",
    "t8120": "A16 Bionic",
    "t8130": "A17 Pro",
    "t8140a": "A18",
    "t8140": "A18 Pro",
    "t8150": "A19 Pro",
    
    // M-series (Mac/iPad Pro)
    "t8103": "M1",
    "t6000": "M1 Pro",
    "t6001": "M1 Max",
    "t6002": "M1 Ultra",
    "t8112": "M2",
    "t6020": "M2 Pro",
    "t6021": "M2 Max",
    "t6022": "M2 Ultra",
    "t8122": "M3",
    "t6030": "M3 Pro",
    "t6031": "M3 Max",
    "t6034": "M3 Max",
    "t6032": "M3 Ultra",
    "t8132": "M4",
    "t6040": "M4 Pro",
    "t6041": "M4 Max",
    "t8142": "M5",
    "t6050": "M5 Pro",
    
    // S-series (Apple Watch) and T-series (Security Chip)
    "s7002": "S1",
    "t8002": "S1P / S2 / T1",
    "t8004": "S3",
    "t8006": "S4",
    "t8301": "S5/S6",
    "t8310": "S9",
    "t8012": "T2",
    
    // W-series (Wireless Chip)
    "w1": "W1",
    "w2": "W2",
    "w3": "W3",
    
    // R-series (Apple Vision Pro)
    "t6500": "R1"
]

// MARK: - Device Identifiers

/// Maps product type codes to device names
public let deviceIdentifiers: [String: String] = [
    // iPod touch
    "iPod1,1": "iPod touch 1 Gen",
    "iPod2,1": "iPod touch 2 Gen",
    "iPod3,1": "iPod touch 3 Gen",
    "iPod4,1": "iPod touch 4 Gen",
    "iPod5,1": "iPod touch 5 Gen",
    "iPod7,1": "iPod touch (6th generation)",
    "iPod9,1": "iPod touch (7th generation)",
    
    // Apple TV
    "AppleTV1,1": "Apple TV 1G",
    "AppleTV2,1": "Apple TV 2G",
    "AppleTV3,1": "Apple TV 3G",
    "AppleTV3,2": "Apple TV 3G",
    "AppleTV5,3": "Apple TV 4G",
    "AppleTV6,2": "Apple TV 4K (1st generation)",
    "AppleTV11,1": "Apple TV 4K (2nd generation)",
    "AppleTV14,1": "Apple TV 4K (3rd generation)",
    
    // Apple Watch
    "Watch1,1": "Apple Watch",
    "Watch1,2": "Apple Watch",
    "Watch2,6": "Apple Watch Series 1",
    "Watch2,7": "Apple Watch Series 1",
    "Watch2,3": "Apple Watch Series 2",
    "Watch2,4": "Apple Watch Series 2",
    "Watch3,1": "Apple Watch Series 3",
    "Watch3,2": "Apple Watch Series 3 Cellular",
    "Watch3,3": "Apple Watch Series 3",
    "Watch3,4": "Apple Watch Series 3 Cellular",
    "Watch4,1": "Apple Watch Series 4 (GPS)",
    "Watch4,2": "Apple Watch Series 4 (GPS)",
    "Watch4,3": "Apple Watch Series 4 (GPS + Cellular)",
    "Watch4,4": "Apple Watch Series 4 (GPS + Cellular)",
    "Watch5,1": "Apple Watch Series 5 (GPS)",
    "Watch5,2": "Apple Watch Series 5 (GPS)",
    "Watch5,3": "Apple Watch Series 5 (GPS + Cellular)",
    "Watch5,4": "Apple Watch Series 5 (GPS + Cellular)",
    "Watch5,9": "Apple Watch SE (GPS)",
    "Watch5,10": "Apple Watch SE (GPS)",
    "Watch5,11": "Apple Watch SE (GPS + Cellular)",
    "Watch5,12": "Apple Watch SE (GPS + Cellular)",
    "Watch6,1": "Apple Watch Series 6 (GPS)",
    "Watch6,2": "Apple Watch Series 6 (GPS)",
    "Watch6,3": "Apple Watch Series 6 (GPS + Cellular)",
    "Watch6,4": "Apple Watch Series 6 (GPS + Cellular)",
    "Watch6,6": "Apple Watch Series 7 (GPS)",
    "Watch6,7": "Apple Watch Series 7 (GPS)",
    "Watch6,8": "Apple Watch Series 7 (GPS + Cellular)",
    "Watch6,9": "Apple Watch Series 7 (GPS + Cellular)",
    "Watch6,10": "Apple Watch SE (2nd generation) (GPS)",
    "Watch6,11": "Apple Watch SE (2nd generation) (GPS)",
    "Watch6,12": "Apple Watch SE (2nd generation) (GPS + Cellular)",
    "Watch6,13": "Apple Watch SE (2nd generation) (GPS + Cellular)",
    "Watch6,14": "Apple Watch Series 8 (GPS)",
    "Watch6,15": "Apple Watch Series 8 (GPS)",
    "Watch6,16": "Apple Watch Series 8 (GPS + Cellular)",
    "Watch6,17": "Apple Watch Series 8 (GPS + Cellular)",
    "Watch6,18": "Apple Watch Ultra",
    "Watch7,1": "Apple Watch Series 9 (GPS)",
    "Watch7,2": "Apple Watch Series 9 (GPS)",
    "Watch7,3": "Apple Watch Series 9 (GPS + Cellular)",
    "Watch7,4": "Apple Watch Series 9 (GPS + Cellular)",
    "Watch7,5": "Apple Watch Ultra 2",
    "Watch7,8": "Apple Watch Series 10 (GPS)",
    "Watch7,9": "Apple Watch Series 10 (GPS)",
    "Watch7,10": "Apple Watch Series 10 (GPS + Cellular)",
    "Watch7,11": "Apple Watch Series 10 (GPS + Cellular)",
    "Watch7,12": "Apple Watch Ultra 3",
    "Watch7,13": "Apple Watch SE 3 (GPS)",
    "Watch7,14": "Apple Watch SE 3 (GPS)",
    "Watch7,15": "Apple Watch SE 3 (GPS + Cellular)",
    "Watch7,16": "Apple Watch SE 3 (GPS + Cellular)",
    "Watch7,17": "Apple Watch Series 11 (GPS)",
    "Watch7,18": "Apple Watch Series 11 (GPS)",
    "Watch7,19": "Apple Watch Series 11 (GPS + Cellular)",
    "Watch7,20": "Apple Watch Series 11 (GPS + Cellular)",
    
    // iPhone
    "iPhone1,1": "iPhone",
    "iPhone1,2": "iPhone 3G",
    "iPhone2,1": "iPhone 3GS",
    "iPhone3,1": "iPhone 4",
    "iPhone3,2": "iPhone 4 RevA",
    "iPhone3,3": "iPhone 4 CDMA",
    "iPhone4,1": "iPhone 4S",
    "iPhone5,1": "iPhone 5 GSM",
    "iPhone5,2": "iPhone 5 Global",
    "iPhone5,3": "iPhone 5c",
    "iPhone5,4": "iPhone 5c",
    "iPhone6,1": "iPhone 5s",
    "iPhone6,2": "iPhone 5s",
    "iPhone7,2": "iPhone 6",
    "iPhone7,1": "iPhone 6 Plus",
    "iPhone8,1": "iPhone 6s",
    "iPhone8,2": "iPhone 6s Plus",
    "iPhone8,4": "iPhone SE",
    "iPhone9,1": "iPhone 7",
    "iPhone9,3": "iPhone 7",
    "iPhone9,2": "iPhone 7 Plus",
    "iPhone9,4": "iPhone 7 Plus",
    "iPhone10,1": "iPhone 8",
    "iPhone10,4": "iPhone 8",
    "iPhone10,2": "iPhone 8 Plus",
    "iPhone10,5": "iPhone 8 Plus",
    "iPhone10,3": "iPhone X",
    "iPhone10,6": "iPhone X",
    "iPhone11,8": "iPhone XR",
    "iPhone11,2": "iPhone XS",
    "iPhone11,4": "iPhone XS Max [China]",
    "iPhone11,6": "iPhone XS Max [Global]",
    "iPhone12,1": "iPhone 11",
    "iPhone12,3": "iPhone 11 Pro",
    "iPhone12,5": "iPhone 11 Pro Max",
    "iPhone12,8": "iPhone SE (2nd generation)",
    "iPhone13,1": "iPhone 12 mini",
    "iPhone13,2": "iPhone 12",
    "iPhone13,3": "iPhone 12 Pro",
    "iPhone13,4": "iPhone 12 Pro Max",
    "iPhone14,2": "iPhone 13 Pro",
    "iPhone14,3": "iPhone 13 Pro Max",
    "iPhone14,4": "iPhone 13 mini",
    "iPhone14,5": "iPhone 13",
    "iPhone14,6": "iPhone SE (3rd generation)",
    "iPhone14,7": "iPhone 14",
    "iPhone14,8": "iPhone 14 Plus",
    "iPhone15,2": "iPhone 14 Pro",
    "iPhone15,3": "iPhone 14 Pro Max",
    "iPhone15,4": "iPhone 15",
    "iPhone15,5": "iPhone 15 Plus",
    "iPhone16,1": "iPhone 15 Pro",
    "iPhone16,2": "iPhone 15 Pro Max",
    "iPhone17,1": "iPhone 16 Pro",
    "iPhone17,2": "iPhone 16 Pro Max",
    "iPhone17,3": "iPhone 16",
    "iPhone17,4": "iPhone 16 Plus",
    "iPhone17,5": "iPhone 16e",
    "iPhone18,1": "iPhone 17 Pro",
    "iPhone18,2": "iPhone 17 Pro Max",
    "iPhone18,3": "iPhone 17",
    "iPhone18,4": "iPhone Air",
    
    // iPad
    "iPad1,1": "iPad",
    "iPad2,1": "iPad 2 Wifi",
    "iPad2,2": "iPad 2 GSM",
    "iPad2,3": "iPad 2 CDMA",
    "iPad2,4": "iPad 2 Wifi RevA",
    "iPad2,5": "iPad mini",
    "iPad2,6": "iPad mini Cellular",
    "iPad2,7": "iPad mini Cellular MM",
    "iPad3,1": "iPad 3 Wifi",
    "iPad3,2": "iPad 3 Global",
    "iPad3,3": "iPad 3 GSM",
    "iPad3,4": "iPad 4 Wifi",
    "iPad3,5": "iPad 4 GSM",
    "iPad3,6": "iPad 4 Global",
    "iPad4,1": "iPad Air Wifi",
    "iPad4,2": "iPad Air Cellular LTE",
    "iPad4,3": "iPad Air Cellular CDMA",
    "iPad4,4": "iPad mini 2 WiFi",
    "iPad4,5": "iPad mini 2 Cellular LTE",
    "iPad4,6": "iPad mini 2 Cellular CDMA",
    "iPad4,7": "iPad mini 3 WiFi",
    "iPad4,8": "iPad mini 3 Cellular LTE",
    "iPad4,9": "iPad mini 3 Cellular CDMA",
    "iPad5,1": "iPad mini 4 WiFi",
    "iPad5,2": "iPad mini 4 Cellular",
    "iPad5,3": "iPad Air 2 WiFi",
    "iPad5,4": "iPad Air 2 Cellular",
    "iPad6,3": "iPad Pro 9.7 WiFi",
    "iPad6,4": "iPad Pro 9.7 Cellular",
    "iPad6,7": "iPad Pro 12.9 2nd WiFi",
    "iPad6,8": "iPad Pro 12.9 2nd Cellular",
    "iPad6,11": "iPad 5 9.7 WiFi",
    "iPad6,12": "iPad 5 9.7 Cellular",
    "iPad7,1": "iPad Pro 2 12.9 WiFi",
    "iPad7,2": "iPad Pro 2 12.9 Cellular",
    "iPad7,3": "iPad Pro 10.5 WiFi",
    "iPad7,4": "iPad Pro 10.5 Cellular",
    "iPad7,5": "iPad 9.7 6th Cellular",
    "iPad7,6": "iPad 9.7 6th WiFi",
    "iPad7,11": "iPad (7th generation)",
    "iPad7,12": "iPad (7th generation)",
    "iPad8,1": "iPad Pro (11-inch)",
    "iPad8,2": "iPad Pro (11-inch)",
    "iPad8,3": "iPad Pro (11-inch)",
    "iPad8,4": "iPad Pro (11-inch)",
    "iPad8,5": "iPad Pro (12.9-inch) (3rd generation)",
    "iPad8,6": "iPad Pro (12.9-inch) (3rd generation)",
    "iPad8,7": "iPad Pro (12.9-inch) (3rd generation)",
    "iPad8,8": "iPad Pro (12.9-inch) (3rd generation)",
    "iPad8,9": "iPad Pro (11-inch) (2nd generation)",
    "iPad8,10": "iPad Pro (11-inch) (2nd generation)",
    "iPad8,11": "iPad Pro (12.9-inch) (4th generation)",
    "iPad8,12": "iPad Pro (12.9-inch) (4th generation)",
    "iPad11,1": "iPad mini (5th generation)",
    "iPad11,2": "iPad mini (5th generation)",
    "iPad11,3": "iPad Air (3rd generation)",
    "iPad11,4": "iPad Air (3rd generation)",
    "iPad11,6": "iPad (8th generation)",
    "iPad11,7": "iPad (8th generation)",
    "iPad12,1": "iPad (9th generation)",
    "iPad12,2": "iPad (9th generation)",
    "iPad13,1": "iPad Air (4th generation)",
    "iPad13,2": "iPad Air (4th generation)",
    "iPad13,4": "iPad Pro (11-inch) (3rd generation)",
    "iPad13,5": "iPad Pro (11-inch) (3rd generation)",
    "iPad13,6": "iPad Pro (11-inch) (3rd generation)",
    "iPad13,7": "iPad Pro (11-inch) (3rd generation)",
    "iPad13,8": "iPad Pro (12.9-inch) (5th generation)",
    "iPad13,9": "iPad Pro (12.9-inch) (5th generation)",
    "iPad13,10": "iPad Pro (12.9-inch) (5th generation)",
    "iPad13,11": "iPad Pro (12.9-inch) (5th generation)",
    "iPad13,16": "iPad Air (5th generation)",
    "iPad13,17": "iPad Air (5th generation)",
    "iPad13,18": "iPad (10th generation)",
    "iPad13,19": "iPad (10th generation)",
    "iPad14,1": "iPad mini (6th generation)",
    "iPad14,2": "iPad mini (6th generation)",
    "iPad14,3": "iPad Pro (11-inch) (4th generation)",
    "iPad14,4": "iPad Pro (11-inch) (4th generation)",
    "iPad14,5": "iPad Pro (12.9-inch) (6th generation)",
    "iPad14,6": "iPad Pro (12.9-inch) (6th generation)",
    "iPad14,8": "iPad Air 11-inch (M2)",
    "iPad14,9": "iPad Air 11-inch (M2)",
    "iPad14,10": "iPad Air 13-inch (M2)",
    "iPad14,11": "iPad Air 13-inch (M2)",
    "iPad15,3": "iPad Air 11-inch (M3)",
    "iPad15,4": "iPad Air 11-inch (M3)",
    "iPad15,5": "iPad Air 13-inch (M3)",
    "iPad15,6": "iPad Air 13-inch (M3)",
    "iPad15,7": "iPad (A16)",
    "iPad15,8": "iPad (A16)",
    "iPad16,1": "iPad mini (A17 Pro)",
    "iPad16,2": "iPad mini (A17 Pro)",
    "iPad16,3": "iPad Pro 11-inch (M4)",
    "iPad16,4": "iPad Pro 11-inch (M4)",
    "iPad16,5": "iPad Pro 13-inch (M4)",
    "iPad16,6": "iPad Pro 13-inch (M4)",
    "iPad17,1": "iPad Pro 11-inch (M5)",
    "iPad17,2": "iPad Pro 11-inch (M5)",
    "iPad17,3": "iPad Pro 13-inch (M5)",
    "iPad17,4": "iPad Pro 13-inch (M5)",
    
    // Mac
    "Macmini9,1": "Mac mini (M1, 2020)",
    "Mac14,3": "Mac mini (2023)",
    "Mac14,12": "Mac mini (2023)",
    "Mac16,10": "Mac mini (2024)",
    "Mac16,11": "Mac mini (2024)",
    "MacBookAir10,1": "MacBook Air (M1, 2020)",
    "Mac14,2": "MacBook Air (M2, 2022)",
    "Mac14,15": "MacBook Air (15-inch, M2, 2023)",
    "Mac15,12": "MacBook Air (13-inch, M3, 2024)",
    "Mac15,13": "MacBook Air (15-inch, M3, 2024)",
    "Mac16,12": "MacBook Air (13-inch, M4, 2025)",
    "Mac16,13": "MacBook Air (15-inch, M4, 2025)",
    "MacBookPro17,1": "MacBook Pro (13-inch, M1, 2020)",
    "MacBookPro18,3": "MacBook Pro (14-inch, 2021)",
    "MacBookPro18,4": "MacBook Pro (14-inch, 2021)",
    "MacBookPro18,1": "MacBook Pro (16-inch, 2021)",
    "MacBookPro18,2": "MacBook Pro (16-inch, 2021)",
    "Mac14,7": "MacBook Pro (13-inch, M2, 2022)",
    "Mac14,5": "MacBook Pro (14-inch, 2023)",
    "Mac14,9": "MacBook Pro (14-inch, 2023)",
    "Mac14,6": "MacBook Pro (16-inch, 2023)",
    "Mac14,10": "MacBook Pro (16-inch, 2023)",
    "Mac15,3": "MacBook Pro (14-inch, Nov 2023)",
    "Mac15,6": "MacBook Pro (14-inch, Nov 2023)",
    "Mac15,8": "MacBook Pro (14-inch, Nov 2023)",
    "Mac15,10": "MacBook Pro (14-inch, Nov 2023)",
    "Mac15,7": "MacBook Pro (16-inch, Nov 2023)",
    "Mac15,9": "MacBook Pro (16-inch, Nov 2023)",
    "Mac15,11": "MacBook Pro (16-inch, Nov 2023)",
    "Mac16,1": "MacBook Pro (14-inch, 2024)",
    "Mac16,6": "MacBook Pro (14-inch, 2024)",
    "Mac16,8": "MacBook Pro (14-inch, 2024)",
    "Mac16,5": "MacBook Pro (16-inch, 2024)",
    "Mac16,7": "MacBook Pro (16-inch, 2024)",
    "Mac17,2": "MacBook Pro (14-inch, M5)",
    "Mac13,1": "Mac Studio (2022)",
    "Mac13,2": "Mac Studio (2022)",
    "Mac14,13": "Mac Studio (2023)",
    "Mac14,14": "Mac Studio (2023)",
    "Mac15,14": "Mac Studio (2025)",
    "Mac16,9": "Mac Studio (2025)",
    "Mac14,8": "Mac Pro (2023)",
    "iMac21,1": "iMac (24-inch, M1, 2021)",
    "iMac21,2": "iMac (24-inch, M1, 2021)",
    "Mac15,4": "iMac (24-inch, 2023)",
    "Mac15,5": "iMac (24-inch, 2023)",
    "Mac16,2": "iMac (24-inch, 2024)",
    "Mac16,3": "iMac (24-inch, 2024)",
    
    // HomePod
    "AudioAccessory1,1": "HomePod",
    "AudioAccessory5,1": "HomePod mini",
    "AudioAccessory6,1": "HomePod (2nd generation)",
    
    // Apple Vision Pro
    "RealityDevice14,1": "Apple Vision Pro",
    "RealityDevice17,1": "Apple Vision Pro (M5)"
]

// MARK: - Helper Functions

/// Get chip name from hardware platform code
public func getChipName(from platformCode: String) -> String {
    return chipIdentifiers[platformCode.lowercased()] ?? "Unknown CPU"
}

/// Get device name from product type code
public func getDeviceName(from productType: String) -> String {
    return deviceIdentifiers[productType] ?? "Unknown"
}

/// Get chip image name for display
public func getChipImageName(from platformCode: String) -> String? {
    let code = platformCode.lowercased()
    
    // A-series
    if code.hasPrefix("s5l8930") { return "A4" }
    if code.hasPrefix("s5l8940") || code.hasPrefix("s5l8942") { return "A5" }
    if code.hasPrefix("s5l8945") { return "A5X" }
    if code.hasPrefix("s5l8950") { return "A6" }
    if code.hasPrefix("s5l8955") { return "A6X" }
    if code.hasPrefix("s5l8960") || code.hasPrefix("s5l8965") { return "A7" }
    if code.hasPrefix("t7000") { return "A8" }
    if code.hasPrefix("t7001") { return "A8X" }
    if code.hasPrefix("s8000") || code.hasPrefix("s8001") || code.hasPrefix("s8003") { return "A9" }
    if code.hasPrefix("t8010") { return "A10" }
    if code.hasPrefix("t8011") { return "A10X" }
    if code.hasPrefix("t8015") { return "A11" }
    if code.hasPrefix("t8020") { return "A12" }
    if code.hasPrefix("t8027") { return "A12X" }
    if code.hasPrefix("t8030") { return "A13" }
    if code.hasPrefix("t8101") { return "A14" }
    if code.hasPrefix("t8110") { return "A15" }
    if code.hasPrefix("t8120") { return "A16" }
    if code.hasPrefix("t8130") { return "A17" }
    if code.hasPrefix("t8140") { return "A18" }
    if code.hasPrefix("t8150") { return "A19" }
    
    // M-series
    if code.hasPrefix("t8103") || code.hasPrefix("t6000") || code.hasPrefix("t6001") || code.hasPrefix("t6002") { return "M1" }
    if code.hasPrefix("t8112") || code.hasPrefix("t6020") || code.hasPrefix("t6021") || code.hasPrefix("t6022") { return "M2" }
    if code.hasPrefix("t8122") || code.hasPrefix("t6030") || code.hasPrefix("t6031") || code.hasPrefix("t6032") || code.hasPrefix("t6034") { return "M3" }
    if code.hasPrefix("t8132") || code.hasPrefix("t6040") || code.hasPrefix("t6041") { return "M4" }
    if code.hasPrefix("t8142") || code.hasPrefix("t6050") { return "M5" }
    
    return nil
}
