//
//  SettingsViewController.m
//  iTwatch
//
//  Created by pii on 30.10.10.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController.h"


@implementation SettingsViewController
@synthesize twatch, backlightSwitch, ipField, modeSegment, settings;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Settings";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneButton)];
    twatch = [Twatch sharedInstance];
    settings = [Settings sharedInstance];
    
    
    backlightSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(200, 8, 0, 0)];
    backlightSwitch.on = [settings backlight];
    [backlightSwitch addTarget:self action:@selector(backlightChanged:) forControlEvents:UIControlEventValueChanged];
        
    ipField = [[UITextField alloc] initWithFrame:CGRectMake(120, 12, 186, 24)];
    ipField.adjustsFontSizeToFitWidth = YES;
    ipField.font = [UIFont fontWithName:@"Helvetica" size:20];
    ipField.autocorrectionType = UITextAutocorrectionTypeNo;
    ipField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    ipField.clearButtonMode = UITextFieldViewModeWhileEditing;
    ipField.placeholder = @"10.0.0.7";
    ipField.text = [settings ipAddress];
    ipField.delegate = self;
    ipField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    ipField.returnKeyType = UIReturnKeyDone;
    [ipField addTarget:self action:@selector(ipFieldChanged:) forControlEvents:UIControlEventEditingDidEnd];
    

    NSArray *modes = [NSArray arrayWithObjects:@"Matrix Orbital", @"Twitter", nil];
    modeSegment = [[UISegmentedControl alloc] initWithItems:modes];
    modeSegment.frame = CGRectMake(-1.0f, -1.0f, 302.0f, 46.0f);
    modeSegment.selectedSegmentIndex = [settings mode];
    [modeSegment addTarget:self action:@selector(modeChanged:) forControlEvents:UIControlEventValueChanged];
}


- (void)backlightChanged:(id)sender {
    backlightSwitch.on ? [twatch backlightOn] : [twatch backlightOff];
    [settings setBacklight:backlightSwitch.on];
}

- (void)modeChanged:(id)sender {
    (modeSegment.selectedSegmentIndex == 0) ? [twatch matrixMode] : [twatch twitterMode];
    [settings setMode:modeSegment.selectedSegmentIndex];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (void)ipFieldChanged:(id)sender {
    NSLog(@"ip field changed");
    [settings setIpAddress:ipField.text];
}

- (void)doneButton {
    [self dismissModalViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    else if (section == 1) {
        return 2;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                [cell.contentView addSubview:modeSegment]; 
            }
        }
        else if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                cell.textLabel.text = [NSString stringWithFormat:@"Address"];
                [cell addSubview:ipField];
            }
            else if (indexPath.row == 1) {
                cell.textLabel.text = @"Backlight";
                [cell addSubview:backlightSwitch];
            }
        }
    }
    return cell;    
}



#pragma mark -
#pragma mark Table view delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [twatch release];
    [backlightSwitch release];
    [ipField release];
    [modeSegment release];
	[settings release];
    [super dealloc];
}


@end

