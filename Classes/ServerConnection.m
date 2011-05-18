//
//  ServerConnection.m
//  HTRemote1
//
//  Created by pii on 06.08.10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//
//  Singelton pattern adopted from http://stackoverflow.com/questions/145154

#import "ServerConnection.h"
#import "NSStream+MyAdditions.h"


//#define serverAddress @"10.0.0.79"
#define serverPort 1337

static ServerConnection *sharedInstance = nil;

@implementation ServerConnection

- (id)init {
    self = [super init];
    aSocket = [[AsyncSocket alloc] initWithDelegate:self];
    settings = [Settings sharedInstance];
    connectInProgress = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ipChanged:) name:@"ServerIpAddressDidChangeNotification" object:nil];
    
    //[self connect];
    reconnectCounter = 0;
    return self;
}

- (void)ipChanged:(NSNotification *)aNotification {
    if ([aSocket isConnected]) {
        [aSocket disconnect];
    }
    [self connect];
}

- (void)connect {
    NSString *serverAddress = [settings ipAddress];
    if ([serverAddress length] == 0) {
        NSLog(@"Ip address not defined");
        return;
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:@"ConnectingNotification" object:nil];
	NSLog(@"Connecting to: %@ ...", serverAddress);
	
	NSError *error = nil;
	if (![aSocket connectToHost:serverAddress onPort:serverPort error:&error]) {
		NSLog(@"Error: %@", [error localizedDescription]);
	}	
}

- (void)disconnect {
	[aSocket disconnect];
}

- (BOOL)onSocketWillConnect:(AsyncSocket *)sock {
	connectInProgress = YES;
    NSLog(@"Will connect");
	return YES;
}

- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port {
    connectInProgress = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ConnectedNotification" object:nil];
	NSLog(@"Did connect to host: %@:%d", host, port);
}

- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err {
	NSLog(@"Will disconnect: %@", err);
}

- (void)onSocketDidDisconnect:(AsyncSocket *)sock {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DisconnectedNotification" object:nil];
	NSLog(@"Did disconnect");
    connectInProgress = NO;
}

- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag {
	NSLog(@"Did write data");
}



- (void)sendData:(NSData *)data {  
    if (connectInProgress) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        [self performSelector:@selector(sendData:) withObject:data afterDelay:1];
    }
    else if (reconnectCounter >= 3) {
        NSLog(@"Unable to reconnect");
        reconnectCounter = 0;
    }
    else if (![aSocket isConnected]) {
        NSLog(@"Not connected");
        [self connect];
        reconnectCounter++;
        [self performSelector:@selector(sendData:) withObject:data afterDelay:1];
    }
    else {
        NSLog(@"Connection status: %d", [aSocket isConnected]);
        reconnectCounter = 0;
        [aSocket writeData:data withTimeout:1 tag:0];   
    }
}


- (void)dealloc {
    [aSocket release];
	[settings release];
    [super dealloc];
}

#pragma mark -
#pragma mark Singleton methods

+ (ServerConnection*)sharedInstance {
    @synchronized(self) {
        if (sharedInstance == nil)
            sharedInstance = [[ServerConnection alloc] init];
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
