//
//  EditingViewController.h
//  BeaconScanner
//
//  Created by SilverNine on 2014. 8. 24..
//  Copyright (c) 2014년 B-Conner. All rights reserved.
//

@interface EditingViewController : UIViewController

@property (nonatomic, strong) NSManagedObject *editedObject;
@property (nonatomic, strong) NSString *editedFieldKey;
@property (nonatomic, strong) NSString *editedFieldName;

@end
