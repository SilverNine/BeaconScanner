//
//  DetailViewController.h
//  BeaconScanner
//
//  Created by SilverNine on 2014. 8. 10..
//  Copyright (c) 2014년 B-Conner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
