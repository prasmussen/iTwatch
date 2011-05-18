//
//  ServerConnection.h
//  HTRemote1
//
//  Created by pii on 06.08.10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsyncSocket.h"
#import "Settings.h"

@interface ServerConnection : NSObject {
	AsyncSocket *aSocket;
    Settings *settings;
    int reconnectCounter;
    BOOL connectInProgress;
}

+ (ServerConnection*)sharedInstance;
- (void)connect;
- (void)disconnect;
- (void)sendData:(NSData *)data;

@end
