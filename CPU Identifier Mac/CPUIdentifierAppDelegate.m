//
//  CPUIdentifierAppDelegate.m
//  CPUIdentifier
//
//  Created by Leo Wu on 19/10/2016.
//  Copyright © 2016年 Leo Wu. All rights reserved.
//

#import "CPUIdentifierAppDelegate.h"

static AppDelegate *classPointer;
struct am_device* device;
struct am_device_notification *notification;

void notification_callback(struct am_device_notification_callback_info *info, int cookie) {	
	if (info->msg == ADNCI_MSG_CONNECTED) {
		device = info->dev;
		AMDeviceConnect(device);
		AMDevicePair(device);
		AMDeviceValidatePairing(device);
		AMDeviceStartSession(device);
		[classPointer populateData];
	}else if (info->msg == ADNCI_MSG_DISCONNECTED)
		[classPointer dePopulateData];
}

void recovery_connect_callback(struct am_recovery_device *rdev){[classPointer recoveryCallback];}

void recovery_disconnect_callback(struct am_recovery_device *rdev){[classPointer dePopulateData];}


@interface NSAttributedString (Hyperlink)
+(id)hyperlinkFromString:(NSString*)inString withURL:(NSURL*)aURL alignment:(NSTextAlignment)alignment;
@end

@implementation NSAttributedString (Hyperlink)
+(id)hyperlinkFromString:(NSString*)inString withURL:(NSURL*)aURL alignment:(NSTextAlignment)alignment{
    NSMutableAttributedString* attrString = [[NSMutableAttributedString alloc] initWithString: inString];
    NSRange range = NSMakeRange(0, [attrString length]);
    [attrString beginEditing];
    [attrString addAttribute:NSLinkAttributeName value:[aURL absoluteString] range:range];
    [attrString addAttribute:NSForegroundColorAttributeName value:[NSColor blueColor] range:range];
    [attrString addAttribute:NSFontAttributeName value:[NSFont systemFontOfSize:12] range:range];
    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setAlignment:alignment];
    [attrString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    [attrString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSSingleUnderlineStyle] range:range];
    [attrString endEditing];
    return [attrString autorelease];
}
@end

@implementation AppDelegate

//@synthesize window, loadingInd;
@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	classPointer = self;
    
//    self.window.backgroundColor = [NSColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.0];
    
	AMDeviceNotificationSubscribe(notification_callback, 0, 0, 0, &notification);
	AMRestoreRegisterForDeviceNotifications(recovery_disconnect_callback, recovery_connect_callback, recovery_disconnect_callback, recovery_disconnect_callback, 0, NULL);
    
    accept = NO;
    connected = NO;
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
	return YES;
}

-(void)setHyperlinkWithTextField:(NSTextField*)inTextField string:(NSString *)stringText url:(NSString *)urlString alignment:(NSTextAlignment)alignment{
    // both are needed, otherwise hyperlink won't accept mousedown
    [inTextField setAllowsEditingTextAttributes: YES];
    [inTextField setSelectable: YES];
    
    NSURL* url = [NSURL URLWithString:urlString];
    
    NSMutableAttributedString* string = [[NSMutableAttributedString alloc] init];
    [string appendAttributedString: [NSAttributedString hyperlinkFromString:stringText withURL:url alignment:alignment]];

    // set the attributed string to the NSTextField
    [inTextField setAttributedStringValue: string];
    
    [string release];
}

- (void)recoveryCallback {
	[disconnetLabel setHidden:YES];
}

- (void)getKey{
    NSArray* key=[[NSArray alloc]initWithObjects:
                  @"DieID",
                  @"RegionInfo",
                  @"UniqueChipID", // ECID
                  @"DeviceClass",
//                  @"DeviceColor",
//                  @"CPUArchitecture",
//                  @"PhoneNumber",
//                  @"BluetoothAddress",
                  @"DeviceName",
//                  @"BuildVersion",
//                  @"ProductVersion",
//                  @"WiFiAddress",
                  @"UniqueDeviceID", // UDID
//                  @"SerialNumber",
//                  @"HardwarePlatform",
                  @"ModelNumber",
//                  @"ProductType",
                  @"RegionCode",
                  nil];
    for(int i=0;i<key.count;i++){
        NSLog(@"%@: %@",[key objectAtIndex:i],[self getDeviceValue:[key objectAtIndex:i]]);
    }
}

