//
//  RootViewController.h
//  iTwatch
//
//  Created by pii on 28.11.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Twatch.h"
#import "Settings.h"

@interface RootViewController : UITableViewController <UITextFieldDelegate> {
    Twatch *twatch;
    Settings *settings;
    NSArray *placeholders;
    NSMutableArray *inputFields;
    UISwitch *liveUpdateSwitch;
}

@property (nonatomic, retain) Twatch *twatch;
@property (nonatomic, retain) Settings *settings;
@property (nonatomic, retain) NSArray *placeholders;
@property (nonatomic, retain) NSMutableArray *inputFields;
@property (nonatomic, retain) UISwitch *liveUpdateSwitch;

- (IBAction)settingsButton:(id)sender;

@end
