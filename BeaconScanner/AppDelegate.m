//
//  AppDelegate.m
//  BeaconScanner
//
//  Created by SilverNine on 2014. 8. 10..
//  Copyright (c) 2014년 B-Conner. All rights reserved.
//

#import "AppDelegate.h"
#import "UUIDViewController.h"
#import "ScanViewController.h"
#import "Beacon.h"

@interface AppDelegate ()

@property (nonatomic, strong, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

 
#pragma mark -

@implementation AppDelegate

@synthesize managedObjectModel=_managedObjectModel, managedObjectContext=_managedObjectContext, persistentStoreCoordinator=_persistentStoreCoordinator;


#pragma mark - Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application
{
    [NSThread sleepForTimeInterval:2.0f];

    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
    UITabBar *tabBar = tabBarController.tabBar;
    UITabBarItem *tabBarItem1 = [tabBar.items objectAtIndex:0];
    UITabBarItem *tabBarItem2 = [tabBar.items objectAtIndex:1];
    
    tabBarItem1.selectedImage = [[UIImage imageNamed:@"listSelected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    tabBarItem1.image = [[UIImage imageNamed:@"list"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    tabBarItem1.title = @"UUID List";
    
    tabBarItem2.selectedImage = [[UIImage imageNamed:@"searchSelected"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    tabBarItem2.image = [[UIImage imageNamed:@"search"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
    tabBarItem2.title = @"Beacon Search";

    UINavigationController *navController = tabBarController.viewControllers[0];
    UUIDViewController *uuidViewController = (UUIDViewController *)[[navController viewControllers] objectAtIndex:0];
    uuidViewController.managedObjectContext = self.managedObjectContext;
    
    UINavigationController *scanNavController = tabBarController.viewControllers[1];
    ScanViewController *scanViewController = (ScanViewController *)[[scanNavController viewControllers] objectAtIndex:0];
    scanViewController.managedObjectContext = self.managedObjectContext;

    NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
    fetch.entity = [NSEntityDescription entityForName:@"Beacon"
                               inManagedObjectContext:self.managedObjectContext];
    
    fetch.predicate = [NSPredicate predicateWithFormat:@"name LIKE[c] '( Default ) Apple Airlocate'"];
    
    NSError *error = nil;
    NSArray *objects = [self.managedObjectContext executeFetchRequest:fetch error:&error];
    if (error) {
        NSLog(@"Failed to fetch objects: %@", [error description]);
    }
    
    // NSLog(@"count = %lu",(unsigned long)objects.count);

    if(objects.count < 3){
        NSArray *supportedProximityUUIDs;
        
        supportedProximityUUIDs = @[@"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0",
                                    @"5A4BCFCE-174E-4BAC-A814-092E77F6B7E5",
                                    @"74278BDA-B644-4520-8F0C-720EAF059935"];
        
        for (NSString *uuid in supportedProximityUUIDs)
        {
            Beacon *entity = [NSEntityDescription insertNewObjectForEntityForName:@"Beacon" inManagedObjectContext:self.managedObjectContext];
            entity.name = @"( Default ) Apple Airlocate";
            entity.uuid = uuid;
            
            NSError *error = nil;
            if ([self.managedObjectContext save:&error] == NO) {
                NSLog(@"Failed to add entity: %@", [error description]);
            }
        }
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [self saveContext];
} 

- (void)applicationWillResignActive:(UIApplication *)application
{
    [self saveContext];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [self saveContext];
}

- (void)saveContext
{
    NSError *error;
    if (_managedObjectContext != nil) {
        if ([_managedObjectContext hasChanges] && ![_managedObjectContext save:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            //abort();
        }
    }
}


#pragma mark - Core Data stack

/*
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *) managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"CoreDataBeacons" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

/*
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"CoreDataBeacons.sqlite"];
    
    /*
     Set up the store.
     For the sake of illustration, provide a pre-populated default store.
     */
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // If the expected store doesn't exist, copy the default store.
    if (![fileManager fileExistsAtPath:[storeURL path]]) {
        NSURL *defaultStoreURL = [[NSBundle mainBundle] URLForResource:@"CoreDataBeacons" withExtension:@"sqlite"];
        if (defaultStoreURL) {
            [fileManager copyItemAtURL:defaultStoreURL toURL:storeURL error:NULL];
        }
    }
    
    NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption: @YES, NSInferMappingModelAutomaticallyOption: @YES};
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
    
    NSError *error;
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        //abort();
    }
    
    return _persistentStoreCoordinator;
}


#pragma mark - Application's documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


@end
