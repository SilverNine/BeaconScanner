//
//  EditingViewController.m
//  BeaconScanner
//
//  Created by SilverNine on 2014. 8. 24..
//  Copyright (c) 2014년 B-Conner. All rights reserved.
//

#import "EditingViewController.h"

@interface EditingViewController ()

@property (nonatomic, weak) IBOutlet UITextField *textField;

@end

#pragma mark -

@implementation EditingViewController
{

}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    // Set the title to the user-visible name of the field.
    
    self.title = self.editedFieldName;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.textField.hidden = NO;
    self.textField.text = [self.editedObject valueForKey:self.editedFieldKey];
    self.textField.placeholder = self.title;
    [self.textField becomeFirstResponder];
}


#pragma mark - Save and cancel operations

- (IBAction)save:(id)sender
{
    if(self.textField.text.length > 0){
        // Set the action name for the undo operation.
        NSUndoManager * undoManager = [[self.editedObject managedObjectContext] undoManager];
        [undoManager setActionName:[NSString stringWithFormat:@"%@", self.editedFieldName]];
        
        // Pass current value to the edited object, then pop
        [self.editedObject setValue:self.textField.text forKey:self.editedFieldKey];
        
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:@"잠시만요!"
                                                           message:@"내용을 입력해주세요."
                                                          delegate:self
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
        [theAlert show];
    }
}


- (IBAction)cancel:(id)sender
{
    // Don't pass current value to the edited object, just pop.
    [self.navigationController popViewControllerAnimated:YES];
}

@end


