import UIKit

class ViewController: UIViewController {
    
    private var mainScrollView: UIScrollView!
    private var chipImageView: UIImageView!
    private var chipNameLabel: UILabel!
    private var manufacturerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        #if targetEnvironment(simulator)
        showSimulatorAlert()
        #else
        setupUI()
        displayChipInfo()
        #endif
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        // Calculate ad height based on device
        let adHeight: CGFloat
        if UIScreen.main.bounds.height >= 736 {
            adHeight = 66
        } else if UIScreen.main.bounds.height >= 667 {
            adHeight = 60
        } else {
            adHeight = 52
        }
        
        let upperOffset: CGFloat = 70
        
        // Setup scroll view
        mainScrollView = UIScrollView()
        mainScrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mainScrollView)
        
        NSLayoutConstraint.activate([
            mainScrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainScrollView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            mainScrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            mainScrollView.heightAnchor.constraint(equalTo: view.heightAnchor, constant: -adHeight)
        ])
        
        // Setup chip name label
        chipNameLabel = UILabel()
        chipNameLabel.translatesAutoresizingMaskIntoConstraints = false
        chipNameLabel.font = .systemFont(ofSize: 36, weight: .medium)
        chipNameLabel.textAlignment = .center
        mainScrollView.addSubview(chipNameLabel)
        
        // Setup manufacturer label
        manufacturerLabel = UILabel()
        manufacturerLabel.translatesAutoresizingMaskIntoConstraints = false
        manufacturerLabel.font = .systemFont(ofSize: 16)
        manufacturerLabel.textAlignment = .center
        manufacturerLabel.textColor = .secondaryLabel
        mainScrollView.addSubview(manufacturerLabel)
        
        // Setup chip image view
        chipImageView = UIImageView()
        chipImageView.translatesAutoresizingMaskIntoConstraints = false
        chipImageView.contentMode = .scaleAspectFit
        chipImageView.backgroundColor = .clear
        mainScrollView.addSubview(chipImageView)
        
        NSLayoutConstraint.activate([
            chipNameLabel.centerXAnchor.constraint(equalTo: mainScrollView.centerXAnchor),
            chipNameLabel.centerYAnchor.constraint(equalTo: mainScrollView.centerYAnchor, constant: -upperOffset),
            
            manufacturerLabel.centerXAnchor.constraint(equalTo: mainScrollView.centerXAnchor),
            manufacturerLabel.topAnchor.constraint(equalTo: chipNameLabel.bottomAnchor, constant: 8),
            
            chipImageView.centerXAnchor.constraint(equalTo: mainScrollView.centerXAnchor),
            chipImageView.bottomAnchor.constraint(equalTo: chipNameLabel.topAnchor, constant: -24),
            chipImageView.widthAnchor.constraint(equalTo: mainScrollView.widthAnchor, multiplier: 0.4),
            chipImageView.heightAnchor.constraint(equalTo: chipImageView.widthAnchor)
        ])
        
        mainScrollView.contentSize = CGSize(
            width: view.frame.width,
            height: UIScreen.main.bounds.height + 1 - upperOffset * 2
        )
    }
    
    // MARK: - Chip Detection
    
    private func displayChipInfo() {
        guard let platformCode = getHardwarePlatform() else {
            chipNameLabel.text = "Unknown"
            return
        }
        
        // Get chip name
        let chipName = getChipName(from: platformCode)
        chipNameLabel.text = chipName
        
        // Check for A9 manufacturer
        let lowercasePlatform = platformCode.lowercased()
        if lowercasePlatform == "s8000" {
            manufacturerLabel.text = "Samsung"
        } else if lowercasePlatform == "s8003" {
            manufacturerLabel.text = "TSMC"
        }
        
        // Get and display chip image
        if let imageName = getChipImageName(from: platformCode),
           let image = UIImage(named: imageName) {
            chipImageView.image = image
        }
    }
    
    /// Get hardware platform using MobileGestalt
    private func getHardwarePlatform() -> String? {
        guard let gestalt = dlopen("/usr/lib/libMobileGestalt.dylib", RTLD_GLOBAL | RTLD_LAZY) else {
            return nil
        }
        
        typealias MGCopyAnswerType = @convention(c) (CFString) -> CFTypeRef?
        
        guard let symbol = dlsym(gestalt, "MGCopyAnswer") else {
            dlclose(gestalt)
            return nil
        }
        
        let mgCopyAnswer = unsafeBitCast(symbol, to: MGCopyAnswerType.self)
        
        if let result = mgCopyAnswer("HardwarePlatform" as CFString) {
            return result as? String
        }
        
        dlclose(gestalt)
        return nil
    }
    
    // MARK: - Alerts
    
    private func showSimulatorAlert() {
        let alert = UIAlertController(
            title: "ERROR",
            message: "You are using Simulator",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            exit(0)
        })
        present(alert, animated: true)
    }
}
