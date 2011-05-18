//
//  RootViewController.m
//  iTwatch
//
//  Created by pii on 28.11.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"
#import "SettingsViewController.h"

@implementation RootViewController
@synthesize twatch, placeholders, inputFields, liveUpdateSwitch, settings;


- (void)viewDidLoad {
    [super viewDidLoad];
    twatch = [Twatch sharedInstance];
    settings = [Settings sharedInstance];
    
    placeholders = [[NSArray alloc] initWithObjects:@"Lorem ipsum", @"dolor sit amet,", @"consectetur", @"adipiscing elit.", nil];
    inputFields = [[NSMutableArray alloc] initWithCapacity:[twatch rows]];
    
    liveUpdateSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(200, 10, 0, 0)];
    liveUpdateSwitch.on = [settings liveUpdate];
    
    UIBarButtonItem *settingsButton = self.navigationItem.rightBarButtonItem;
    [settingsButton setTarget:self];
    [settingsButton setAction:@selector(settingsButton:)];
    
    
    for (int i = 0; i < [twatch rows]; i++) {
        UITextField *inputField = [[UITextField alloc] initWithFrame:CGRectMake(100, 12, 206, 24)];
        inputField.adjustsFontSizeToFitWidth = YES;
        inputField.font = [UIFont fontWithName:@"Helvetica" size:20];
        inputField.autocorrectionType = UITextAutocorrectionTypeNo;
        inputField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
        inputField.clearButtonMode = UITextFieldViewModeWhileEditing;
        inputField.placeholder = [placeholders objectAtIndex:i];
        inputField.tag = i + 1;
        inputField.delegate = self;
        
        if (i == ([twatch rows] - 1)) {
            inputField.returnKeyType = UIReturnKeyDone;
        }
        else {
            inputField.returnKeyType = UIReturnKeyNext;
        }
        
        [inputField addTarget:self action:@selector(inputFieldChanged:) forControlEvents:UIControlEventEditingChanged];
        [inputFields insertObject:inputField atIndex:i];
        [inputField release];
    }
}



- (IBAction)settingsButton:(id)sender {
    UITableViewController *settingsVC = [[SettingsViewController alloc] initWithStyle:UITableViewStyleGrouped];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:settingsVC];
    [self.navigationController presentModalViewController:navController animated:YES];
    [settingsVC release];
    [navController release];
}




- (void)sendAllFields {
    for (int i = 0; i < inputFields.count; i++) {
        UITextField *field = [inputFields objectAtIndex:i];
        NSString *text = ([field.text length]) ? field.text : @"";
        [twatch setPaddedText:text row:i + 1];
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    for (int i = 0; i < inputFields.count; i++) {
        if (i == (inputFields.count - 1)) {
            NSLog(@"Send text");
            [self sendAllFields];
            [textField resignFirstResponder];
        }
        else if (textField == [inputFields objectAtIndex:i]) {
            UITextField *nextField = [inputFields objectAtIndex:i + 1];
            [nextField becomeFirstResponder];
            break;
        }
    }
    return NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return (textField.text.length >= [twatch columns] && range.length == 0) ? NO : YES;
}


- (void)inputFieldChanged:(id)sender {
    UITextField *changedTextField = sender;
	
    if (liveUpdateSwitch.on == YES) {
        [twatch setPaddedText:changedTextField.text row:changedTextField.tag];
    }
    NSLog(@"Row %d text: %@", changedTextField.tag, changedTextField.text);
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (section == 0) ? [twatch rows] : 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		
        if (indexPath.section == 0) {
            cell.textLabel.text = [NSString stringWithFormat:@"Row %d", indexPath.row + 1];
            [cell addSubview:[inputFields objectAtIndex:indexPath.row]];
        }
        else if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                cell.textLabel.text = @"Live update";
				
                [cell addSubview:liveUpdateSwitch];
            }
            else if (indexPath.row == 1) {
                cell.textLabel.textAlignment = UITextAlignmentCenter;
                cell.textLabel.text = @"Clear screen";
            }
        }
    }
    return cell;    
}


- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && indexPath.row == 1)
        return indexPath;
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && indexPath.row == 1) {
        // Clear screen button
        [twatch clearScreen];
        for (UITextField *field in inputFields) {
            field.text = @"";
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];    
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

- (void)dealloc {
    [placeholders release];
    [inputFields release];
    [liveUpdateSwitch release];
    [twatch release];
	[settings release];
    [super dealloc];
}

@end

