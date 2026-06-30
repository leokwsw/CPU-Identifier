//
//  ViewController.m
//  CPU Identifier iOS
//
//  Created by Leo Wu on 25/1/2017.
//
//

#import "ViewController.h"

#include <sys/sysctl.h>
#include <sys/resource.h>
#include <sys/vm.h>
#include <dlfcn.h>
#import "MobileGestalt.h"
#import "AppDelegate.h"

static CFStringRef (*$MGCopyAnswer)(CFStringRef);

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    void *gestalt = dlopen("/usr/lib/libMobileGestalt.dylib", RTLD_GLOBAL | RTLD_LAZY);
    $MGCopyAnswer = dlsym(gestalt, "MGCopyAnswer");
    
#if TARGET_OS_SIMULATOR
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"ERROR" message:@"You are Simulator" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
        exit(0);
    }]];
    [self presentViewController:alert animated:YES completion:nil];
#else
    int adH ,upperOffset = 70;
    
    if(IS_IPHONE_6P ){
        adH = 66;
    }else if(IS_IPHONE_6){
        adH = 60;
    }else{
        adH = 52;
    }
    
    mainScrollView = [[UIScrollView alloc] init];
    [self.view addSubview:mainScrollView];
    [mainScrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:mainScrollView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:mainScrollView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:mainScrollView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:mainScrollView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:1.0 constant:-adH]];
    
    NSArray* key = [[NSArray alloc]initWithObjects:@"DiskUsage",@"ModelNumber",@"SIMTrayStatus",@"SerialNumber",@"MLBSerialNumber",@"UniqueDeviceID",@"UniqueDeviceIDData",@"UniqueChipID",@"InverseDeviceID",@"DiagData",@"DieId",@"CPUArchitecture",@"PartitionType",@"UserAssignedDeviceName",@"BluetoothAddress",@"RequiredBatteryLevelForSoftwareUpdate",@"BatteryIsFullyCharged",@"BatteryIsCharging",@"BatteryCurrentCapacity",@"ExternalPowerSourceConnected",@"BasebandSerialNumber",@"BasebandCertId",@"BasebandChipId",@"BasebandFirmwareManifestData",@"BasebandFirmwareVersion",@"BasebandKeyHashInformation",@"CarrierBundleInfoArray",@"CarrierInstallCapability",@"InternationalMobileEquipmentIdentity",@"MobileSubscriberCountryCode",@"MobileSubscriberNetworkCode",@"ChipID",@"ComputerName",@"DeviceVariant",@"HWModelStr",@"BoardId",@"HardwarePlatform",@"DeviceName",@"DeviceColor",@"DeviceClassNumber", @"DeviceClass", @"BuildVersion", @"ProductName", @"ProductType", @"ProductVersion", @"FirmwareNonce", @"FirmwareVersion", @"FirmwarePreflightInfo", @"IntegratedCircuitCardIdentifier", @"AirplaneMode", @"AllowYouTube", @"AllowYouTubePlugin", @"MinimumSupportediTunesVersion", @"ProximitySensorCalibration", @"RegionCode", @"RegionInfo", @"RegulatoryIdentifiers", @"SBAllowSensitiveUI", @"SBCanForceDebuggingInfo", @"SDIOManufacturerTuple", @"SDIOProductInfo", @"ShouldHactivate", @"SigningFuse", @"SoftwareBehavior", @"SoftwareBundleVersion",    @"SupportedDeviceFamilies", @"SupportedKeyboards", @"TotalSystemAvailable", @"AllDeviceCapabilities", @"AppleInternalInstallCapability", @"ExternalChargeCapability", @"ForwardCameraCapability", @"PanoramaCameraCapability", @"RearCameraCapability", @"HasAllFeaturesCapability", @"HasBaseband", @"HasInternalSettingsBundle", @"HasSpringBoard", @"InternalBuild", @"IsSimulator", @"IsThereEnoughBatteryLevelForSoftwareUpdate", @"IsUIBuild", @"RegionalBehaviorAll", @"RegionalBehaviorChinaBrick", @"RegionalBehaviorEUVolumeLimit", @"RegionalBehaviorGB18030", @"RegionalBehaviorGoogleMail", @"RegionalBehaviorNTSC", @"RegionalBehaviorNoPasscodeLocationTiles", @"RegionalBehaviorNoVOIP", @"RegionalBehaviorNoWiFi", @"RegionalBehaviorShutterClick", @"RegionalBehaviorVolumeLimit", @"ActiveWirelessTechnology", @"WifiAddress", @"WifiAddressData", @"WifiVendor", @"FaceTimeBitRate2G", @"FaceTimeBitRate3G", @"FaceTimeBitRateLTE", @"FaceTimeBitRateWiFi", @"FaceTimeDecodings", @"FaceTimeEncodings", @"FaceTimePreferredDecoding", @"FaceTimePreferredEncoding", @"DeviceSupportsFaceTime", @"DeviceSupportsTethering", @"DeviceSupportsSimplisticRoadMesh", @"DeviceSupportsNavigation", @"DeviceSupportsLineIn", @"DeviceSupports9Pin", @"DeviceSupports720p", @"DeviceSupports4G", @"DeviceSupports3DMaps", @"DeviceSupports3DImagery", @"DeviceSupports1080p", nil];
    
    for(int i=0;i<key.count;i++){
        NSString* temp = [[NSString alloc]initWithString:[key objectAtIndex:i]];
        NSLog(@"%@ : %@",
              temp,
              (CFStringRef)$MGCopyAnswer((__bridge CFStringRef)(temp))
              );
    }
    //
    // Chips
    CFStringRef boardID = (CFStringRef)$MGCopyAnswer(CFSTR("HardwarePlatform"));
    
    UILabel* boardIDLabel = [[UILabel alloc] init];
    UILabel* manufactory = [[UILabel alloc] init];
    
    boardIDLabel.text = (__bridge NSString *)boardID;
    BOOL isA9 = NO;
    manufactory.text = @"";
    
    if ([(__bridge NSString *)boardID isEqualToString:@"s8000"]) {
        manufactory.text = @"Samsung";
        isA9 = YES;
        imageName = @"A9";
    }
    
    if ([(__bridge NSString *)boardID isEqualToString:@"s8003"]) {
        manufactory.text = @"TSMC";
        isA9 = YES;
        imageName = @"A9";
    }
    
    NSString* str2Cmp = [(__bridge NSString *)boardID lowercaseString];
    // A-series chips
    if ([str2Cmp hasPrefix:@"s5l8930"]){
        imageName = @"A4";
    }else if ([str2Cmp hasPrefix:@"s5l8940"] || [str2Cmp hasPrefix:@"s5l8942"] ){
        imageName = @"A5";
    }else if ([str2Cmp hasPrefix:@"s5l8945"]){
        imageName = @"A5X";
    }else if ([str2Cmp hasPrefix:@"s5l8950"]){
        imageName = @"A6";
    }else if ([str2Cmp hasPrefix:@"s5l8955"]){
        imageName = @"A6X";
    }else if ([str2Cmp hasPrefix:@"s5l8960"] || [str2Cmp hasPrefix:@"s5l8965"]){
        imageName = @"A7";
    }else if ([str2Cmp hasPrefix:@"t7000"]){
        imageName = @"A8";
    }else if ([str2Cmp hasPrefix:@"t7001"]){
        imageName = @"A8X";
    }else if ([str2Cmp hasPrefix:@"t8010"]){
        imageName = @"A10";
        boardIDLabel.text = @"A10 Fusion";
    }else if ([str2Cmp hasPrefix:@"t8011"]){
        imageName = @"A10X";
        boardIDLabel.text = @"A10X Fusion";
    }else if ([str2Cmp hasPrefix:@"t8015"]){
        imageName = @"A11";
        boardIDLabel.text = @"A11 Bionic";
    }else if ([str2Cmp hasPrefix:@"t8020"]){
        imageName = @"A12";
        boardIDLabel.text = @"A12 Bionic";
    }else if ([str2Cmp hasPrefix:@"t8027"]){
        imageName = @"A12X";
        boardIDLabel.text = @"A12X Bionic";
    }else if ([str2Cmp hasPrefix:@"t8030"]){
        imageName = @"A13";
        boardIDLabel.text = @"A13 Bionic";
    }else if ([str2Cmp hasPrefix:@"t8101"]){
        imageName = @"A14";
        boardIDLabel.text = @"A14 Bionic";
    }else if ([str2Cmp hasPrefix:@"t8110"]){
        imageName = @"A15";
        boardIDLabel.text = @"A15 Bionic";
    }else if ([str2Cmp hasPrefix:@"t8120"]){
        imageName = @"A16";
        boardIDLabel.text = @"A16 Bionic";
    }else if ([str2Cmp hasPrefix:@"t8130"]){
        imageName = @"A17";
        boardIDLabel.text = @"A17 Pro";
    }else if ([str2Cmp hasPrefix:@"t8140a"]){
        imageName = @"A18";
        boardIDLabel.text = @"A18";
    }else if ([str2Cmp hasPrefix:@"t8140"]){
        imageName = @"A18";
        boardIDLabel.text = @"A18 Pro";
    }else if ([str2Cmp hasPrefix:@"t8150"]){
        imageName = @"A19";
        boardIDLabel.text = @"A19 Pro";
    // M-series chips
    }else if ([str2Cmp hasPrefix:@"t8103"]){
        imageName = @"M1";
        boardIDLabel.text = @"M1";
    }else if ([str2Cmp hasPrefix:@"t6000"]){
        imageName = @"M1";
        boardIDLabel.text = @"M1 Pro";
    }else if ([str2Cmp hasPrefix:@"t6001"]){
        imageName = @"M1";
        boardIDLabel.text = @"M1 Max";
    }else if ([str2Cmp hasPrefix:@"t6002"]){
        imageName = @"M1";
        boardIDLabel.text = @"M1 Ultra";
    }else if ([str2Cmp hasPrefix:@"t8112"]){
        imageName = @"M2";
        boardIDLabel.text = @"M2";
    }else if ([str2Cmp hasPrefix:@"t6020"]){
        imageName = @"M2";
        boardIDLabel.text = @"M2 Pro";
    }else if ([str2Cmp hasPrefix:@"t6021"]){
        imageName = @"M2";
        boardIDLabel.text = @"M2 Max";
    }else if ([str2Cmp hasPrefix:@"t6022"]){
        imageName = @"M2";
        boardIDLabel.text = @"M2 Ultra";
    }else if ([str2Cmp hasPrefix:@"t8122"]){
        imageName = @"M3";
        boardIDLabel.text = @"M3";
    }else if ([str2Cmp hasPrefix:@"t6030"]){
        imageName = @"M3";
        boardIDLabel.text = @"M3 Pro";
    }else if ([str2Cmp hasPrefix:@"t6031"] || [str2Cmp hasPrefix:@"t6034"]){
        imageName = @"M3";
        boardIDLabel.text = @"M3 Max";
    }else if ([str2Cmp hasPrefix:@"t6032"]){
        imageName = @"M3";
        boardIDLabel.text = @"M3 Ultra";
    }else if ([str2Cmp hasPrefix:@"t8132"]){
        imageName = @"M4";
        boardIDLabel.text = @"M4";
    }else if ([str2Cmp hasPrefix:@"t6040"]){
        imageName = @"M4";
        boardIDLabel.text = @"M4 Pro";
    }else if ([str2Cmp hasPrefix:@"t6041"]){
        imageName = @"M4";
        boardIDLabel.text = @"M4 Max";
    }else if ([str2Cmp hasPrefix:@"t8142"]){
        imageName = @"M5";
        boardIDLabel.text = @"M5";
    }else if ([str2Cmp hasPrefix:@"t6050"]){
        imageName = @"M5";
        boardIDLabel.text = @"M5 Pro";
    }
    //
    //
    
    [boardIDLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [manufactory setTranslatesAutoresizingMaskIntoConstraints:NO];
    [boardIDLabel setFont:[UIFont systemFontOfSize:36]];
    
    // add UILable to ScrollView
    [mainScrollView addSubview:boardIDLabel];
    [mainScrollView addSubview:manufactory];
    
    [mainScrollView addConstraint:[NSLayoutConstraint constraintWithItem:boardIDLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:mainScrollView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [mainScrollView addConstraint:[NSLayoutConstraint constraintWithItem:boardIDLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:mainScrollView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:-upperOffset]];
    [mainScrollView addConstraint:[NSLayoutConstraint constraintWithItem:manufactory attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:mainScrollView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [mainScrollView addConstraint:[NSLayoutConstraint constraintWithItem:manufactory attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:mainScrollView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:50-upperOffset]];
    
    //    Add chip icon
    UIImageView *imgView = [[UIImageView alloc] init];
    if(imageName) {
        
        imgView.image = [UIImage imageNamed:imageName];
        imgView.backgroundColor = [UIColor clearColor];
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        
        // add image view to scroll view
        [mainScrollView addSubview: imgView];
        
        [imgView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [mainScrollView  addConstraint:[NSLayoutConstraint constraintWithItem:imgView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:mainScrollView  attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
        [mainScrollView  addConstraint:[NSLayoutConstraint constraintWithItem:imgView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:mainScrollView  attribute:NSLayoutAttributeWidth multiplier:0.4 constant:0]];
        [mainScrollView  addConstraint:[NSLayoutConstraint constraintWithItem:imgView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:imgView  attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
        [mainScrollView  addConstraint:[NSLayoutConstraint constraintWithItem:imgView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:boardIDLabel  attribute:NSLayoutAttributeTop multiplier:1.0 constant:-24]];
    }else{
        NSLog(@"null of the imageName");
    }
    mainScrollView.contentSize = CGSizeMake(self.view.frame.size.width, SCREEN_HEIGHT + 1-upperOffset*2);
    
#endif
}

@end
