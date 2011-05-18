//
//  ConnectionStatusNotifier.h
//  iTwatch
//
//  Created by pii on 06.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface ConnectionStatusNotifier : NSObject {
    UIWindow *window;
    UIView *notificationView;
    UILabel *notificationLabel;
}

- (id)initWithWindow:(UIWindow *)theWindow;
- (void)notificationViewInit;

@end
