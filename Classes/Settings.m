//
//  Settings.m
//  iTwatch
//
//  Created by pii on 14.11.10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import "Settings.h"


static Settings *sharedInstance = nil;


@implementation Settings
@synthesize defaults;

- (id)init {
    self = [super init];
    defaults = [NSUserDefaults standardUserDefaults];
    return self;
}


- (NSString *)ipAddress {
    NSString *ipAddress = [defaults objectForKey:@"ipAddress"];
    NSLog(@"defaults ip address: %@", ipAddress);
    return ([ipAddress length] > 0) ? ipAddress : @"";
}

- (NSInteger)mode {
    NSNumber *mode = [defaults objectForKey:@"mode"];
    return (mode) ? [mode intValue] : 1;
}

- (BOOL)backlight {
    NSNumber *backlight = [defaults objectForKey:@"backlight"];
    return (backlight) ? [backlight boolValue] : 1;
}

- (BOOL)liveUpdate {
    NSNumber *liveUpdate = [defaults objectForKey:@"liveUpdate"];
    return (liveUpdate) ? [liveUpdate boolValue] : 1;
}

- (void)setIpAddress:(NSString *)ipAddress {
    if (![self validIpAddress:ipAddress]) {
        NSLog(@"Invalid ip");
    }
    else if ([ipAddress compare:[self ipAddress]] == NSOrderedSame) {
        NSLog(@"Ip address did not change");
    }
    else {
        [defaults setObject:ipAddress forKey:@"ipAddress"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ServerIpAddressDidChangeNotification" object:self];
    }
}

- (void)setMode:(NSInteger)mode {
    [defaults setObject:[NSNumber numberWithInteger:mode] forKey:@"mode"];
}

- (void)setBacklight:(BOOL)backlight {
    [defaults setObject:[NSNumber numberWithBool:backlight] forKey:@"backlight"];
}

- (void)setLiveUpdate:(BOOL)liveUpdate {
    [defaults setObject:[NSNumber numberWithBool:liveUpdate] forKey:@"liveUpdate"];
}


- (BOOL)validIpAddress:(NSString *)address {
    NSString *regex = @"\\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\b"; 
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex]; 
    return [predicate evaluateWithObject:address];
}


- (void)dealloc {
    [defaults release];
    [super dealloc];
}


#pragma mark -
#pragma mark Singleton methods

+ (Settings *)sharedInstance {
    @synchronized(self) {
        if (sharedInstance == nil)
            sharedInstance = [[Settings alloc] init];
    }
    return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [super allocWithZone:zone];
            return sharedInstance;  // assignment and return on first allocation
        }
    }
    return nil; // on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)retain {
    return self;
}

- (unsigned)retainCount {
    return UINT_MAX;  // denotes an object that cannot be released
}


- (void)release {
    //do nothing
}

- (id)autorelease {
    return self;
}

@end
