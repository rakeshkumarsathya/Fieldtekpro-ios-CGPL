//
//  FunctionalLocation.h
//  PMCockpit
//
//  Created by Shyam Chandar on 08/03/15.
//  Copyright (c) 2015 Enstrapp IT Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Equipment;

@interface FunctionalLocation : NSManagedObject

@property (nonatomic, retain) NSString * locationid;
@property (nonatomic, retain) NSString * locationName;
@property (nonatomic, retain) NSString * plantName;
@property (nonatomic, retain) NSString * workStation;
@property (nonatomic, retain) NSSet *equipments;
@property (nonatomic, retain) NSString *costCenter;//Kostl
@property (nonatomic, retain) NSString *fltyp;
@property (nonatomic, retain) NSString *plannerGroup;//Ingrp
@property (nonatomic, retain) NSString *tplma;//Tplma
@property (nonatomic, retain) NSString *level;//level
@property (nonatomic, retain) NSString *stplnr,*iwerks;//level


@end

@interface FunctionalLocation (CoreDataGeneratedAccessors)

- (void)addEquipmentsObject:(Equipment *)value;
- (void)removeEquipmentsObject:(Equipment *)value;
- (void)addEquipments:(NSSet *)values;
- (void)removeEquipments:(NSSet *)values;

@end
