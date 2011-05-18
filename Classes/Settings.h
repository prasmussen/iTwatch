//
//  Settings.h
//  iTwatch
//
//  Created by pii on 14.11.10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Settings : NSObject {
    NSUserDefaults *defaults;
}

@property (nonatomic, retain) NSUserDefaults *defaults;

+ (Settings *)sharedInstance;
- (NSString *)ipAddress;
- (NSInteger)mode;
- (BOOL)backlight;
- (BOOL)liveUpdate;
- (void)setIpAddress:(NSString *)ipAddress;
- (void)setMode:(NSInteger)mode;
- (void)setBacklight:(BOOL)backlight;
- (void)setLiveUpdate:(BOOL)liveUpdate;
- (BOOL)validIpAddress:(NSString *)address;

@end
