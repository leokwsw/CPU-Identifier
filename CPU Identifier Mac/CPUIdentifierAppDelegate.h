//
//  CPUIdentifierAppDelegate.h
//  CPUIdentifier
//
//  Created by Leo Wu on 19/10/2016.
//  Copyright © 2016年 Leo Wu. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>
#import "MobileDevice.h"
#import "NSString+MD5Addition.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, NSURLSessionDelegate> {
    NSWindow *window;
	IBOutlet NSTextField *disconnetLabel;
    IBOutlet NSTextField *devicetype;
    IBOutlet NSTextField *deviceModel;
    IBOutlet NSTextField *deviceCPU;
    BOOL accept;
    BOOL connected;
}

@property (assign) IBOutlet NSWindow *window;
@property (nonatomic, retain) NSProgressIndicator *loadingInd;

- (void)populateData;
- (void)dePopulateData;
- (void)recoveryCallback;
- (NSString *)getDeviceValue:(NSString *)value;

@end
