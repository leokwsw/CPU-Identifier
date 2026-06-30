import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate, DeviceManagerDelegate {
    
    @IBOutlet var window: NSWindow!
    @IBOutlet weak var disconnectLabel: NSTextField!
    @IBOutlet weak var deviceTypeLabel: NSTextField!
    @IBOutlet weak var deviceModelLabel: NSTextField!
    @IBOutlet weak var deviceCPULabel: NSTextField!
    
    private let deviceManager = DeviceManager()
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        deviceManager.delegate = self
        
        // Start monitoring for devices
        deviceManager.startMonitoring()
        
        // Show disconnected state initially
        showDisconnectedState()
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        deviceManager.stopMonitoring()
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
    
    // MARK: - DeviceManagerDelegate
    
    func deviceDidConnect(info: DeviceInfo) {
        disconnectLabel.isHidden = true
        
        let deviceDisplay: String
        if info.deviceDisplayName == "Unknown" {
            deviceDisplay = "\(info.deviceDisplayName) Mode/Device Detected"
        } else {
            deviceDisplay = "\(info.deviceDisplayName) iOS: \(info.productVersion)"
        }
        
        deviceTypeLabel.stringValue = deviceDisplay
        deviceCPULabel.stringValue = info.chipName
        deviceModelLabel.stringValue = info.modelDisplay
    }
    
    func deviceDidDisconnect() {
        showDisconnectedState()
    }
    
    func deviceError(message: String) {
        // Log error but don't show alert to avoid interrupting user
        print("Device error: \(message)")
    }
    
    // MARK: - Private Methods
    
    private func showDisconnectedState() {
        disconnectLabel.isHidden = false
        deviceTypeLabel.stringValue = ""
        deviceCPULabel.stringValue = ""
        deviceModelLabel.stringValue = ""
    }
}
