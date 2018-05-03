//
//  EquipmentBOMHeader.h
//  
//
//  Created by Enstrapp Bangalore on 13/04/17.
//
//

#import <CoreData/CoreData.h>

@interface EquipmentBOMHeader : NSManagedObject

@property (nonatomic, retain) NSString *bomheader;
@property (nonatomic, retain) NSString *plant;
@property (nonatomic, retain) NSString *bomdesc;

@end
