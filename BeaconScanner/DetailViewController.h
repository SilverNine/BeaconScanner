//
//  DetailViewController.h
//  BeaconScanner
//
//  Created by SilverNine on 2014. 8. 24..
//  Copyright (c) 2014년 B-Conner. All rights reserved.
//

@class Beacon;

@interface DetailViewController : UITableViewController

@property (nonatomic, strong) Beacon *beacon;

@end

@interface DetailViewController (Private)

- (void)setUpUndoManager;

- (void)cleanUpUndoManager;

@end