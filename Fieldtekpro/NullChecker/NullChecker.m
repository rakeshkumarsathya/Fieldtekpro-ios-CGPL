//
//  NullChecker.m
//  BMW_NEW
//
//  Created by Enstrapp on 02/10/14.
//  Copyright (c) 2014 Enstrapp IT Solutions. All rights reserved.

#import "NullChecker.h"

@implementation NullChecker


+(BOOL)isNull :(NSObject *)classObject{
  if (![classObject isEqual:[NSNull null]] && classObject !=nil && ![classObject isEqual:@"<nil>"] && ![classObject isEqual:@"nil"] && ![classObject isEqual:@"<null>"] && ![classObject isEqual:@"<NULL>"]&& ![classObject isEqual:@"null"] && ![classObject isEqual:@"(null)"])
  {
      if ([classObject isKindOfClass:[NSDictionary class]]) {
          NSDictionary *dict = [classObject copy];
          
          if (!([[dict allKeys]count]>0)) {
              return YES;
          }
          else{
              return NO;
              
          }
      }
      if ([classObject isKindOfClass:[NSArray class]]) {
          NSArray *array = [classObject copy];
          if (!([array count]>0)) {
              return YES;
          }
          else{
              return NO;
              
          }
      }
    
      if ([classObject isKindOfClass:[NSString class]]) {
          NSString *string = [classObject copy];
          if (!([string length]>0)) {
              return YES;
          }
          else{
              return NO;
              
          }
      }
      
      
      return NO;
  }
    else
        return YES;
}

    
    


@end
