//
//  EquipMptt.h
//  Fieldtekpro
//
//  Created by Enstrapp Bangalore on 25/08/16.
//  Copyright © 2016 Enstrapp IT Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface EquipMptt : NSManagedObject

@property (nonatomic, retain) NSString * atbez;
@property (nonatomic, retain) NSString * atinn;
@property (nonatomic, retain) NSString * desir;
@property (nonatomic, retain) NSString * equnr;

@property (nonatomic, retain) NSString * mpobj;
@property (nonatomic, retain) NSString * mptyp;
@property (nonatomic, retain) NSString * mrngu;
@property (nonatomic, retain) NSString * msehl;

@property (nonatomic, retain) NSString * point;
@property (nonatomic, retain) NSString * psort;
@property (nonatomic, retain) NSString * pttxt;
@property (nonatomic, retain) NSString * tplnr;


@property (nonatomic, retain) NSString * strno;
@property (nonatomic, retain) NSString * mpobt;
@property (nonatomic, retain) NSString * mrmin;
@property (nonatomic, retain) NSString * mrmax;
@property (nonatomic, retain) NSString * cdsuf;
@property (nonatomic, retain) NSString * codct;
@property (nonatomic, retain) NSString * codgr;


@property (nonatomic, retain) NSString * readc;
@property (nonatomic, retain) NSString * task;
@property (nonatomic, retain) NSString * normal;
@property (nonatomic, retain) NSString * alarm;
@property (nonatomic, retain) NSString * critical;
@property (nonatomic, retain) NSString * notes;



@end
