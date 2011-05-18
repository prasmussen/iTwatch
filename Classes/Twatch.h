//
//  Twatch.h
//  Twatch
//
//  Created by pii on 21.10.10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServerConnection.h"

@interface Twatch : NSObject {
    ServerConnection *server;
}

@property (nonatomic, retain) ServerConnection *server;

+ (Twatch *)sharedInstance;
- (void)setText:(NSString *)text;
- (void)setText:(NSString *)text row:(int)row;
- (void)setText:(NSString *)text row:(int)row index:(int)index;
- (void)setPaddedText:(NSString *)text row:(int)row;
- (void)backlightOn;
- (void)backlightOff;
- (void)clearScreen;
- (void)setBrightness:(int)brightness;
- (void)matrixMode;
- (void)networkConfig;
- (void)twitterMode;
- (NSInteger)rows;
- (NSInteger)columns;

@end