- (void)populateData {
    
    connected = YES;
    
    [self getKey];
    
    NSString *platform = [self getDeviceValue:@"HardwarePlatform"];//CPU
	NSString *modelNumber = [self getDeviceValue:@"ModelNumber"];//Model Code
	NSString *deviceString = [self getDeviceValue:@"ProductType"];//Identifier
    NSString *region = [self getDeviceValue:@"RegionCode"];//RegionCode
    
    // CPU - A-series (iPhone/iPad)
    if ([platform isEqualToString:@"s5l8900"]) platform = @"Older Version";
    else if ([platform isEqualToString:@"s5l8720"]) platform = @"Older Version";
    else if ([platform isEqualToString:@"s5l8920"]) platform = @"Older Version";
    else if ([platform isEqualToString:@"s5l8922"]) platform = @"Older Version";
    else if ([platform isEqualToString:@"s5l8930"]) platform = @"A4";
    else if ([platform isEqualToString:@"s5l8940"]) platform = @"A5";
    else if ([platform isEqualToString:@"s5l8942x"]) platform = @"A5 Rev A";
    else if ([platform isEqualToString:@"s5l8945"]) platform = @"A5X";
    else if ([platform isEqualToString:@"s5l8947"]) platform = @"A5 Rev B";
    else if ([platform isEqualToString:@"s5l8950"]) platform = @"A6";
    else if ([platform isEqualToString:@"s5l8955"]) platform = @"A6X";
    else if ([platform isEqualToString:@"s5l8960"]) platform = @"A7";
    else if ([platform isEqualToString:@"s5l8965"]) platform = @"A7 Variant";
    else if ([platform isEqualToString:@"t7000"]) platform = @"A8";
    else if ([platform isEqualToString:@"t7001"]) platform = @"A8X";
    else if ([platform isEqualToString:@"s8000"]) platform = @"A9 (Samsung)";
    else if ([platform isEqualToString:@"s8001"]) platform = @"A9X";
    else if ([platform isEqualToString:@"s8003"]) platform = @"A9 (TSMC)";
    else if ([platform isEqualToString:@"t8010"]) platform = @"A10 Fusion";
    else if ([platform isEqualToString:@"t8011"]) platform = @"A10X Fusion";
    else if ([platform isEqualToString:@"t8015"]) platform = @"A11 Bionic";
    else if ([platform isEqualToString:@"t8020"]) platform = @"A12 Bionic";
    else if ([platform isEqualToString:@"t8027"]) platform = @"A12X Bionic";
    else if ([platform isEqualToString:@"t8030"]) platform = @"A13 Bionic";
    else if ([platform isEqualToString:@"t8101"]) platform = @"A14 Bionic";
    else if ([platform isEqualToString:@"t8110"]) platform = @"A15 Bionic";
    else if ([platform isEqualToString:@"t8120"]) platform = @"A16 Bionic";
    else if ([platform isEqualToString:@"t8130"]) platform = @"A17 Pro";
    else if ([platform isEqualToString:@"t8140a"]) platform = @"A18";
    else if ([platform isEqualToString:@"t8140"]) platform = @"A18 Pro";
    else if ([platform isEqualToString:@"t8150"]) platform = @"A19 Pro";

    // CPU - M-series (Mac/iPad Pro)
    else if ([platform isEqualToString:@"t8103"]) platform = @"M1";
    else if ([platform isEqualToString:@"t6000"]) platform = @"M1 Pro";
    else if ([platform isEqualToString:@"t6001"]) platform = @"M1 Max";
    else if ([platform isEqualToString:@"t6002"]) platform = @"M1 Ultra";
    else if ([platform isEqualToString:@"t8112"]) platform = @"M2";
    else if ([platform isEqualToString:@"t6020"]) platform = @"M2 Pro";
    else if ([platform isEqualToString:@"t6021"]) platform = @"M2 Max";
    else if ([platform isEqualToString:@"t6022"]) platform = @"M2 Ultra";
    else if ([platform isEqualToString:@"t8122"]) platform = @"M3";
    else if ([platform isEqualToString:@"t6030"]) platform = @"M3 Pro";
    else if ([platform isEqualToString:@"t6031"]) platform = @"M3 Max";
    else if ([platform isEqualToString:@"t6034"]) platform = @"M3 Max";
    else if ([platform isEqualToString:@"t6032"]) platform = @"M3 Ultra";
    else if ([platform isEqualToString:@"t8132"]) platform = @"M4";
    else if ([platform isEqualToString:@"t6040"]) platform = @"M4 Pro";
    else if ([platform isEqualToString:@"t6041"]) platform = @"M4 Max";
    else if ([platform isEqualToString:@"t8142"]) platform = @"M5";
    else if ([platform isEqualToString:@"t6050"]) platform = @"M5 Pro";

    // CPU - S-series (Apple Watch) and T-series (Security Chip)
    else if ([platform isEqualToString:@"s7002"]) platform = @"S1";
    else if ([platform isEqualToString:@"t8002"]) platform = @"S1P / S2 / T1";
    else if ([platform isEqualToString:@"t8004"]) platform = @"S3";
    else if ([platform isEqualToString:@"t8006"]) platform = @"S4";
    else if ([platform isEqualToString:@"t8301"]) platform = @"S5";
    else if ([platform isEqualToString:@"t8301"]) platform = @"S6";
    else if ([platform isEqualToString:@"t8310"]) platform = @"S9";
    else if ([platform isEqualToString:@"t8012"]) platform = @"T2";
    
    // CPU - W-series (Wireless Chip)
    else if ([platform isEqualToString:@"w1"]) platform = @"W1";
    else if ([platform isEqualToString:@"w2"]) platform = @"W2";
    else if ([platform isEqualToString:@"w3"]) platform = @"W3";

    // CPU - R-series (Apple Vision Pro)
    else if ([platform isEqualToString:@"t6500"]) platform = @"R1";
    
    else platform = @"Unknown CPU";
    
	// iPod
    // ref : https://www.theiphonewiki.com/wiki/List_of_iPod_touches
    // iPod Touch
	if ([deviceString isEqualToString:@"iPod1,1"]) deviceString = @"iPod touch 1 Gen";
    // iPod Touch 2th
	else if ([deviceString isEqualToString:@"iPod2,1"]) deviceString = @"iPod touch 2 Gen";
    // iPod Touch 3rd
    else if ([deviceString isEqualToString:@"iPod3,1"]) deviceString = @"iPod touch 3 Gen";
    // iPod Touch 4th
    else if ([deviceString isEqualToString:@"iPod4,1"]) deviceString = @"iPod touch 4 Gen";
    // iPod Touch 5th
    else if ([deviceString isEqualToString:@"iPod5,1"]) deviceString = @"iPod touch 5 Gen";
    // iPod Touch 6th
    else if ([deviceString isEqualToString:@"iPod7,1"]) deviceString = @"iPod touch (6th generation)";
    // iPod Touch 7th
    else if ([deviceString isEqualToString:@"iPod9,1"]) deviceString = @"iPod touch (7th generation)";
    
    // Apple TV
    // ref : https://www.theiphonewiki.com/wiki/List_of_Apple_TVs
    // Apple TV
    else if ([deviceString isEqualToString:@"AppleTV1,1"]) deviceString = @"Apple TV 1G";
    // Apple TV 2nd
    else if ([deviceString isEqualToString:@"AppleTV2,1"]) deviceString = @"Apple TV 2G";
    // Apple TV 3rd
    else if ([deviceString isEqualToString:@"AppleTV3,1"]) deviceString = @"Apple TV 3G";
    else if ([deviceString isEqualToString:@"AppleTV3,2"]) deviceString = @"Apple TV 3G";
    // Apple TV 4th
    else if ([deviceString isEqualToString:@"AppleTV5,3"]) deviceString = @"Apple TV 4G";
    // Apple TV 4K (1st generation)
    else if ([deviceString isEqualToString:@"AppleTV6,2"]) deviceString = @"Apple TV 4K (1st generation)";
    // Apple TV 4K (2nd generation)
    else if ([deviceString isEqualToString:@"AppleTV11,1"]) deviceString = @"Apple TV 4K (2nd generation)";
    // Apple TV 4K (3rd generation)
    else if ([deviceString isEqualToString:@"AppleTV14,1"]) deviceString = @"Apple TV 4K (3rd generation)";
    
    // Apple Watch
    // ref: https://www.theiphonewiki.com/wiki/List_of_Apple_Watches
    // Apple Watch
    else if ([deviceString isEqualToString:@"Watch1,1"]) deviceString = @"Apple Watch";
    else if ([deviceString isEqualToString:@"Watch1,2"]) deviceString = @"Apple Watch";
    // Apple Watch S1
    else if ([deviceString isEqualToString:@"Watch2,6"]) deviceString = @"Apple Watch Series 1";
    else if ([deviceString isEqualToString:@"Watch2,7"]) deviceString = @"Apple Watch Series 1";
    // Apple Watch S2
    else if ([deviceString isEqualToString:@"Watch2,3"]) deviceString = @"Apple Watch Series 2";
    else if ([deviceString isEqualToString:@"Watch2,4"]) deviceString = @"Apple Watch Series 2";
    // Apple Watch S3
    else if ([deviceString isEqualToString:@"Watch3,1"]) deviceString = @"Apple Watch Series 3";
    else if ([deviceString isEqualToString:@"Watch3,2"]) deviceString = @"Apple Watch Series 3 Cellular";
    else if ([deviceString isEqualToString:@"Watch3,3"]) deviceString = @"Apple Watch Series 3";
    else if ([deviceString isEqualToString:@"Watch3,4"]) deviceString = @"Apple Watch Series 3 Cellular";
    // Apple Watch S4
    else if ([deviceString isEqualToString:@"Watch4,1"]) deviceString = @"Apple Watch Series 4 (GPS)";
    else if ([deviceString isEqualToString:@"Watch4,2"]) deviceString = @"Apple Watch Series 4 (GPS)";
    else if ([deviceString isEqualToString:@"Watch4,3"]) deviceString = @"Apple Watch Series 4 (GPS + Cellular)";
    else if ([deviceString isEqualToString:@"Watch4,4"]) deviceString = @"Apple Watch Series 4 (GPS + Cellular)";
    // Apple Watch S5
    else if ([deviceString isEqualToString:@"Watch5,1"]) deviceString = @"Apple Watch Series 5 (GPS)";
    else if ([deviceString isEqualToString:@"Watch5,2"]) deviceString = @"Apple Watch Series 5 (GPS)";
    else if ([deviceString isEqualToString:@"Watch5,3"]) deviceString = @"Apple Watch Series 5 (GPS + Cellular)";
    else if ([deviceString isEqualToString:@"Watch5,4"]) deviceString = @"Apple Watch Series 5 (GPS + Cellular)";
    // Apple Watch SE
    else if ([deviceString isEqualToString:@"Watch5,9"]) deviceString = @"Apple Watch SE (GPS)";
    else if ([deviceString isEqualToString:@"Watch5,10"]) deviceString = @"Apple Watch SE (GPS)";
    else if ([deviceString isEqualToString:@"Watch5,11"]) deviceString = @"Apple Watch SE (GPS + Cellular)";
    else if ([deviceString isEqualToString:@"Watch5,12"]) deviceString = @"Apple Watch SE (GPS + Cellular)";
    // Apple Watch S6
    else if ([deviceString isEqualToString:@"Watch6,1"]) deviceString = @"Apple Watch Series 6 (GPS)";
    else if ([deviceString isEqualToString:@"Watch6,2"]) deviceString = @"Apple Watch Series 6 (GPS)";
    else if ([deviceString isEqualToString:@"Watch6,3"]) deviceString = @"Apple Watch Series 6 (GPS + Cellular)";
    else if ([deviceString isEqualToString:@"Watch6,4"]) deviceString = @"Apple Watch Series 6 (GPS + Cellular)";
    // Apple Watch S7
    else if ([deviceString isEqualToString:@"Watch6,6"]) deviceString = @"Apple Watch Series 7 (GPS)";
    else if ([deviceString isEqualToString:@"Watch6,7"]) deviceString = @"Apple Watch Series 7 (GPS)";
    else if ([deviceString isEqualToString:@"Watch6,8"]) deviceString = @"Apple Watch Series 7 (GPS + Cellular)";
    else if ([deviceString isEqualToString:@"Watch6,9"]) deviceString = @"Apple Watch Series 7 (GPS + Cellular)";
    // Apple Watch SE (2nd generation)
    else if ([deviceString isEqualToString:@"Watch6,10"]) deviceString = @"Apple Watch SE (2nd generation) (GPS)";
    else if ([deviceString isEqualToString:@"Watch6,11"]) deviceString = @"Apple Watch SE (2nd generation) (GPS)";
    else if ([deviceString isEqualToString:@"Watch6,12"]) deviceString = @"Apple Watch SE (2nd generation) (GPS + Cellular)";
    else if ([deviceString isEqualToString:@"Watch6,13"]) deviceString = @"Apple Watch SE (2nd generation) (GPS + Cellular)";
    // Apple Watch S8
    else if ([deviceString isEqualToString:@"Watch6,14"]) deviceString = @"Apple Watch Series 8 (GPS)";
    else if ([deviceString isEqualToString:@"Watch6,15"]) deviceString = @"Apple Watch Series 8 (GPS)";
    else if ([deviceString isEqualToString:@"Watch6,16"]) deviceString = @"Apple Watch Series 8 (GPS + Cellular)";
    else if ([deviceString isEqualToString:@"Watch6,17"]) deviceString = @"Apple Watch Series 8 (GPS + Cellular)";
    // Apple Watch Ultra
    else if ([deviceString isEqualToString:@"Watch6,18"]) deviceString = @"Apple Watch Ultra";
    // Apple Watch S9
    else if ([deviceString isEqualToString:@"Watch7,1"]) deviceString = @"Apple Watch Series 9 (GPS)";
    else if ([deviceString isEqualToString:@"Watch7,2"]) deviceString = @"Apple Watch Series 9 (GPS)";
    else if ([deviceString isEqualToString:@"Watch7,3"]) deviceString = @"Apple Watch Series 9 (GPS + Cellular)";
    else if ([deviceString isEqualToString:@"Watch7,4"]) deviceString = @"Apple Watch Series 9 (GPS + Cellular)";
    // Apple Watch Ultra 2
    else if ([deviceString isEqualToString:@"Watch7,5"]) deviceString = @"Apple Watch Ultra 2";
    // Apple Watch S10
    else if ([deviceString isEqualToString:@"Watch7,8"]) deviceString = @"Apple Watch Series 10 (GPS)";
    else if ([deviceString isEqualToString:@"Watch7,9"]) deviceString = @"Apple Watch Series 10 (GPS)";
    else if ([deviceString isEqualToString:@"Watch7,10"]) deviceString = @"Apple Watch Series 10 (GPS + Cellular)";
    else if ([deviceString isEqualToString:@"Watch7,11"]) deviceString = @"Apple Watch Series 10 (GPS + Cellular)";
    // Apple Watch Ultra 3
    else if ([deviceString isEqualToString:@"Watch7,12"]) deviceString = @"Apple Watch Ultra 3";
    // Apple Watch SE 3
    else if ([deviceString isEqualToString:@"Watch7,13"]) deviceString = @"Apple Watch SE 3 (GPS)";
    else if ([deviceString isEqualToString:@"Watch7,14"]) deviceString = @"Apple Watch SE 3 (GPS)";
    else if ([deviceString isEqualToString:@"Watch7,15"]) deviceString = @"Apple Watch SE 3 (GPS + Cellular)";
    else if ([deviceString isEqualToString:@"Watch7,16"]) deviceString = @"Apple Watch SE 3 (GPS + Cellular)";
    // Apple Watch S11
    else if ([deviceString isEqualToString:@"Watch7,17"]) deviceString = @"Apple Watch Series 11 (GPS)";
    else if ([deviceString isEqualToString:@"Watch7,18"]) deviceString = @"Apple Watch Series 11 (GPS)";
    else if ([deviceString isEqualToString:@"Watch7,19"]) deviceString = @"Apple Watch Series 11 (GPS + Cellular)";
    else if ([deviceString isEqualToString:@"Watch7,20"]) deviceString = @"Apple Watch Series 11 (GPS + Cellular)";
    
    // iPhone
    // ref : https://www.theiphonewiki.com/wiki/List_of_iPhones
    // iPhone
	else if ([deviceString isEqualToString:@"iPhone1,1"]) deviceString = @"iPhone";
    // iPhone 3G
	else if ([deviceString isEqualToString:@"iPhone1,2"]) deviceString = @"iPhone 3G";
    // iPhone 3GS
	else if ([deviceString isEqualToString:@"iPhone2,1"]) deviceString = @"iPhone 3GS";
    // iPhone 4
	else if ([deviceString isEqualToString:@"iPhone3,1"]) deviceString = @"iPhone 4";
    else if ([deviceString isEqualToString:@"iPhone3,2"]) deviceString = @"iPhone 4 RevA";
    else if ([deviceString isEqualToString:@"iPhone3,3"]) deviceString = @"iPhone 4 CDMA";
    // iPhone 4S
    else if ([deviceString isEqualToString:@"iPhone4,1"]) deviceString = @"iPhone 4S";
    // iPhone 5
    else if ([deviceString isEqualToString:@"iPhone5,1"]) deviceString = @"iPhone 5 GSM";
    else if ([deviceString isEqualToString:@"iPhone5,2"]) deviceString = @"iPhone 5 Global";
    // iPhone 5c
    else if ([deviceString isEqualToString:@"iPhone5,3"]) deviceString = @"iPhone 5c";
    else if ([deviceString isEqualToString:@"iPhone5,4"]) deviceString = @"iPhone 5c";
    // iPhone 5s
    else if ([deviceString isEqualToString:@"iPhone6,1"]) deviceString = @"iPhone 5s";
    else if ([deviceString isEqualToString:@"iPhone6,2"]) deviceString = @"iPhone 5s";
    // iPhone 6
    else if ([deviceString isEqualToString:@"iPhone7,2"]) deviceString = @"iPhone 6";
    // iPhone 6 Plus
    else if ([deviceString isEqualToString:@"iPhone7,1"]) deviceString = @"iPhone 6 Plus";
    // iPhone 6s
    else if ([deviceString isEqualToString:@"iPhone8,1"]) deviceString = @"iPhone 6s";
    // iPhone 6s Plus
    else if ([deviceString isEqualToString:@"iPhone8,2"]) deviceString = @"iPhone 6s Plus";
    // iPhone SE
    else if ([deviceString isEqualToString:@"iPhone8,4"]) deviceString = @"iPhone SE";
    // iPhone 7
    else if ([deviceString isEqualToString:@"iPhone9,1"]) deviceString = @"iPhone 7";
    else if ([deviceString isEqualToString:@"iPhone9,3"]) deviceString = @"iPhone 7";
    // iPhone 7 Plus
    else if ([deviceString isEqualToString:@"iPhone9,2"]) deviceString = @"iPhone 7 Plus";
    else if ([deviceString isEqualToString:@"iPhone9,4"]) deviceString = @"iPhone 7 Plus";
    // iPhone 8
    else if ([deviceString isEqualToString:@"iPhone10,1"]) deviceString = @"iPhone 8";
    else if ([deviceString isEqualToString:@"iPhone10,4"]) deviceString = @"iPhone 8";
    // iPhone 8 Plus
    else if ([deviceString isEqualToString:@"iPhone10,2"]) deviceString = @"iPhone 8 Plus";
    else if ([deviceString isEqualToString:@"iPhone10,5"]) deviceString = @"iPhone 8 Plus";
    // iPhone X
    else if ([deviceString isEqualToString:@"iPhone10,3"]) deviceString = @"iPhone X";
    else if ([deviceString isEqualToString:@"iPhone10,6"]) deviceString = @"iPhone X";
    // iPhone XR
    else if ([deviceString isEqualToString:@"iPhone11,8"]) deviceString = @"iPhone XR";
    // iPhone XS
    else if ([deviceString isEqualToString:@"iPhone11,2"]) deviceString = @"iPhone XS";
    // iPhone XS Max
    else if ([deviceString isEqualToString:@"iPhone11,4"]) deviceString = @"iPhone XS Max [China]";
    else if ([deviceString isEqualToString:@"iPhone11,6"]) deviceString = @"iPhone XS Max [Global]";
    // iPhone 11
    else if ([deviceString isEqualToString:@"iPhone12,1"]) deviceString = @"iPhone 11";
    // iPhone 11 Pro
    else if ([deviceString isEqualToString:@"iPhone12,3"]) deviceString = @"iPhone 11 Pro";
    // iPhone 11 Pro Max
    else if ([deviceString isEqualToString:@"iPhone12,5"]) deviceString = @"iPhone 11 Pro Max";
    // iPhone SE (2nd generation)
    else if ([deviceString isEqualToString:@"iPhone12,8"]) deviceString = @"iPhone SE (2nd generation)";
    // iPhone 12 mini
    else if ([deviceString isEqualToString:@"iPhone13,1"]) deviceString = @"iPhone 12 mini";
    // iPhone 12
    else if ([deviceString isEqualToString:@"iPhone13,2"]) deviceString = @"iPhone 12";
    // iPhone 12 Pro
    else if ([deviceString isEqualToString:@"iPhone13,3"]) deviceString = @"iPhone 12 Pro";
    // iPhone 12 Pro Max
    else if ([deviceString isEqualToString:@"iPhone13,4"]) deviceString = @"iPhone 12 Pro Max";
    // iPhone 13 Pro
    else if ([deviceString isEqualToString:@"iPhone14,2"]) deviceString = @"iPhone 13 Pro";
    // iPhone 13 Pro Max
    else if ([deviceString isEqualToString:@"iPhone14,3"]) deviceString = @"iPhone 13 Pro Max";
    // iPhone 13 mini
    else if ([deviceString isEqualToString:@"iPhone14,4"]) deviceString = @"iPhone 13 mini";
    // iPhone 13
    else if ([deviceString isEqualToString:@"iPhone14,5"]) deviceString = @"iPhone 13";
    // iPhone SE (3rd generation)
    else if ([deviceString isEqualToString:@"iPhone14,6"]) deviceString = @"iPhone SE (3rd generation)";
    // iPhone 14
    else if ([deviceString isEqualToString:@"iPhone14,7"]) deviceString = @"iPhone 14";
    // iPhone 14 Plus
    else if ([deviceString isEqualToString:@"iPhone14,8"]) deviceString = @"iPhone 14 Plus";
    // iPhone 14 Pro
    else if ([deviceString isEqualToString:@"iPhone15,2"]) deviceString = @"iPhone 14 Pro";
    // iPhone 14 Pro Max
    else if ([deviceString isEqualToString:@"iPhone15,3"]) deviceString = @"iPhone 14 Pro Max";
    // iPhone 15
    else if ([deviceString isEqualToString:@"iPhone15,4"]) deviceString = @"iPhone 15";
    // iPhone 15 Plus
    else if ([deviceString isEqualToString:@"iPhone15,5"]) deviceString = @"iPhone 15 Plus";
    // iPhone 15 Pro
    else if ([deviceString isEqualToString:@"iPhone16,1"]) deviceString = @"iPhone 15 Pro";
    // iPhone 15 Pro Max
    else if ([deviceString isEqualToString:@"iPhone16,2"]) deviceString = @"iPhone 15 Pro Max";
    // iPhone 16 Pro
    else if ([deviceString isEqualToString:@"iPhone17,1"]) deviceString = @"iPhone 16 Pro";
    // iPhone 16 Pro Max
    else if ([deviceString isEqualToString:@"iPhone17,2"]) deviceString = @"iPhone 16 Pro Max";
    // iPhone 16
    else if ([deviceString isEqualToString:@"iPhone17,3"]) deviceString = @"iPhone 16";
    // iPhone 16 Plus
    else if ([deviceString isEqualToString:@"iPhone17,4"]) deviceString = @"iPhone 16 Plus";
    // iPhone 16e
    else if ([deviceString isEqualToString:@"iPhone17,5"]) deviceString = @"iPhone 16e";
    // iPhone 17 Pro
    else if ([deviceString isEqualToString:@"iPhone18,1"]) deviceString = @"iPhone 17 Pro";
    // iPhone 17 Pro Max
    else if ([deviceString isEqualToString:@"iPhone18,2"]) deviceString = @"iPhone 17 Pro Max";
    // iPhone 17
    else if ([deviceString isEqualToString:@"iPhone18,3"]) deviceString = @"iPhone 17";
    // iPhone Air
    else if ([deviceString isEqualToString:@"iPhone18,4"]) deviceString = @"iPhone Air";
    
    // iPad
    // ref: https://www.theiphonewiki.com/wiki/List_of_iPads
    // iPad
    else if ([deviceString isEqualToString:@"iPad1,1"]) deviceString = @"iPad";
    // iPad 2
    else if ([deviceString isEqualToString:@"iPad2,1"]) deviceString = @"iPad 2 Wifi";
    else if ([deviceString isEqualToString:@"iPad2,2"]) deviceString = @"iPad 2 GSM";
    else if ([deviceString isEqualToString:@"iPad2,3"]) deviceString = @"iPad 2 CDMA";
    else if ([deviceString isEqualToString:@"iPad2,4"]) deviceString = @"iPad 2 Wifi RevA";
    // iPad 3
    else if ([deviceString isEqualToString:@"iPad3,1"]) deviceString = @"iPad 3 Wifi";
    else if ([deviceString isEqualToString:@"iPad3,2"]) deviceString = @"iPad 3 Global";
    else if ([deviceString isEqualToString:@"iPad3,3"]) deviceString = @"iPad 3 GSM";
    // iPad 4
    else if ([deviceString isEqualToString:@"iPad3,4"]) deviceString = @"iPad 4 Wifi";
    else if ([deviceString isEqualToString:@"iPad3,5"]) deviceString = @"iPad 4 GSM";
    else if ([deviceString isEqualToString:@"iPad3,6"]) deviceString = @"iPad 4 Global";
    // iPad Air
    else if ([deviceString isEqualToString:@"iPad4,1"]) deviceString = @"iPad Air Wifi";
    else if ([deviceString isEqualToString:@"iPad4,2"]) deviceString = @"iPad Air Cellular LTE";
    else if ([deviceString isEqualToString:@"iPad4,3"]) deviceString = @"iPad Air Cellular CDMA";
    // iPad Air 2
    else if ([deviceString isEqualToString:@"iPad5,3"]) deviceString = @"iPad Air 2 WiFi";
    else if ([deviceString isEqualToString:@"iPad5,4"]) deviceString = @"iPad Air 2 Cellular";
    // iPad Pro 12.9
    else if ([deviceString isEqualToString:@"iPad6,7"]) deviceString = @"iPad Pro 12.9 2nd WiFi";
    else if ([deviceString isEqualToString:@"iPad6,8"]) deviceString = @"iPad Pro 12.9 2nd Cellular";
    // iPad Pro 9.7
    else if ([deviceString isEqualToString:@"iPad6,3"]) deviceString = @"iPad Pro 9.7 WiFi";
    else if ([deviceString isEqualToString:@"iPad6,4"]) deviceString = @"iPad Pro 9.7 Cellular";
    // iPad 5
    else if ([deviceString isEqualToString:@"iPad6,11"]) deviceString = @"iPad 5 9.7 WiFi";
    else if ([deviceString isEqualToString:@"iPad6,12"]) deviceString = @"iPad 5 9.7 Cellular";
    // iPad Pro 12.9 2nd
    else if ([deviceString isEqualToString:@"iPad7,1"]) deviceString = @"iPad Pro 2 12.9 WiFi";
    else if ([deviceString isEqualToString:@"iPad7,2"]) deviceString = @"iPad Pro 2 12.9 Cellular";
    // iPad Pro 10.5
    else if ([deviceString isEqualToString:@"iPad7,3"]) deviceString = @"iPad Pro 10.5 WiFi";
    else if ([deviceString isEqualToString:@"iPad7,4"]) deviceString = @"iPad Pro 10.5 Cellular";
    // iPad 6th
    else if ([deviceString isEqualToString:@"iPad7,5"]) deviceString = @"iPad 9.7 6th Cellular";
    else if ([deviceString isEqualToString:@"iPad7,6"]) deviceString = @"iPad 9.7 6th WiFi";
    // iPad Pro 3rd Generation (11-inch)
    else if ([deviceString isEqualToString:@"iPad8,1"]) deviceString = @"iPad Pro (11-inch)";
    else if ([deviceString isEqualToString:@"iPad8,2"]) deviceString = @"iPad Pro (11-inch)";
    else if ([deviceString isEqualToString:@"iPad8,3"]) deviceString = @"iPad Pro (11-inch)";
    else if ([deviceString isEqualToString:@"iPad8,4"]) deviceString = @"iPad Pro (11-inch)";
    // iPad Pro 3rd Generation (12.9-inch)
    else if ([deviceString isEqualToString:@"iPad8,5"]) deviceString = @"iPad Pro (12.9-inch) (3rd generation)";
    else if ([deviceString isEqualToString:@"iPad8,6"]) deviceString = @"iPad Pro (12.9-inch) (3rd generation)";
    else if ([deviceString isEqualToString:@"iPad8,7"]) deviceString = @"iPad Pro (12.9-inch) (3rd generation)";
    else if ([deviceString isEqualToString:@"iPad8,8"]) deviceString = @"iPad Pro (12.9-inch) (3rd generation)";
    // iPad Pro 2nd Generation (11-inch)
    else if ([deviceString isEqualToString:@"iPad8,9"]) deviceString = @"iPad Pro (11-inch) (2nd generation)";
    else if ([deviceString isEqualToString:@"iPad8,10"]) deviceString = @"iPad Pro (11-inch) (2nd generation)";
    // iPad Pro 4th Generation (12.9-inch)
    else if ([deviceString isEqualToString:@"iPad8,11"]) deviceString = @"iPad Pro (12.9-inch) (4th generation)";
    else if ([deviceString isEqualToString:@"iPad8,12"]) deviceString = @"iPad Pro (12.9-inch) (4th generation)";
    // iPad 7th generation
    else if ([deviceString isEqualToString:@"iPad7,11"]) deviceString = @"iPad (7th generation)";
    else if ([deviceString isEqualToString:@"iPad7,12"]) deviceString = @"iPad (7th generation)";
    // iPad mini 5th generation
    else if ([deviceString isEqualToString:@"iPad11,1"]) deviceString = @"iPad mini (5th generation)";
    else if ([deviceString isEqualToString:@"iPad11,2"]) deviceString = @"iPad mini (5th generation)";
    // iPad Air 3rd generation
    else if ([deviceString isEqualToString:@"iPad11,3"]) deviceString = @"iPad Air (3rd generation)";
    else if ([deviceString isEqualToString:@"iPad11,4"]) deviceString = @"iPad Air (3rd generation)";
    // iPad 8th generation
    else if ([deviceString isEqualToString:@"iPad11,6"]) deviceString = @"iPad (8th generation)";
    else if ([deviceString isEqualToString:@"iPad11,7"]) deviceString = @"iPad (8th generation)";
    // iPad 9th generation
    else if ([deviceString isEqualToString:@"iPad12,1"]) deviceString = @"iPad (9th generation)";
    else if ([deviceString isEqualToString:@"iPad12,2"]) deviceString = @"iPad (9th generation)";
    // iPad Air 4th generation
    else if ([deviceString isEqualToString:@"iPad13,1"]) deviceString = @"iPad Air (4th generation)";
    else if ([deviceString isEqualToString:@"iPad13,2"]) deviceString = @"iPad Air (4th generation)";
    // iPad Pro 3rd Generation (11-inch) M1
    else if ([deviceString isEqualToString:@"iPad13,4"]) deviceString = @"iPad Pro (11-inch) (3rd generation)";
    else if ([deviceString isEqualToString:@"iPad13,5"]) deviceString = @"iPad Pro (11-inch) (3rd generation)";
    else if ([deviceString isEqualToString:@"iPad13,6"]) deviceString = @"iPad Pro (11-inch) (3rd generation)";
    else if ([deviceString isEqualToString:@"iPad13,7"]) deviceString = @"iPad Pro (11-inch) (3rd generation)";
    // iPad Pro 5th Generation (12.9-inch) M1
    else if ([deviceString isEqualToString:@"iPad13,8"]) deviceString = @"iPad Pro (12.9-inch) (5th generation)";
    else if ([deviceString isEqualToString:@"iPad13,9"]) deviceString = @"iPad Pro (12.9-inch) (5th generation)";
    else if ([deviceString isEqualToString:@"iPad13,10"]) deviceString = @"iPad Pro (12.9-inch) (5th generation)";
    else if ([deviceString isEqualToString:@"iPad13,11"]) deviceString = @"iPad Pro (12.9-inch) (5th generation)";
    // iPad Air 5th generation
    else if ([deviceString isEqualToString:@"iPad13,16"]) deviceString = @"iPad Air (5th generation)";
    else if ([deviceString isEqualToString:@"iPad13,17"]) deviceString = @"iPad Air (5th generation)";
    // iPad 10th generation
    else if ([deviceString isEqualToString:@"iPad13,18"]) deviceString = @"iPad (10th generation)";
    else if ([deviceString isEqualToString:@"iPad13,19"]) deviceString = @"iPad (10th generation)";
    // iPad mini 6th generation
    else if ([deviceString isEqualToString:@"iPad14,1"]) deviceString = @"iPad mini (6th generation)";
    else if ([deviceString isEqualToString:@"iPad14,2"]) deviceString = @"iPad mini (6th generation)";
    // iPad Pro 4th Generation (11-inch) M2
    else if ([deviceString isEqualToString:@"iPad14,3"]) deviceString = @"iPad Pro (11-inch) (4th generation)";
    else if ([deviceString isEqualToString:@"iPad14,4"]) deviceString = @"iPad Pro (11-inch) (4th generation)";
    // iPad Pro 6th Generation (12.9-inch) M2
    else if ([deviceString isEqualToString:@"iPad14,5"]) deviceString = @"iPad Pro (12.9-inch) (6th generation)";
    else if ([deviceString isEqualToString:@"iPad14,6"]) deviceString = @"iPad Pro (12.9-inch) (6th generation)";
    // iPad Air 11-inch (M2)
    else if ([deviceString isEqualToString:@"iPad14,8"]) deviceString = @"iPad Air 11-inch (M2)";
    else if ([deviceString isEqualToString:@"iPad14,9"]) deviceString = @"iPad Air 11-inch (M2)";
    // iPad Air 13-inch (M2)
    else if ([deviceString isEqualToString:@"iPad14,10"]) deviceString = @"iPad Air 13-inch (M2)";
    else if ([deviceString isEqualToString:@"iPad14,11"]) deviceString = @"iPad Air 13-inch (M2)";
    // iPad Air 11-inch (M3)
    else if ([deviceString isEqualToString:@"iPad15,3"]) deviceString = @"iPad Air 11-inch (M3)";
    else if ([deviceString isEqualToString:@"iPad15,4"]) deviceString = @"iPad Air 11-inch (M3)";
    // iPad Air 13-inch (M3)
    else if ([deviceString isEqualToString:@"iPad15,5"]) deviceString = @"iPad Air 13-inch (M3)";
    else if ([deviceString isEqualToString:@"iPad15,6"]) deviceString = @"iPad Air 13-inch (M3)";
    // iPad (A16)
    else if ([deviceString isEqualToString:@"iPad15,7"]) deviceString = @"iPad (A16)";
    else if ([deviceString isEqualToString:@"iPad15,8"]) deviceString = @"iPad (A16)";
    // iPad mini (A17 Pro)
    else if ([deviceString isEqualToString:@"iPad16,1"]) deviceString = @"iPad mini (A17 Pro)";
    else if ([deviceString isEqualToString:@"iPad16,2"]) deviceString = @"iPad mini (A17 Pro)";
    // iPad Pro 11-inch (M4)
    else if ([deviceString isEqualToString:@"iPad16,3"]) deviceString = @"iPad Pro 11-inch (M4)";
    else if ([deviceString isEqualToString:@"iPad16,4"]) deviceString = @"iPad Pro 11-inch (M4)";
    // iPad Pro 13-inch (M4)
    else if ([deviceString isEqualToString:@"iPad16,5"]) deviceString = @"iPad Pro 13-inch (M4)";
    else if ([deviceString isEqualToString:@"iPad16,6"]) deviceString = @"iPad Pro 13-inch (M4)";
    // iPad Pro 11-inch (M5)
    else if ([deviceString isEqualToString:@"iPad17,1"]) deviceString = @"iPad Pro 11-inch (M5)";
    else if ([deviceString isEqualToString:@"iPad17,2"]) deviceString = @"iPad Pro 11-inch (M5)";
    // iPad Pro 13-inch (M5)
    else if ([deviceString isEqualToString:@"iPad17,3"]) deviceString = @"iPad Pro 13-inch (M5)";
    else if ([deviceString isEqualToString:@"iPad17,4"]) deviceString = @"iPad Pro 13-inch (M5)";
    // iPad mini
    // ref: https://www.theiphonewiki.com/wiki/List_of_iPad_minis
    // iPad mini
    else if ([deviceString isEqualToString:@"iPad2,5"]) deviceString = @"iPad mini";
    else if ([deviceString isEqualToString:@"iPad2,6"]) deviceString = @"iPad mini Cellular";
    else if ([deviceString isEqualToString:@"iPad2,7"]) deviceString = @"iPad mini Cellular MM";
    // iPad mini 2
    else if ([deviceString isEqualToString:@"iPad4,4"]) deviceString = @"iPad mini 2 WiFi";
    else if ([deviceString isEqualToString:@"iPad4,5"]) deviceString = @"iPad mini 2 Cellular LTE";
    else if ([deviceString isEqualToString:@"iPad4,6"]) deviceString = @"iPad mini 2 Cellular CDMA";
    // iPad mini 3
    else if ([deviceString isEqualToString:@"iPad4,7"]) deviceString = @"iPad mini 3 WiFi";
    else if ([deviceString isEqualToString:@"iPad4,8"]) deviceString = @"iPad mini 3 Cellular LTE";
    else if ([deviceString isEqualToString:@"iPad4,9"]) deviceString = @"iPad mini 3 Cellular CDMA";
    // iPad mini 4
    else if ([deviceString isEqualToString:@"iPad5,1"]) deviceString = @"iPad mini 4 WiFi";
    else if ([deviceString isEqualToString:@"iPad5,2"]) deviceString = @"iPad mini 4 Cellular";
    
    // Mac
    // ref: https://support.apple.com/en-us/102852
    // Mac mini (M1, 2020)
    else if ([deviceString isEqualToString:@"Macmini9,1"]) deviceString = @"Mac mini (M1, 2020)";
    // Mac mini (2023)
    else if ([deviceString isEqualToString:@"Mac14,3"]) deviceString = @"Mac mini (2023)";
    else if ([deviceString isEqualToString:@"Mac14,12"]) deviceString = @"Mac mini (2023)";
    // Mac mini (2024)
    else if ([deviceString isEqualToString:@"Mac16,10"]) deviceString = @"Mac mini (2024)";
    else if ([deviceString isEqualToString:@"Mac16,11"]) deviceString = @"Mac mini (2024)";
    // MacBook Air (M1, 2020)
    else if ([deviceString isEqualToString:@"MacBookAir10,1"]) deviceString = @"MacBook Air (M1, 2020)";
    // MacBook Air (M2, 2022)
    else if ([deviceString isEqualToString:@"Mac14,2"]) deviceString = @"MacBook Air (M2, 2022)";
    // MacBook Air (15-inch, M2, 2023)
    else if ([deviceString isEqualToString:@"Mac14,15"]) deviceString = @"MacBook Air (15-inch, M2, 2023)";
    // MacBook Air (13-inch, M3, 2024)
    else if ([deviceString isEqualToString:@"Mac15,12"]) deviceString = @"MacBook Air (13-inch, M3, 2024)";
    // MacBook Air (15-inch, M3, 2024)
    else if ([deviceString isEqualToString:@"Mac15,13"]) deviceString = @"MacBook Air (15-inch, M3, 2024)";
    // MacBook Air (13-inch, M4, 2025)
    else if ([deviceString isEqualToString:@"Mac16,12"]) deviceString = @"MacBook Air (13-inch, M4, 2025)";
    // MacBook Air (15-inch, M4, 2025)
    else if ([deviceString isEqualToString:@"Mac16,13"]) deviceString = @"MacBook Air (15-inch, M4, 2025)";
    // MacBook Pro (13-inch, M1, 2020)
    else if ([deviceString isEqualToString:@"MacBookPro17,1"]) deviceString = @"MacBook Pro (13-inch, M1, 2020)";
    // MacBook Pro (14-inch, 2021)
    else if ([deviceString isEqualToString:@"MacBookPro18,3"]) deviceString = @"MacBook Pro (14-inch, 2021)";
    else if ([deviceString isEqualToString:@"MacBookPro18,4"]) deviceString = @"MacBook Pro (14-inch, 2021)";
    // MacBook Pro (16-inch, 2021)
    else if ([deviceString isEqualToString:@"MacBookPro18,1"]) deviceString = @"MacBook Pro (16-inch, 2021)";
    else if ([deviceString isEqualToString:@"MacBookPro18,2"]) deviceString = @"MacBook Pro (16-inch, 2021)";
    // MacBook Pro (13-inch, M2, 2022)
    else if ([deviceString isEqualToString:@"Mac14,7"]) deviceString = @"MacBook Pro (13-inch, M2, 2022)";
    // MacBook Pro (14-inch, 2023)
    else if ([deviceString isEqualToString:@"Mac14,5"]) deviceString = @"MacBook Pro (14-inch, 2023)";
    else if ([deviceString isEqualToString:@"Mac14,9"]) deviceString = @"MacBook Pro (14-inch, 2023)";
    // MacBook Pro (16-inch, 2023)
    else if ([deviceString isEqualToString:@"Mac14,6"]) deviceString = @"MacBook Pro (16-inch, 2023)";
    else if ([deviceString isEqualToString:@"Mac14,10"]) deviceString = @"MacBook Pro (16-inch, 2023)";
    // MacBook Pro (14-inch, Nov 2023)
    else if ([deviceString isEqualToString:@"Mac15,3"]) deviceString = @"MacBook Pro (14-inch, Nov 2023)";
    else if ([deviceString isEqualToString:@"Mac15,6"]) deviceString = @"MacBook Pro (14-inch, Nov 2023)";
    else if ([deviceString isEqualToString:@"Mac15,8"]) deviceString = @"MacBook Pro (14-inch, Nov 2023)";
    else if ([deviceString isEqualToString:@"Mac15,10"]) deviceString = @"MacBook Pro (14-inch, Nov 2023)";
    // MacBook Pro (16-inch, Nov 2023)
    else if ([deviceString isEqualToString:@"Mac15,7"]) deviceString = @"MacBook Pro (16-inch, Nov 2023)";
    else if ([deviceString isEqualToString:@"Mac15,9"]) deviceString = @"MacBook Pro (16-inch, Nov 2023)";
    else if ([deviceString isEqualToString:@"Mac15,11"]) deviceString = @"MacBook Pro (16-inch, Nov 2023)";
    // MacBook Pro (14-inch, 2024)
    else if ([deviceString isEqualToString:@"Mac16,1"]) deviceString = @"MacBook Pro (14-inch, 2024)";
    else if ([deviceString isEqualToString:@"Mac16,6"]) deviceString = @"MacBook Pro (14-inch, 2024)";
    else if ([deviceString isEqualToString:@"Mac16,8"]) deviceString = @"MacBook Pro (14-inch, 2024)";
    // MacBook Pro (16-inch, 2024)
    else if ([deviceString isEqualToString:@"Mac16,5"]) deviceString = @"MacBook Pro (16-inch, 2024)";
    else if ([deviceString isEqualToString:@"Mac16,7"]) deviceString = @"MacBook Pro (16-inch, 2024)";
    // MacBook Pro (14-inch, M5)
    else if ([deviceString isEqualToString:@"Mac17,2"]) deviceString = @"MacBook Pro (14-inch, M5)";
    // Mac Studio (2022)
    else if ([deviceString isEqualToString:@"Mac13,1"]) deviceString = @"Mac Studio (2022)";
    else if ([deviceString isEqualToString:@"Mac13,2"]) deviceString = @"Mac Studio (2022)";
    // Mac Studio (2023)
    else if ([deviceString isEqualToString:@"Mac14,13"]) deviceString = @"Mac Studio (2023)";
    else if ([deviceString isEqualToString:@"Mac14,14"]) deviceString = @"Mac Studio (2023)";
    // Mac Studio (2025)
    else if ([deviceString isEqualToString:@"Mac15,14"]) deviceString = @"Mac Studio (2025)";
    else if ([deviceString isEqualToString:@"Mac16,9"]) deviceString = @"Mac Studio (2025)";
    // Mac Pro (2023)
    else if ([deviceString isEqualToString:@"Mac14,8"]) deviceString = @"Mac Pro (2023)";
    // iMac (24-inch, M1, 2021)
    else if ([deviceString isEqualToString:@"iMac21,1"]) deviceString = @"iMac (24-inch, M1, 2021)";
    else if ([deviceString isEqualToString:@"iMac21,2"]) deviceString = @"iMac (24-inch, M1, 2021)";
    // iMac (24-inch, 2023)
    else if ([deviceString isEqualToString:@"Mac15,4"]) deviceString = @"iMac (24-inch, 2023)";
    else if ([deviceString isEqualToString:@"Mac15,5"]) deviceString = @"iMac (24-inch, 2023)";
    // iMac (24-inch, 2024)
    else if ([deviceString isEqualToString:@"Mac16,2"]) deviceString = @"iMac (24-inch, 2024)";
    else if ([deviceString isEqualToString:@"Mac16,3"]) deviceString = @"iMac (24-inch, 2024)";
    
    // HomePod
    else if ([deviceString isEqualToString:@"AudioAccessory1,1"]) deviceString = @"HomePod";
    else if ([deviceString isEqualToString:@"AudioAccessory5,1"]) deviceString = @"HomePod mini";
    else if ([deviceString isEqualToString:@"AudioAccessory6,1"]) deviceString = @"HomePod (2nd generation)";
    
    // Apple Vision Pro
    else if ([deviceString isEqualToString:@"RealityDevice14,1"]) deviceString = @"Apple Vision Pro";
    else if ([deviceString isEqualToString:@"RealityDevice17,1"]) deviceString = @"Apple Vision Pro (M5)";
    
	else deviceString = @"Unknown";
	
	if ([deviceString isEqualToString:@"Unknown"])
        [devicetype setStringValue:[NSString stringWithFormat:@"%@ Mode/Device Detected",deviceString]];
    else {
        NSString* device = [NSString stringWithFormat:@"%@ iOS: %@",deviceString,[self getDeviceValue:@"ProductVersion"]];
        [devicetype setStringValue:[NSString stringWithFormat:@"%@", device]];
    }
    [deviceCPU setStringValue:platform];
    [deviceModel setStringValue:[NSString stringWithFormat:@"%@ %@",modelNumber,region]];
    [disconnetLabel setHidden:YES];
    
}

- (void)dePopulateData {
    [disconnetLabel setHidden:NO];
    [deviceCPU setStringValue:@""];
    [deviceModel setStringValue:@""];
    [devicetype setStringValue:@""];
}

- (NSString *)getDeviceValue:(NSString *)value {
	return AMDeviceCopyValue(device, 0, value);
}

@end
