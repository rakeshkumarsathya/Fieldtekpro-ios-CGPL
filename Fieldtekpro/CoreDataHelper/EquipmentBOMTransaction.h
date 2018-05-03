//
//  EquipmentBOMTransaction.h
//  Fieldtekpro
//
//  Created by Enstrapp Bangalore on 13/04/17.
//  Copyright © 2017 Enstrapp IT Solutions. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface EquipmentBOMTransaction : NSManagedObject

@property (nonatomic, retain) NSString *bomtransaction;
@property (nonatomic, retain) NSString *bomcomponent;
@property (nonatomic, retain) NSString *comptext;
@property (nonatomic, retain) NSString *quantity;
@property (nonatomic, retain) NSString *unit;
@property (nonatomic, retain) NSString *stlkz;

@end
