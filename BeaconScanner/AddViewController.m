//
//  AddViewController.m
//  BeaconScanner
//
//  Created by SilverNine on 2014. 8. 24..
//  Copyright (c) 2014년 B-Conner. All rights reserved.
//

#import "AddViewController.h"

@implementation AddViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set up the undo manager and set editing state to YES.
    [self setUpUndoManager];
    self.editing = YES;
}


- (IBAction)cancel:(id)sender
{
    [self.delegate addViewController:self didFinishWithSave:NO];
}


- (IBAction)save:(id)sender
{
    [self.delegate addViewController:self didFinishWithSave:YES];
}


- (void)dealloc
{
    [self cleanUpUndoManager];
}

@end