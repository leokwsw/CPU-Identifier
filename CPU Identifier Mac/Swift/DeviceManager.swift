import Foundation

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

/// Manages iOS device connections using libimobiledevice
class DeviceManager {
    weak var delegate: DeviceManagerDelegate?
    
    private var monitorProcess: Process?
    private var isMonitoring = false
    private let queue = DispatchQueue(label: "com.cpuidentifier.devicemanager")
    
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
        monitorProcess?.terminate()
        monitorProcess = nil
    }
    
    /// Monitor for device connections using idevice_id
    private func monitorDevices() {
        while isMonitoring {
            if let udid = getConnectedDeviceUDID() {
                if let info = getDeviceInfo(udid: udid) {
                    DispatchQueue.main.async { [weak self] in
                        self?.delegate?.deviceDidConnect(info: info)
                    }
                }
            } else {
                DispatchQueue.main.async { [weak self] in
                    self?.delegate?.deviceDidDisconnect()
                }
            }
            Thread.sleep(forTimeInterval: 2.0)
        }
    }
    
    /// Get the UDID of the first connected device
    private func getConnectedDeviceUDID() -> String? {
        let output = runCommand("idevice_id", arguments: ["-l"])
        let udids = output.components(separatedBy: .newlines).filter { !$0.isEmpty }
        return udids.first
    }
    
    /// Get device information using ideviceinfo
    private func getDeviceInfo(udid: String) -> DeviceInfo? {
        let output = runCommand("ideviceinfo", arguments: ["-u", udid])
        
        guard !output.isEmpty else {
            DispatchQueue.main.async { [weak self] in
                self?.delegate?.deviceError(message: "Failed to get device info. Make sure libimobiledevice is installed.")
            }
            return nil
        }
        
        var info: [String: String] = [:]
        for line in output.components(separatedBy: .newlines) {
            let parts = line.components(separatedBy: ": ")
            if parts.count >= 2 {
                let key = parts[0].trimmingCharacters(in: .whitespaces)
                let value = parts.dropFirst().joined(separator: ": ").trimmingCharacters(in: .whitespaces)
                info[key] = value
            }
        }
        
        return DeviceInfo(
            productType: info["ProductType"] ?? "Unknown",
            hardwarePlatform: info["HardwarePlatform"] ?? "Unknown",
            modelNumber: info["ModelNumber"] ?? "Unknown",
            regionCode: info["RegionCode"] ?? "",
            productVersion: info["ProductVersion"] ?? "",
            deviceName: info["DeviceName"] ?? "Unknown Device"
        )
    }
    
    /// Run a shell command and return its output
    private func runCommand(_ command: String, arguments: [String] = []) -> String {
        let process = Process()
        let pipe = Pipe()
        
        // Try common installation paths
        let paths = [
            "/opt/homebrew/bin/\(command)",  // Apple Silicon Homebrew
            "/usr/local/bin/\(command)",      // Intel Homebrew
            "/usr/bin/\(command)"             // System
        ]
        
        var executablePath: String?
        for path in paths {
            if FileManager.default.fileExists(atPath: path) {
                executablePath = path
                break
            }
        }
        
        guard let path = executablePath else {
            return ""
        }
        
        process.executableURL = URL(fileURLWithPath: path)
        process.arguments = arguments
        process.standardOutput = pipe
        process.standardError = pipe
        
        do {
            try process.run()
            process.waitUntilExit()
            
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            return String(data: data, encoding: .utf8) ?? ""
        } catch {
            return ""
        }
    }
    
    /// Check if libimobiledevice is installed
    func checkDependencies() -> Bool {
        let output = runCommand("idevice_id", arguments: ["--version"])
        return !output.isEmpty || runCommand("which", arguments: ["idevice_id"]).contains("idevice_id")
    }
}
