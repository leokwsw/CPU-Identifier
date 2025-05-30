//
//  NSString+MD5Addition.m
//  UIDeviceAddition
//
//  Created by Georg Kitz on 20.08.11.
//  Copyright 2011 Aurora Apps. All rights reserved.
//

#import "NSString+MD5Addition.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (MD5)
- (NSString *)MD5String {   
    if(self == nil || [self length] == 0) return nil;
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++)
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    
    return [outputString autorelease];
}
@end
