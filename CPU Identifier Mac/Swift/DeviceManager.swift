import Foundation
import AppleMobileDevice

/// Protocol for device connection events
protocol DeviceManagerDelegate: AnyObject {
    func deviceDidConnect(info: DeviceInfo)
    func deviceDidDisconnect()
    func deviceError(message: String)
}

/// Device information structure
struct DeviceInfo {
    let productType: String      // e.g., "iPhone17,1"
    let hardwarePlatform: String // e.g., "t8130"
    let modelNumber: String      // e.g., "MU793"
    let regionCode: String       // e.g., "ZA"
    let productVersion: String   // e.g., "18.0"
    let deviceName: String       // User-assigned name
    
    var chipName: String {
        return getChipName(from: hardwarePlatform)
    }
    
    var deviceDisplayName: String {
        return getDeviceName(from: productType)
    }
    
    var modelDisplay: String {
        return "\(modelNumber) \(regionCode)"
    }
}

/// Manages iOS device connections using AppleMobileDevice (libimobiledevice wrapper)
class DeviceManager {
    weak var delegate: DeviceManagerDelegate?
    
    private var isMonitoring = false
    private let queue = DispatchQueue(label: "com.cpuidentifier.devicemanager")
    private var lastConnectedUDID: String?
    
    init() {}
    
    deinit {
        stopMonitoring()
    }
    
    /// Start monitoring for device connections
    func startMonitoring() {
        guard !isMonitoring else { return }
        isMonitoring = true
        
        queue.async { [weak self] in
            self?.monitorDevices()
        }
    }
    
    /// Stop monitoring for device connections
    func stopMonitoring() {
        isMonitoring = false
        lastConnectedUDID = nil
    }
    
    /// Monitor for device connections
    private func monitorDevices() {
        while isMonitoring {
            checkForDevices()
            Thread.sleep(forTimeInterval: 2.0)
        }
    }
    
    /// Check for connected devices
    private func checkForDevices() {
        do {
            let devices = try AMDevice.enumerate()
            
            if let device = devices.first {
                let udid = device.udid
                
                // Only notify if it's a new device
                if udid != lastConnectedUDID {
                    lastConnectedUDID = udid
                    
                    if let info = getDeviceInfo(device: device) {
                        DispatchQueue.main.async { [weak self] in
                            self?.delegate?.deviceDidConnect(info: info)
                        }
                    }
                }
            } else {
                // No devices connected
                if lastConnectedUDID != nil {
                    lastConnectedUDID = nil
                    DispatchQueue.main.async { [weak self] in
                        self?.delegate?.deviceDidDisconnect()
                    }
                }
            }
        } catch {
            // Handle error silently during monitoring
            if lastConnectedUDID != nil {
                lastConnectedUDID = nil
                DispatchQueue.main.async { [weak self] in
                    self?.delegate?.deviceDidDisconnect()
                }
            }
        }
    }
    
    /// Get device information
    private func getDeviceInfo(device: AMDevice) -> DeviceInfo? {
        do {
            try device.connect()
            try device.startSession()
            
            let productType = try device.copyValue(key: "ProductType") as? String ?? "Unknown"
            let hardwarePlatform = try device.copyValue(key: "HardwarePlatform") as? String ?? "Unknown"
            let modelNumber = try device.copyValue(key: "ModelNumber") as? String ?? "Unknown"
            let regionCode = try device.copyValue(key: "RegionCode") as? String ?? ""
            let productVersion = try device.copyValue(key: "ProductVersion") as? String ?? ""
            let deviceName = try device.copyValue(key: "DeviceName") as? String ?? "Unknown Device"
            
            try device.stopSession()
            try device.disconnect()
            
            return DeviceInfo(
                productType: productType,
                hardwarePlatform: hardwarePlatform,
                modelNumber: modelNumber,
                regionCode: regionCode,
                productVersion: productVersion,
                deviceName: deviceName
            )
        } catch {
            DispatchQueue.main.async { [weak self] in
                self?.delegate?.deviceError(message: "Failed to read device info: \(error.localizedDescription)")
            }
            return nil
        }
    }
}
