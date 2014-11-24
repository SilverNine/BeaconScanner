//
//  AddViewController.h
//  BeaconScanner
//
//  Created by SilverNine on 2014. 8. 24..
//  Copyright (c) 2014년 B-Conner. All rights reserved.
//

#import "DetailViewController.h"


@protocol AddViewControllerDelegate;


@interface AddViewController : DetailViewController

@property (nonatomic, weak) id <AddViewControllerDelegate> delegate;

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end


@protocol AddViewControllerDelegate
- (void)addViewController:(AddViewController *)controller didFinishWithSave:(BOOL)save;
@end
