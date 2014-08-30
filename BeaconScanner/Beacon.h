//
//  Beacon.h
//  BeaconScanner
//
//  Created by SilverNine on 2014. 8. 30..
//  Copyright (c) 2014년 B-Conner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Beacon : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * uuid;

@end
