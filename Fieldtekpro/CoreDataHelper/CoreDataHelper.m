//
//  CoreDataHelper.m
//  Grocery Dude
//
//  Created by Tim Roadley on 18/09/13.
//  Copyright (c) 2013 Tim Roadley. All rights reserved.
//

#import "CoreDataHelper.h"

@implementation CoreDataHelper
#define debug 1

#pragma mark - FILES
NSString *storeFilename = @"PM.sqlite";

#pragma mark - PATHS
- (NSString *)applicationDocumentsDirectory {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class,NSStringFromSelector(_cmd));
    }
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) lastObject];
}
- (NSURL *)applicationStoresDirectory {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    
    NSURL *storesDirectory =
    [[NSURL fileURLWithPath:[self applicationDocumentsDirectory]]
     URLByAppendingPathComponent:@"CoreDB"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:[storesDirectory path]]) {
        NSError *error = nil;
        if ([fileManager createDirectoryAtURL:storesDirectory
                  withIntermediateDirectories:YES
                                   attributes:nil
                                        error:&error]) {
            if (debug==1) {
                NSLog(@"Successfully created Stores directory");}
        }
        else {NSLog(@"FAILED to create Stores directory: %@", error);}
    }
    return storesDirectory;
}
- (NSURL *)storeURL {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    return [[self applicationStoresDirectory]
            URLByAppendingPathComponent:storeFilename];
}

#pragma mark - SETUP
- (id)init {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    self = [super init];
    if (!self) {return nil;}
    
    _model = [NSManagedObjectModel mergedModelFromBundles:nil];
    _coordinator = [[NSPersistentStoreCoordinator alloc]
                    initWithManagedObjectModel:_model];
    _context = [[NSManagedObjectContext alloc]
                initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_context setPersistentStoreCoordinator:_coordinator];
    return self;
}

- (void)loadStore {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    if (_store) {return;} // Don’t load store if it's already loaded
    
    NSDictionary *options =
    @{
      NSMigratePersistentStoresAutomaticallyOption:@YES ,NSInferMappingModelAutomaticallyOption:@YES ,NSSQLitePragmasOption: @{@"journal_mode": @"DELETE"}
      };
    
    NSError *error = nil;
    _store = [_coordinator addPersistentStoreWithType:NSSQLiteStoreType
                                        configuration:nil
                                                  URL:[self storeURL]
                                              options:options error:&error];
    if (!_store) {NSLog(@"Failed to add store. Error: %@", error);abort();}
    else         {if (debug==1) {NSLog(@"Successfully added store: %@", _store);}}
}

- (void)setupCoreData {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    [self loadStore];
}

