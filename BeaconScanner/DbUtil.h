//
//  DbUtil.h
//  BeaconScanner
//
//  Created by SilverNine on 2014. 8. 16..
//  Copyright (c) 2014년 B-Conner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "Beacon.h"

@interface DbUtil : NSObject {
    sqlite3 *mySqliteDB;
}

@property (nonatomic, strong) NSString *databasePath;

-(void) initDatabase;
-(BOOL) saveBeacon:(Beacon *)beacon;
-(BOOL) deleteBeacon:(Beacon *)beacon;
-(NSMutableArray *) getBeacons;
-(Beacon *) getBeacon:(NSInteger)seq;

@end
