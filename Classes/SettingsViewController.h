//
//  SettingsViewController.h
//  iTwatch
//
//  Created by pii on 30.10.10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Twatch.h"
#import "Settings.h"

@interface SettingsViewController : UITableViewController <UITextFieldDelegate> {
    Twatch *twatch;
    Settings *settings;
    UISwitch *backlightSwitch;
    UITextField *ipField;
    UISegmentedControl *modeSegment;
}

@property (nonatomic, retain) Twatch *twatch;
@property (nonatomic, retain) Settings *settings;
@property (nonatomic, retain) UISwitch *backlightSwitch;
@property (nonatomic, retain) UITextField *ipField;
@property (nonatomic, retain) UISegmentedControl *modeSegment;

@end