#pragma mark - SAVING
- (void)saveContext {
    if (debug==1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
    if ([_context hasChanges]) {
        NSError *error = nil;
        if ([_context save:&error]) {
            NSLog(@"_context SAVED changes to persistent store");
        } else {
            NSLog(@"Failed to save _context: %@", error);
        }
    } else {
        NSLog(@"SKIPPED _context save, there are no changes!");
    }
}

/**
 * Will remove the persistent store
 */
-(void)removeContextForFuncLocEquipment{
    
    NSFetchRequest * allEntites = [[NSFetchRequest alloc] init];
    [allEntites setEntity:[NSEntityDescription entityForName:@"FunctionalLocation" inManagedObjectContext:_context]];
    [allEntites setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    NSError * error = nil;
    NSArray * entity = [_context executeFetchRequest:allEntites error:&error];
    //error handling goes here
    for (NSManagedObject * car in entity) {
        [_context deleteObject:car];
    }
    NSError *saveError = nil;
    [_context save:&saveError];
    //more error handling here
    
    ////////////
    [allEntites setEntity:[NSEntityDescription entityForName:@"Equipment" inManagedObjectContext:_context]];
    [allEntites setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    error = nil;
    entity = nil;
    entity = [_context executeFetchRequest:allEntites error:&error];
    //error handling goes here
    for (NSManagedObject * car in entity) {
        [_context deleteObject:car];
    }
    saveError = nil;
    [_context save:&saveError];
    //more error handling here
}

-(void)removeContextForEquipMptt{
    
    NSFetchRequest * allEntites = [[NSFetchRequest alloc] init];
    [allEntites setEntity:[NSEntityDescription entityForName:@"EquipMptt" inManagedObjectContext:_context]];
    [allEntites setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    NSError * error = nil;
    NSArray * entity = [_context executeFetchRequest:allEntites error:&error];
    //error handling goes here
    for (NSManagedObject * car in entity) {
        [_context deleteObject:car];
    }
    NSError *saveError = nil;
    [_context save:&saveError];
    //more error handling here
}


-(void)removeContextForFlocMptt{
    
    NSFetchRequest * allEntites = [[NSFetchRequest alloc] init];
    [allEntites setEntity:[NSEntityDescription entityForName:@"FlocMptt" inManagedObjectContext:_context]];
    [allEntites setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    NSError * error = nil;
    NSArray * entity = [_context executeFetchRequest:allEntites error:&error];
    //error handling goes here
    for (NSManagedObject * car in entity) {
        [_context deleteObject:car];
    }
    NSError *saveError = nil;
    [_context save:&saveError];
    //more error handling here
}

-(void)removeContextForMaterial:(NSString *)equipmentNumber{
    
    NSFetchRequest * allEntites = [[NSFetchRequest alloc] init];
    
    [allEntites setEntity:[NSEntityDescription entityForName:@"Material" inManagedObjectContext:_context]];
    [allEntites setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    //////////////
    if (equipmentNumber.length) {
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"equipmentid == %@", equipmentNumber];
        [allEntites setPredicate:predicate];
    }
    
    NSError *error = nil;
    NSArray * entity = [_context executeFetchRequest:allEntites error:&error];
    //error handling goes here
    for (NSManagedObject * car in entity) {
        [_context deleteObject:car];
    }
    NSError *saveError = nil;
    [_context save:&saveError];
    //more error handling here
}

-(void)removeContextForFuncLoc:(NSString *)functionalLocationID{
    
    NSFetchRequest * allEntites = [[NSFetchRequest alloc] init];
    
    [allEntites setEntity:[NSEntityDescription entityForName:@"FunctionalLocation" inManagedObjectContext:_context]];
    [allEntites setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    if (functionalLocationID.length) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"locationid == %@",functionalLocationID];
        [allEntites setPredicate:predicate];
    }
    
    NSError * error = nil;
    NSArray * entity = [_context executeFetchRequest:allEntites error:&error];
    //error handling goes here
    for (NSManagedObject * car in entity) {
        [_context deleteObject:car];
    }
    
    NSError *saveError = nil;
    
    [_context save:&saveError];
    //more error handling here
}


-(void)removeContextForEquipmentBOM:(NSString *)bomString{
    
    NSFetchRequest * allEntites = [[NSFetchRequest alloc] init];
    [allEntites setEntity:[NSEntityDescription entityForName:@"EquipmentBOMHeader" inManagedObjectContext:_context]];
    [allEntites setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    if (bomString.length) {
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"bomheader == %@", bomString];
        [allEntites setPredicate:predicate];
    }
    
    NSError * error = nil;
    NSArray * entity = [_context executeFetchRequest:allEntites error:&error];
    
    //error handling goes here
    for (NSManagedObject * bomHeader in entity) {
        [_context deleteObject:bomHeader];
    }
    NSError *saveError = nil;
    [_context save:&saveError];
    //more error handling here
    
    [allEntites setEntity:[NSEntityDescription entityForName:@"EquipmentBOMTransaction" inManagedObjectContext:_context]];
    
    if (bomString.length) {
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"bomtransaction == %@", bomString];
        [allEntites setPredicate:predicate];
    }
    
    entity = [_context executeFetchRequest:allEntites error:&error];
    
    for (NSManagedObject * bomTransaction in entity) {
        [_context deleteObject:bomTransaction];
    }
    
    [_context save:&saveError];
    //more error handling here
}

-(void)removeContextForStockOverView:(NSString *)materialid{
    
    NSFetchRequest * allEntites = [[NSFetchRequest alloc] init];
    [allEntites setEntity:[NSEntityDescription entityForName:@"StockOverView" inManagedObjectContext:_context]];
    [allEntites setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    if (materialid.length) {
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"matnr == %@", materialid];
        [allEntites setPredicate:predicate];
    }
    
    NSError * error = nil;
    NSArray * entity = [_context executeFetchRequest:allEntites error:&error];
    
    //error handling goes here
    for (NSManagedObject * bomHeader in entity) {
        [_context deleteObject:bomHeader];
    }
    NSError *saveError = nil;
    [_context save:&saveError];
    //more error handling here
}

-(void)removeContextForEquipment:(NSString *)functionalLocationID{
    
    NSFetchRequest * allEntites = [[NSFetchRequest alloc] init];
    
    [allEntites setEntity:[NSEntityDescription entityForName:@"Equipment" inManagedObjectContext:_context]];
    [allEntites setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    if (functionalLocationID.length) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"tplnr == %@",functionalLocationID];
        [allEntites setPredicate:predicate];
    }
    
    NSError * error = nil;
    NSArray * entity = [_context executeFetchRequest:allEntites error:&error];
    //error handling goes here
    for (NSManagedObject * car in entity) {
        [_context deleteObject:car];
    }
    
    NSError *saveError = nil;
    
    [_context save:&saveError];
    //more error handling here
}


/*
 - (NSPersistentStoreCoordinator *)resetPersistentStore {
 NSError *error;
 
 [_context lock];
 
 // FIXME: dirty. If there are many stores...
 NSPersistentStore *store = [[_coordinator persistentStores] objectAtIndex:0];
 
 if (![_coordinator removePersistentStore:store error:&error]) {
 NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
 abort();
 }
 
 // Delete file
 if (![[NSFileManager defaultManager] removeItemAtPath:store.URL.path error:&error]) {
 NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
 abort();
 }
 
 // Delete the reference to non-existing store
 //    [_coordinator release];
 _coordinator = nil;
 
 NSPersistentStoreCoordinator *r = [self coordinator];
 [_context unlock];
 
 return r;
 }*/

@end
