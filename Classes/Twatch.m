//
//  Twatch.m
//  Twatch
//
//  Created by pii on 21.10.10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import "Twatch.h"

#define MATRIX_ORBITAL_COMMAND 254 //0xfe
#define BACKLIGHT_ON 66 //0x42, 1 parameter (minutes 00=forever)
#define BACKLIGHT_OFF 70 //0x46
#define CLEAR 88
#define HOME 72
#define POSITION 71 //2 parameters (col, row)
#define UNDERLINE_CURSER_ON 74
#define UNDERLINE_CURSER_OFF 75
#define BLOCK_CURSER_ON 83
#define BLOCK_CURSER_OFF 84
#define BACKLIGHT_BRIGHTNESS 152 //1 parameter (brightness)
#define CUSTOM_CHARACTER 78 //9 parameters (character #, 8 byte bitmap)
#define NETWORK_CONFIG 153 //show node connection details (custom)
#define EXIT 154 //exit Matrix orbital mode and resume screeensaver

#define ROWS 4
#define COLUMNS 20

static Twatch *sharedInstance = nil;

@implementation Twatch
@synthesize server;


- (id)init {
    self = [super init];
    server = [ServerConnection sharedInstance];
    return self;
}


- (void)networkConfig {
    const char bytes[] = {MATRIX_ORBITAL_COMMAND, NETWORK_CONFIG};
    NSData *data = [NSData dataWithBytes:bytes length:2];
    [server sendData:data];
}

- (void)matrixMode {
    const char bytes[] = {MATRIX_ORBITAL_COMMAND, POSITION, 1, 1, MATRIX_ORBITAL_COMMAND, CLEAR};
    NSData *data = [NSData dataWithBytes:bytes length:6];
    [server sendData:data];
}

- (void)twitterMode {
    const char bytes[] = {MATRIX_ORBITAL_COMMAND, EXIT};
    NSData *data = [NSData dataWithBytes:bytes length:2];
    [server sendData:data];    
}

- (void)setText:(NSString *)text {
    NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"Server < sending text");
    [server sendData:data];
}

- (void)setText:(NSString *)text row:(int)row {
    const char bytes[] = {MATRIX_ORBITAL_COMMAND, POSITION, 1, row};
    NSData *data = [NSData dataWithBytes:bytes length:4];
    NSLog(@"Server < sending cursor position");
    [server sendData:data];
    [self setText:text];
}

- (void)setText:(NSString *)text row:(int)row index:(int)index {
    const char bytes[] = {MATRIX_ORBITAL_COMMAND, POSITION, index, row};
    NSData *data = [NSData dataWithBytes:bytes length:4];
    [server sendData:data];
    [self setText:text];
}

- (void)setPaddedText:(NSString *)text row:(int)row {
    NSString *paddedText = [text stringByPaddingToLength:COLUMNS withString:@" " startingAtIndex:0];
    [self setText:paddedText row:row];
}

- (void)backlightOn {
    const char bytes[] = {MATRIX_ORBITAL_COMMAND, BACKLIGHT_ON, 00};
    NSData *data = [NSData dataWithBytes:bytes length:3];
    [server sendData:data];
}

- (void)backlightOff {
    const char bytes[] = {MATRIX_ORBITAL_COMMAND, BACKLIGHT_OFF};
    NSData *data = [NSData dataWithBytes:bytes length:2];
    [server sendData:data];
}

- (void)clearScreen {
    const char bytes[] = {MATRIX_ORBITAL_COMMAND, CLEAR};
    NSData *data = [NSData dataWithBytes:bytes length:2];
    [server sendData:data];
}


- (void)setBrightness:(int)brightness {
    const char bytes[] = {MATRIX_ORBITAL_COMMAND, BACKLIGHT_BRIGHTNESS, brightness};
    NSData *data = [NSData dataWithBytes:bytes length:3];
    [server sendData:data];
}

- (NSInteger)rows {
    return ROWS;
}

- (NSInteger)columns {
    return COLUMNS;
}

- (void)dealloc {
    [server release];
    [super dealloc];
}

#pragma mark -
#pragma mark Singleton methods

+ (Twatch *)sharedInstance {
    @synchronized(self) {
        if (sharedInstance == nil)
            sharedInstance = [[Twatch alloc] init];
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
