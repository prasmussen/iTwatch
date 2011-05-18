//
//  ConnectionStatusNotifier.m
//  iTwatch
//
//  Created by pii on 06.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ConnectionStatusNotifier.h"
#define NotificationWidth 160
#define NotificationHeight 40

@implementation ConnectionStatusNotifier

- (id)initWithWindow:(UIWindow *)theWindow {
    self = [super init];
    window = theWindow;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connecting) name:@"ConnectingNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connected) name:@"ConnectedNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disconnected) name:@"DisconnectedNotification" object:nil];
    [self notificationViewInit];
    return self;
}

- (void)notificationViewInit {
    // Background
    notificationView = [[UIView alloc] init];
    notificationView.alpha = 0.0;
    notificationView.frame = CGRectMake(0, 0, NotificationWidth, NotificationHeight);
    notificationView.center = CGPointMake(window.frame.size.width * 0.5, window.frame.size.height * 0.45);
    notificationView.userInteractionEnabled = NO;
    notificationView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    notificationView.layer.cornerRadius = 8.0;
    
    // Text
    notificationLabel = [[UILabel alloc] init];
    notificationLabel.frame = CGRectMake(0, 0, NotificationWidth, NotificationHeight);
    notificationLabel.textAlignment = UITextAlignmentCenter;
    notificationLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0];
    notificationLabel.textColor = [UIColor whiteColor];
    notificationLabel.backgroundColor = [UIColor clearColor];
    
    [notificationView addSubview:notificationLabel];
}


- (void)showNotification {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideNotification) object:nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:notificationView selector:@selector(removeFromSuperview) object:nil];
    notificationView.alpha = 1.0;
    [window addSubview:notificationView];
}

- (void)showNotificationAndHideAfter:(float)seconds {
    [self showNotification];
    [self performSelector:@selector(hideNotification) withObject:nil afterDelay:seconds];
}

- (void)hideNotification {
    [UIView beginAnimations:@"hide" context:nil];
    [UIView setAnimationDuration:0.5];
    notificationView.alpha = 0.0;
    [UIView commitAnimations];
    [notificationView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.6];
}


- (void)connecting {
    notificationLabel.text = @"CONNECTING...";
    [self showNotification];
}

- (void)connected {
    notificationLabel.text = @"CONNECTED";
    [self showNotificationAndHideAfter:1.0];
}

- (void)disconnected {
    notificationLabel.text = @"DISCONNECTED";
    [self showNotificationAndHideAfter:1.0];
}

- (void)dealloc {
    [notificationLabel release];
    [notificationView release];
    [super dealloc];
}

@end
