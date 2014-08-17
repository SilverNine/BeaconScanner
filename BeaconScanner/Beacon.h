//
//  Beacon.h
//  BeaconScanner
//
//  Created by SilverNine on 2014. 8. 16..
//  Copyright (c) 2014년 B-Conner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Beacon : NSObject

@property (nonatomic) NSInteger seq;
@property (nonatomic, strong) NSString *uuid;
@property (nonatomic, strong) NSString *name;

@end
