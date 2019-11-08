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
    
    // CPU
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

    else if ([platform isEqualToString:@"s7002"]) platform = @"S1";
    else if ([platform isEqualToString:@"t8002"]) platform = @"S1P / S2 / T1";
    else if ([platform isEqualToString:@"t8004"]) platform = @"S3";
    else if ([platform isEqualToString:@"t8012"]) platform = @"T2";
    else if ([platform isEqualToString:@"t8006"]) platform = @"S4";
    
    else if ([platform isEqualToString:@"w1"]) platform = @"W1";
    else if ([platform isEqualToString:@"w2"]) platform = @"W2";
    else if ([platform isEqualToString:@"w3"]) platform = @"W3";
    
    else platform = @"Unknow CPU";
    
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
    else if ([deviceString isEqualToString:@"iPod7,1"]) deviceString = @"iPod touch 6 Gen";
    
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
    // Apple TV 4K
    else if ([deviceString isEqualToString:@"AppleTV6,2"]) deviceString = @"Apple TV 4K";
    
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
    else if ([deviceString isEqualToString:@"Watch4,1"]) deviceString = @"Apple Watch Series 4";
    else if ([deviceString isEqualToString:@"Watch4,2"]) deviceString = @"Apple Watch Series 4 Cellular";
    else if ([deviceString isEqualToString:@"Watch4,3"]) deviceString = @"Apple Watch Series 4";
    else if ([deviceString isEqualToString:@"Watch4,4"]) deviceString = @"Apple Watch Series 4 Cellular";
    
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
    // iPad Pro 3rd Generation
    else if ([deviceString isEqualToString:@"iPad8.1"]) deviceString = @"iPad Pro 3 11";
    else if ([deviceString isEqualToString:@"iPad8.2"]) deviceString = @"iPad Pro 3 11";
    else if ([deviceString isEqualToString:@"iPad8.3"]) deviceString = @"iPad Pro 3 11";
    else if ([deviceString isEqualToString:@"iPad8.4"]) deviceString = @"iPad Pro 3 11";
    else if ([deviceString isEqualToString:@"iPad8.5"]) deviceString = @"iPad Pro 3 12.9";
    else if ([deviceString isEqualToString:@"iPad8.6"]) deviceString = @"iPad Pro 3 12.9";
    else if ([deviceString isEqualToString:@"iPad8.7"]) deviceString = @"iPad Pro 3 12.9";
    else if ([deviceString isEqualToString:@"iPad8.5"]) deviceString = @"iPad Pro 3 12.9";
    // iPad min
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
    
    
    else if ([deviceString isEqualToString:@"AudioAccessory1,1"]) deviceString = @"HomePod";
    
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
