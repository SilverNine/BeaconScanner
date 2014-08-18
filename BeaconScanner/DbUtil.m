//
//  DbUtil.m
//  BeaconScanner
//
//  Created by SilverNine on 2014. 8. 16..
//  Copyright (c) 2014년 B-Conner. All rights reserved.
//

#import "DbUtil.h"

@implementation DbUtil

@synthesize databasePath;

- (void) initDatabase {
    
    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString:
                    [docsDir stringByAppendingPathComponent:@"beacons.db"]];
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    //the file will not be there when we load the application for the first time
    //so this will create the database table
    if ([filemgr fileExistsAtPath: databasePath ] == NO)
    {
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &mySqliteDB) == SQLITE_OK)
        {
            char *errMsg;
            NSString *sql_stmt = @"CREATE TABLE IF NOT EXISTS BEACONS (";
            sql_stmt = [sql_stmt stringByAppendingString:@"seq INTEGER PRIMARY KEY AUTOINCREMENT, "];
            sql_stmt = [sql_stmt stringByAppendingString:@"uuid TEXT, "];
            sql_stmt = [sql_stmt stringByAppendingString:@"name TEXT)"];
            
            if (sqlite3_exec(mySqliteDB, [sql_stmt UTF8String], NULL, NULL, &errMsg) != SQLITE_OK)
            {
                NSLog(@"Failed to create table");
            }
            else
            {
                NSLog(@"Beacons table created successfully");
            }
            
            sqlite3_close(mySqliteDB);
            
        } else {
            NSLog(@"Failed to open/create database");
        }
    }
    
}

//save our data
- (BOOL) saveBeacon:(Beacon *)beacon
{
    BOOL success = false;
    sqlite3_stmt *statement = NULL;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &mySqliteDB) == SQLITE_OK)
    {
        if (beacon.seq > 0) {
            NSLog(@"Exitsing data, Update Please");
            NSString *updateSQL = [NSString stringWithFormat:@"UPDATE BEACONS set name = '%@', uuid = '%@' WHERE seq = ?",
                                   beacon.name,
                                   beacon.uuid
                                   ];
            
            const char *update_stmt = [updateSQL UTF8String];
            sqlite3_prepare_v2(mySqliteDB, update_stmt, -1, &statement, NULL );
            sqlite3_bind_int(statement, 1, (int)beacon.seq);
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                success = true;
            }
            
        }
        else{
            NSLog(@"New data, Insert Please");
            NSString *insertSQL = [NSString stringWithFormat:
                                   @"INSERT INTO BEACONS (name, uuid) VALUES (\"%@\", \"%@\")",
                                   beacon.name,
                                   beacon.uuid
                                   ];
            
            const char *insert_stmt = [insertSQL UTF8String];
            sqlite3_prepare_v2(mySqliteDB, insert_stmt, -1, &statement, NULL);
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                success = true;
            }
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(mySqliteDB);
        
    }
    
    return success;
}


//get a list of all our employees
- (NSMutableArray *) getBeacons
{
    NSMutableArray *beaconList = [[NSMutableArray alloc] init];
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &mySqliteDB) == SQLITE_OK)
    {
        NSString *querySQL = @"SELECT seq, name, uuid FROM BEACONS";
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(mySqliteDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                Beacon *beacon = [[Beacon alloc] init];
                beacon.seq = sqlite3_column_int(statement, 0);
                beacon.name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                beacon.uuid = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                [beaconList addObject:beacon];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(mySqliteDB);
    }
    
    return beaconList;
}


//get information about a specfic employee by it's id
- (Beacon *) getBeacon:(NSInteger) seq
{
    Beacon *beacon = [[Beacon alloc] init];
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    if (sqlite3_open(dbpath, &mySqliteDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT seq, name, uuid FROM BEACONS WHERE seq=%d",
                              (int)seq];
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(mySqliteDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                beacon.seq = sqlite3_column_int(statement, 0);
                beacon.name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                beacon.uuid = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(mySqliteDB);
    }
    
    return beacon;
}

//delete the employee from the database
- (BOOL) deleteBeacon:(Beacon *)beacon
{
    BOOL success = false;
    sqlite3_stmt *statement = NULL;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &mySqliteDB) == SQLITE_OK)
    {
        if (beacon.seq > 0) {
            NSLog(@"Exitsing data, Delete Please");
            NSString *deleteSQL = [NSString stringWithFormat:@"DELETE from BEACONS WHERE seq = ?"];
            
            const char *delete_stmt = [deleteSQL UTF8String];
            sqlite3_prepare_v2(mySqliteDB, delete_stmt, -1, &statement, NULL );
            sqlite3_bind_int(statement, 1, (int)beacon.seq);
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                success = true;
            }
            
        }
        else{
            NSLog(@"New data, Nothing to delete");
            success = true;
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(mySqliteDB);
        
    }
    
    return success;
}


@end
