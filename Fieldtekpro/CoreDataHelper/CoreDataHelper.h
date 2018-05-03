//
//  CoreDataHelper.h
//  Grocery Dude
//
//  Created by Tim Roadley on 18/09/13.
//  Copyright (c) 2013 Tim Roadley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataHelper :NSObject

@property (nonatomic, readonly) NSManagedObjectContext       *context;
@property (nonatomic, readonly) NSManagedObjectModel         *model;
@property (nonatomic, readonly) NSPersistentStoreCoordinator *coordinator;
@property (nonatomic, readonly) NSPersistentStore            *store;

- (void)setupCoreData;
- (void)saveContext;
-(void)removeContextForMaterial:(NSString *)bomNumber;
-(void)removeContextForFuncLocEquipment;
-(void)removeContextForFlocMptt;
-(void)removeContextForEquipMptt;
-(void)removeContextForEquipmentBOM:(NSString *)bomString;
-(void)removeContextForStockOverView:(NSString *)materialid;

-(void)removeContextForFuncLoc:(NSString *)functionalLocationID;
-(void)removeContextForEquipment:(NSString *)functionalLocationID;

@end
