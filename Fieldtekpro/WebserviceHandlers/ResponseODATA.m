//
//  ResponseODATA.m
//  PMCockpit
//
//  Created by Shyam Chandar on 29/03/15.
//  Copyright (c) 2015 Enstrapp IT Solutions. All rights reserved.
//

#import "ResponseODATA.h"

@implementation ResponseODATA
#pragma - Response for different Functions

- (NSMutableDictionary *)parseForLogin:(NSDictionary *)resultDictionary
{
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    NSDictionary *parseDictionary;
    if ([resultDictionary objectForKey:@"d"]) {
        parseDictionary = [resultDictionary objectForKey:@"d"];
        
        BOOL isFailed=[[parseDictionary objectForKey:@"Userid"] boolValue];
        
        if (!isFailed)
        {
            [xmlDoc setObject:@"" forKey:@"FAILED"];
        }
        else
        {
            [xmlDoc setObject:@"X" forKey:@"FAILED"];
        }
        
        return xmlDoc;
    }
    else
    {
        [xmlDoc setObject:@"X" forKey:@"FAILED"];
        return xmlDoc;
    }
    return [NSMutableDictionary dictionary];
}

- (NSMutableDictionary *)parseForSyncMapData:(NSDictionary *)resultDictionary
{
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    NSDictionary *parseDictionary;
    
    if ([resultDictionary objectForKey:@"d"]) {
        parseDictionary = [resultDictionary objectForKey:@"d"];
        
        if ([parseDictionary objectForKey:@"results"])
        {
            id dataObject = [parseDictionary objectForKey:@"results"];
            if ([dataObject isKindOfClass:[NSDictionary class]])
            {
                [xmlDoc setObject:[NSMutableArray arrayWithObject:dataObject] forKey:@"result"];
                
            }
            else if([dataObject isKindOfClass:[NSArray class]])
            {
                id result = [parseDictionary objectForKey:@"results"];

                [[DataBase sharedInstance] deleteSyncMapData];
 
                id tempResult = [result copy];
 
                [[DataBase sharedInstance] insertSyncMapData:tempResult :@"ODATA"];
 
            }
            return xmlDoc;
        }
    }
    
     return [NSMutableDictionary dictionary];

}
 

- (NSMutableDictionary *)parseForLoadSettings:(NSDictionary *)resultDictionary
{
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    
     NSDictionary *parseDictionary;
    
    if ([resultDictionary objectForKey:@"d"]) {
          parseDictionary = [resultDictionary objectForKey:@"d"];
            if ([parseDictionary objectForKey:@"results"])
            {
                id objectData=[parseDictionary objectForKey:@"results"];
                
                if ([objectData isKindOfClass:[NSDictionary class]]){
                     parseDictionary = [objectData objectForKey:@"results"];
                }
                 else if ([objectData isKindOfClass:[NSArray class]]){
                     parseDictionary = [[objectData objectAtIndex:0] copy];
                 }
                
               if ([parseDictionary objectForKey:@"EsIload"]){
                   if ([[[parseDictionary objectForKey:@"EsIload"] objectForKey:@"results"] isKindOfClass:[NSDictionary class]]){
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:[[parseDictionary objectForKey:@"EsIload"] objectForKey:@"results"]]  forKey:@"resultILoad"];
                  }
                 else if([[[parseDictionary objectForKey:@"EsIload"] objectForKey:@"results"] isKindOfClass:[NSArray class]]){
                     
                      [xmlDoc setObject:[[parseDictionary objectForKey:@"EsIload"] objectForKey:@"results"] forKey:@"resultILoad"];
                    }
               }
 
              if ([parseDictionary objectForKey:@"EsRefresh"]) {
                 if ([[[parseDictionary objectForKey:@"EsRefresh"] objectForKey:@"results"] isKindOfClass:[NSDictionary class]]){
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:[[parseDictionary objectForKey:@"EsRefresh"] objectForKey:@"results"]] forKey:@"resultRefresh"];
                }
                else if([[[parseDictionary objectForKey:@"EsRefresh"] objectForKey:@"results"] isKindOfClass:[NSArray class]]){
                    [xmlDoc setObject:[[parseDictionary objectForKey:@"EsRefresh"] objectForKey:@"results"] forKey:@"resultRefresh"];
                 }
            }
             return xmlDoc;
        }
    }
    return [NSMutableDictionary dictionary];
}

- (NSMutableDictionary *)parseForSearchFunclocEquipments:(NSDictionary *)resultDictionary
{
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    NSDictionary *parseDictionary,*parseDictionary_Equip;
 
    if ([resultDictionary objectForKey:@"d"])
    {
        parseDictionary = [resultDictionary objectForKey:@"d"];
        
           if ([parseDictionary objectForKey:@"results"])
           {
             id dataObject = [parseDictionary objectForKey:@"results"];
               
               if ([dataObject isKindOfClass:[NSDictionary class]]){
                    parseDictionary=[dataObject copy];
               }
               else if ([dataObject isKindOfClass:[NSArray class]]){
                   parseDictionary=[[dataObject objectAtIndex:0] copy];
                }
 
             if ([parseDictionary objectForKey:@"EtEqui"])
             {
                   parseDictionary_Equip = [[parseDictionary objectForKey:@"EtEqui"]objectForKey:@"results"];
 
                    if ([parseDictionary_Equip isKindOfClass:[NSDictionary class]])
                    {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionary_Equip] forKey:@"resultEquip"];
                    }
                    else if([parseDictionary_Equip isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionary_Equip forKey:@"resultEquip"];
                    }
             }
 
             if ([parseDictionary objectForKey:@"EtFuncEquip"])
             {
                 parseDictionary = [[parseDictionary objectForKey:@"EtFuncEquip"]objectForKey:@"results"];
                 
                    if ([parseDictionary isKindOfClass:[NSDictionary class]])
                    {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionary] forKey:@"resultFloc"];
                    }
                    else if([parseDictionary isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionary forKey:@"resultFloc"];
                    }
            }
         }
        
        return xmlDoc;
       }
    
     return [NSMutableDictionary dictionary];
 }

- (NSMutableDictionary *)parseForJSAValueHelps:(NSDictionary *)resultDictionary
{
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    NSDictionary *dataObjectDictionary;
 
    if ([resultDictionary objectForKey:@"d"]) {
        dataObjectDictionary = [resultDictionary objectForKey:@"d"];
        if ([dataObjectDictionary objectForKey:@"results"])
        {
            
            id dataDictionary=[dataObjectDictionary objectForKey:@"results"];
            
            id parseDictionary ;
            
            if ([dataDictionary isKindOfClass:[NSDictionary class]]) {
                parseDictionary = [dataDictionary copy];
            }
            else if ([dataDictionary isKindOfClass:[NSArray class]]){
                 if ([dataDictionary count]) {
                    parseDictionary = [[dataDictionary objectAtIndex:0] copy];
                 }
            }
            
            if ([parseDictionary objectForKey:@"EtEHSOpstat"]) {
                if ([[parseDictionary objectForKey:@"EtEHSOpstat"] isKindOfClass:[NSDictionary class]])
                {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:[parseDictionary objectForKey:@"EtEHSOpstat"]] forKey:@"resultEHSOpstat"];
                }
                else if ([[parseDictionary objectForKey:@"EtEHSOpstat"] isKindOfClass:[NSArray class]]){
                    
                    [xmlDoc setObject:[parseDictionary objectForKey:@"EtEHSOpstat"] forKey:@"resultEHSOpstat"];
                }
            }
            
            if ([parseDictionary objectForKey:@"EtEHSHazcat"]) {
                if ([[parseDictionary objectForKey:@"EtEHSHazcat"] isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:[parseDictionary objectForKey:@"EtEHSHazcat"]] forKey:@"resultEHSHazcat"];
                }
                else if ([[parseDictionary objectForKey:@"EtEHSHazcat"] isKindOfClass:[NSArray class]]){
                    
                    [xmlDoc setObject:[parseDictionary objectForKey:@"EtEHSHazcat"] forKey:@"resultEHSHazcat"];
                }
            }
            
            
            if ([parseDictionary objectForKey:@"EtEHSHazard"]) {
                if ([[parseDictionary objectForKey:@"EtEHSHazard"] isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:[parseDictionary objectForKey:@"EtEHSHazard"]] forKey:@"resultEHSHazard"];
                }
                else if ([[parseDictionary objectForKey:@"EtEHSHazard"] isKindOfClass:[NSArray class]]){
                    
                    [xmlDoc setObject:[parseDictionary objectForKey:@"EtEHSHazard"] forKey:@"resultEHSHazard"];
                }
            }
            
            
            if ([parseDictionary objectForKey:@"EtEHSHazimp"]) {
                if ([[parseDictionary objectForKey:@"EtEHSHazimp"] isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:[parseDictionary objectForKey:@"EtEHSHazimp"]] forKey:@"resultEHSHazimp"];
                }
                else if ([[parseDictionary objectForKey:@"EtEHSHazimp"] isKindOfClass:[NSArray class]]){
                    
                    [xmlDoc setObject:[parseDictionary objectForKey:@"EtEHSHazimp"] forKey:@"resultEHSHazimp"];
                }
            }
            
            if ([parseDictionary objectForKey:@"EtEHSHazctrl"]) {
                if ([[parseDictionary objectForKey:@"EtEHSHazctrl"] isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:[parseDictionary objectForKey:@"EtEHSHazctrl"]] forKey:@"resultEHSHazctrl"];
                }
                else if ([[parseDictionary objectForKey:@"EtEHSHazctrl"] isKindOfClass:[NSArray class]]){
                    
                    [xmlDoc setObject:[parseDictionary objectForKey:@"EtEHSHazctrl"] forKey:@"resultEHSHazctrl"];
                }
            }
            
            if ([parseDictionary objectForKey:@"EtEHSLocTyp"]) {
                if ([[parseDictionary objectForKey:@"EtEHSLocTyp"] isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:[parseDictionary objectForKey:@"EtEHSLocTyp"]] forKey:@"resultEHSLocTyp"];
                }
                else if ([[parseDictionary objectForKey:@"EtEHSLocTyp"] isKindOfClass:[NSArray class]]){
                    
                    [xmlDoc setObject:[parseDictionary objectForKey:@"EtEHSLocTyp"] forKey:@"resultEHSLocTyp"];
                }
            }
            
            if ([parseDictionary objectForKey:@"EtEHSLocRev"]) {
                if ([[parseDictionary objectForKey:@"EtEHSLocRev"] isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:[parseDictionary objectForKey:@"EtEHSLocRev"]] forKey:@"resultEHSLocRev"];
                }
                else if ([[parseDictionary objectForKey:@"EtEHSLocRev"] isKindOfClass:[NSArray class]]){
                    
                    [xmlDoc setObject:[parseDictionary objectForKey:@"EtEHSLocRev"] forKey:@"resultEHSLocRev"];
                }
            }
            
 
            if ([parseDictionary objectForKey:@"EtEHSJobTyp"]) {
                if ([[parseDictionary objectForKey:@"EtEHSJobTyp"] isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:[parseDictionary objectForKey:@"EtEHSJobTyp"]] forKey:@"resultEHSJobTyp"];
                }
                else if ([[parseDictionary objectForKey:@"EtEHSJobTyp"] isKindOfClass:[NSArray class]]){
                    
                    [xmlDoc setObject:[parseDictionary objectForKey:@"EtEHSJobTyp"] forKey:@"resultEHSJobTyp"];
                }
            }
 
            if ([parseDictionary objectForKey:@"EtEHSReason"]) {
                if ([[parseDictionary objectForKey:@"EtEHSReason"] isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:[parseDictionary objectForKey:@"EtEHSReason"]] forKey:@"resultEHSReason"];
                }
                else if ([[parseDictionary objectForKey:@"EtEHSReason"] isKindOfClass:[NSArray class]]){
                    
                    [xmlDoc setObject:[parseDictionary objectForKey:@"EtEHSReason"] forKey:@"resultEHSReason"];
                }
            }
            
            
            if ([parseDictionary objectForKey:@"EtEHSRasrole"]) {
                if ([[parseDictionary objectForKey:@"EtEHSRasrole"] isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:[parseDictionary objectForKey:@"EtEHSRasrole"]] forKey:@"resultEHSRasrole"];
                }
                else if ([[parseDictionary objectForKey:@"EtEHSRasrole"] isKindOfClass:[NSArray class]]){
                    
                    [xmlDoc setObject:[parseDictionary objectForKey:@"EtEHSRasrole"] forKey:@"resultEHSRasrole"];
                }
            }
            
            if ([parseDictionary objectForKey:@"EtEHSRasstep"]) {
                if ([[parseDictionary objectForKey:@"EtEHSRasstep"] isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:[parseDictionary objectForKey:@"EtEHSRasstep"]] forKey:@"resultEHSRasstep"];
                }
                else if ([[parseDictionary objectForKey:@"EtEHSRasstep"] isKindOfClass:[NSArray class]]){
                    
                    [xmlDoc setObject:[parseDictionary objectForKey:@"EtEHSRasstep"] forKey:@"resultEHSRasstep"];
                }
            }
            
             return xmlDoc;
          }
    }
     return [NSMutableDictionary dictionary];
}

- (NSMutableDictionary *)parseForWCMValueHelps:(NSDictionary *)resultDictionary
{
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    NSDictionary *dataObjectDictionary;
 
    
      if ([resultDictionary objectForKey:@"d"]) {
       
          dataObjectDictionary = [resultDictionary objectForKey:@"d"];
          
        if ([dataObjectDictionary objectForKey:@"results"])
        {
            
            id dataDictionary=[dataObjectDictionary objectForKey:@"results"];
            
            id parseDictionary ;
            
            if ([dataDictionary isKindOfClass:[NSDictionary class]]) {
                parseDictionary = [dataDictionary copy];
            }
            else if ([dataDictionary isKindOfClass:[NSArray class]]){
                if ([dataDictionary count]) {
                     parseDictionary = [[dataDictionary objectAtIndex:0] copy];
                 }
            }
            
         /*   if ([parseDictionary objectForKey:@"EsWsmObjavail"]) {
                if ([[parseDictionary objectForKey:@"EsWsmObjavail"] isKindOfClass:[NSDictionary class]])
                {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:[parseDictionary objectForKey:@"EsWsmObjavail"]] forKey:@"resultWSMObjAvail"];
                }
                else if ([[parseDictionary objectForKey:@"EsWsmObjavail"] isKindOfClass:[NSArray class]]){
                    
                    [xmlDoc setObject:[parseDictionary objectForKey:@"EsWsmObjavail"] forKey:@"resultWSMObjAvail"];
                }
            }
            
            if ([parseDictionary objectForKey:@"EtWsmDocument"]) {
                if ([[parseDictionary objectForKey:@"EtWsmDocument"] isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:[parseDictionary objectForKey:@"EtWsmDocument"]] forKey:@"resultWSMDocument"];
                }
                else if ([[parseDictionary objectForKey:@"EtWsmDocument"] isKindOfClass:[NSArray class]]){
                    
                    [xmlDoc setObject:[parseDictionary objectForKey:@"EtWsmDocument"] forKey:@"resultWSMDocument"];
                }
            }
            
            
            if ([parseDictionary objectForKey:@"EtWsmEqui"]) {
                if ([[parseDictionary objectForKey:@"EtWsmEqui"] isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:[parseDictionary objectForKey:@"EtWsmEqui"]] forKey:@"resultWSMEqui"];
                }
                else if ([[parseDictionary objectForKey:@"EtWsmEqui"] isKindOfClass:[NSArray class]]){
                    
                    [xmlDoc setObject:[parseDictionary objectForKey:@"EtWsmEqui"] forKey:@"resultWSMEqui"];
                }
            }
            
            
            if ([parseDictionary objectForKey:@"EtWsmMaterial"]) {
                if ([[parseDictionary objectForKey:@"EtWsmMaterial"] isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:[parseDictionary objectForKey:@"EtWsmMaterial"]] forKey:@"resultWSMMaterial"];
                }
                else if ([[parseDictionary objectForKey:@"EtWsmMaterial"] isKindOfClass:[NSArray class]]){
                    
                    [xmlDoc setObject:[parseDictionary objectForKey:@"EtWsmMaterial"] forKey:@"resultWSMMaterial"];
                }
            }
            
            if ([parseDictionary objectForKey:@"EtWsmPermit"]) {
                if ([[parseDictionary objectForKey:@"EtWsmPermit"] isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:[parseDictionary objectForKey:@"EtWsmPermit"]] forKey:@"resultWSMPermit"];
                }
                else if ([[parseDictionary objectForKey:@"EtWsmPermit"] isKindOfClass:[NSArray class]]){
                    
                    [xmlDoc setObject:[parseDictionary objectForKey:@"EtWsmPermit"] forKey:@"resultWSMPermit"];
                }
            }
            
            if ([parseDictionary objectForKey:@"EtWsmPlants"]) {
                if ([[parseDictionary objectForKey:@"EtWsmPlants"] isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:[parseDictionary objectForKey:@"EtWsmPlants"]] forKey:@"resultWSMPlants"];
                }
                else if ([[parseDictionary objectForKey:@"EtWsmPlants"] isKindOfClass:[NSArray class]]){
                    
                    [xmlDoc setObject:[parseDictionary objectForKey:@"EtWsmPlants"] forKey:@"resultWSMPlants"];
                }
            }
            
            
            if ([parseDictionary objectForKey:@"EtWsmResponses"]) {
                if ([[parseDictionary objectForKey:@"EtWsmResponses"] isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:[parseDictionary objectForKey:@"EtWsmResponses"]] forKey:@"resultWSMResponses"];
                }
                else if ([[parseDictionary objectForKey:@"EtWsmResponses"] isKindOfClass:[NSArray class]]){
                    
                    [xmlDoc setObject:[parseDictionary objectForKey:@"EtWsmResponses"] forKey:@"resultWSMResponses"];
                }
            }
            
            
            if ([parseDictionary objectForKey:@"EtWsmRisks"]) {
                if ([[parseDictionary objectForKey:@"EtWsmRisks"] isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:[parseDictionary objectForKey:@"EtWsmRisks"]] forKey:@"resultWSMRisks"];
                }
                else if ([[parseDictionary objectForKey:@"EtWsmRisks"] isKindOfClass:[NSArray class]]){
                    
                    [xmlDoc setObject:[parseDictionary objectForKey:@"EtWsmRisks"] forKey:@"resultWSMRisks"];
                }
            }
            
            if ([parseDictionary objectForKey:@"EtWsmSafetymeas"]) {
                if ([[parseDictionary objectForKey:@"EtWsmSafetymeas"] isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:[parseDictionary objectForKey:@"EtWsmSafetymeas"]] forKey:@"resultWSMSafetymeas"];
                }
                else if ([[parseDictionary objectForKey:@"EtWsmRisks"] isKindOfClass:[NSArray class]]){
                    
                    [xmlDoc setObject:[parseDictionary objectForKey:@"EtWsmSafetymeas"] forKey:@"resultWSMSafetymeas"];
                }
            }
            
            if ([parseDictionary objectForKey:@"EtWsmWcmr"]) {
                if ([[parseDictionary objectForKey:@"EtWsmWcmr"] isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:[parseDictionary objectForKey:@"EtWsmWcmr"]] forKey:@"resultWSMWcmr"];
                }
                else if ([[parseDictionary objectForKey:@"EtWsmWcmr"] isKindOfClass:[NSArray class]]){
                    
                    [xmlDoc setObject:[parseDictionary objectForKey:@"EtWsmWcmr"] forKey:@"resultWSMWcmr"];
                }
            }*/
            
            
            ////wcm
            
            
        /*    if ([parseDictionary objectForKey:@"EtWCMChkReq"]) {
                if ([[parseDictionary objectForKey:@"EtWCMChkReq"] objectForKey:@"results"]) {
                    if ([[[parseDictionary objectForKey:@"EtWCMChkReq"] objectForKey:@"results"] isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:[[parseDictionary objectForKey:@"EtWCMChkReq"] objectForKey:@"results"]] forKey:@"resultChkRequests"];
                    }
                    else if([[[parseDictionary objectForKey:@"EtWCMChkReq"] objectForKey:@"results"] isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:[[parseDictionary objectForKey:@"EtWCMChkReq"] objectForKey:@"results"] forKey:@"resultChkRequests"];
                    }
                }
            }*/
            
            
            if ([parseDictionary objectForKey:@"EtWCMTgtyp"]) {
                if ([[parseDictionary objectForKey:@"EtWCMTgtyp"] objectForKey:@"results"]) {
                    if ([[[parseDictionary objectForKey:@"EtWCMTgtyp"] objectForKey:@"results"] isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:[[parseDictionary objectForKey:@"EtWCMTgtyp"] objectForKey:@"results"]] forKey:@"resultWcmTgTypes"];
                    }
                    else if([[[parseDictionary objectForKey:@"EtWCMTgtyp"] objectForKey:@"results"] isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:[[parseDictionary objectForKey:@"EtWCMTgtyp"] objectForKey:@"results"] forKey:@"resultWcmTgTypes"];
                    }
                }
            }
            
            
            
            if ([parseDictionary objectForKey:@"EtWCMWcvp6"]) {
                if ([[parseDictionary objectForKey:@"EtWCMWcvp6"] objectForKey:@"results"]) {
                    if ([[[parseDictionary objectForKey:@"EtWCMWcvp6"] objectForKey:@"results"] isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:[[parseDictionary objectForKey:@"EtWCMWcvp6"] objectForKey:@"results"]] forKey:@"resultWcmWcvp6"];
                    }
                    else if([[[parseDictionary objectForKey:@"EtWCMWcvp6"] objectForKey:@"results"] isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:[[parseDictionary objectForKey:@"EtWCMWcvp6"] objectForKey:@"results"] forKey:@"resultWcmWcvp6"];
                    }
                }
            }
            
            if ([parseDictionary objectForKey:@"EtWCMTypes"]) {
                if ([[parseDictionary objectForKey:@"EtWCMTypes"] objectForKey:@"results"]) {
                    if ([[[parseDictionary objectForKey:@"EtWCMTypes"] objectForKey:@"results"] isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:[[parseDictionary objectForKey:@"EtWCMTypes"] objectForKey:@"results"]] forKey:@"resultWcmTypes"];
                    }
                    else if([[[parseDictionary objectForKey:@"EtWCMTypes"] objectForKey:@"results"] isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:[[parseDictionary objectForKey:@"EtWCMTypes"] objectForKey:@"results"] forKey:@"resultWcmTypes"];
                    }
                }
            }
            
            if ([parseDictionary objectForKey:@"EtWCMBegru"]) {
                if ([[parseDictionary objectForKey:@"EtWCMBegru"] objectForKey:@"results"]) {
                    if ([[[parseDictionary objectForKey:@"EtWCMBegru"] objectForKey:@"results"] isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:[[parseDictionary objectForKey:@"EtWCMBegru"] objectForKey:@"results"]] forKey:@"resultAuthorizationGroups"];
                    }
                    else if([[[parseDictionary objectForKey:@"EtWCMBegru"] objectForKey:@"results"] isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:[[parseDictionary objectForKey:@"EtWCMBegru"] objectForKey:@"results"] forKey:@"resultAuthorizationGroups"];
                    }
                }
            }
            
 
            if ([parseDictionary objectForKey:@"EtWCMUsages"]) {
                if ([[parseDictionary objectForKey:@"EtWCMUsages"] objectForKey:@"results"]) {
                    if ([[[parseDictionary objectForKey:@"EtWCMUsages"] objectForKey:@"results"] isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:[[parseDictionary objectForKey:@"EtWCMUsages"] objectForKey:@"results"]] forKey:@"resultUsages"];
                    }
                    else if([[[parseDictionary objectForKey:@"EtWCMUsages"] objectForKey:@"results"] isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:[[parseDictionary objectForKey:@"EtWCMUsages"] objectForKey:@"results"] forKey:@"resultUsages"];
                    }
                }
            }
            
            
            
            if ([parseDictionary objectForKey:@"EtWCMWork"]) {
                if ([[parseDictionary objectForKey:@"EtWCMWork"] objectForKey:@"results"]) {
                    if ([[[parseDictionary objectForKey:@"EtWCMWork"] objectForKey:@"results"] isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:[[parseDictionary objectForKey:@"EtWcmWork"] objectForKey:@"results"]] forKey:@"resultWcmWork"];
                    }
                    else if([[[parseDictionary objectForKey:@"EtWCMWork"] objectForKey:@"results"] isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:[[parseDictionary objectForKey:@"EtWCMWork"] objectForKey:@"results"] forKey:@"resultWcmWork"];
                    }
                }
            }
            
 
            if ([parseDictionary objectForKey:@"EtWCMReqm"]) {
                if ([[parseDictionary objectForKey:@"EtWCMReqm"] objectForKey:@"results"]) {
                    if ([[[parseDictionary objectForKey:@"EtWCMReqm"] objectForKey:@"results"] isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:[[parseDictionary objectForKey:@"EtWCMReqm"] objectForKey:@"results"]] forKey:@"resultWcmRequirements"];
                    }
                    else if([[[parseDictionary objectForKey:@"EtWCMReqm"] objectForKey:@"results"] isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:[[parseDictionary objectForKey:@"EtWCMReqm"] objectForKey:@"results"] forKey:@"resultWcmRequirements"];
                    }
                }
            }
            
 
            if ([parseDictionary objectForKey:@"EtWCMWcco"]) {
                if ([[parseDictionary objectForKey:@"EtWCMWcco"] objectForKey:@"results"]) {
                    if ([[[parseDictionary objectForKey:@"EtWCMWcco"] objectForKey:@"results"] isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:[[parseDictionary objectForKey:@"EtWCMWcco"] objectForKey:@"results"]] forKey:@"resultWcmCco"];
                    }
                    else if([[[parseDictionary objectForKey:@"EtWCMWcco"] objectForKey:@"results"] isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:[[parseDictionary objectForKey:@"EtWCMWcco"] objectForKey:@"results"] forKey:@"resultWcmCco"];
                    }
                }
            }
            
            
            
         }
           return xmlDoc;
      }
    
    return [NSMutableDictionary dictionary];
    
  }

- (NSMutableDictionary *)parseForValueHelps:(NSDictionary *)resultDictionary
{
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    NSDictionary *dataObjectDictionary;
    
    if ([resultDictionary objectForKey:@"d"]) {
        dataObjectDictionary = [resultDictionary objectForKey:@"d"];
        if ([dataObjectDictionary objectForKey:@"results"])
        {
            
            id dataDictionary=[dataObjectDictionary objectForKey:@"results"];
            
            id parseDictionary ;

             if ([dataDictionary isKindOfClass:[NSDictionary class]]) {
                   parseDictionary = [dataDictionary copy];
             }
            else if ([dataDictionary isKindOfClass:[NSArray class]]){
                
                if ([dataDictionary count]) {
                    parseDictionary = [[dataDictionary objectAtIndex:0] copy];
                 }
              }
 
             if ([parseDictionary objectForKey:@"EsIload"]) {
                if ([[parseDictionary objectForKey:@"EsIload"] isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:[parseDictionary objectForKey:@"EsIload"]] forKey:@"resultIOrder"];
                }
                else if([[parseDictionary objectForKey:@"EsIload"] isKindOfClass:[NSArray class]])
                {
                    [xmlDoc setObject:[parseDictionary objectForKey:@"EsIload"] forKey:@"resultIOrder"];
                }
            }
            
            if ([parseDictionary objectForKey:@"EsRefresh"]) {
                if ([[parseDictionary objectForKey:@"EsRefresh"] isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:[parseDictionary objectForKey:@"EsRefresh"]] forKey:@"resultRefresh"];
                }
                else if([[parseDictionary objectForKey:@"EsRefresh"] isKindOfClass:[NSArray class]])
                {
                    [xmlDoc setObject:[parseDictionary objectForKey:@"EsRefresh"] forKey:@"resultRefresh"];
                }
            }
            
            ///////// till this?////////
            
            if ([parseDictionary objectForKey:@"EtLstar"]) {
                if ([[parseDictionary objectForKey:@"EtLstar"] objectForKey:@"results"]) {
                    if ([[[parseDictionary objectForKey:@"EtLstar"] objectForKey:@"results"] isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:[[parseDictionary objectForKey:@"results"] objectForKey:@"results"]] forKey:@"resultLstar"];
                    }
                    else if([[[parseDictionary objectForKey:@"EtLstar"] objectForKey:@"results"] isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:[[parseDictionary objectForKey:@"EtLstar"] objectForKey:@"results"] forKey:@"resultLstar"];
                    }
                }
            }
            
            if ([parseDictionary objectForKey:@"EtNotifEffect"]) {
                if ([[parseDictionary objectForKey:@"EtNotifEffect"] objectForKey:@"results"]) {
                    if ([[[parseDictionary objectForKey:@"EtNotifEffect"] objectForKey:@"results"] isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:[[parseDictionary objectForKey:@"EtNotifEffect"] objectForKey:@"results"]] forKey:@"resultNotifEffect"];
                    }
                    else if([[[parseDictionary objectForKey:@"EtNotifEffect"] objectForKey:@"results"] isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:[[parseDictionary objectForKey:@"EtNotifEffect"] objectForKey:@"results"] forKey:@"resultNotifEffect"];
                    }
                }
            }
            
            if ([parseDictionary objectForKey:@"EtNotifTypes"]) {
                if ([[parseDictionary objectForKey:@"EtNotifTypes"] objectForKey:@"results"]) {
                    if ([[[parseDictionary objectForKey:@"EtNotifTypes"] objectForKey:@"results"] isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:[[parseDictionary objectForKey:@"EtNotifTypes"] objectForKey:@"results"]] forKey:@"resultNotifTypes"];
                    }
                    else if([[[parseDictionary objectForKey:@"EtNotifTypes"] objectForKey:@"results"] isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:[[parseDictionary objectForKey:@"EtNotifTypes"] objectForKey:@"results"] forKey:@"resultNotifTypes"];
                    }
                }
            }
            
            if ([parseDictionary objectForKey:@"EtNotifPriority"]) {
                if ([[parseDictionary objectForKey:@"EtNotifPriority"] objectForKey:@"results"]) {
                    if ([[[parseDictionary objectForKey:@"EtNotifPriority"] objectForKey:@"results"] isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:[[parseDictionary objectForKey:@"EtNotifPriority"] objectForKey:@"results"]] forKey:@"resultNotifPriority"];
                    }
                    else if([[[parseDictionary objectForKey:@"EtNotifPriority"] objectForKey:@"results"] isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:[[parseDictionary objectForKey:@"EtNotifPriority"] objectForKey:@"results"] forKey:@"resultNotifPriority"];
                    }
                }
            }
            
            if ([parseDictionary objectForKey:@"EtOrdPriority"]) {
                if ([[parseDictionary objectForKey:@"EtOrdPriority"] objectForKey:@"results"]) {
                    if ([[[parseDictionary objectForKey:@"EtOrdPriority"] objectForKey:@"results"] isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:[[parseDictionary objectForKey:@"EtOrdPriority"] objectForKey:@"results"]] forKey:@"resultOrderPriority"];
                    }
                    else if([[[parseDictionary objectForKey:@"EtOrdPriority"] objectForKey:@"results"] isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:[[parseDictionary objectForKey:@"EtOrdPriority"] objectForKey:@"results"] forKey:@"resultOrderPriority"];
                    }
                }
            }
            
            if ([parseDictionary objectForKey:@"EtOrdSyscond"]) {
                if ([[parseDictionary objectForKey:@"EtOrdSyscond"] objectForKey:@"results"]) {
                    if ([[[parseDictionary objectForKey:@"EtOrdSyscond"] objectForKey:@"results"] isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:[[parseDictionary objectForKey:@"EtOrdSyscond"] objectForKey:@"results"]] forKey:@"resultOrderSystemCondition"];
                    }
                    else if([[[parseDictionary objectForKey:@"EtOrdSyscond"] objectForKey:@"results"] isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:[[parseDictionary objectForKey:@"EtOrdSyscond"] objectForKey:@"results"] forKey:@"resultOrderSystemCondition"];
                    }
                }
            }
            
            if ([parseDictionary objectForKey:@"EtOrdTypes"]) {
                if ([[parseDictionary objectForKey:@"EtOrdTypes"] objectForKey:@"results"]) {
                    if ([[[parseDictionary objectForKey:@"EtOrdTypes"] objectForKey:@"results"] isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:[[parseDictionary objectForKey:@"EtOrdTypes"] objectForKey:@"results"]] forKey:@"resultOrderTypes"];
                    }
                    else if([[[parseDictionary objectForKey:@"EtOrdTypes"] objectForKey:@"results"] isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:[[parseDictionary objectForKey:@"EtOrdTypes"] objectForKey:@"results"] forKey:@"resultOrderTypes"];
                    }
                }
            }
            
            if ([parseDictionary objectForKey:@"EtUnits"]) {
                if ([[parseDictionary objectForKey:@"EtUnits"] objectForKey:@"results"]) {
                    if ([[[parseDictionary objectForKey:@"EtUnits"] objectForKey:@"results"] isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:[[parseDictionary objectForKey:@"EtUnits"] objectForKey:@"results"]] forKey:@"resultUnits"];
                    }
                    else if([[[parseDictionary objectForKey:@"EtUnits"] objectForKey:@"results"] isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:[[parseDictionary objectForKey:@"EtUnits"] objectForKey:@"results"] forKey:@"resultUnits"];
                    }
                }
            }
            
            if ([parseDictionary objectForKey:@"EtKostl"]) {
                if ([[parseDictionary objectForKey:@"EtKostl"] objectForKey:@"results"]) {
                    if ([[[parseDictionary objectForKey:@"EtKostl"] objectForKey:@"results"] isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:[[parseDictionary objectForKey:@"EtKostl"] objectForKey:@"results"]] forKey:@"resultKostl"];
                    }
                    else if([[[parseDictionary objectForKey:@"EtKostl"] objectForKey:@"results"] isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:[[parseDictionary objectForKey:@"EtKostl"] objectForKey:@"results"] forKey:@"resultKostl"];
                    }
                }
            }
            
            if ([parseDictionary objectForKey:@"EtBemot"]) {
                if ([[parseDictionary objectForKey:@"EtBemot"] objectForKey:@"results"]) {
                    if ([[[parseDictionary objectForKey:@"EtBemot"] objectForKey:@"results"] isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:[[parseDictionary objectForKey:@"EtBemot"] objectForKey:@"results"]] forKey:@"resultBemot"];
                    }
                    else if([[[parseDictionary objectForKey:@"EtBemot"] objectForKey:@"results"] isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:[[parseDictionary objectForKey:@"EtBemot"] objectForKey:@"results"] forKey:@"resultBemot"];
                    }
                }
            }
            
            if ([parseDictionary objectForKey:@"EtNotifCodes"]) {
                if ([[parseDictionary objectForKey:@"EtNotifCodes"] objectForKey:@"results"]) {
                    if ([[[parseDictionary objectForKey:@"EtNotifCodes"] objectForKey:@"results"] isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:[[parseDictionary objectForKey:@"EtNotifCodes"] objectForKey:@"results"]] forKey:@"resultNotifCodes"];
                    }
                    else if([[[parseDictionary objectForKey:@"EtNotifCodes"] objectForKey:@"results"] isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:[[parseDictionary objectForKey:@"EtNotifCodes"] objectForKey:@"results"] forKey:@"resultNotifCodes"];
                    }
                }
            }
            
            
            if ([parseDictionary objectForKey:@"EtConfReason"]) {
                if ([[parseDictionary objectForKey:@"EtConfReason"] objectForKey:@"results"]) {
                    if ([[[parseDictionary objectForKey:@"EtConfReason"] objectForKey:@"results"] isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:[[parseDictionary objectForKey:@"EtConfReason"] objectForKey:@"results"]] forKey:@"resultConfReason"];
                    }
                    else if([[[parseDictionary objectForKey:@"EtConfReason"] objectForKey:@"results"] isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:[[parseDictionary objectForKey:@"EtConfReason"] objectForKey:@"results"] forKey:@"resultConfReason"];
                    }
                }
            }
            
            
            if ([parseDictionary objectForKey:@"EtPlants"]) {
                if ([[parseDictionary objectForKey:@"EtPlants"] objectForKey:@"results"]) {
                    if ([[[parseDictionary objectForKey:@"EtPlants"] objectForKey:@"results"] isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:[[parseDictionary objectForKey:@"EtPlants"] objectForKey:@"results"]] forKey:@"resultPlants"];
                    }
                    else if([[[parseDictionary objectForKey:@"EtPlants"] objectForKey:@"results"] isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:[[parseDictionary objectForKey:@"EtPlants"] objectForKey:@"results"] forKey:@"resultPlants"];
                    }
                }
            }
            
            if ([parseDictionary objectForKey:@"EtStloc"]) {
                if ([[parseDictionary objectForKey:@"EtStloc"] objectForKey:@"results"]) {
                    if ([[[parseDictionary objectForKey:@"EtStloc"] objectForKey:@"results"] isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:[[parseDictionary objectForKey:@"EtStloc"] objectForKey:@"results"]] forKey:@"resultStloc"];
                    }
                    else if([[[parseDictionary objectForKey:@"EtStloc"] objectForKey:@"results"] isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:[[parseDictionary objectForKey:@"EtStloc"] objectForKey:@"results"] forKey:@"resultStloc"];
                    }
                }
            }
            
            if ([parseDictionary objectForKey:@"EtMovementTypes"]) {
                if ([[parseDictionary objectForKey:@"EtMovementTypes"] objectForKey:@"results"]) {
                    if ([[[parseDictionary objectForKey:@"EtMovementTypes"] objectForKey:@"results"] isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:[[parseDictionary objectForKey:@"EtMovementTypes"] objectForKey:@"results"]] forKey:@"resultMovementTypes"];
                    }
                    else if([[[parseDictionary objectForKey:@"EtMovementTypes"] objectForKey:@"results"] isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:[[parseDictionary objectForKey:@"EtMovementTypes"] objectForKey:@"results"] forKey:@"resultMovementTypes"];
                    }
                }
            }
            
            if ([parseDictionary objectForKey:@"EtWkctrPlant"]) {
                if ([[parseDictionary objectForKey:@"EtWkctrPlant"] objectForKey:@"results"]) {
                    if ([[[parseDictionary objectForKey:@"EtWkctrPlant"] objectForKey:@"results"] isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:[[parseDictionary objectForKey:@"EtWkctrPlant"] objectForKey:@"results"]] forKey:@"resultWkctrPlant"];
                    }
                    else if([[[parseDictionary objectForKey:@"EtWkctrPlant"] objectForKey:@"results"] isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:[[parseDictionary objectForKey:@"EtWkctrPlant"] objectForKey:@"results"] forKey:@"resultWkctrPlant"];
                    }
                }
            }
            
            if ([parseDictionary objectForKey:@"EtPermits"]) {
                if ([[parseDictionary objectForKey:@"EtPermits"] objectForKey:@"results"]) {
                    if ([[[parseDictionary objectForKey:@"EtPermits"] objectForKey:@"results"] isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:[[parseDictionary objectForKey:@"EtPermits"] objectForKey:@"results"]] forKey:@"resultPermits"];
                    }
                    else if([[[parseDictionary objectForKey:@"EtPermits"] objectForKey:@"results"] isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:[[parseDictionary objectForKey:@"EtPermits"] objectForKey:@"results"] forKey:@"resultPermits"];
                    }
                }
            }
            
            if ([parseDictionary objectForKey:@"EtFields"]) {
                if ([[parseDictionary objectForKey:@"EtFields"] objectForKey:@"results"]) {
                    if ([[[parseDictionary objectForKey:@"EtFields"] objectForKey:@"results"] isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:[[parseDictionary objectForKey:@"EtFields"] objectForKey:@"results"]] forKey:@"CustomFields"];
                    }
                    else if([[[parseDictionary objectForKey:@"EtFields"] objectForKey:@"results"] isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:[[parseDictionary objectForKey:@"EtFields"] objectForKey:@"results"] forKey:@"CustomFields"];
                    }
                }
            }
            
            if ([parseDictionary objectForKey:@"EtSteus"]) {
                if ([[parseDictionary objectForKey:@"EtSteus"] objectForKey:@"results"]) {
                    if ([[[parseDictionary objectForKey:@"EtSteus"] objectForKey:@"results"] isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:[[parseDictionary objectForKey:@"EtSteus"] objectForKey:@"results"]] forKey:@"resultControlKeys"];
                    }
                    else if([[[parseDictionary objectForKey:@"EtSteus"] objectForKey:@"results"] isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:[[parseDictionary objectForKey:@"EtSteus"] objectForKey:@"results"] forKey:@"resultControlKeys"];
                    }
                }
            }
            
            if ([parseDictionary objectForKey:@"EtTq80"]) {
                
                if ([[parseDictionary objectForKey:@"EtTq80"] objectForKey:@"results"]) {
                    if ([[[parseDictionary objectForKey:@"EtTq80"] objectForKey:@"results"] isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:[[parseDictionary objectForKey:@"EtTq80"] objectForKey:@"results"]] forKey:@"resultEtTq80"];
                    }
                    else if([[[parseDictionary objectForKey:@"EtTq80"] objectForKey:@"results"] isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:[[parseDictionary objectForKey:@"EtTq80"] objectForKey:@"results"] forKey:@"resultEtTq80"];
                    }
                }
            }
            
          
            
            if ([parseDictionary objectForKey:@"EtIngrp"]) {
                if ([[parseDictionary objectForKey:@"EtIngrp"] objectForKey:@"results"]) {
                    if ([[[parseDictionary objectForKey:@"EtIngrp"] objectForKey:@"results"] isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:[[parseDictionary objectForKey:@"EtIngrp"] objectForKey:@"results"]] forKey:@"resultInGrp"];
                    }
                    else if([[[parseDictionary objectForKey:@"EtIngrp"] objectForKey:@"results"] isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:[[parseDictionary objectForKey:@"EtIngrp"] objectForKey:@"results"] forKey:@"resultInGrp"];
                    }
                }
            }
            
 
            if ([parseDictionary objectForKey:@"EtPernr"]) {
                if ([[parseDictionary objectForKey:@"EtPernr"] objectForKey:@"results"]) {
                    if ([[[parseDictionary objectForKey:@"EtPernr"] objectForKey:@"results"] isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:[[parseDictionary objectForKey:@"EtPernr"] objectForKey:@"item"]] forKey:@"resultPernr"];
                    }
                    else if([[[parseDictionary objectForKey:@"EtPernr"] objectForKey:@"results"] isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:[[parseDictionary objectForKey:@"EtPernr"] objectForKey:@"results"] forKey:@"resultPernr"];
                    }
                }
            }
 
            if ([parseDictionary objectForKey:@"EtUsers"]) {
                if ([[parseDictionary objectForKey:@"EtUsers"] objectForKey:@"results"]) {
                    if ([[[parseDictionary objectForKey:@"EtUsers"] objectForKey:@"results"] isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:[[parseDictionary objectForKey:@"EtUsers"] objectForKey:@"results"]] forKey:@"resultEtUserTokenId"];
                    }
                    else if([[[parseDictionary objectForKey:@"EtUsers"] objectForKey:@"results"] isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:[[parseDictionary objectForKey:@"EtUsers"] objectForKey:@"results"] forKey:@"resultEtUserTokenId"];
                    }
                }
            }
 
            if ([parseDictionary objectForKey:@"EtMeasCodes"]) {
                if ([[parseDictionary objectForKey:@"EtMeasCodes"] objectForKey:@"results"]) {
                    if ([[[parseDictionary objectForKey:@"EtMeasCodes"] objectForKey:@"results"] isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:[[parseDictionary objectForKey:@"EtMeasCodes"] objectForKey:@"results"]] forKey:@"resultInpectionmeasDocs"];
                    }
                    else if([[[parseDictionary objectForKey:@"EtMeasCodes"] objectForKey:@"results"] isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:[[parseDictionary objectForKey:@"EtMeasCodes"] objectForKey:@"results"] forKey:@"resultInpectionmeasDocs"];
                    }
                }
            }
            
            if ([parseDictionary objectForKey:@"EtWbs"]) {
                
                if ([[parseDictionary objectForKey:@"EtWbs"] objectForKey:@"results"])
                {
                    if ([[[parseDictionary objectForKey:@"EtWbs"] objectForKey:@"results"] isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:[[parseDictionary objectForKey:@"EtWbs"] objectForKey:@"results"]] forKey:@"resultWBS"];
                    }
                    else if([[[parseDictionary objectForKey:@"EtWbs"] objectForKey:@"results"] isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:[[parseDictionary objectForKey:@"EtWbs"] objectForKey:@"results"] forKey:@"resultWBS"];
                    }
                }
            }
            
            if ([parseDictionary objectForKey:@"EtRevnr"]) {
                
                if ([[parseDictionary objectForKey:@"EtRevnr"] objectForKey:@"results"])
                {
                    if ([[[parseDictionary objectForKey:@"EtRevnr"] objectForKey:@"results"] isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:[[parseDictionary objectForKey:@"EtRevnr"] objectForKey:@"results"]] forKey:@"resultRevnr"];
                    }
                    else if([[[parseDictionary objectForKey:@"EtRevnr"] objectForKey:@"results"] isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:[[parseDictionary objectForKey:@"EtRevnr"] objectForKey:@"results"] forKey:@"resultRevnr"];
                    }
                }
            }
            
         }
 
            return xmlDoc;
        }
     return [NSMutableDictionary dictionary];
 }

- (NSMutableDictionary *)parseForListOfPMBOMS:(NSDictionary *)resultDictionary
{
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    NSDictionary *parseDictionary,*parseTransactionDictionary,*parseDictionary_Stock;
    
    if ([resultDictionary objectForKey:@"d"])
    {
        parseDictionary = [resultDictionary objectForKey:@"d"];
        
        if ([parseDictionary objectForKey:@"results"])
        {
            id dataObject = [parseDictionary objectForKey:@"results"];
            
            if ([dataObject isKindOfClass:[NSDictionary class]]) {
                
                parseTransactionDictionary = [dataObject copy];
                //parseDictionary_Component = parseDictionary;
                parseDictionary_Stock = [dataObject copy];
            }
            
            else if ([dataObject isKindOfClass:[NSArray class]]){
                
                if ([dataObject count]) {
                    
                    parseTransactionDictionary = [[dataObject objectAtIndex:0]copy];
                    //parseDictionary_Component = parseDictionary;
                    parseDictionary_Stock = [[dataObject objectAtIndex:0]copy];
                }
              }
 
             if ([parseTransactionDictionary objectForKey:@"EtBomHeader"])
             {
                 if ([[parseTransactionDictionary objectForKey:@"EtBomHeader"] objectForKey:@"results"])
                 {
                     parseTransactionDictionary=[[parseTransactionDictionary objectForKey:@"EtBomHeader"] objectForKey:@"results"];
                     if ([parseTransactionDictionary isKindOfClass:[NSDictionary class]])
                     {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseTransactionDictionary] forKey:@"resultHeader"];
                    }
                    else if([parseTransactionDictionary isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseTransactionDictionary forKey:@"resultHeader"];
                    }
                 }
                 
                 NSMutableDictionary *equipmentBOM = [NSMutableDictionary new];
                 [equipmentBOM setObject:[xmlDoc objectForKey:@"resultHeader"] forKey:@"BOMHeader"];
                 
                 [[DataBase sharedInstance] insertEquipmentBOMToCoreDataFromArray:equipmentBOM];
            }
 
 
            if ([parseDictionary_Stock objectForKey:@"EtStock"])
             {
                 if ([[parseDictionary_Stock objectForKey:@"EtStock"] objectForKey:@"results"]) {
                     
                     parseDictionary_Stock=[[parseDictionary_Stock objectForKey:@"EtStock"] objectForKey:@"results"];
 
                     if ([parseDictionary_Stock isKindOfClass:[NSDictionary class]])
                     {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionary_Stock] forKey:@"resultStock"];
                    }
                    else if([parseDictionary_Stock isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionary_Stock forKey:@"resultStock"];
                    }
                }
                
             }
            
            if ([xmlDoc objectForKey:@"resultStock"])
            {
                if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"ACTIVATELOGS"] isEqualToString:@"X"])
                {
                    [[DataBase sharedInstance] writToLogFile:[NSString stringWithFormat:@"#INFO#.com.enstrapp.fieldtekpro#Stock Data received"]];
                }
 
                NSMutableArray *stockMasterDataArray = [NSMutableArray new];
 
                [stockMasterDataArray addObjectsFromArray:[xmlDoc objectForKey:@"resultStock"]];
 
                AppDelegate *tempDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                
                 [tempDelegate.coreDataControlObject removeContextForStockOverView:@""];
                
                 [[DataBase sharedInstance] insertStockOverViewToCoreDataFromArray:stockMasterDataArray];
            }
            
            return xmlDoc;
        }
    }
    
     return [NSMutableDictionary dictionary];
 }

- (NSMutableDictionary *)parseForReleaseNotification:(NSDictionary *)resultDictionary
{
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    NSDictionary *parseDictionary,*parseDictionaryTransaction,*parseDictionaryLongText,*parseDictionaryDocs,*parseDictionaryTasks,*parseDictionaryNotifStatus,*parseInspectionDictionary,*parseHeaderDictionary,*parseMessageDictionary;
    
    if ([resultDictionary objectForKey:@"d"])
    {
        parseDictionary = [resultDictionary objectForKey:@"d"];
        
        if ([parseDictionary objectForKey:@"results"])
        {
            id dataObject = [parseDictionary objectForKey:@"results"];
            
            if ([dataObject isKindOfClass:[NSDictionary class]]) {
                parseDictionaryTransaction = [dataObject copy];
                parseDictionaryLongText = [dataObject copy];
                parseDictionaryDocs = [dataObject copy];
                parseDictionaryTasks = [dataObject copy];
                parseDictionaryNotifStatus = [dataObject copy];
                parseInspectionDictionary = [dataObject copy];
                parseHeaderDictionary = [dataObject copy];
                parseMessageDictionary = [dataObject copy];

                
            }
            else if ([dataObject isKindOfClass:[NSArray class]]){
                
                if ([dataObject count])
                {
                    parseDictionaryTransaction = [[dataObject objectAtIndex:0] copy];
                    parseDictionaryLongText = [[dataObject objectAtIndex:0] copy];
                    parseDictionaryDocs = [[dataObject objectAtIndex:0] copy];
                    parseDictionaryTasks = [[dataObject objectAtIndex:0] copy];
                    parseDictionaryNotifStatus = [[dataObject objectAtIndex:0] copy];
                    parseInspectionDictionary = [[dataObject objectAtIndex:0] copy];
                    parseHeaderDictionary = [[dataObject objectAtIndex:0] copy];
                    parseMessageDictionary = [[dataObject objectAtIndex:0] copy];
 
                }
                
            }
            
            if ([parseHeaderDictionary objectForKey:@"EtNotifHeader"]) {
                parseHeaderDictionary = [parseHeaderDictionary objectForKey:@"EtNotifHeader"];
                if ([parseHeaderDictionary objectForKey:@"results"]) {
                    parseHeaderDictionary = [parseHeaderDictionary objectForKey:@"results"];
                    if ([parseHeaderDictionary isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseHeaderDictionary] forKey:@"resultHeader"];
                    }
                    else if([parseHeaderDictionary isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseHeaderDictionary forKey:@"resultHeader"];
                    }
                }
            }
            
            if ([parseInspectionDictionary objectForKey:@"EtImrg"]) {
                parseInspectionDictionary = [parseInspectionDictionary objectForKey:@"EtImrg"];
                if ([parseInspectionDictionary objectForKey:@"results"]) {
                    parseInspectionDictionary = [parseInspectionDictionary objectForKey:@"results"];
                    if ([parseInspectionDictionary isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseInspectionDictionary] forKey:@"resultInspection"];
                    }
                    else if([parseInspectionDictionary isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseInspectionDictionary forKey:@"resultInspection"];
                    }
                }
            }
            
            id messageObject=[parseMessageDictionary copy];
            
            if ([[messageObject objectForKey:@"EvMessage"] objectForKey:@"results"]) {
                
                if ([[[messageObject objectForKey:@"EvMessage"] objectForKey:@"results"] isKindOfClass:[NSDictionary class]]){
                    
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:[[[[messageObject objectForKey:@"EvMessage"] objectForKey:@"results"] objectAtIndex:0] objectForKey:@"Message"]] forKey:@"MESSAGE"];
                    
                }
                else if ([[[messageObject objectForKey:@"EvMessage"] objectForKey:@"results"] isKindOfClass:[NSArray class]]){
                    
                    if ([[[messageObject objectForKey:@"EvMessage"] objectForKey:@"results"] count])
                    {
                        [xmlDoc setObject:[[[[messageObject objectForKey:@"EvMessage"] objectForKey:@"results"] objectAtIndex:0] objectForKey:@"Message"] forKey:@"MESSAGE"];
                    }
                    
                }
            }
            
            if ([parseDictionaryTransaction objectForKey:@"EtNotifItems"]) {
                parseDictionaryTransaction = [parseDictionaryTransaction objectForKey:@"EtNotifItems"];
                if ([parseDictionaryTransaction objectForKey:@"results"]) {
                    parseDictionaryTransaction = [parseDictionaryTransaction objectForKey:@"results"];
                    if ([parseDictionaryTransaction isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryTransaction] forKey:@"resultTransactions"];
                    }
                    else if([parseDictionaryTransaction isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryTransaction forKey:@"resultTransactions"];
                    }
                }
            }
            
            if ([parseDictionaryLongText objectForKey:@"EtNotifLongtext"]) {
                parseDictionaryLongText = [parseDictionaryLongText objectForKey:@"EtNotifLongtext"];
                if ([parseDictionaryLongText objectForKey:@"results"]) {
                    parseDictionaryLongText = [parseDictionaryLongText objectForKey:@"results"];
                    if ([parseDictionaryLongText isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryLongText] forKey:@"resultLongText"];
                    }
                    else if([parseDictionaryLongText isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryLongText forKey:@"resultLongText"];
                    }
                }
            }
            
            if ([parseDictionaryDocs objectForKey:@"EtDocs"]) {
                parseDictionaryDocs = [parseDictionaryDocs objectForKey:@"EtDocs"];
                if ([parseDictionaryDocs objectForKey:@"results"]) {
                    parseDictionaryDocs = [parseDictionaryDocs objectForKey:@"results"];
                    if ([parseDictionaryDocs isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryDocs] forKey:@"resultDocs"];
                    }
                    else if([parseDictionaryDocs isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryDocs forKey:@"resultDocs"];
                    }
                }
            }
            
            if ([parseDictionaryTasks objectForKey:@"EtNotifTasks"]) {
                parseDictionaryTasks = [parseDictionaryTasks objectForKey:@"EtNotifTasks"];
                if ([parseDictionaryTasks objectForKey:@"results"]) {
                    parseDictionaryTasks = [parseDictionaryTasks objectForKey:@"results"];
                    if ([parseDictionaryTasks isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryTasks] forKey:@"resultTasks"];
                    }
                    else if([parseDictionaryTasks isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryTasks forKey:@"resultTasks"];
                    }
                }
            }
            
            if ([parseDictionaryNotifStatus objectForKey:@"EtNotifStatus"]) {
                parseDictionaryNotifStatus = [parseDictionaryNotifStatus objectForKey:@"EtNotifStatus"];
                if ([parseDictionaryNotifStatus objectForKey:@"results"]) {
                    parseDictionaryNotifStatus = [parseDictionaryNotifStatus objectForKey:@"results"];
                    if ([parseDictionaryNotifStatus isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryNotifStatus] forKey:@"resultNotifStatus"];
                    }
                    else if([parseDictionaryNotifStatus isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryNotifStatus forKey:@"resultNotifStatus"];
                    }
                }
            }
            
            return xmlDoc;
            
        }
    }
    return [NSMutableDictionary dictionary];
}

- (NSMutableDictionary *)parseForListOfDueNotification:(NSDictionary *)resultDictionary
{
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    NSDictionary *parseDictionary,*parseDictionaryTransaction,*parseDictionaryLongText,*parseDictionaryDocs,*parseDictionaryTasks,*parseDictionaryNotifStatus,*parseInspectionDictionary,*parseHeaderDictionary,*parseActivityDictionary;
    
    if ([resultDictionary objectForKey:@"d"])
    {
        parseDictionary = [resultDictionary objectForKey:@"d"];
        
        if ([parseDictionary objectForKey:@"results"])
        {
            id dataObject = [parseDictionary objectForKey:@"results"];
            
            if ([dataObject isKindOfClass:[NSDictionary class]]) {
                parseDictionaryTransaction = [dataObject copy];
                parseDictionaryLongText = [dataObject copy];
                parseDictionaryDocs = [dataObject copy];
                parseDictionaryTasks = [dataObject copy];
                parseDictionaryNotifStatus = [dataObject copy];
                parseInspectionDictionary = [dataObject copy];
                parseHeaderDictionary = [dataObject copy];
                parseActivityDictionary = [dataObject copy];
 
             }
             else if ([dataObject isKindOfClass:[NSArray class]]){
              
                if ([dataObject count]){
                    
                 parseDictionaryTransaction = [[dataObject objectAtIndex:0] copy];
                 parseDictionaryLongText = [[dataObject objectAtIndex:0] copy];
                 parseDictionaryDocs = [[dataObject objectAtIndex:0] copy];
                 parseDictionaryTasks = [[dataObject objectAtIndex:0] copy];
                 parseDictionaryNotifStatus = [[dataObject objectAtIndex:0] copy];
                 parseInspectionDictionary = [[dataObject objectAtIndex:0] copy];
                 parseHeaderDictionary = [[dataObject objectAtIndex:0] copy];
                 parseActivityDictionary = [[dataObject objectAtIndex:0] copy];
                    
                 }
             }
           
             if ([parseHeaderDictionary objectForKey:@"EtNotifHeader"]) {
                parseHeaderDictionary = [parseHeaderDictionary objectForKey:@"EtNotifHeader"];
                if ([parseHeaderDictionary objectForKey:@"results"]) {
                    parseHeaderDictionary = [parseHeaderDictionary objectForKey:@"results"];
                    if ([parseHeaderDictionary isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseHeaderDictionary] forKey:@"resultHeader"];
                    }
                    else if([parseHeaderDictionary isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseHeaderDictionary forKey:@"resultHeader"];
                    }
                }
            }
            
             if ([parseInspectionDictionary objectForKey:@"EtImrg"]) {
                parseInspectionDictionary = [parseInspectionDictionary objectForKey:@"EtImrg"];
                if ([parseInspectionDictionary objectForKey:@"results"]) {
                    parseInspectionDictionary = [parseInspectionDictionary objectForKey:@"results"];
                    if ([parseInspectionDictionary isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseInspectionDictionary] forKey:@"resultInspection"];
                    }
                    else if([parseInspectionDictionary isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseInspectionDictionary forKey:@"resultInspection"];
                    }
                }
            }
            
            if ([parseActivityDictionary objectForKey:@"EtNotifActvs"]) {
                parseActivityDictionary = [parseActivityDictionary objectForKey:@"EtNotifActvs"];
                if ([parseActivityDictionary objectForKey:@"results"]) {
                    parseActivityDictionary = [parseActivityDictionary objectForKey:@"results"];
                    if ([parseActivityDictionary isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseActivityDictionary] forKey:@"resultActivities"];
                    }
                    else if([parseActivityDictionary isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseActivityDictionary forKey:@"resultActivities"];
                    }
                }
            }
            
            
            if ([parseDictionaryTransaction objectForKey:@"EtNotifItems"]) {
                parseDictionaryTransaction = [parseDictionaryTransaction objectForKey:@"EtNotifItems"];
                if ([parseDictionaryTransaction objectForKey:@"results"]) {
                    parseDictionaryTransaction = [parseDictionaryTransaction objectForKey:@"results"];
                    if ([parseDictionaryTransaction isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryTransaction] forKey:@"resultTransactions"];
                    }
                    else if([parseDictionaryTransaction isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryTransaction forKey:@"resultTransactions"];
                    }
                }
            }
            
            if ([parseDictionaryLongText objectForKey:@"EtNotifLongtext"]) {
                parseDictionaryLongText = [parseDictionaryLongText objectForKey:@"EtNotifLongtext"];
                if ([parseDictionaryLongText objectForKey:@"results"]) {
                    parseDictionaryLongText = [parseDictionaryLongText objectForKey:@"results"];
                    if ([parseDictionaryLongText isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryLongText] forKey:@"resultLongText"];
                    }
                    else if([parseDictionaryLongText isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryLongText forKey:@"resultLongText"];
                    }
                }
            }
            
            if ([parseDictionaryDocs objectForKey:@"EtDocs"]) {
                parseDictionaryDocs = [parseDictionaryDocs objectForKey:@"EtDocs"];
                if ([parseDictionaryDocs objectForKey:@"results"]) {
                    parseDictionaryDocs = [parseDictionaryDocs objectForKey:@"results"];
                    if ([parseDictionaryDocs isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryDocs] forKey:@"resultDocs"];
                    }
                    else if([parseDictionaryDocs isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryDocs forKey:@"resultDocs"];
                    }
                }
            }
            
            if ([parseDictionaryTasks objectForKey:@"EtNotifTasks"]) {
                parseDictionaryTasks = [parseDictionaryTasks objectForKey:@"EtNotifTasks"];
                if ([parseDictionaryTasks objectForKey:@"results"]) {
                    parseDictionaryTasks = [parseDictionaryTasks objectForKey:@"results"];
                    if ([parseDictionaryTasks isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryTasks] forKey:@"resultTasks"];
                    }
                    else if([parseDictionaryTasks isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryTasks forKey:@"resultTasks"];
                    }
                }
            }
            
            if ([parseDictionaryNotifStatus objectForKey:@"EtNotifStatus"]) {
                parseDictionaryNotifStatus = [parseDictionaryNotifStatus objectForKey:@"EtNotifStatus"];
                if ([parseDictionaryNotifStatus objectForKey:@"results"]) {
                    parseDictionaryNotifStatus = [parseDictionaryNotifStatus objectForKey:@"results"];
                    if ([parseDictionaryNotifStatus isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryNotifStatus] forKey:@"resultNotifStatus"];
                    }
                    else if([parseDictionaryNotifStatus isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryNotifStatus forKey:@"resultNotifStatus"];
                    }
                }
            }
            
            return xmlDoc;
            
        }
    }
    return [NSMutableDictionary dictionary];
}


- (NSMutableDictionary *)parseForMonitorEquipmentHistory:(NSDictionary *)resultDictionary
{
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    NSDictionary *parseDictionary;
    if ([resultDictionary objectForKey:@"d"]) {
        parseDictionary = [resultDictionary objectForKey:@"d"];
        if ([parseDictionary objectForKey:@"results"]) {
            
            id dataObject = [parseDictionary objectForKey:@"results"];
            
            if ([dataObject isKindOfClass:[NSDictionary class]]) {
                
                dataObject=[dataObject copy];
                
            }
            
            else if ([dataObject isKindOfClass:[NSArray class]]){
                
                dataObject=[[dataObject objectAtIndex:0 ]copy];
                
            }
            
            if ([[dataObject objectForKey:@"NavEquipHistory"] objectForKey:@"results"]) {
                
                if ([[[dataObject objectForKey:@"NavEquipHistory"] objectForKey:@"results"] isKindOfClass:[NSDictionary class]]){
                    
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:[[[dataObject objectForKey:@"NavEquipHistory"] objectForKey:@"results"] copy]] forKey:@"resultEquipmentHistory"];
                    
                }
                else if ([[[dataObject objectForKey:@"NavEquipHistory"] objectForKey:@"results"] isKindOfClass:[NSArray class]]){
                    
                    if ([[[dataObject objectForKey:@"NavEquipHistory"] objectForKey:@"results"] count])
                    {
                        [xmlDoc setObject:[[[dataObject objectForKey:@"NavEquipHistory"] objectForKey:@"results"]  copy] forKey:@"resultEquipmentHistory"];
                    }
                }
            }
            
            
            return xmlDoc;
        }
    }
    else if([resultDictionary objectForKey:@"error"])
    {
        parseDictionary = [[resultDictionary objectForKey:@"error"] objectForKey:@"message"];
        [xmlDoc setObject:[parseDictionary objectForKey:@"value"] forKey:@"ERROR"];
        return xmlDoc;
    }
    
    return [NSMutableDictionary dictionary];
}

- (NSMutableDictionary *)parseForReleaseOrder:(NSDictionary *)resultDictionary
{
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    
    NSDictionary *parseDictionary,*parseDictionaryHeaderPermits,*parseDictionaryOperationTransaction,*parseDictionaryComponentsTransaction,*parseDictionaryLongText,*parseDictionaryDocs,*parseDictionaryWSM,*parseDictionaryObjects,*parsedDictionaryOrderStatus,*parsedDictionaryOrderOlist,*parsedDictionaryCheckPoints,*parsedDictionaryWorkApplications,*parsedDictionaryWcagns,*parsedDictionaryOpWCDDetails,*parsedDictionaryOpWCDItemDetails,*parsedDictionaryWorkApprovalDetails,*parsedDictionaryMeasurementDocuments,*parseHeaderDictionary,*parseMessageDictionary;
    
    if ([resultDictionary objectForKey:@"d"])
    {
        parseDictionary = [resultDictionary objectForKey:@"d"];
        
        if ([parseDictionary objectForKey:@"results"])
        {
            id dataObject = [parseDictionary objectForKey:@"results"];
            
            if ([dataObject isKindOfClass:[NSDictionary class]]) {
                
                parseDictionaryHeaderPermits = [dataObject copy];
                parseDictionaryOperationTransaction = [dataObject copy];
                parseDictionaryComponentsTransaction = [dataObject copy];
                parseDictionaryLongText = [dataObject copy];
                parseDictionaryDocs = [dataObject copy];
                parseDictionaryWSM = [dataObject copy];
                parseDictionaryObjects = [dataObject copy];
                parsedDictionaryOrderStatus = [dataObject copy];
                parsedDictionaryOrderOlist = [dataObject copy];
                parsedDictionaryCheckPoints = [dataObject copy];
                parsedDictionaryWorkApplications = [dataObject copy];
                parsedDictionaryWcagns = [dataObject copy];
                parsedDictionaryOpWCDDetails = [dataObject copy];
                parsedDictionaryOpWCDItemDetails = [dataObject copy];
                parsedDictionaryWorkApprovalDetails = [dataObject copy];
                parsedDictionaryMeasurementDocuments = [dataObject copy];
                parseHeaderDictionary = [dataObject copy];
                parseMessageDictionary=[dataObject copy];
                
            }
            else if ([dataObject isKindOfClass:[NSArray class]])
            {
                if ([dataObject count]) {
                    parseDictionaryHeaderPermits = [[dataObject objectAtIndex:0] copy];
                    parseDictionaryOperationTransaction = [[dataObject objectAtIndex:0] copy];
                    parseDictionaryComponentsTransaction = [[dataObject objectAtIndex:0] copy];
                    parseDictionaryLongText = [[dataObject objectAtIndex:0] copy];
                    parseDictionaryDocs = [[dataObject objectAtIndex:0] copy];
                    parseDictionaryWSM = [[dataObject objectAtIndex:0] copy];
                    parseDictionaryObjects = [[dataObject objectAtIndex:0] copy];
                    parsedDictionaryOrderStatus = [[dataObject objectAtIndex:0] copy];
                    parsedDictionaryOrderOlist = [[dataObject objectAtIndex:0] copy];
                    parsedDictionaryCheckPoints = [[dataObject objectAtIndex:0] copy];
                    parsedDictionaryWorkApplications = [[dataObject objectAtIndex:0] copy];
                    parsedDictionaryWcagns = [[dataObject objectAtIndex:0] copy];
                    parsedDictionaryOpWCDDetails = [[dataObject objectAtIndex:0] copy];
                    parsedDictionaryOpWCDItemDetails = [[dataObject objectAtIndex:0] copy];
                    parsedDictionaryWorkApprovalDetails = [[dataObject objectAtIndex:0] copy];
                    parsedDictionaryMeasurementDocuments = [[dataObject objectAtIndex:0] copy];
                    parseHeaderDictionary = [[dataObject objectAtIndex:0] copy];
                     parseMessageDictionary=[[dataObject objectAtIndex:0] copy];

                 }
            }
            
            
            if ([parseHeaderDictionary objectForKey:@"EtOrderHeader"]) {
                parseHeaderDictionary = [parseHeaderDictionary objectForKey:@"EtOrderHeader"];
                if ([parseHeaderDictionary objectForKey:@"results"]) {
                    parseHeaderDictionary = [parseHeaderDictionary objectForKey:@"results"];
                    if ([parseHeaderDictionary isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseHeaderDictionary] forKey:@"resultHeader"];
                    }
                    else if([parseHeaderDictionary isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseHeaderDictionary forKey:@"resultHeader"];
                    }
                }
            }
 
                  id messageObject=parseMessageDictionary;
                         
         if ([[messageObject objectForKey:@"EvMessageRe"] objectForKey:@"results"]) {
                             
                if ([[[messageObject objectForKey:@"EvMessageRe"] objectForKey:@"results"] isKindOfClass:[NSDictionary class]]){
                                 
                [xmlDoc setObject:[NSMutableArray arrayWithObject:[[[[messageObject objectForKey:@"EvMessageRe"] objectForKey:@"results"] objectAtIndex:0] objectForKey:@"Message"]] forKey:@"Message"];
                                 
                }
                else if ([[[messageObject objectForKey:@"EvMessageRe"] objectForKey:@"results"] isKindOfClass:[NSArray class]]){
                                 
                  if ([[[messageObject objectForKey:@"EvMessageRe"] objectForKey:@"results"] count])
                  {
                     [xmlDoc setObject:[[[[messageObject objectForKey:@"EvMessageRe"] objectForKey:@"results"] objectAtIndex:0] objectForKey:@"Message"] forKey:@"Message"];
                   }
                    
                }
            }
            
            if ([parseDictionaryObjects objectForKey:@"EtOrderOlist"]) {
                parseDictionaryObjects = [parseDictionaryObjects objectForKey:@"EtOrderOlist"];
                if ([parseDictionaryObjects objectForKey:@"results"]) {
                    parseDictionaryObjects = [parseDictionaryObjects objectForKey:@"results"];
                    if ([parseDictionaryObjects isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryObjects] forKey:@"resultHeaderObjects"];
                    }
                    else if([parseDictionaryObjects isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryObjects forKey:@"resultHeaderObjects"];
                    }
                }
            }
            
            if ([parsedDictionaryMeasurementDocuments objectForKey:@"EtImrg"]) {
                parsedDictionaryMeasurementDocuments = [parsedDictionaryMeasurementDocuments objectForKey:@"EtImrg"];
                if ([parsedDictionaryMeasurementDocuments objectForKey:@"results"]) {
                    parsedDictionaryMeasurementDocuments = [parsedDictionaryMeasurementDocuments objectForKey:@"results"];
                    if ([parsedDictionaryMeasurementDocuments isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parsedDictionaryMeasurementDocuments] forKey:@"resultMeasurementDocuments"];
                    }
                    else if([parsedDictionaryMeasurementDocuments isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parsedDictionaryMeasurementDocuments forKey:@"resultMeasurementDocuments"];
                    }
                }
            }
            
            if ([parseDictionaryHeaderPermits objectForKey:@"EtOrderPermits"]) {
                parseDictionaryHeaderPermits = [parseDictionaryHeaderPermits objectForKey:@"EtOrderPermits"];
                if ([parseDictionaryHeaderPermits objectForKey:@"results"]) {
                    parseDictionaryHeaderPermits = [parseDictionaryHeaderPermits objectForKey:@"results"];
                    if ([parseDictionaryHeaderPermits isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryHeaderPermits] forKey:@"resultHeaderPermits"];
                    }
                    else if([parseDictionaryHeaderPermits isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryHeaderPermits forKey:@"resultHeaderPermits"];
                    }
                }
            }
            
            if ([parseDictionaryOperationTransaction objectForKey:@"EtOrderOperations"]) {
                parseDictionaryOperationTransaction = [parseDictionaryOperationTransaction objectForKey:@"EtOrderOperations"];
                if ([parseDictionaryOperationTransaction objectForKey:@"results"]) {
                    parseDictionaryOperationTransaction = [parseDictionaryOperationTransaction objectForKey:@"results"];
                    if ([parseDictionaryOperationTransaction isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryOperationTransaction] forKey:@"resultOperationsTransactions"];
                    }
                    else if([parseDictionaryOperationTransaction isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryOperationTransaction forKey:@"resultOperationsTransactions"];
                    }
                }
            }
            
            if ([parseDictionaryComponentsTransaction objectForKey:@"EtOrderComponents"]) {
                parseDictionaryComponentsTransaction = [parseDictionaryComponentsTransaction objectForKey:@"EtOrderComponents"];
                if ([parseDictionaryComponentsTransaction objectForKey:@"results"]) {
                    parseDictionaryComponentsTransaction = [parseDictionaryComponentsTransaction objectForKey:@"results"];
                    if ([parseDictionaryComponentsTransaction isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryComponentsTransaction] forKey:@"resultComponentsTransactions"];
                    }
                    else if([parseDictionaryComponentsTransaction isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryComponentsTransaction forKey:@"resultComponentsTransactions"];
                    }
                }
            }
            
            if ([parseDictionaryLongText objectForKey:@"EtOrderLongtext"]) {
                parseDictionaryLongText = [parseDictionaryLongText objectForKey:@"EtOrderLongtext"];
                if ([parseDictionaryLongText objectForKey:@"results"]) {
                    parseDictionaryLongText = [parseDictionaryLongText objectForKey:@"results"];
                    if ([parseDictionaryLongText isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryLongText] forKey:@"resultLongText"];
                    }
                    else if([parseDictionaryLongText isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryLongText forKey:@"resultLongText"];
                    }
                }
            }
            
            if ([parseDictionaryDocs objectForKey:@"EtDocs"]) {
                parseDictionaryDocs = [parseDictionaryDocs objectForKey:@"EtDocs"];
                if ([parseDictionaryDocs objectForKey:@"results"]) {
                    parseDictionaryDocs = [parseDictionaryDocs objectForKey:@"results"];
                    if ([parseDictionaryDocs isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryDocs] forKey:@"resultDocs"];
                    }
                    else if([parseDictionaryDocs isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryDocs forKey:@"resultDocs"];
                    }
                }
            }
            
            if ([parseDictionaryWSM objectForKey:@"EtWsmOrdSafemeas"]) {
                parseDictionaryWSM = [parseDictionaryWSM objectForKey:@"EtWsmOrdSafemeas"];
                if ([parseDictionaryWSM objectForKey:@"results"]) {
                    parseDictionaryWSM = [parseDictionaryWSM objectForKey:@"results"];
                    if ([parseDictionaryWSM isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryWSM] forKey:@"resultWSMSafetyMeasures"];
                    }
                    else if([parseDictionaryWSM isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryWSM forKey:@"resultWSMSafetyMeasures"];
                    }
                }
            }
            
            if ([parsedDictionaryOrderStatus objectForKey:@"EtOrderStatus"]) {
                parsedDictionaryOrderStatus = [parsedDictionaryOrderStatus objectForKey:@"EtOrderStatus"];
                if ([parsedDictionaryOrderStatus objectForKey:@"results"]) {
                    parsedDictionaryOrderStatus = [parsedDictionaryOrderStatus objectForKey:@"results"];
                    if ([parsedDictionaryOrderStatus isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parsedDictionaryOrderStatus] forKey:@"resultOrderStatus"];
                    }
                    else if([parsedDictionaryOrderStatus isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parsedDictionaryOrderStatus forKey:@"resultOrderStatus"];
                    }
                }
            }
            
            if ([parsedDictionaryOrderOlist objectForKey:@"EtOrderOlist"]) {
                parsedDictionaryOrderOlist = [parsedDictionaryOrderOlist objectForKey:@"EtOrderOlist"];
                if ([parsedDictionaryOrderOlist objectForKey:@"results"]) {
                    parsedDictionaryOrderOlist = [parsedDictionaryOrderOlist objectForKey:@"results"];
                    if ([parsedDictionaryOrderOlist isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parsedDictionaryOrderOlist] forKey:@"resultOrderOlist"];
                    }
                    else if([parsedDictionaryOrderOlist isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parsedDictionaryOrderOlist forKey:@"resultOrderOlist"];
                    }
                }
            }
            
            //WCM
            if ([parsedDictionaryCheckPoints objectForKey:@"EtWcmWaChkReq"]) {
                parsedDictionaryCheckPoints = [parsedDictionaryCheckPoints objectForKey:@"EtWcmWaChkReq"];
                if ([parsedDictionaryCheckPoints objectForKey:@"results"]) {
                    parsedDictionaryCheckPoints = [parsedDictionaryCheckPoints objectForKey:@"results"];
                    if ([parsedDictionaryCheckPoints isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parsedDictionaryCheckPoints] forKey:@"resultStandardCheckPoints"];
                    }
                    else if([parsedDictionaryCheckPoints isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parsedDictionaryCheckPoints forKey:@"resultStandardCheckPoints"];
                    }
                }
            }
            
            if ([parsedDictionaryWorkApplications objectForKey:@"EtWcmWaData"]) {
                parsedDictionaryWorkApplications = [parsedDictionaryWorkApplications objectForKey:@"EtWcmWaData"];
                if ([parsedDictionaryWorkApplications objectForKey:@"results"]) {
                    parsedDictionaryWorkApplications = [parsedDictionaryWorkApplications objectForKey:@"results"];
                    if ([parsedDictionaryWorkApplications isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parsedDictionaryWorkApplications] forKey:@"resultWorkApplicationData"];
                    }
                    else if([parsedDictionaryWorkApplications isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parsedDictionaryWorkApplications forKey:@"resultWorkApplicationData"];
                    }
                }
            }
            
            if ([parsedDictionaryWcagns objectForKey:@"EtWcmWcagns"]) {
                parsedDictionaryWcagns = [parsedDictionaryWcagns objectForKey:@"EtWcmWcagns"];
                if ([parsedDictionaryWcagns objectForKey:@"results"]) {
                    parsedDictionaryWcagns = [parsedDictionaryWcagns objectForKey:@"results"];
                    if ([parsedDictionaryWcagns isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parsedDictionaryWcagns] forKey:@"resultIssuePermits"];//issue permits
                    }
                    else if([parsedDictionaryWcagns isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parsedDictionaryWcagns forKey:@"resultIssuePermits"];//issue permits
                    }
                }
            }
            
            if ([parsedDictionaryOpWCDDetails objectForKey:@"EtWcmWdData"]) {
                parsedDictionaryOpWCDDetails = [parsedDictionaryOpWCDDetails objectForKey:@"EtWcmWdData"];
                if ([parsedDictionaryOpWCDDetails objectForKey:@"results"]) {
                    parsedDictionaryOpWCDDetails = [parsedDictionaryOpWCDDetails objectForKey:@"results"];
                    if ([parsedDictionaryOpWCDDetails isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parsedDictionaryOpWCDDetails] forKey:@"resultOperationWCDData"];//isolation
                    }
                    else if([parsedDictionaryOpWCDDetails isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parsedDictionaryOpWCDDetails forKey:@"resultOperationWCDData"];//isolation
                    }
                }
            }
            
            if ([parsedDictionaryOpWCDItemDetails objectForKey:@"EtWcmWdItemData"]) {
                parsedDictionaryOpWCDItemDetails = [parsedDictionaryOpWCDItemDetails objectForKey:@"EtWcmWdItemData"];
                if ([parsedDictionaryOpWCDItemDetails objectForKey:@"results"]) {
                    parsedDictionaryOpWCDItemDetails = [parsedDictionaryOpWCDItemDetails objectForKey:@"results"];
                    if ([parsedDictionaryOpWCDItemDetails isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parsedDictionaryOpWCDItemDetails] forKey:@"resultOperationWCDItemData"];//tagging conditions
                    }
                    else if([parsedDictionaryOpWCDItemDetails isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parsedDictionaryOpWCDItemDetails forKey:@"resultOperationWCDItemData"];//tagging conditions
                    }
                }
            }
            
            if ([parsedDictionaryWorkApprovalDetails objectForKey:@"EtWcmWwData"]) {
                parsedDictionaryWorkApprovalDetails = [parsedDictionaryWorkApprovalDetails objectForKey:@"EtWcmWwData"];
                if ([parsedDictionaryWorkApprovalDetails objectForKey:@"results"]) {
                    parsedDictionaryWorkApprovalDetails = [parsedDictionaryWorkApprovalDetails objectForKey:@"results"];
                    if ([parsedDictionaryWorkApprovalDetails isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parsedDictionaryWorkApprovalDetails] forKey:@"resultWorkApprovalsData"];
                    }
                    else if([parsedDictionaryWorkApprovalDetails isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parsedDictionaryWorkApprovalDetails forKey:@"resultWorkApprovalsData"];
                    }
                }
            }
            
            return xmlDoc;
            
          }
     }
    return [NSMutableDictionary dictionary];
}

- (NSMutableDictionary *)parseForListOfDueOrders:(NSDictionary *)resultDictionary
{
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    
    NSDictionary *parseDictionary,*parseDictionaryHeaderPermits,*parseDictionaryOperationTransaction,*parseDictionaryComponentsTransaction,*parseDictionaryLongText,*parseDictionaryDocs,*parseDictionaryWSM,*parseDictionaryObjects,*parsedDictionaryOrderStatus,*parsedDictionaryOrderOlist,*parsedDictionaryCheckPoints,*parsedDictionaryWorkApplications,*parsedDictionaryWcagns,*parsedDictionaryOpWCDDetails,*parsedDictionaryOpWCDItemDetails,*parsedDictionaryWorkApprovalDetails,*parsedDictionaryMeasurementDocuments,*parseHeaderDictionary;
    
    if ([resultDictionary objectForKey:@"d"])
    {
        parseDictionary = [resultDictionary objectForKey:@"d"];
        
        if ([parseDictionary objectForKey:@"results"])
        {
            id dataObject = [parseDictionary objectForKey:@"results"];
            
            if ([dataObject isKindOfClass:[NSDictionary class]]) {
                
                parseDictionaryHeaderPermits = [dataObject copy];
                parseDictionaryOperationTransaction = [dataObject copy];
                parseDictionaryComponentsTransaction = [dataObject copy];
                parseDictionaryLongText = [dataObject copy];
                parseDictionaryDocs = [dataObject copy];
                parseDictionaryWSM = [dataObject copy];
                parseDictionaryObjects = [dataObject copy];
                parsedDictionaryOrderStatus = [dataObject copy];
                parsedDictionaryOrderOlist = [dataObject copy];
                parsedDictionaryCheckPoints = [dataObject copy];
                parsedDictionaryWorkApplications = [dataObject copy];
                parsedDictionaryWcagns = [dataObject copy];
                parsedDictionaryOpWCDDetails = [dataObject copy];
                parsedDictionaryOpWCDItemDetails = [dataObject copy];
                parsedDictionaryWorkApprovalDetails = [dataObject copy];
                parsedDictionaryMeasurementDocuments = [dataObject copy];
                parseHeaderDictionary = [dataObject copy];

                
            }
            else if ([dataObject isKindOfClass:[NSArray class]])
            {
                if ([dataObject count]) {
                parseDictionaryHeaderPermits = [[dataObject objectAtIndex:0] copy];
                parseDictionaryOperationTransaction = [[dataObject objectAtIndex:0] copy];
                parseDictionaryComponentsTransaction = [[dataObject objectAtIndex:0] copy];
                parseDictionaryLongText = [[dataObject objectAtIndex:0] copy];
                parseDictionaryDocs = [[dataObject objectAtIndex:0] copy];
                parseDictionaryWSM = [[dataObject objectAtIndex:0] copy];
                parseDictionaryObjects = [[dataObject objectAtIndex:0] copy];
                parsedDictionaryOrderStatus = [[dataObject objectAtIndex:0] copy];
                parsedDictionaryOrderOlist = [[dataObject objectAtIndex:0] copy];
                parsedDictionaryCheckPoints = [[dataObject objectAtIndex:0] copy];
                parsedDictionaryWorkApplications = [[dataObject objectAtIndex:0] copy];
                parsedDictionaryWcagns = [[dataObject objectAtIndex:0] copy];
                parsedDictionaryOpWCDDetails = [[dataObject objectAtIndex:0] copy];
                parsedDictionaryOpWCDItemDetails = [[dataObject objectAtIndex:0] copy];
                parsedDictionaryWorkApprovalDetails = [[dataObject objectAtIndex:0] copy];
                parsedDictionaryMeasurementDocuments = [[dataObject objectAtIndex:0] copy];
                parseHeaderDictionary = [[dataObject objectAtIndex:0] copy];
                    
                }
             }
       
           
            if ([parseHeaderDictionary objectForKey:@"EtOrderHeader"]) {
                parseHeaderDictionary = [parseHeaderDictionary objectForKey:@"EtOrderHeader"];
                if ([parseHeaderDictionary objectForKey:@"results"]) {
                    parseHeaderDictionary = [parseHeaderDictionary objectForKey:@"results"];
                    if ([parseHeaderDictionary isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseHeaderDictionary] forKey:@"resultHeader"];
                    }
                    else if([parseHeaderDictionary isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseHeaderDictionary forKey:@"resultHeader"];
                    }
                }
            }
            
            if ([parseDictionaryObjects objectForKey:@"EtOrderOlist"]) {
                parseDictionaryObjects = [parseDictionaryObjects objectForKey:@"EtOrderOlist"];
                if ([parseDictionaryObjects objectForKey:@"results"]) {
                    parseDictionaryObjects = [parseDictionaryObjects objectForKey:@"results"];
                    if ([parseDictionaryObjects isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryObjects] forKey:@"resultHeaderObjects"];
                    }
                    else if([parseDictionaryObjects isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryObjects forKey:@"resultHeaderObjects"];
                    }
                }
            }
            
            if ([parsedDictionaryMeasurementDocuments objectForKey:@"EtImrg"]) {
                parsedDictionaryMeasurementDocuments = [parsedDictionaryMeasurementDocuments objectForKey:@"EtImrg"];
                if ([parsedDictionaryMeasurementDocuments objectForKey:@"results"]) {
                    parsedDictionaryMeasurementDocuments = [parsedDictionaryMeasurementDocuments objectForKey:@"results"];
                    if ([parsedDictionaryMeasurementDocuments isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parsedDictionaryMeasurementDocuments] forKey:@"resultMeasurementDocuments"];
                    }
                    else if([parsedDictionaryMeasurementDocuments isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parsedDictionaryMeasurementDocuments forKey:@"resultMeasurementDocuments"];
                    }
                }
            }
            
            if ([parseDictionaryHeaderPermits objectForKey:@"EtOrderPermits"]) {
                parseDictionaryHeaderPermits = [parseDictionaryHeaderPermits objectForKey:@"EtOrderPermits"];
                if ([parseDictionaryHeaderPermits objectForKey:@"results"]) {
                    parseDictionaryHeaderPermits = [parseDictionaryHeaderPermits objectForKey:@"results"];
                    if ([parseDictionaryHeaderPermits isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryHeaderPermits] forKey:@"resultHeaderPermits"];
                    }
                    else if([parseDictionaryHeaderPermits isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryHeaderPermits forKey:@"resultHeaderPermits"];
                    }
                }
            }
            
            if ([parseDictionaryOperationTransaction objectForKey:@"EtOrderOperations"]) {
                parseDictionaryOperationTransaction = [parseDictionaryOperationTransaction objectForKey:@"EtOrderOperations"];
                if ([parseDictionaryOperationTransaction objectForKey:@"results"]) {
                    parseDictionaryOperationTransaction = [parseDictionaryOperationTransaction objectForKey:@"results"];
                    if ([parseDictionaryOperationTransaction isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryOperationTransaction] forKey:@"resultOperationsTransactions"];
                    }
                    else if([parseDictionaryOperationTransaction isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryOperationTransaction forKey:@"resultOperationsTransactions"];
                    }
                }
            }
            
            if ([parseDictionaryComponentsTransaction objectForKey:@"EtOrderComponents"]) {
                parseDictionaryComponentsTransaction = [parseDictionaryComponentsTransaction objectForKey:@"EtOrderComponents"];
                if ([parseDictionaryComponentsTransaction objectForKey:@"results"]) {
                    parseDictionaryComponentsTransaction = [parseDictionaryComponentsTransaction objectForKey:@"results"];
                    if ([parseDictionaryComponentsTransaction isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryComponentsTransaction] forKey:@"resultComponentsTransactions"];
                    }
                    else if([parseDictionaryComponentsTransaction isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryComponentsTransaction forKey:@"resultComponentsTransactions"];
                    }
                }
            }
            
            if ([parseDictionaryLongText objectForKey:@"EtOrderLongtext"]) {
                parseDictionaryLongText = [parseDictionaryLongText objectForKey:@"EtOrderLongtext"];
                if ([parseDictionaryLongText objectForKey:@"results"]) {
                    parseDictionaryLongText = [parseDictionaryLongText objectForKey:@"results"];
                    if ([parseDictionaryLongText isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryLongText] forKey:@"resultLongText"];
                    }
                    else if([parseDictionaryLongText isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryLongText forKey:@"resultLongText"];
                    }
                }
            }
            
            if ([parseDictionaryDocs objectForKey:@"EtDocs"]) {
                parseDictionaryDocs = [parseDictionaryDocs objectForKey:@"EtDocs"];
                if ([parseDictionaryDocs objectForKey:@"results"]) {
                    parseDictionaryDocs = [parseDictionaryDocs objectForKey:@"results"];
                    if ([parseDictionaryDocs isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryDocs] forKey:@"resultDocs"];
                    }
                    else if([parseDictionaryDocs isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryDocs forKey:@"resultDocs"];
                    }
                }
            }
            
            if ([parseDictionaryWSM objectForKey:@"EtWsmOrdSafemeas"]) {
                parseDictionaryWSM = [parseDictionaryWSM objectForKey:@"EtWsmOrdSafemeas"];
                if ([parseDictionaryWSM objectForKey:@"results"]) {
                    parseDictionaryWSM = [parseDictionaryWSM objectForKey:@"results"];
                    if ([parseDictionaryWSM isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryWSM] forKey:@"resultWSMSafetyMeasures"];
                    }
                    else if([parseDictionaryWSM isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryWSM forKey:@"resultWSMSafetyMeasures"];
                    }
                }
            }
            
            if ([parsedDictionaryOrderStatus objectForKey:@"EtOrderStatus"]) {
                parsedDictionaryOrderStatus = [parsedDictionaryOrderStatus objectForKey:@"EtOrderStatus"];
                if ([parsedDictionaryOrderStatus objectForKey:@"results"]) {
                    parsedDictionaryOrderStatus = [parsedDictionaryOrderStatus objectForKey:@"results"];
                    if ([parsedDictionaryOrderStatus isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parsedDictionaryOrderStatus] forKey:@"resultOrderStatus"];
                    }
                    else if([parsedDictionaryOrderStatus isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parsedDictionaryOrderStatus forKey:@"resultOrderStatus"];
                    }
                }
            }
            
            if ([parsedDictionaryOrderOlist objectForKey:@"EtOrderOlist"]) {
                parsedDictionaryOrderOlist = [parsedDictionaryOrderOlist objectForKey:@"EtOrderOlist"];
                if ([parsedDictionaryOrderOlist objectForKey:@"results"]) {
                    parsedDictionaryOrderOlist = [parsedDictionaryOrderOlist objectForKey:@"results"];
                    if ([parsedDictionaryOrderOlist isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parsedDictionaryOrderOlist] forKey:@"resultOrderOlist"];
                    }
                    else if([parsedDictionaryOrderOlist isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parsedDictionaryOrderOlist forKey:@"resultOrderOlist"];
                    }
                }
            }
            
            //WCM
            if ([parsedDictionaryCheckPoints objectForKey:@"EtWcmWaChkReq"]) {
                parsedDictionaryCheckPoints = [parsedDictionaryCheckPoints objectForKey:@"EtWcmWaChkReq"];
                if ([parsedDictionaryCheckPoints objectForKey:@"results"]) {
                    parsedDictionaryCheckPoints = [parsedDictionaryCheckPoints objectForKey:@"results"];
                    if ([parsedDictionaryCheckPoints isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parsedDictionaryCheckPoints] forKey:@"resultStandardCheckPoints"];
                    }
                    else if([parsedDictionaryCheckPoints isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parsedDictionaryCheckPoints forKey:@"resultStandardCheckPoints"];
                    }
                }
            }
            
            if ([parsedDictionaryWorkApplications objectForKey:@"EtWcmWaData"]) {
                parsedDictionaryWorkApplications = [parsedDictionaryWorkApplications objectForKey:@"EtWcmWaData"];
                if ([parsedDictionaryWorkApplications objectForKey:@"results"]) {
                    parsedDictionaryWorkApplications = [parsedDictionaryWorkApplications objectForKey:@"results"];
                    if ([parsedDictionaryWorkApplications isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parsedDictionaryWorkApplications] forKey:@"resultWorkApplicationData"];
                    }
                    else if([parsedDictionaryWorkApplications isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parsedDictionaryWorkApplications forKey:@"resultWorkApplicationData"];
                    }
                }
            }
            
            if ([parsedDictionaryWcagns objectForKey:@"EtWcmWcagns"]) {
                parsedDictionaryWcagns = [parsedDictionaryWcagns objectForKey:@"EtWcmWcagns"];
                if ([parsedDictionaryWcagns objectForKey:@"results"]) {
                    parsedDictionaryWcagns = [parsedDictionaryWcagns objectForKey:@"results"];
                    if ([parsedDictionaryWcagns isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parsedDictionaryWcagns] forKey:@"resultIssuePermits"];//issue permits
                    }
                    else if([parsedDictionaryWcagns isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parsedDictionaryWcagns forKey:@"resultIssuePermits"];//issue permits
                    }
                }
            }
            
            if ([parsedDictionaryOpWCDDetails objectForKey:@"EtWcmWdData"]) {
                parsedDictionaryOpWCDDetails = [parsedDictionaryOpWCDDetails objectForKey:@"EtWcmWdData"];
                if ([parsedDictionaryOpWCDDetails objectForKey:@"results"]) {
                    parsedDictionaryOpWCDDetails = [parsedDictionaryOpWCDDetails objectForKey:@"results"];
                    if ([parsedDictionaryOpWCDDetails isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parsedDictionaryOpWCDDetails] forKey:@"resultOperationWCDData"];//isolation
                    }
                    else if([parsedDictionaryOpWCDDetails isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parsedDictionaryOpWCDDetails forKey:@"resultOperationWCDData"];//isolation
                    }
                }
            }
            
            if ([parsedDictionaryOpWCDItemDetails objectForKey:@"EtWcmWdItemData"]) {
                parsedDictionaryOpWCDItemDetails = [parsedDictionaryOpWCDItemDetails objectForKey:@"EtWcmWdItemData"];
                if ([parsedDictionaryOpWCDItemDetails objectForKey:@"results"]) {
                    parsedDictionaryOpWCDItemDetails = [parsedDictionaryOpWCDItemDetails objectForKey:@"results"];
                    if ([parsedDictionaryOpWCDItemDetails isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parsedDictionaryOpWCDItemDetails] forKey:@"resultOperationWCDItemData"];//tagging conditions
                    }
                    else if([parsedDictionaryOpWCDItemDetails isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parsedDictionaryOpWCDItemDetails forKey:@"resultOperationWCDItemData"];//tagging conditions
                    }
                }
            }
            
            if ([parsedDictionaryWorkApprovalDetails objectForKey:@"EtWcmWwData"]) {
                parsedDictionaryWorkApprovalDetails = [parsedDictionaryWorkApprovalDetails objectForKey:@"EtWcmWwData"];
                if ([parsedDictionaryWorkApprovalDetails objectForKey:@"results"]) {
                    parsedDictionaryWorkApprovalDetails = [parsedDictionaryWorkApprovalDetails objectForKey:@"results"];
                    if ([parsedDictionaryWorkApprovalDetails isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parsedDictionaryWorkApprovalDetails] forKey:@"resultWorkApprovalsData"];
                    }
                    else if([parsedDictionaryWorkApprovalDetails isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parsedDictionaryWorkApprovalDetails forKey:@"resultWorkApprovalsData"];
                    }
                }
            }
            
            return xmlDoc;
        }
    }
    
    return [NSMutableDictionary dictionary];
}

- (NSMutableDictionary *)parseForListOfPMBOMSItemData:(NSDictionary *)resultDictionary
{
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    NSDictionary *parseDictionary,*parseMatnrDictionary,*parseStockDictionary,*parseResponseDictionary;
    
    if ([resultDictionary objectForKey:@"d"])
    {
        parseResponseDictionary = [resultDictionary objectForKey:@"d"];
        
        if ([parseResponseDictionary objectForKey:@"results"])
        {
            id dataObject = [parseResponseDictionary objectForKey:@"results"];
            
            if ([dataObject isKindOfClass:[NSDictionary class]]) {
                 parseDictionary=[dataObject copy];
                parseStockDictionary=[dataObject copy];
                parseMatnrDictionary=[dataObject copy];

              }
            else if ([dataObject isKindOfClass:[NSArray class]])
            {
                parseDictionary=[[dataObject objectAtIndex:0] copy];
                 parseMatnrDictionary=[[dataObject objectAtIndex:0] copy];
                parseStockDictionary=[[dataObject objectAtIndex:0] copy];
                
            }
            
            
            if ([parseDictionary objectForKey:@"EtBomItem"]) {
                parseDictionary = [parseDictionary objectForKey:@"EtBomItem"];
                if ([parseDictionary objectForKey:@"results"]) {
                    parseDictionary = [parseDictionary objectForKey:@"results"];
                    if ([parseDictionary isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionary] forKey:@"resultTransaction"];
                    }
                    else if([parseDictionary isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionary forKey:@"resultTransaction"];
                    }
                }
            }
            
            
            if ([parseMatnrDictionary objectForKey:@"EtMaterial"]) {
                parseMatnrDictionary = [parseMatnrDictionary objectForKey:@"EtMaterial"];
                if ([parseMatnrDictionary objectForKey:@"results"]) {
                    parseMatnrDictionary = [parseMatnrDictionary objectForKey:@"results"];
                    if ([parseMatnrDictionary isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseMatnrDictionary] forKey:@"resultMaterial"];
                    }
                    else if([parseMatnrDictionary isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseMatnrDictionary forKey:@"resultMaterial"];
                    }
                }
            }
            
            
            if ([parseStockDictionary objectForKey:@"EtStock"]) {
                parseStockDictionary = [parseStockDictionary objectForKey:@"EtStock"];
                if ([parseStockDictionary objectForKey:@"results"]) {
                    parseStockDictionary = [parseStockDictionary objectForKey:@"results"];
                    if ([parseStockDictionary isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseStockDictionary] forKey:@"resultStock"];
                    }
                    else if([parseStockDictionary isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseStockDictionary forKey:@"resultStock"];
                    }
                }
            }
            
            
            NSMutableDictionary *equipmentBOM = [NSMutableDictionary new];
            
             if([xmlDoc objectForKey:@"resultTransaction"]){
                
                [equipmentBOM setObject:[xmlDoc objectForKey:@"resultTransaction"] forKey:@"BOMTransaction"];
                
                [[DataBase sharedInstance] insertEquipmentBOMToCoreDataFromArray:equipmentBOM];
            }
            
            NSMutableDictionary *materialBOM = [NSMutableDictionary new];
 
            if([xmlDoc objectForKey:@"resultMaterial"]){
                 [materialBOM setObject:[xmlDoc objectForKey:@"resultMaterial"] forKey:@"Material"];
                 [[DataBase sharedInstance] insertMaterialsToCoreDataFromBomItemsArray:materialBOM];
             }
            
            NSMutableDictionary *stockOverView = [NSMutableDictionary new];
            
            if([xmlDoc objectForKey:@"resultStock"]){
                 [stockOverView setObject:[xmlDoc objectForKey:@"resultStock"] forKey:@"StocKView"];
                 [[DataBase sharedInstance] insertStocksToCoreDataFromBomItemsArray:stockOverView];
             }
         }
    }
    
    return [NSMutableDictionary dictionary];
}


- (NSMutableDictionary *)parseForCreateNotification:(NSDictionary *)resultDictionary
{
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    NSDictionary *parseDictionary,*parseDictionaryTransaction,*parseDictionaryLongText,*parseDictionaryDocs,*parseDictionaryTasks,*parseDictionaryNotifStatus,*parseInspectionDictionary,*parseHeaderDictionary,*parseMessageDictionary,*parsedDuplicateDataDictionary,*parseActivityDictionary;
    
    if ([resultDictionary objectForKey:@"d"])
    {
        parseDictionary = [resultDictionary copy];
        
        if ([parseDictionary objectForKey:@"d"])
        {
            id dataObject = [parseDictionary objectForKey:@"d"];
            
            if ([dataObject isKindOfClass:[NSDictionary class]]) {
                parseDictionaryTransaction = [dataObject copy];
                parseDictionaryLongText = [dataObject copy];
                parseDictionaryDocs = [dataObject copy];
                parseDictionaryTasks = [dataObject copy];
                parseDictionaryNotifStatus = [dataObject copy];
                parseInspectionDictionary = [dataObject copy];
                parseHeaderDictionary = [dataObject copy];
                parseMessageDictionary = [dataObject copy];
                parsedDuplicateDataDictionary=[dataObject copy];
                parseActivityDictionary=[dataObject copy];
                
            }
            else if ([dataObject isKindOfClass:[NSArray class]]){
                
                if ([dataObject count])
                {
                    parseDictionaryTransaction = [[dataObject objectAtIndex:0] copy];
                    parseDictionaryLongText = [[dataObject objectAtIndex:0] copy];
                    parseDictionaryDocs = [[dataObject objectAtIndex:0] copy];
                    parseDictionaryTasks = [[dataObject objectAtIndex:0] copy];
                    parseDictionaryNotifStatus = [[dataObject objectAtIndex:0] copy];
                    parseInspectionDictionary = [[dataObject objectAtIndex:0] copy];
                    parseHeaderDictionary = [[dataObject objectAtIndex:0] copy];
                    parseMessageDictionary = [[dataObject objectAtIndex:0] copy];
                    parsedDuplicateDataDictionary=[[dataObject objectAtIndex:0] copy];
                    parseActivityDictionary=[[dataObject objectAtIndex:0] copy];

                }
                
            }
            
            
            id messageObject=[parseMessageDictionary copy];
            
            if ([[messageObject objectForKey:@"EvMessage"] objectForKey:@"results"]) {
                
                if ([[[messageObject objectForKey:@"EvMessage"] objectForKey:@"results"] isKindOfClass:[NSDictionary class]]){
                    
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:[[[[messageObject objectForKey:@"EvMessage"] objectForKey:@"results"] objectAtIndex:0] objectForKey:@"Message"]] forKey:@"MESSAGE"];
                    
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:[[[[messageObject objectForKey:@"EvMessage"] objectForKey:@"results"] objectAtIndex:0] objectForKey:@"Qmnum"]] forKey:@"OBJECTID"];
                    
                }
                else if ([[[messageObject objectForKey:@"EvMessage"] objectForKey:@"results"] isKindOfClass:[NSArray class]]){
                    
                    if ([[[messageObject objectForKey:@"EvMessage"] objectForKey:@"results"] count])
                    {
                        [xmlDoc setObject:[[[[messageObject objectForKey:@"EvMessage"] objectForKey:@"results"] objectAtIndex:0] objectForKey:@"Message"] forKey:@"MESSAGE"];
                        
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:[[[[messageObject objectForKey:@"EvMessage"] objectForKey:@"results"] objectAtIndex:0] objectForKey:@"Qmnum"]] forKey:@"OBJECTID"];
                    }
                    
                }
            }
            
            
            if ([parsedDuplicateDataDictionary objectForKey:@"EtNotifDup"]) {
                
                if (![NullChecker isNull:[parseHeaderDictionary objectForKey:@"EtNotifDup"]]) {
                 parsedDuplicateDataDictionary = [parsedDuplicateDataDictionary objectForKey:@"EtNotifDup"];
                if ([parsedDuplicateDataDictionary objectForKey:@"results"]) {
                    parsedDuplicateDataDictionary = [parsedDuplicateDataDictionary objectForKey:@"results"];
                    if ([parsedDuplicateDataDictionary isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parsedDuplicateDataDictionary] forKey:@"resultDuplicates"];
                    }
                    else if([parsedDuplicateDataDictionary isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parsedDuplicateDataDictionary forKey:@"resultDuplicates"];
                    }
                  }
                }
            }
            
            if ([parseHeaderDictionary objectForKey:@"EtNotifHeader"]) {
                if (![NullChecker isNull:[parseHeaderDictionary objectForKey:@"EtNotifHeader"]]) {
                     parseHeaderDictionary = [parseHeaderDictionary objectForKey:@"EtNotifHeader"];
                    if ([parseHeaderDictionary objectForKey:@"results"]) {
                        parseHeaderDictionary = [parseHeaderDictionary objectForKey:@"results"];
                        if ([parseHeaderDictionary isKindOfClass:[NSDictionary class]]) {
                            [xmlDoc setObject:[NSMutableArray arrayWithObject:parseHeaderDictionary] forKey:@"resultHeader"];
                        }
                        else if([parseHeaderDictionary isKindOfClass:[NSArray class]])
                        {
                            [xmlDoc setObject:parseHeaderDictionary forKey:@"resultHeader"];
                        }
                    }
                }
             }
            
            if ([parseActivityDictionary objectForKey:@"EtNotifActvs"]) {
                
                if (![NullChecker isNull:[parseActivityDictionary objectForKey:@"EtNotifActvs"]]) {

                parseActivityDictionary = [parseActivityDictionary objectForKey:@"EtNotifActvs"];
                if ([parseActivityDictionary objectForKey:@"results"]) {
                    parseActivityDictionary = [parseActivityDictionary objectForKey:@"results"];
                    
                    if ([parseActivityDictionary isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseActivityDictionary] forKey:@"resultActivities"];
                    }
                    else if([parseActivityDictionary isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseActivityDictionary forKey:@"resultActivities"];
                    }
                   }
                 }
            }
            
            if ([parseInspectionDictionary objectForKey:@"EtImrg"]) {
                
                if (![NullChecker isNull:[parseInspectionDictionary objectForKey:@"EtImrg"]]) {
 
                    if ([parseInspectionDictionary objectForKey:@"results"]) {
                        parseInspectionDictionary = [parseInspectionDictionary objectForKey:@"results"];
                        if ([parseInspectionDictionary isKindOfClass:[NSDictionary class]]) {
                            [xmlDoc setObject:[NSMutableArray arrayWithObject:parseInspectionDictionary] forKey:@"resultInspection"];
                        }
                        else if([parseInspectionDictionary isKindOfClass:[NSArray class]])
                        {
                            [xmlDoc setObject:parseInspectionDictionary forKey:@"resultInspection"];
                        }
                    }
                }
               
            }
 
            if ([parseDictionaryTransaction objectForKey:@"EtNotifItems"]) {
                
                if (![NullChecker isNull:[parseDictionaryTransaction objectForKey:@"EtNotifItems"]]) {

                    parseDictionaryTransaction = [parseDictionaryTransaction objectForKey:@"EtNotifItems"];
                    if ([parseDictionaryTransaction objectForKey:@"results"]) {
                        parseDictionaryTransaction = [parseDictionaryTransaction objectForKey:@"results"];
                        if ([parseDictionaryTransaction isKindOfClass:[NSDictionary class]]) {
                            [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryTransaction] forKey:@"resultTransactions"];
                        }
                        else if([parseDictionaryTransaction isKindOfClass:[NSArray class]])
                        {
                            [xmlDoc setObject:parseDictionaryTransaction forKey:@"resultTransactions"];
                        }
                    }
                }
 
            }
            
            if ([parseDictionaryLongText objectForKey:@"EtNotifLongtext"]) {
                
                if (![NullChecker isNull:[parseDictionaryLongText objectForKey:@"EtNotifLongtext"]]) {
 
                 parseDictionaryLongText = [parseDictionaryLongText objectForKey:@"EtNotifLongtext"];
                if ([parseDictionaryLongText objectForKey:@"results"]) {
                    parseDictionaryLongText = [parseDictionaryLongText objectForKey:@"results"];
                    if ([parseDictionaryLongText isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryLongText] forKey:@"resultLongText"];
                    }
                    else if([parseDictionaryLongText isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryLongText forKey:@"resultLongText"];
                    }
                 }
              
                }
            }
            
            if ([parseDictionaryDocs objectForKey:@"EtDocs"]) {
                
                if (![NullChecker isNull:[parseDictionaryDocs objectForKey:@"EtDocs"]]) {

                  parseDictionaryDocs = [parseDictionaryDocs objectForKey:@"EtDocs"];
                    if ([parseDictionaryDocs objectForKey:@"results"]) {
                    parseDictionaryDocs = [parseDictionaryDocs objectForKey:@"results"];
                    if ([parseDictionaryDocs isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryDocs] forKey:@"resultDocs"];
                    }
                    else if([parseDictionaryDocs isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryDocs forKey:@"resultDocs"];
                    }
                 }
               }
            }
            
            if ([parseDictionaryTasks objectForKey:@"EtNotifTasks"]) {
                
                if (![NullChecker isNull:[parseDictionaryTasks objectForKey:@"EtNotifTasks"]]) {

                 parseDictionaryTasks = [parseDictionaryTasks objectForKey:@"EtNotifTasks"];
                if ([parseDictionaryTasks objectForKey:@"results"]) {
                    parseDictionaryTasks = [parseDictionaryTasks objectForKey:@"results"];
                    if ([parseDictionaryTasks isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryTasks] forKey:@"resultTasks"];
                    }
                    else if([parseDictionaryTasks isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryTasks forKey:@"resultTasks"];
                    }
                 }
                    
                }
            }
            
            if ([parseDictionaryNotifStatus objectForKey:@"EtNotifStatus"]) {
                
                if (![NullChecker isNull:[parseDictionaryNotifStatus objectForKey:@"EtNotifStatus"]]) {
 
                    parseDictionaryNotifStatus = [parseDictionaryNotifStatus objectForKey:@"EtNotifStatus"];
                 if ([parseDictionaryNotifStatus objectForKey:@"results"]) {
                    parseDictionaryNotifStatus = [parseDictionaryNotifStatus objectForKey:@"results"];
                    if ([parseDictionaryNotifStatus isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryNotifStatus] forKey:@"resultNotifStatus"];
                    }
                    else if([parseDictionaryNotifStatus isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryNotifStatus forKey:@"resultNotifStatus"];
                    }
                  }
              }
            }
            
            return xmlDoc;
            
        }
    }
    return [NSMutableDictionary dictionary];
}


- (NSMutableDictionary *)parseForChangeNotification:(NSDictionary *)resultDictionary
{
        NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
        NSDictionary *parseDictionary,*parseDictionaryTransaction,*parseDictionaryLongText,*parseDictionaryDocs,*parseDictionaryTasks,*parseDictionaryNotifStatus,*parseInspectionDictionary,*parseHeaderDictionary,*parseMessageDictionary,*parsedDuplicateDataDictionary,*parseActivityDictionary;
        
        if ([resultDictionary objectForKey:@"d"])
        {
            parseDictionary = [resultDictionary copy];
            
            if ([parseDictionary objectForKey:@"d"])
            {
                id dataObject = [parseDictionary objectForKey:@"d"];
                
                if ([dataObject isKindOfClass:[NSDictionary class]]) {
                    parseDictionaryTransaction = [dataObject copy];
                    parseDictionaryLongText = [dataObject copy];
                    parseDictionaryDocs = [dataObject copy];
                    parseDictionaryTasks = [dataObject copy];
                    parseDictionaryNotifStatus = [dataObject copy];
                    parseInspectionDictionary = [dataObject copy];
                    parseHeaderDictionary = [dataObject copy];
                    parseMessageDictionary = [dataObject copy];
                    parsedDuplicateDataDictionary=[dataObject copy];
                    parseActivityDictionary=[dataObject copy];

                    
                    
                }
                else if ([dataObject isKindOfClass:[NSArray class]]){
                    
                    if ([dataObject count])
                    {
                        parseDictionaryTransaction = [[dataObject objectAtIndex:0] copy];
                        parseDictionaryLongText = [[dataObject objectAtIndex:0] copy];
                        parseDictionaryDocs = [[dataObject objectAtIndex:0] copy];
                        parseDictionaryTasks = [[dataObject objectAtIndex:0] copy];
                        parseDictionaryNotifStatus = [[dataObject objectAtIndex:0] copy];
                        parseInspectionDictionary = [[dataObject objectAtIndex:0] copy];
                        parseHeaderDictionary = [[dataObject objectAtIndex:0] copy];
                        parseMessageDictionary = [[dataObject objectAtIndex:0] copy];
                        parsedDuplicateDataDictionary=[[[dataObject objectAtIndex:0] copy] copy];
                        parseActivityDictionary = [[dataObject objectAtIndex:0] copy];
                    }
                    
                }
                
                
                id messageObject=[parseMessageDictionary copy];
                
                if ([[messageObject objectForKey:@"EvMessage"] objectForKey:@"results"]) {
                    
                    if ([[[messageObject objectForKey:@"EvMessage"] objectForKey:@"results"] isKindOfClass:[NSDictionary class]]){
                        
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:[[[[messageObject objectForKey:@"EvMessage"] objectForKey:@"results"] objectAtIndex:0] objectForKey:@"Message"]] forKey:@"MESSAGE"];
                        
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:[[[[messageObject objectForKey:@"EvMessage"] objectForKey:@"results"] objectAtIndex:0] objectForKey:@"Qmnum"]] forKey:@"OBJECTID"];
                        
                    }
                    else if ([[[messageObject objectForKey:@"EvMessage"] objectForKey:@"results"] isKindOfClass:[NSArray class]]){
                        
                        if ([[[messageObject objectForKey:@"EvMessage"] objectForKey:@"results"] count])
                        {
                            [xmlDoc setObject:[[[[messageObject objectForKey:@"EvMessage"] objectForKey:@"results"] objectAtIndex:0] objectForKey:@"Message"] forKey:@"MESSAGE"];
                            
                            [xmlDoc setObject:[NSMutableArray arrayWithObject:[[[[messageObject objectForKey:@"EvMessage"] objectForKey:@"results"] objectAtIndex:0] objectForKey:@"Qmnum"]] forKey:@"OBJECTID"];
                        }
                        
                    }
                }
                
                
                if ([parseActivityDictionary objectForKey:@"EtNotifActvs"]) {
                    
                    if (![NullChecker isNull:[parseActivityDictionary objectForKey:@"EtNotifActvs"]]) {
                        
                        parseActivityDictionary = [parseActivityDictionary objectForKey:@"EtNotifActvs"];
                        if ([parseActivityDictionary objectForKey:@"results"]) {
                            parseActivityDictionary = [parseActivityDictionary objectForKey:@"results"];
                            
                            if ([parseActivityDictionary isKindOfClass:[NSDictionary class]]) {
                                [xmlDoc setObject:[NSMutableArray arrayWithObject:parseActivityDictionary] forKey:@"resultActivities"];
                            }
                            else if([parseActivityDictionary isKindOfClass:[NSArray class]])
                            {
                                [xmlDoc setObject:parseActivityDictionary forKey:@"resultActivities"];
                            }
                        }
                    }
                }
                
                
                if ([parsedDuplicateDataDictionary objectForKey:@"EtNotifDup"]) {
                    
                    if (![NullChecker isNull:[parseHeaderDictionary objectForKey:@"EtNotifDup"]]) {
                        parsedDuplicateDataDictionary = [parsedDuplicateDataDictionary objectForKey:@"EtNotifDup"];
                        if ([parsedDuplicateDataDictionary objectForKey:@"results"]) {
                            parsedDuplicateDataDictionary = [parsedDuplicateDataDictionary objectForKey:@"results"];
                            if ([parsedDuplicateDataDictionary isKindOfClass:[NSDictionary class]]) {
                                [xmlDoc setObject:[NSMutableArray arrayWithObject:parsedDuplicateDataDictionary] forKey:@"resultDuplicates"];
                            }
                            else if([parsedDuplicateDataDictionary isKindOfClass:[NSArray class]])
                            {
                                [xmlDoc setObject:parsedDuplicateDataDictionary forKey:@"resultDuplicates"];
                            }
                        }
                    }
                }
                
                if ([parseHeaderDictionary objectForKey:@"EtNotifHeader"]) {
                    if (![NullChecker isNull:[parseHeaderDictionary objectForKey:@"EtNotifHeader"]]) {
                        parseHeaderDictionary = [parseHeaderDictionary objectForKey:@"EtNotifHeader"];
                        if ([parseHeaderDictionary objectForKey:@"results"]) {
                            parseHeaderDictionary = [parseHeaderDictionary objectForKey:@"results"];
                            if ([parseHeaderDictionary isKindOfClass:[NSDictionary class]]) {
                                [xmlDoc setObject:[NSMutableArray arrayWithObject:parseHeaderDictionary] forKey:@"resultHeader"];
                            }
                            else if([parseHeaderDictionary isKindOfClass:[NSArray class]])
                            {
                                [xmlDoc setObject:parseHeaderDictionary forKey:@"resultHeader"];
                            }
                        }
                    }
                }
                
                if ([parseInspectionDictionary objectForKey:@"EtImrg"]) {
                    
                    if (![NullChecker isNull:[parseInspectionDictionary objectForKey:@"EtImrg"]]) {
                        
                        if ([parseInspectionDictionary objectForKey:@"results"]) {
                            parseInspectionDictionary = [parseInspectionDictionary objectForKey:@"results"];
                            if ([parseInspectionDictionary isKindOfClass:[NSDictionary class]]) {
                                [xmlDoc setObject:[NSMutableArray arrayWithObject:parseInspectionDictionary] forKey:@"resultInspection"];
                            }
                            else if([parseInspectionDictionary isKindOfClass:[NSArray class]])
                            {
                                [xmlDoc setObject:parseInspectionDictionary forKey:@"resultInspection"];
                            }
                        }
                    }
                    
                }
                
                if ([parseDictionaryTransaction objectForKey:@"EtNotifItems"]) {
                    
                    if (![NullChecker isNull:[parseDictionaryTransaction objectForKey:@"EtNotifItems"]]) {
                        
                        parseDictionaryTransaction = [parseDictionaryTransaction objectForKey:@"EtNotifItems"];
                        if ([parseDictionaryTransaction objectForKey:@"results"]) {
                            parseDictionaryTransaction = [parseDictionaryTransaction objectForKey:@"results"];
                            if ([parseDictionaryTransaction isKindOfClass:[NSDictionary class]]) {
                                [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryTransaction] forKey:@"resultTransactions"];
                            }
                            else if([parseDictionaryTransaction isKindOfClass:[NSArray class]])
                            {
                                [xmlDoc setObject:parseDictionaryTransaction forKey:@"resultTransactions"];
                            }
                        }
                    }
                    
                }
                
 
              if ([parseDictionaryLongText objectForKey:@"EtNotifLongtext"]) {
                    
                    if (![NullChecker isNull:[parseDictionaryLongText objectForKey:@"EtNotifLongtext"]]) {
                         parseDictionaryLongText = [parseDictionaryLongText objectForKey:@"EtNotifLongtext"];
                        if ([parseDictionaryLongText objectForKey:@"results"]) {
                            parseDictionaryLongText = [parseDictionaryLongText objectForKey:@"results"];
                            if ([parseDictionaryLongText isKindOfClass:[NSDictionary class]]) {
                                [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryLongText] forKey:@"resultLongText"];
                            }
                            else if([parseDictionaryLongText isKindOfClass:[NSArray class]])
                            {
                                [xmlDoc setObject:parseDictionaryLongText forKey:@"resultLongText"];
                            }
                        }
                        
                    }
              }
                
                
                if ([parseDictionaryDocs objectForKey:@"EtDocs"]) {
                    
                    if (![NullChecker isNull:[parseDictionaryDocs objectForKey:@"EtDocs"]]) {
                        
                        parseDictionaryDocs = [parseDictionaryDocs objectForKey:@"EtDocs"];
                        if ([parseDictionaryDocs objectForKey:@"results"]) {
                            parseDictionaryDocs = [parseDictionaryDocs objectForKey:@"results"];
                            if ([parseDictionaryDocs isKindOfClass:[NSDictionary class]]) {
                                [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryDocs] forKey:@"resultDocs"];
                            }
                            else if([parseDictionaryDocs isKindOfClass:[NSArray class]])
                            {
                                [xmlDoc setObject:parseDictionaryDocs forKey:@"resultDocs"];
                            }
                        }
                    }
                }
                
                if ([parseDictionaryTasks objectForKey:@"EtNotifTasks"]) {
                    
                    if (![NullChecker isNull:[parseDictionaryTasks objectForKey:@"EtNotifTasks"]]) {
                        
                        parseDictionaryTasks = [parseDictionaryTasks objectForKey:@"EtNotifTasks"];
                        if ([parseDictionaryTasks objectForKey:@"results"]) {
                            parseDictionaryTasks = [parseDictionaryTasks objectForKey:@"results"];
                            if ([parseDictionaryTasks isKindOfClass:[NSDictionary class]]) {
                                [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryTasks] forKey:@"resultTasks"];
                            }
                            else if([parseDictionaryTasks isKindOfClass:[NSArray class]])
                            {
                                [xmlDoc setObject:parseDictionaryTasks forKey:@"resultTasks"];
                            }
                        }
                        
                    }
                }
                
                if ([parseDictionaryNotifStatus objectForKey:@"EtNotifStatus"]) {
                    
                    if (![NullChecker isNull:[parseDictionaryNotifStatus objectForKey:@"EtNotifStatus"]]) {
                        
                        parseDictionaryNotifStatus = [parseDictionaryNotifStatus objectForKey:@"EtNotifStatus"];
                        if ([parseDictionaryNotifStatus objectForKey:@"results"]) {
                            parseDictionaryNotifStatus = [parseDictionaryNotifStatus objectForKey:@"results"];
                            if ([parseDictionaryNotifStatus isKindOfClass:[NSDictionary class]]) {
                                [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryNotifStatus] forKey:@"resultNotifStatus"];
                            }
                            else if([parseDictionaryNotifStatus isKindOfClass:[NSArray class]])
                            {
                                [xmlDoc setObject:parseDictionaryNotifStatus forKey:@"resultNotifStatus"];
                            }
                        }
                    }
                }
                
                return xmlDoc;
                
            }
        }
        return [NSMutableDictionary dictionary];
    }


-(NSMutableDictionary *)parseForAuthData:(NSDictionary *)resultDictionary{
    
     NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
      NSDictionary *parseDictionary;
    
    id responseDictionary;
    
     if ([resultDictionary objectForKey:@"d"]) {
        
          responseDictionary = [[resultDictionary objectForKey:@"d"] copy];
        
          if ([responseDictionary objectForKey:@"results"]){
              
              responseDictionary= [[responseDictionary objectForKey:@"results"] copy];
            
              if ([responseDictionary isKindOfClass:[NSArray class]]) {
                 
                   parseDictionary = [[responseDictionary  objectAtIndex:0] copy];
 
              }
              else if ([responseDictionary isKindOfClass:[NSDictionary class]]){
 
                  parseDictionary = [[responseDictionary objectForKey:@"results"] copy];
                 
              }
 
             if ([parseDictionary objectForKey:@"EsUser"]) {
                
             if (![NullChecker isNull:[parseDictionary objectForKey:@"EsUser"]]||[[parseDictionary objectForKey:@"EsUser"] objectForKey:@"results"]) {
 
                if ([[[parseDictionary objectForKey:@"EsUser"] objectForKey:@"results"] isKindOfClass:[NSDictionary class]])
                {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:[[parseDictionary objectForKey:@"EsUser"] objectForKey:@"results"]] forKey:@"resultUser"];
                }
                else if([[[parseDictionary objectForKey:@"EsUser"] objectForKey:@"results"] isKindOfClass:[NSArray class]])
                 {
                    [xmlDoc setObject:[[parseDictionary objectForKey:@"EsUser"] objectForKey:@"results"] forKey:@"resultUser"];
                  }
                }
            }
            
          
            if ([parseDictionary objectForKey:@"EtBusf"]) {
                
                if (![NullChecker isNull:[parseDictionary objectForKey:@"EtBusf"]]||[[parseDictionary objectForKey:@"EtBusf"] objectForKey:@"results"]) {
                    
                    if ([[[parseDictionary objectForKey:@"EtBusf"] objectForKey:@"results"] isKindOfClass:[NSDictionary class]])
                    {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:[[parseDictionary objectForKey:@"EtBusf"] objectForKey:@"results"]] forKey:@"Busfresult"];
                    }
                    else if([[[parseDictionary objectForKey:@"EtBusf"] objectForKey:@"results"] isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:[[parseDictionary objectForKey:@"EtBusf"] objectForKey:@"results"] forKey:@"Busfresult"];
                    }
                }
            }
            
            if ([parseDictionary objectForKey:@"EtMusrf"]) {
                
                if (![NullChecker isNull:[parseDictionary objectForKey:@"EtMusrf"]]||[[parseDictionary objectForKey:@"EtMusrf"] objectForKey:@"results"]) {
                    
                    if ([[[parseDictionary objectForKey:@"EtMusrf"] objectForKey:@"results"] isKindOfClass:[NSDictionary class]])
                    {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:[[parseDictionary objectForKey:@"EtMusrf"] objectForKey:@"results"]] forKey:@"MUserresult"];
                    }
                    else if([[[parseDictionary objectForKey:@"EtMusrf"] objectForKey:@"results"] isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:[[parseDictionary objectForKey:@"EtMusrf"] objectForKey:@"results"] forKey:@"MUserresult"];
                    }
                }
            }
            
            
            if ([parseDictionary objectForKey:@"EtScrf"]) {
                
                if (![NullChecker isNull:[parseDictionary objectForKey:@"EtScrf"]]||[[parseDictionary objectForKey:@"EtScrf"] objectForKey:@"results"]) {
                    
                    if ([[[parseDictionary objectForKey:@"EtScrf"] objectForKey:@"results"] isKindOfClass:[NSDictionary class]])
                    {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:[[parseDictionary objectForKey:@"EtScrf"] objectForKey:@"results"]] forKey:@"Scrfresult"];
                    }
                    else if([[[parseDictionary objectForKey:@"EtScrf"] objectForKey:@"results"] isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:[[parseDictionary objectForKey:@"EtScrf"] objectForKey:@"results"] forKey:@"Scrfresult"];
                    }
                }
            }
            
            
            if ([parseDictionary objectForKey:@"EtUsrf"]) {
                
                if (![NullChecker isNull:[parseDictionary objectForKey:@"EtUsrf"]]||[[parseDictionary objectForKey:@"EtUsrf"] objectForKey:@"results"]) {
                    
                    if ([[[parseDictionary objectForKey:@"EtUsrf"] objectForKey:@"results"] isKindOfClass:[NSDictionary class]])
                    {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:[[parseDictionary objectForKey:@"EtUsrf"] objectForKey:@"results"]] forKey:@"Usrfresult"];
                    }
                    else if([[[parseDictionary objectForKey:@"EtUsrf"] objectForKey:@"results"] isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:[[parseDictionary objectForKey:@"EtUsrf"] objectForKey:@"results"] forKey:@"Usrfresult"];
                    }
                }
            }
 
            return xmlDoc;
            
        }
    }
    
    return [NSMutableDictionary dictionary];
}

- (NSMutableDictionary *)parseForMonitorMeasurementDocs:(NSDictionary *)resultDictionary
{
    
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    NSDictionary *parseDictionary;
    
    if ([resultDictionary objectForKey:@"d"]) {
        
         parseDictionary = [[resultDictionary objectForKey:@"d"] copy];
 
               if ([parseDictionary objectForKey:@"results"]) {
                   
                   parseDictionary = [[parseDictionary objectForKey:@"results"] copy];
                   
                   id parseMonitorDocs=[parseDictionary copy];
 
                    if ([parseMonitorDocs isKindOfClass:[NSDictionary class]])
                    {
                          [xmlDoc setObject:[NSMutableArray arrayWithObject:parseMonitorDocs] forKey:@"resultMonitorMdocs"];
                        
                    }
                    else if([parseMonitorDocs isKindOfClass:[NSArray class]])
                    {
                        if ([[[parseMonitorDocs objectAtIndex:0]  objectForKey:@"EtImrg"] objectForKey:@"results"]){
                            
                            parseMonitorDocs = [[[parseMonitorDocs objectAtIndex:0]  objectForKey:@"EtImrg"] objectForKey:@"results"];
                            
                             [xmlDoc setObject:parseMonitorDocs forKey:@"resultMonitorMdocs"];
                            
                        }
                    }
                 }
             }
 
      return xmlDoc;
    
    return [NSMutableDictionary dictionary];
 }

- (NSMutableDictionary *)parseForMeasurementDocs:(NSDictionary *)resultDictionary
{
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    NSDictionary *parseDictionary;
    
    if ([resultDictionary objectForKey:@"d"]) {
        
        parseDictionary = [[resultDictionary objectForKey:@"d"] copy];
        
        if ([parseDictionary objectForKey:@"results"]) {
            
            parseDictionary = [[parseDictionary objectForKey:@"results"] copy];
            
            id parseMonitorDocs=[parseDictionary copy];
            
            if ([parseMonitorDocs isKindOfClass:[NSDictionary class]])
            {
                [xmlDoc setObject:[NSMutableArray arrayWithObject:parseMonitorDocs] forKey:@"resultMDocs"];
                
            }
            else if([parseMonitorDocs isKindOfClass:[NSArray class]])
            {
                if (![NullChecker isNull:[[parseMonitorDocs objectAtIndex:0]  objectForKey:@"EquiMPs"]])
                {

                if ([[[parseMonitorDocs objectAtIndex:0]  objectForKey:@"EquiMPs"] objectForKey:@"results"]){
                    
                    parseMonitorDocs = [[[parseMonitorDocs objectAtIndex:0]  objectForKey:@"EquiMPs"] objectForKey:@"results"];
                    
                    [xmlDoc setObject:parseMonitorDocs forKey:@"resultMDocs"];
                    
                 }
                }
            }
        }
    }
    
    return xmlDoc;
    
    return [NSMutableDictionary dictionary];
}


-(NSMutableDictionary *)parseForSetMonitorMeasurementDocs:(NSDictionary *)resultDictionary{
    
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    NSDictionary *parseDictionary,*parseMessageDictionary;
    
    if ([resultDictionary objectForKey:@"d"]) {
        
          parseDictionary = [[resultDictionary objectForKey:@"d"] copy];
        
          parseMessageDictionary = [[resultDictionary objectForKey:@"d"] copy];

        
             id parseMonitorDocs=[parseDictionary copy];
            
            if ([parseMonitorDocs isKindOfClass:[NSDictionary class]])
            {
                [xmlDoc setObject:[NSMutableArray arrayWithObject:parseMonitorDocs] forKey:@"resultMonitorMdocs"];
                
            }
            else if([parseMonitorDocs isKindOfClass:[NSArray class]])
            {
                if (![NullChecker isNull:[[parseMonitorDocs objectAtIndex:0]  objectForKey:@"EtMeaImrg"]]) {
            
                if ([[[parseMonitorDocs objectAtIndex:0]  objectForKey:@"EtMeaImrg"] objectForKey:@"results"]){
                    
                    parseMonitorDocs = [[[parseMonitorDocs objectAtIndex:0]  objectForKey:@"EtMeaImrg"] objectForKey:@"results"];
                    
                    [xmlDoc setObject:parseMonitorDocs forKey:@"resultMonitorMdocs"];
                 }
                    
                }
            }
 
           id messageObject=[parseMessageDictionary copy];
        
        if ([[messageObject objectForKey:@"EtMsg"] objectForKey:@"results"]) {
            
            if ([[[messageObject objectForKey:@"EtMsg"] objectForKey:@"results"] isKindOfClass:[NSDictionary class]]){
                
                [xmlDoc setObject:[NSMutableArray arrayWithObject:[[[[messageObject objectForKey:@"EtMsg"] objectForKey:@"results"] objectAtIndex:0] objectForKey:@"Message"]] forKey:@"MESSAGE"];
 
            }
            else if ([[[messageObject objectForKey:@"EtMsg"] objectForKey:@"results"] isKindOfClass:[NSArray class]]){
                
                 if ([[[messageObject objectForKey:@"EtMsg"] objectForKey:@"results"] count])
                {
                    [xmlDoc setObject:[[[[messageObject objectForKey:@"EtMsg"] objectForKey:@"results"] objectAtIndex:0] objectForKey:@"Message"] forKey:@"MESSAGE"];
                    
                 }
                
             }
           }
            
            return xmlDoc;
         }
 
     return [NSMutableDictionary dictionary];
    
}

- (NSMutableDictionary *)parseForCancelNotification:(NSDictionary *)resultDictionary{
    
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    NSDictionary *parseDictionary;
    if ([resultDictionary objectForKey:@"d"]) {
        parseDictionary = [resultDictionary objectForKey:@"d"];
        if ([parseDictionary objectForKey:@"results"]) {
            id dataObject = [parseDictionary objectForKey:@"results"];
            if ([dataObject isKindOfClass:[NSDictionary class]]) {
                [xmlDoc setObject:[NSMutableArray arrayWithObject:dataObject] forKey:@"result"];
            }
            else if([dataObject isKindOfClass:[NSArray class]])
            {
                [xmlDoc setObject:dataObject forKey:@"result"];
            }
            NSMutableArray *resultArray = [NSMutableArray arrayWithArray:[xmlDoc objectForKey:@"result"]];
            
            NSMutableArray *messageArray = [[NSMutableArray alloc] init];
            for (int i=0; i<[resultArray count]; i++) {
                NSMutableDictionary *resultDictionary = [resultArray objectAtIndex:i];
                if ([resultDictionary objectForKey:@"ObjectNo"]) {
                    if ([resultDictionary objectForKey:@"Success"]) {
                        if ([[resultDictionary objectForKey:@"Success"] boolValue]) {
                            [messageArray addObject:[NSString stringWithFormat:@"S Notification %@ Cancelled Succesfully",[resultDictionary objectForKey:@"ObjectNo"]]];
                        }
                        else
                        {
                            [messageArray addObject:[NSString stringWithFormat:@"E notification %@ Cancelled failed",[resultDictionary objectForKey:@"ObjectNo"]]];
                        }
                    }
                }
            }
            [xmlDoc removeAllObjects];
            if (messageArray.count) {
               [xmlDoc setObject:messageArray forKey:@"Message"];
            }
            
            return xmlDoc;
        }
    }
    else if([resultDictionary objectForKey:@"error"])
    {
        parseDictionary = [[resultDictionary objectForKey:@"error"] objectForKey:@"message"];
        [xmlDoc setObject:[parseDictionary objectForKey:@"value"] forKey:@"ERROR"];
        return xmlDoc;
    }

    return [NSMutableDictionary dictionary];
    
}

- (NSMutableDictionary *)parseForCompleteNotification:(NSDictionary *)resultDictionary
{
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    NSDictionary *parseDictionary, *parseMessageDictionary;
    
    if ([resultDictionary objectForKey:@"d"])
    {
        parseDictionary = [resultDictionary objectForKey:@"d"];
        
        if ([parseDictionary objectForKey:@"NotiComplete"])
        {
            id dataObject = [parseDictionary objectForKey:@"NotiComplete"];
            
            if ([dataObject isKindOfClass:[NSDictionary class]]) {
                
                 parseMessageDictionary = [dataObject copy];
 
            }
            else if ([dataObject isKindOfClass:[NSArray class]]){
                
                if ([dataObject count])
                {
                    parseMessageDictionary = [[dataObject objectAtIndex:0] copy];
                 }
             }
 
            id messageObject=[parseMessageDictionary copy];
            
            if ([messageObject objectForKey:@"Message"]) {
                
                [xmlDoc setObject:[messageObject objectForKey:@"Message"] forKey:@"MESSAGE"];
                [xmlDoc setObject:[messageObject objectForKey:@"Qmnum"] forKey:@"OBJECTID"];
 
            }
 
            return xmlDoc;
            
        }
    }
    return [NSMutableDictionary dictionary];
}

- (NSMutableDictionary *)parseForCreateOrder:(NSDictionary *)resultDictionary
{
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    
    NSDictionary *parseDictionary,*parseDictionaryHeaderPermits,*parseDictionaryOperationTransaction,*parseDictionaryComponentsTransaction,*parseDictionaryLongText,*parseDictionaryDocs,*parseDictionaryWSM,*parseDictionaryObjects,*parsedDictionaryOrderStatus,*parsedDictionaryOrderOlist,*parsedDictionaryCheckPoints,*parsedDictionaryWorkApplications,*parsedDictionaryWcagns,*parsedDictionaryOpWCDDetails,*parsedDictionaryOpWCDItemDetails,*parsedDictionaryWorkApprovalDetails,*parsedDictionaryMeasurementDocuments,*parseHeaderDictionary,*parseMessageDictionary;
    
    if ([resultDictionary objectForKey:@"d"])
    {
        parseDictionary = [resultDictionary objectForKey:@"d"];
        
             id dataObject = [parseDictionary copy];
            
            if ([dataObject isKindOfClass:[NSDictionary class]]) {
                
                parseDictionaryHeaderPermits = [dataObject copy];
                parseDictionaryOperationTransaction = [dataObject copy];
                parseDictionaryComponentsTransaction = [dataObject copy];
                parseDictionaryLongText = [dataObject copy];
                parseDictionaryDocs = [dataObject copy];
                parseDictionaryWSM = [dataObject copy];
                parseDictionaryObjects = [dataObject copy];
                parsedDictionaryOrderStatus = [dataObject copy];
                parsedDictionaryOrderOlist = [dataObject copy];
                parsedDictionaryCheckPoints = [dataObject copy];
                parsedDictionaryWorkApplications = [dataObject copy];
                parsedDictionaryWcagns = [dataObject copy];
                parsedDictionaryOpWCDDetails = [dataObject copy];
                parsedDictionaryOpWCDItemDetails = [dataObject copy];
                parsedDictionaryWorkApprovalDetails = [dataObject copy];
                parsedDictionaryMeasurementDocuments = [dataObject copy];
                parseHeaderDictionary = [dataObject copy];
                
                parseMessageDictionary = [dataObject copy];

            }
            else if ([dataObject isKindOfClass:[NSArray class]])
            {
                if ([dataObject count]) {
                    parseDictionaryHeaderPermits = [[dataObject objectAtIndex:0] copy];
                    parseDictionaryOperationTransaction = [[dataObject objectAtIndex:0] copy];
                    parseDictionaryComponentsTransaction = [[dataObject objectAtIndex:0] copy];
                    parseDictionaryLongText = [[dataObject objectAtIndex:0] copy];
                    parseDictionaryDocs = [[dataObject objectAtIndex:0] copy];
                    parseDictionaryWSM = [[dataObject objectAtIndex:0] copy];
                    parseDictionaryObjects = [[dataObject objectAtIndex:0] copy];
                    parsedDictionaryOrderStatus = [[dataObject objectAtIndex:0] copy];
                    parsedDictionaryOrderOlist = [[dataObject objectAtIndex:0] copy];
                    parsedDictionaryCheckPoints = [[dataObject objectAtIndex:0] copy];
                    parsedDictionaryWorkApplications = [[dataObject objectAtIndex:0] copy];
                    parsedDictionaryWcagns = [[dataObject objectAtIndex:0] copy];
                    parsedDictionaryOpWCDDetails = [[dataObject objectAtIndex:0] copy];
                    parsedDictionaryOpWCDItemDetails = [[dataObject objectAtIndex:0] copy];
                    parsedDictionaryWorkApprovalDetails = [[dataObject objectAtIndex:0] copy];
                    parsedDictionaryMeasurementDocuments = [[dataObject objectAtIndex:0] copy];
                    parseHeaderDictionary = [[dataObject objectAtIndex:0] copy];
                    parseMessageDictionary = [[dataObject objectAtIndex:0] copy];

                 }
            }
 
            if ([parseHeaderDictionary objectForKey:@"EtOrderHeader"]) {
 
                if (![NullChecker isNull:[parseHeaderDictionary objectForKey:@"EtOrderHeader"]]) {
                     parseHeaderDictionary = [parseHeaderDictionary objectForKey:@"EtOrderHeader"];
                    if ([parseHeaderDictionary objectForKey:@"results"]) {
                        parseHeaderDictionary = [parseHeaderDictionary objectForKey:@"results"];
                        if ([parseHeaderDictionary isKindOfClass:[NSDictionary class]]) {
                            [xmlDoc setObject:[NSMutableArray arrayWithObject:parseHeaderDictionary] forKey:@"resultHeader"];
                        }
                        else if([parseHeaderDictionary isKindOfClass:[NSArray class]])
                        {
                            [xmlDoc setObject:parseHeaderDictionary forKey:@"resultHeader"];
                        }
                    }
                }
             }
            
            if ([parseDictionaryObjects objectForKey:@"EtOrderOlist"]) {
                
              if (![NullChecker isNull:[parseDictionaryObjects objectForKey:@"EtOrderOlist"]]) {
                    
                 parseDictionaryObjects = [parseDictionaryObjects objectForKey:@"EtOrderOlist"];
                if ([parseDictionaryObjects objectForKey:@"results"]) {
                    parseDictionaryObjects = [parseDictionaryObjects objectForKey:@"results"];
                    if ([parseDictionaryObjects isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryObjects] forKey:@"resultHeaderObjects"];
                    }
                    else if([parseDictionaryObjects isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryObjects forKey:@"resultHeaderObjects"];
                    }
                }
              }
            }
            
            if ([parsedDictionaryMeasurementDocuments objectForKey:@"EtImrg"]) {
                
                if (![NullChecker isNull:[parsedDictionaryMeasurementDocuments objectForKey:@"EtImrg"]]) {

                 parsedDictionaryMeasurementDocuments = [parsedDictionaryMeasurementDocuments objectForKey:@"EtImrg"];
                if ([parsedDictionaryMeasurementDocuments objectForKey:@"results"]) {
                    parsedDictionaryMeasurementDocuments = [parsedDictionaryMeasurementDocuments objectForKey:@"results"];
                    if ([parsedDictionaryMeasurementDocuments isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parsedDictionaryMeasurementDocuments] forKey:@"resultMeasurementDocuments"];
                    }
                    else if([parsedDictionaryMeasurementDocuments isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parsedDictionaryMeasurementDocuments forKey:@"resultMeasurementDocuments"];
                    }
                 }
              }
            }
            
            if ([parseDictionaryHeaderPermits objectForKey:@"EtOrderPermits"]) {
                
                if (![NullChecker isNull:[parseDictionaryHeaderPermits objectForKey:@"EtOrderPermits"]]) {
 
                 parseDictionaryHeaderPermits = [parseDictionaryHeaderPermits objectForKey:@"EtOrderPermits"];
                if ([parseDictionaryHeaderPermits objectForKey:@"results"]) {
                    parseDictionaryHeaderPermits = [parseDictionaryHeaderPermits objectForKey:@"results"];
                    if ([parseDictionaryHeaderPermits isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryHeaderPermits] forKey:@"resultHeaderPermits"];
                    }
                    else if([parseDictionaryHeaderPermits isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryHeaderPermits forKey:@"resultHeaderPermits"];
                    }
                  }
                 }
            }
            
            if ([parseDictionaryOperationTransaction objectForKey:@"EtOrderOperations"]) {
                
                if (![NullChecker isNull:[parseDictionaryOperationTransaction objectForKey:@"EtOrderOperations"]]) {
                 parseDictionaryOperationTransaction = [parseDictionaryOperationTransaction objectForKey:@"EtOrderOperations"];
                if ([parseDictionaryOperationTransaction objectForKey:@"results"]) {
                    parseDictionaryOperationTransaction = [parseDictionaryOperationTransaction objectForKey:@"results"];
                    if ([parseDictionaryOperationTransaction isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryOperationTransaction] forKey:@"resultOperationsTransactions"];
                    }
                    else if([parseDictionaryOperationTransaction isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryOperationTransaction forKey:@"resultOperationsTransactions"];
                    }
                  }
                 }
            }
        
         if ([parseMessageDictionary objectForKey:@"EsAufnr"]) {
            
            if (![NullChecker isNull:[parseMessageDictionary objectForKey:@"EsAufnr"]]) {
                
                if ([[parseMessageDictionary objectForKey:@"EsAufnr"] objectForKey:@"results"]) {
                    
                    id messageArray = [[parseMessageDictionary objectForKey:@"EsAufnr"] objectForKey:@"results"];
                    if ([messageArray isKindOfClass:[NSDictionary class]]) {
                        
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:[[[[messageArray objectForKey:@"EsAufnr"] objectForKey:@"results"] objectAtIndex:0] objectForKey:@"Message"]] forKey:@"MESSAGE"];
                        
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:[[[[messageArray objectForKey:@"EsAufnr"] objectForKey:@"results"] objectAtIndex:0] objectForKey:@"Qmnum"]] forKey:@"OBJECTID"];
                        
                    }
                    else if([messageArray isKindOfClass:[NSArray class]])
                    {
                        
                        [xmlDoc setObject:[[messageArray objectAtIndex:0] objectForKey:@"Message"] forKey:@"MESSAGE"];
                         [xmlDoc setObject:[NSMutableArray arrayWithObject:[[messageArray objectAtIndex:0] objectForKey:@"Aufnr"]] forKey:@"OBJECTID"];
                        
                     }
                }
            }
         }
 
        
            if ([parseDictionaryComponentsTransaction objectForKey:@"EtOrderComponents"]) {
                
                if (![NullChecker isNull:[parseDictionaryComponentsTransaction objectForKey:@"EtOrderComponents"]]) {
                 
                parseDictionaryComponentsTransaction = [parseDictionaryComponentsTransaction objectForKey:@"EtOrderComponents"];
                    
                if ([parseDictionaryComponentsTransaction objectForKey:@"results"]) {
                    parseDictionaryComponentsTransaction = [parseDictionaryComponentsTransaction objectForKey:@"results"];
                    if ([parseDictionaryComponentsTransaction isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryComponentsTransaction] forKey:@"resultComponentsTransactions"];
                    }
                    else if([parseDictionaryComponentsTransaction isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryComponentsTransaction forKey:@"resultComponentsTransactions"];
                    }
                 }
               }
            }
            
             if ([parseDictionaryLongText objectForKey:@"EtOrderLongtext"]) {
                 if (![NullChecker isNull:[parseDictionaryDocs objectForKey:@"EtOrderLongtext"]]) {
                 parseDictionaryLongText = [parseDictionaryLongText objectForKey:@"EtOrderLongtext"];
                if ([parseDictionaryLongText objectForKey:@"results"]) {
                    parseDictionaryLongText = [parseDictionaryLongText objectForKey:@"results"];
                    if ([parseDictionaryLongText isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryLongText] forKey:@"resultLongText"];
                    }
                    else if([parseDictionaryLongText isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryLongText forKey:@"resultLongText"];
                    }
                  }
                 
                }
            }
 
        
            if ([parseDictionaryDocs objectForKey:@"EtDocs"]) {
                
            if (![NullChecker isNull:[parseDictionaryDocs objectForKey:@"EtDocs"]]) {
                parseDictionaryDocs = [parseDictionaryDocs objectForKey:@"EtDocs"];
                if ([parseDictionaryDocs objectForKey:@"results"]) {
                    parseDictionaryDocs = [parseDictionaryDocs objectForKey:@"results"];
                    if ([parseDictionaryDocs isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryDocs] forKey:@"resultDocs"];
                    }
                    else if([parseDictionaryDocs isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryDocs forKey:@"resultDocs"];
                    }
                 }
                }
            }
            
            if ([parseDictionaryWSM objectForKey:@"EtWsmOrdSafemeas"]) {
                if (![NullChecker isNull:[parsedDictionaryOrderStatus objectForKey:@"EtWsmOrdSafemeas"]]) {
                 parseDictionaryWSM = [parseDictionaryWSM objectForKey:@"EtWsmOrdSafemeas"];
                if ([parseDictionaryWSM objectForKey:@"results"]) {
                    parseDictionaryWSM = [parseDictionaryWSM objectForKey:@"results"];
                    if ([parseDictionaryWSM isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryWSM] forKey:@"resultWSMSafetyMeasures"];
                    }
                    else if([parseDictionaryWSM isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryWSM forKey:@"resultWSMSafetyMeasures"];
                    }
                  }
                }
            }
            
            if ([parsedDictionaryOrderStatus objectForKey:@"EtOrderStatus"]) {
                
               if (![NullChecker isNull:[parsedDictionaryOrderStatus objectForKey:@"EtOrderStatus"]]) {

                parsedDictionaryOrderStatus = [parsedDictionaryOrderStatus objectForKey:@"EtOrderStatus"];
                if ([parsedDictionaryOrderStatus objectForKey:@"results"]) {
                    parsedDictionaryOrderStatus = [parsedDictionaryOrderStatus objectForKey:@"results"];
                    if ([parsedDictionaryOrderStatus isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parsedDictionaryOrderStatus] forKey:@"resultOrderStatus"];
                    }
                    else if([parsedDictionaryOrderStatus isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parsedDictionaryOrderStatus forKey:@"resultOrderStatus"];
                    }
                }
                }
            }
            
            if ([parsedDictionaryOrderOlist objectForKey:@"EtOrderOlist"]) {
                
                if (![NullChecker isNull:[parsedDictionaryOrderOlist objectForKey:@"EtOrderOlist"]]) {
                  parsedDictionaryOrderOlist = [parsedDictionaryOrderOlist objectForKey:@"EtOrderOlist"];
                if ([parsedDictionaryOrderOlist objectForKey:@"results"]) {
                    parsedDictionaryOrderOlist = [parsedDictionaryOrderOlist objectForKey:@"results"];
                    if ([parsedDictionaryOrderOlist isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parsedDictionaryOrderOlist] forKey:@"resultOrderOlist"];
                    }
                    else if([parsedDictionaryOrderOlist isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parsedDictionaryOrderOlist forKey:@"resultOrderOlist"];
                    }
                }
                }
            }
            
            //WCM
            if ([parsedDictionaryCheckPoints objectForKey:@"EtWcmWaChkReq"]) {
                 if (![NullChecker isNull:[parsedDictionaryCheckPoints objectForKey:@"EtWcmWaChkReq"]]) {
                   parsedDictionaryCheckPoints = [parsedDictionaryCheckPoints objectForKey:@"EtWcmWaChkReq"];
                   if ([parsedDictionaryCheckPoints objectForKey:@"results"]) {
                    parsedDictionaryCheckPoints = [parsedDictionaryCheckPoints objectForKey:@"results"];
                    if ([parsedDictionaryCheckPoints isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parsedDictionaryCheckPoints] forKey:@"resultStandardCheckPoints"];
                    }
                    else if([parsedDictionaryCheckPoints isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parsedDictionaryCheckPoints forKey:@"resultStandardCheckPoints"];
                    }
                  }
                }
            }
        
 
            
            if ([parsedDictionaryWorkApplications objectForKey:@"EtWcmWaData"]) {
                 if (![NullChecker isNull:[parsedDictionaryWorkApplications objectForKey:@"EtWcmWaData"]]) {
                    parsedDictionaryWorkApplications = [parsedDictionaryWorkApplications objectForKey:@"EtWcmWaData"];
                  if ([parsedDictionaryWorkApplications objectForKey:@"results"]) {
                    parsedDictionaryWorkApplications = [parsedDictionaryWorkApplications objectForKey:@"results"];
                    if ([parsedDictionaryWorkApplications isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parsedDictionaryWorkApplications] forKey:@"resultWorkApplicationData"];
                    }
                    else if([parsedDictionaryWorkApplications isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parsedDictionaryWorkApplications forKey:@"resultWorkApplicationData"];
                    }
                  }
                }
            }
            
            if ([parsedDictionaryWcagns objectForKey:@"EtWcmWcagns"]) {
                if (![NullChecker isNull:[parsedDictionaryWcagns objectForKey:@"EtWcmWcagns"]]) {
                 parsedDictionaryWcagns = [parsedDictionaryWcagns objectForKey:@"EtWcmWcagns"];
                if ([parsedDictionaryWcagns objectForKey:@"results"]) {
                    parsedDictionaryWcagns = [parsedDictionaryWcagns objectForKey:@"results"];
                    if ([parsedDictionaryWcagns isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parsedDictionaryWcagns] forKey:@"resultIssuePermits"];//issue permits
                    }
                    else if([parsedDictionaryWcagns isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parsedDictionaryWcagns forKey:@"resultIssuePermits"];//issue permits
                    }
                }
              }
            }
            
            if ([parsedDictionaryOpWCDDetails objectForKey:@"EtWcmWdData"]) {
 
                if (![NullChecker isNull:[parsedDictionaryOpWCDDetails objectForKey:@"EtWcmWdData"]]) {
                   parsedDictionaryOpWCDDetails = [parsedDictionaryOpWCDDetails objectForKey:@"EtWcmWdData"];
                if ([parsedDictionaryOpWCDDetails objectForKey:@"results"]) {
                    parsedDictionaryOpWCDDetails = [parsedDictionaryOpWCDDetails objectForKey:@"results"];
                    if ([parsedDictionaryOpWCDDetails isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parsedDictionaryOpWCDDetails] forKey:@"resultOperationWCDData"];//isolation
                    }
                    else if([parsedDictionaryOpWCDDetails isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parsedDictionaryOpWCDDetails forKey:@"resultOperationWCDData"];//isolation
                    }
                 }
                }
            }
            
            if ([parsedDictionaryOpWCDItemDetails objectForKey:@"EtWcmWdItemData"]) {
                 if (![NullChecker isNull:[parsedDictionaryOpWCDItemDetails objectForKey:@"EtWcmWdItemData"]]) {
                 parsedDictionaryOpWCDItemDetails = [parsedDictionaryOpWCDItemDetails objectForKey:@"EtWcmWdItemData"];
                if ([parsedDictionaryOpWCDItemDetails objectForKey:@"results"]) {
                    parsedDictionaryOpWCDItemDetails = [parsedDictionaryOpWCDItemDetails objectForKey:@"results"];
                    if ([parsedDictionaryOpWCDItemDetails isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parsedDictionaryOpWCDItemDetails] forKey:@"resultOperationWCDItemData"];//tagging conditions
                    }
                    else if([parsedDictionaryOpWCDItemDetails isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parsedDictionaryOpWCDItemDetails forKey:@"resultOperationWCDItemData"];//tagging conditions
                    }
                 }
                }
            }
 
            if ([parsedDictionaryWorkApprovalDetails objectForKey:@"EtWcmWwData"]) {
              if (![NullChecker isNull:[parsedDictionaryWorkApprovalDetails objectForKey:@"EtWcmWwData"]]) {
                 parsedDictionaryWorkApprovalDetails = [parsedDictionaryWorkApprovalDetails objectForKey:@"EtWcmWwData"];
                if ([parsedDictionaryWorkApprovalDetails objectForKey:@"results"]) {
                    parsedDictionaryWorkApprovalDetails = [parsedDictionaryWorkApprovalDetails objectForKey:@"results"];
                    if ([parsedDictionaryWorkApprovalDetails isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parsedDictionaryWorkApprovalDetails] forKey:@"resultWorkApprovalsData"];
                    }
                    else if([parsedDictionaryWorkApprovalDetails isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parsedDictionaryWorkApprovalDetails forKey:@"resultWorkApprovalsData"];
                    }
                  }
               
              }
 
                return xmlDoc;

            }

    }
    
    return [NSMutableDictionary dictionary];
}

- (NSMutableDictionary *)parseForPermitCreate:(NSDictionary *)resultDictionary
{
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    
    NSDictionary *parseDictionary,*parseDictionaryHeaderPermits,*parseDictionaryOperationTransaction,*parseDictionaryComponentsTransaction,*parseDictionaryLongText,*parseDictionaryDocs,*parseDictionaryWSM,*parseDictionaryObjects,*parsedDictionaryOrderStatus,*parsedDictionaryOrderOlist,*parsedDictionaryCheckPoints,*parsedDictionaryWorkApplications,*parsedDictionaryWcagns,*parsedDictionaryOpWCDDetails,*parsedDictionaryOpWCDItemDetails,*parsedDictionaryWorkApprovalDetails,*parsedDictionaryMeasurementDocuments,*parseHeaderDictionary,*parseMessageDictionary;
    
    if ([resultDictionary objectForKey:@"d"])
    {
        parseDictionary = [resultDictionary objectForKey:@"d"];
        
        id dataObject = [parseDictionary copy];
        
        if ([dataObject isKindOfClass:[NSDictionary class]]) {
            
            parseDictionaryHeaderPermits = [dataObject copy];
            parseDictionaryOperationTransaction = [dataObject copy];
            parseDictionaryComponentsTransaction = [dataObject copy];
            parseDictionaryLongText = [dataObject copy];
            parseDictionaryDocs = [dataObject copy];
            parseDictionaryWSM = [dataObject copy];
            parseDictionaryObjects = [dataObject copy];
            parsedDictionaryOrderStatus = [dataObject copy];
            parsedDictionaryOrderOlist = [dataObject copy];
            parsedDictionaryCheckPoints = [dataObject copy];
            parsedDictionaryWorkApplications = [dataObject copy];
            parsedDictionaryWcagns = [dataObject copy];
            parsedDictionaryOpWCDDetails = [dataObject copy];
            parsedDictionaryOpWCDItemDetails = [dataObject copy];
            parsedDictionaryWorkApprovalDetails = [dataObject copy];
            parsedDictionaryMeasurementDocuments = [dataObject copy];
            parseHeaderDictionary = [dataObject copy];
            
            parseMessageDictionary = [dataObject copy];
            
        }
        else if ([dataObject isKindOfClass:[NSArray class]])
        {
            if ([dataObject count]) {
                parseDictionaryHeaderPermits = [[dataObject objectAtIndex:0] copy];
                parseDictionaryOperationTransaction = [[dataObject objectAtIndex:0] copy];
                parseDictionaryComponentsTransaction = [[dataObject objectAtIndex:0] copy];
                parseDictionaryLongText = [[dataObject objectAtIndex:0] copy];
                parseDictionaryDocs = [[dataObject objectAtIndex:0] copy];
                parseDictionaryWSM = [[dataObject objectAtIndex:0] copy];
                parseDictionaryObjects = [[dataObject objectAtIndex:0] copy];
                parsedDictionaryOrderStatus = [[dataObject objectAtIndex:0] copy];
                parsedDictionaryOrderOlist = [[dataObject objectAtIndex:0] copy];
                parsedDictionaryCheckPoints = [[dataObject objectAtIndex:0] copy];
                parsedDictionaryWorkApplications = [[dataObject objectAtIndex:0] copy];
                parsedDictionaryWcagns = [[dataObject objectAtIndex:0] copy];
                parsedDictionaryOpWCDDetails = [[dataObject objectAtIndex:0] copy];
                parsedDictionaryOpWCDItemDetails = [[dataObject objectAtIndex:0] copy];
                parsedDictionaryWorkApprovalDetails = [[dataObject objectAtIndex:0] copy];
                parsedDictionaryMeasurementDocuments = [[dataObject objectAtIndex:0] copy];
                parseHeaderDictionary = [[dataObject objectAtIndex:0] copy];
                parseMessageDictionary = [[dataObject objectAtIndex:0] copy];
                
            }
        }
        
        if ([parseHeaderDictionary objectForKey:@"EtOrderHeader"]) {
            
            if (![NullChecker isNull:[parseHeaderDictionary objectForKey:@"EtOrderHeader"]]) {
                parseHeaderDictionary = [parseHeaderDictionary objectForKey:@"EtOrderHeader"];
                if ([parseHeaderDictionary objectForKey:@"results"]) {
                    parseHeaderDictionary = [parseHeaderDictionary objectForKey:@"results"];
                    if ([parseHeaderDictionary isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseHeaderDictionary] forKey:@"resultHeader"];
                    }
                    else if([parseHeaderDictionary isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseHeaderDictionary forKey:@"resultHeader"];
                    }
                }
            }
        }
        
        if ([parseDictionaryObjects objectForKey:@"EtOrderOlist"]) {
            
            if (![NullChecker isNull:[parseDictionaryObjects objectForKey:@"EtOrderOlist"]]) {
                
                parseDictionaryObjects = [parseDictionaryObjects objectForKey:@"EtOrderOlist"];
                if ([parseDictionaryObjects objectForKey:@"results"]) {
                    parseDictionaryObjects = [parseDictionaryObjects objectForKey:@"results"];
                    if ([parseDictionaryObjects isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryObjects] forKey:@"resultHeaderObjects"];
                    }
                    else if([parseDictionaryObjects isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryObjects forKey:@"resultHeaderObjects"];
                    }
                }
            }
        }
        
        if ([parsedDictionaryMeasurementDocuments objectForKey:@"EtImrg"]) {
            
            if (![NullChecker isNull:[parsedDictionaryMeasurementDocuments objectForKey:@"EtImrg"]]) {
                
                parsedDictionaryMeasurementDocuments = [parsedDictionaryMeasurementDocuments objectForKey:@"EtImrg"];
                if ([parsedDictionaryMeasurementDocuments objectForKey:@"results"]) {
                    parsedDictionaryMeasurementDocuments = [parsedDictionaryMeasurementDocuments objectForKey:@"results"];
                    if ([parsedDictionaryMeasurementDocuments isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parsedDictionaryMeasurementDocuments] forKey:@"resultMeasurementDocuments"];
                    }
                    else if([parsedDictionaryMeasurementDocuments isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parsedDictionaryMeasurementDocuments forKey:@"resultMeasurementDocuments"];
                    }
                }
            }
        }
        
        if ([parseDictionaryHeaderPermits objectForKey:@"EtOrderPermits"]) {
            
            if (![NullChecker isNull:[parseDictionaryHeaderPermits objectForKey:@"EtOrderPermits"]]) {
                
                parseDictionaryHeaderPermits = [parseDictionaryHeaderPermits objectForKey:@"EtOrderPermits"];
                if ([parseDictionaryHeaderPermits objectForKey:@"results"]) {
                    parseDictionaryHeaderPermits = [parseDictionaryHeaderPermits objectForKey:@"results"];
                    if ([parseDictionaryHeaderPermits isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryHeaderPermits] forKey:@"resultHeaderPermits"];
                    }
                    else if([parseDictionaryHeaderPermits isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryHeaderPermits forKey:@"resultHeaderPermits"];
                    }
                }
            }
        }
        
        if ([parseDictionaryOperationTransaction objectForKey:@"EtOrderOperations"]) {
            
            if (![NullChecker isNull:[parseDictionaryOperationTransaction objectForKey:@"EtOrderOperations"]]) {
                parseDictionaryOperationTransaction = [parseDictionaryOperationTransaction objectForKey:@"EtOrderOperations"];
                if ([parseDictionaryOperationTransaction objectForKey:@"results"]) {
                    parseDictionaryOperationTransaction = [parseDictionaryOperationTransaction objectForKey:@"results"];
                    if ([parseDictionaryOperationTransaction isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryOperationTransaction] forKey:@"resultOperationsTransactions"];
                    }
                    else if([parseDictionaryOperationTransaction isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryOperationTransaction forKey:@"resultOperationsTransactions"];
                    }
                }
            }
        }
        
        if ([parseMessageDictionary objectForKey:@"EsAufnr"]) {
            
            if (![NullChecker isNull:[parseMessageDictionary objectForKey:@"EsAufnr"]]) {
                
                if ([[parseMessageDictionary objectForKey:@"EsAufnr"] objectForKey:@"results"]) {
                    
                    id messageArray = [[parseMessageDictionary objectForKey:@"EsAufnr"] objectForKey:@"results"];
                    if ([messageArray isKindOfClass:[NSDictionary class]]) {
                        
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:[[[[messageArray objectForKey:@"EsAufnr"] objectForKey:@"results"] objectAtIndex:0] objectForKey:@"Message"]] forKey:@"MESSAGE"];
                        
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:[[[[messageArray objectForKey:@"EsAufnr"] objectForKey:@"results"] objectAtIndex:0] objectForKey:@"Qmnum"]] forKey:@"OBJECTID"];
                        
                    }
                    else if([messageArray isKindOfClass:[NSArray class]])
                    {
                        
                        [xmlDoc setObject:[[messageArray objectAtIndex:0] objectForKey:@"Message"] forKey:@"MESSAGE"];
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:[[messageArray objectAtIndex:0] objectForKey:@"Aufnr"]] forKey:@"OBJECTID"];
                        
                    }
                }
            }
        }
        
        
        if ([parseDictionaryComponentsTransaction objectForKey:@"EtOrderComponents"]) {
            
            if (![NullChecker isNull:[parseDictionaryComponentsTransaction objectForKey:@"EtOrderComponents"]]) {
                
                parseDictionaryComponentsTransaction = [parseDictionaryComponentsTransaction objectForKey:@"EtOrderComponents"];
                
                if ([parseDictionaryComponentsTransaction objectForKey:@"results"]) {
                    parseDictionaryComponentsTransaction = [parseDictionaryComponentsTransaction objectForKey:@"results"];
                    if ([parseDictionaryComponentsTransaction isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryComponentsTransaction] forKey:@"resultComponentsTransactions"];
                    }
                    else if([parseDictionaryComponentsTransaction isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryComponentsTransaction forKey:@"resultComponentsTransactions"];
                    }
                }
            }
        }
        
        if ([parseDictionaryLongText objectForKey:@"EtOrderLongtext"]) {
            if (![NullChecker isNull:[parseDictionaryDocs objectForKey:@"EtOrderLongtext"]]) {
                parseDictionaryLongText = [parseDictionaryLongText objectForKey:@"EtOrderLongtext"];
                if ([parseDictionaryLongText objectForKey:@"results"]) {
                    parseDictionaryLongText = [parseDictionaryLongText objectForKey:@"results"];
                    if ([parseDictionaryLongText isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryLongText] forKey:@"resultLongText"];
                    }
                    else if([parseDictionaryLongText isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryLongText forKey:@"resultLongText"];
                    }
                }
                
            }
        }
        
        
        if ([parseDictionaryDocs objectForKey:@"EtDocs"]) {
            
            if (![NullChecker isNull:[parseDictionaryDocs objectForKey:@"EtDocs"]]) {
                parseDictionaryDocs = [parseDictionaryDocs objectForKey:@"EtDocs"];
                if ([parseDictionaryDocs objectForKey:@"results"]) {
                    parseDictionaryDocs = [parseDictionaryDocs objectForKey:@"results"];
                    if ([parseDictionaryDocs isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryDocs] forKey:@"resultDocs"];
                    }
                    else if([parseDictionaryDocs isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryDocs forKey:@"resultDocs"];
                    }
                }
            }
        }
        
        if ([parseDictionaryWSM objectForKey:@"EtWsmOrdSafemeas"]) {
            if (![NullChecker isNull:[parsedDictionaryOrderStatus objectForKey:@"EtWsmOrdSafemeas"]]) {
                parseDictionaryWSM = [parseDictionaryWSM objectForKey:@"EtWsmOrdSafemeas"];
                if ([parseDictionaryWSM objectForKey:@"results"]) {
                    parseDictionaryWSM = [parseDictionaryWSM objectForKey:@"results"];
                    if ([parseDictionaryWSM isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryWSM] forKey:@"resultWSMSafetyMeasures"];
                    }
                    else if([parseDictionaryWSM isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryWSM forKey:@"resultWSMSafetyMeasures"];
                    }
                }
            }
        }
        
        if ([parsedDictionaryOrderStatus objectForKey:@"EtOrderStatus"]) {
            
            if (![NullChecker isNull:[parsedDictionaryOrderStatus objectForKey:@"EtOrderStatus"]]) {
                
                parsedDictionaryOrderStatus = [parsedDictionaryOrderStatus objectForKey:@"EtOrderStatus"];
                if ([parsedDictionaryOrderStatus objectForKey:@"results"]) {
                    parsedDictionaryOrderStatus = [parsedDictionaryOrderStatus objectForKey:@"results"];
                    if ([parsedDictionaryOrderStatus isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parsedDictionaryOrderStatus] forKey:@"resultOrderStatus"];
                    }
                    else if([parsedDictionaryOrderStatus isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parsedDictionaryOrderStatus forKey:@"resultOrderStatus"];
                    }
                }
            }
        }
        
        if ([parsedDictionaryOrderOlist objectForKey:@"EtOrderOlist"]) {
            
            if (![NullChecker isNull:[parsedDictionaryOrderOlist objectForKey:@"EtOrderOlist"]]) {
                parsedDictionaryOrderOlist = [parsedDictionaryOrderOlist objectForKey:@"EtOrderOlist"];
                if ([parsedDictionaryOrderOlist objectForKey:@"results"]) {
                    parsedDictionaryOrderOlist = [parsedDictionaryOrderOlist objectForKey:@"results"];
                    if ([parsedDictionaryOrderOlist isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parsedDictionaryOrderOlist] forKey:@"resultOrderOlist"];
                    }
                    else if([parsedDictionaryOrderOlist isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parsedDictionaryOrderOlist forKey:@"resultOrderOlist"];
                    }
                }
            }
        }
        
        //WCM
        if ([parsedDictionaryCheckPoints objectForKey:@"EtWcmWaChkReq"]) {
            if (![NullChecker isNull:[parsedDictionaryCheckPoints objectForKey:@"EtWcmWaChkReq"]]) {
                parsedDictionaryCheckPoints = [parsedDictionaryCheckPoints objectForKey:@"EtWcmWaChkReq"];
                if ([parsedDictionaryCheckPoints objectForKey:@"results"]) {
                    parsedDictionaryCheckPoints = [parsedDictionaryCheckPoints objectForKey:@"results"];
                    if ([parsedDictionaryCheckPoints isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parsedDictionaryCheckPoints] forKey:@"resultStandardCheckPoints"];
                    }
                    else if([parsedDictionaryCheckPoints isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parsedDictionaryCheckPoints forKey:@"resultStandardCheckPoints"];
                    }
                }
            }
        }
        
        
        
        if ([parsedDictionaryWorkApplications objectForKey:@"EtWcmWaData"]) {
            if (![NullChecker isNull:[parsedDictionaryWorkApplications objectForKey:@"EtWcmWaData"]]) {
                parsedDictionaryWorkApplications = [parsedDictionaryWorkApplications objectForKey:@"EtWcmWaData"];
                if ([parsedDictionaryWorkApplications objectForKey:@"results"]) {
                    parsedDictionaryWorkApplications = [parsedDictionaryWorkApplications objectForKey:@"results"];
                    if ([parsedDictionaryWorkApplications isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parsedDictionaryWorkApplications] forKey:@"resultWorkApplicationData"];
                    }
                    else if([parsedDictionaryWorkApplications isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parsedDictionaryWorkApplications forKey:@"resultWorkApplicationData"];
                    }
                }
            }
        }
        
        if ([parsedDictionaryWcagns objectForKey:@"EtWcmWcagns"]) {
            if (![NullChecker isNull:[parsedDictionaryWcagns objectForKey:@"EtWcmWcagns"]]) {
                parsedDictionaryWcagns = [parsedDictionaryWcagns objectForKey:@"EtWcmWcagns"];
                if ([parsedDictionaryWcagns objectForKey:@"results"]) {
                    parsedDictionaryWcagns = [parsedDictionaryWcagns objectForKey:@"results"];
                    if ([parsedDictionaryWcagns isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parsedDictionaryWcagns] forKey:@"resultIssuePermits"];//issue permits
                    }
                    else if([parsedDictionaryWcagns isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parsedDictionaryWcagns forKey:@"resultIssuePermits"];//issue permits
                    }
                }
            }
        }
        
        if ([parsedDictionaryOpWCDDetails objectForKey:@"EtWcmWdData"]) {
            
            if (![NullChecker isNull:[parsedDictionaryOpWCDDetails objectForKey:@"EtWcmWdData"]]) {
                parsedDictionaryOpWCDDetails = [parsedDictionaryOpWCDDetails objectForKey:@"EtWcmWdData"];
                if ([parsedDictionaryOpWCDDetails objectForKey:@"results"]) {
                    parsedDictionaryOpWCDDetails = [parsedDictionaryOpWCDDetails objectForKey:@"results"];
                    if ([parsedDictionaryOpWCDDetails isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parsedDictionaryOpWCDDetails] forKey:@"resultOperationWCDData"];//isolation
                    }
                    else if([parsedDictionaryOpWCDDetails isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parsedDictionaryOpWCDDetails forKey:@"resultOperationWCDData"];//isolation
                    }
                }
            }
        }
        
        if ([parsedDictionaryOpWCDItemDetails objectForKey:@"EtWcmWdItemData"]) {
            if (![NullChecker isNull:[parsedDictionaryOpWCDItemDetails objectForKey:@"EtWcmWdItemData"]]) {
                parsedDictionaryOpWCDItemDetails = [parsedDictionaryOpWCDItemDetails objectForKey:@"EtWcmWdItemData"];
                if ([parsedDictionaryOpWCDItemDetails objectForKey:@"results"]) {
                    parsedDictionaryOpWCDItemDetails = [parsedDictionaryOpWCDItemDetails objectForKey:@"results"];
                    if ([parsedDictionaryOpWCDItemDetails isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parsedDictionaryOpWCDItemDetails] forKey:@"resultOperationWCDItemData"];//tagging conditions
                    }
                    else if([parsedDictionaryOpWCDItemDetails isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parsedDictionaryOpWCDItemDetails forKey:@"resultOperationWCDItemData"];//tagging conditions
                    }
                }
            }
        }
        
        if ([parsedDictionaryWorkApprovalDetails objectForKey:@"EtWcmWwData"]) {
            if (![NullChecker isNull:[parsedDictionaryWorkApprovalDetails objectForKey:@"EtWcmWwData"]]) {
                parsedDictionaryWorkApprovalDetails = [parsedDictionaryWorkApprovalDetails objectForKey:@"EtWcmWwData"];
                if ([parsedDictionaryWorkApprovalDetails objectForKey:@"results"]) {
                    parsedDictionaryWorkApprovalDetails = [parsedDictionaryWorkApprovalDetails objectForKey:@"results"];
                    if ([parsedDictionaryWorkApprovalDetails isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parsedDictionaryWorkApprovalDetails] forKey:@"resultWorkApprovalsData"];
                    }
                    else if([parsedDictionaryWorkApprovalDetails isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parsedDictionaryWorkApprovalDetails forKey:@"resultWorkApprovalsData"];
                    }
                }
                
            }
            
            return xmlDoc;
            
        }
     }
    
    return [NSMutableDictionary dictionary];
}


- (NSMutableDictionary *)parseForColletctiveConfirmOrder:(NSDictionary *)resultDictionary
{
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    
    NSDictionary *parseDictionary,*parseDictionaryHeaderPermits,*parseDictionaryOperationTransaction,*parseDictionaryComponentsTransaction,*parseDictionaryLongText,*parseDictionaryDocs,*parseDictionaryWSM,*parseDictionaryObjects,*parsedDictionaryOrderStatus,*parsedDictionaryOrderOlist,*parsedDictionaryCheckPoints,*parsedDictionaryWorkApplications,*parsedDictionaryWcagns,*parsedDictionaryOpWCDDetails,*parsedDictionaryOpWCDItemDetails,*parsedDictionaryWorkApprovalDetails,*parsedDictionaryMeasurementDocuments,*parseHeaderDictionary,*parseMessageDictionary;
    
    if ([resultDictionary objectForKey:@"d"])
    {
        parseDictionary = [resultDictionary objectForKey:@"d"];
        
        id dataObject = [parseDictionary copy];
        
        if ([dataObject isKindOfClass:[NSDictionary class]]) {
            
            parseDictionaryHeaderPermits = [dataObject copy];
            parseDictionaryOperationTransaction = [dataObject copy];
            parseDictionaryComponentsTransaction = [dataObject copy];
            parseDictionaryLongText = [dataObject copy];
            parseDictionaryDocs = [dataObject copy];
            parseDictionaryWSM = [dataObject copy];
            parseDictionaryObjects = [dataObject copy];
            parsedDictionaryOrderStatus = [dataObject copy];
            parsedDictionaryOrderOlist = [dataObject copy];
            parsedDictionaryCheckPoints = [dataObject copy];
            parsedDictionaryWorkApplications = [dataObject copy];
            parsedDictionaryWcagns = [dataObject copy];
            parsedDictionaryOpWCDDetails = [dataObject copy];
            parsedDictionaryOpWCDItemDetails = [dataObject copy];
            parsedDictionaryWorkApprovalDetails = [dataObject copy];
            parsedDictionaryMeasurementDocuments = [dataObject copy];
            parseHeaderDictionary = [dataObject copy];
            parseMessageDictionary = [dataObject copy];
            
        }
        else if ([dataObject isKindOfClass:[NSArray class]])
        {
            if ([dataObject count]) {
                parseDictionaryHeaderPermits = [[dataObject objectAtIndex:0] copy];
                parseDictionaryOperationTransaction = [[dataObject objectAtIndex:0] copy];
                parseDictionaryComponentsTransaction = [[dataObject objectAtIndex:0] copy];
                parseDictionaryLongText = [[dataObject objectAtIndex:0] copy];
                parseDictionaryDocs = [[dataObject objectAtIndex:0] copy];
                parseDictionaryWSM = [[dataObject objectAtIndex:0] copy];
                parseDictionaryObjects = [[dataObject objectAtIndex:0] copy];
                parsedDictionaryOrderStatus = [[dataObject objectAtIndex:0] copy];
                parsedDictionaryOrderOlist = [[dataObject objectAtIndex:0] copy];
                parsedDictionaryCheckPoints = [[dataObject objectAtIndex:0] copy];
                parsedDictionaryWorkApplications = [[dataObject objectAtIndex:0] copy];
                parsedDictionaryWcagns = [[dataObject objectAtIndex:0] copy];
                parsedDictionaryOpWCDDetails = [[dataObject objectAtIndex:0] copy];
                parsedDictionaryOpWCDItemDetails = [[dataObject objectAtIndex:0] copy];
                parsedDictionaryWorkApprovalDetails = [[dataObject objectAtIndex:0] copy];
                parsedDictionaryMeasurementDocuments = [[dataObject objectAtIndex:0] copy];
                parseHeaderDictionary = [[dataObject objectAtIndex:0] copy];
                
                parseMessageDictionary = [[dataObject objectAtIndex:0] copy];
                
                
            }
        }
        
        
        if ([parseHeaderDictionary objectForKey:@"EtOrderHeader"]) {
            
          if (![NullChecker isNull:[parseHeaderDictionary objectForKey:@"EtOrderHeader"]]) {
 
               parseHeaderDictionary = [parseHeaderDictionary objectForKey:@"EtOrderHeader"];
              if ([parseHeaderDictionary objectForKey:@"results"]) {
                parseHeaderDictionary = [parseHeaderDictionary objectForKey:@"results"];
                if ([parseHeaderDictionary isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:parseHeaderDictionary] forKey:@"resultHeader"];
                }
                else if([parseHeaderDictionary isKindOfClass:[NSArray class]])
                {
                    [xmlDoc setObject:parseHeaderDictionary forKey:@"resultHeader"];
                }
              }
           }
          }
        
        if ([parseDictionaryObjects objectForKey:@"EtOrderOlist"]) {
            parseDictionaryObjects = [parseDictionaryObjects objectForKey:@"EtOrderOlist"];
            if ([parseDictionaryObjects objectForKey:@"results"]) {
                parseDictionaryObjects = [parseDictionaryObjects objectForKey:@"results"];
                if ([parseDictionaryObjects isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryObjects] forKey:@"resultHeaderObjects"];
                }
                else if([parseDictionaryObjects isKindOfClass:[NSArray class]])
                {
                    [xmlDoc setObject:parseDictionaryObjects forKey:@"resultHeaderObjects"];
                }
            }
        }
        
        if ([parsedDictionaryMeasurementDocuments objectForKey:@"EtImrg"]) {
            parsedDictionaryMeasurementDocuments = [parsedDictionaryMeasurementDocuments objectForKey:@"EtImrg"];
            if ([parsedDictionaryMeasurementDocuments objectForKey:@"results"]) {
                parsedDictionaryMeasurementDocuments = [parsedDictionaryMeasurementDocuments objectForKey:@"results"];
                if ([parsedDictionaryMeasurementDocuments isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:parsedDictionaryMeasurementDocuments] forKey:@"resultMeasurementDocuments"];
                }
                else if([parsedDictionaryMeasurementDocuments isKindOfClass:[NSArray class]])
                {
                    [xmlDoc setObject:parsedDictionaryMeasurementDocuments forKey:@"resultMeasurementDocuments"];
                }
            }
        }
        
        if ([parseDictionaryHeaderPermits objectForKey:@"EtOrderPermits"]) {
            parseDictionaryHeaderPermits = [parseDictionaryHeaderPermits objectForKey:@"EtOrderPermits"];
            if ([parseDictionaryHeaderPermits objectForKey:@"results"]) {
                parseDictionaryHeaderPermits = [parseDictionaryHeaderPermits objectForKey:@"results"];
                if ([parseDictionaryHeaderPermits isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryHeaderPermits] forKey:@"resultHeaderPermits"];
                }
                else if([parseDictionaryHeaderPermits isKindOfClass:[NSArray class]])
                {
                    [xmlDoc setObject:parseDictionaryHeaderPermits forKey:@"resultHeaderPermits"];
                }
            }
        }
        
        if ([parseDictionaryOperationTransaction objectForKey:@"EtOrderOperations"]) {
            
            if (![NullChecker isNull:[parseDictionaryComponentsTransaction objectForKey:@"EtOrderOperations"]]) {
           
                parseDictionaryOperationTransaction = [parseDictionaryOperationTransaction objectForKey:@"EtOrderOperations"];
            
                if ([parseDictionaryOperationTransaction objectForKey:@"results"]) {
                parseDictionaryOperationTransaction = [parseDictionaryOperationTransaction objectForKey:@"results"];
                if ([parseDictionaryOperationTransaction isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryOperationTransaction] forKey:@"resultOperationsTransactions"];
                }
                else if([parseDictionaryOperationTransaction isKindOfClass:[NSArray class]])
                {
                    [xmlDoc setObject:parseDictionaryOperationTransaction forKey:@"resultOperationsTransactions"];
                }
            }
            }
        }
        
        if ([parseMessageDictionary objectForKey:@"EsAufnr"]) {
            
            if (![NullChecker isNull:[parseMessageDictionary objectForKey:@"EsAufnr"]]) {
                
                if ([[parseMessageDictionary objectForKey:@"EsAufnr"] objectForKey:@"results"]) {
                    id messageArray = [[parseMessageDictionary objectForKey:@"EsAufnr"] objectForKey:@"results"];
                    if ([messageArray isKindOfClass:[NSDictionary class]]) {
                        
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:[[[[messageArray objectForKey:@"EsAufnr"] objectForKey:@"results"] objectAtIndex:0] objectForKey:@"Message"]] forKey:@"Message"];
                     }
                    else if([messageArray isKindOfClass:[NSArray class]])
                    {
                        
                        [xmlDoc setObject:[[messageArray objectAtIndex:0] objectForKey:@"Message"] forKey:@"Message"];
                     }
                }
            }
 
        }
        
        
        if ([parseDictionaryComponentsTransaction objectForKey:@"EtOrderComponents"]) {
            
            if (![NullChecker isNull:[parseDictionaryComponentsTransaction objectForKey:@"EtOrderComponents"]]) {
                
                parseDictionaryComponentsTransaction = [parseDictionaryComponentsTransaction objectForKey:@"EtOrderComponents"];
                
                if ([parseDictionaryComponentsTransaction objectForKey:@"results"]) {
                    parseDictionaryComponentsTransaction = [parseDictionaryComponentsTransaction objectForKey:@"results"];
                    if ([parseDictionaryComponentsTransaction isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryComponentsTransaction] forKey:@"resultComponentsTransactions"];
                    }
                    else if([parseDictionaryComponentsTransaction isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryComponentsTransaction forKey:@"resultComponentsTransactions"];
                    }
                }
                
            }
        }
        
        if ([parseDictionaryLongText objectForKey:@"EtOrderLongtext"]) {
 
           if (![NullChecker isNull:[parseDictionaryLongText objectForKey:@"EtOrderLongtext"]]) {
           
             parseDictionaryLongText = [parseDictionaryLongText objectForKey:@"EtOrderLongtext"];
            if ([parseDictionaryLongText objectForKey:@"results"]) {
                parseDictionaryLongText = [parseDictionaryLongText objectForKey:@"results"];
                if ([parseDictionaryLongText isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryLongText] forKey:@"resultLongText"];
                }
                else if([parseDictionaryLongText isKindOfClass:[NSArray class]])
                {
                    [xmlDoc setObject:parseDictionaryLongText forKey:@"resultLongText"];
                }
               }
             }
        }
        
        if ([parseDictionaryDocs objectForKey:@"EtDocs"]) {
            
            if (![NullChecker isNull:[parseDictionaryLongText objectForKey:@"EtDocs"]]) {

             parseDictionaryDocs = [parseDictionaryDocs objectForKey:@"EtDocs"];
             if ([parseDictionaryDocs objectForKey:@"results"]) {
                parseDictionaryDocs = [parseDictionaryDocs objectForKey:@"results"];
                if ([parseDictionaryDocs isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryDocs] forKey:@"resultDocs"];
                }
                else if([parseDictionaryDocs isKindOfClass:[NSArray class]])
                {
                    [xmlDoc setObject:parseDictionaryDocs forKey:@"resultDocs"];
                }
              }
                
            }
        }
        
        if ([parseDictionaryWSM objectForKey:@"EtWsmOrdSafemeas"]) {
            parseDictionaryWSM = [parseDictionaryWSM objectForKey:@"EtWsmOrdSafemeas"];
            if ([parseDictionaryWSM objectForKey:@"results"]) {
                parseDictionaryWSM = [parseDictionaryWSM objectForKey:@"results"];
                if ([parseDictionaryWSM isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryWSM] forKey:@"resultWSMSafetyMeasures"];
                }
                else if([parseDictionaryWSM isKindOfClass:[NSArray class]])
                {
                    [xmlDoc setObject:parseDictionaryWSM forKey:@"resultWSMSafetyMeasures"];
                }
            }
        }
        
        if ([parsedDictionaryOrderStatus objectForKey:@"EtOrderStatus"]) {
            if (![NullChecker isNull:[parseDictionaryComponentsTransaction objectForKey:@"EtOrderStatus"]]) {
             parsedDictionaryOrderStatus = [parsedDictionaryOrderStatus objectForKey:@"EtOrderStatus"];
            if ([parsedDictionaryOrderStatus objectForKey:@"results"]) {
                parsedDictionaryOrderStatus = [parsedDictionaryOrderStatus objectForKey:@"results"];
                if ([parsedDictionaryOrderStatus isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:parsedDictionaryOrderStatus] forKey:@"resultOrderStatus"];
                }
                else if([parsedDictionaryOrderStatus isKindOfClass:[NSArray class]])
                {
                    [xmlDoc setObject:parsedDictionaryOrderStatus forKey:@"resultOrderStatus"];
                }
            }
            }
        }
        
        if ([parsedDictionaryOrderOlist objectForKey:@"EtOrderOlist"]) {
            parsedDictionaryOrderOlist = [parsedDictionaryOrderOlist objectForKey:@"EtOrderOlist"];
            if ([parsedDictionaryOrderOlist objectForKey:@"results"]) {
                parsedDictionaryOrderOlist = [parsedDictionaryOrderOlist objectForKey:@"results"];
                if ([parsedDictionaryOrderOlist isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:parsedDictionaryOrderOlist] forKey:@"resultOrderOlist"];
                }
                else if([parsedDictionaryOrderOlist isKindOfClass:[NSArray class]])
                {
                    [xmlDoc setObject:parsedDictionaryOrderOlist forKey:@"resultOrderOlist"];
                }
            }
        }
        
        //WCM
        if ([parsedDictionaryCheckPoints objectForKey:@"EtWcmWaChkReq"]) {
            parsedDictionaryCheckPoints = [parsedDictionaryCheckPoints objectForKey:@"EtWcmWaChkReq"];
            if ([parsedDictionaryCheckPoints objectForKey:@"results"]) {
                parsedDictionaryCheckPoints = [parsedDictionaryCheckPoints objectForKey:@"results"];
                if ([parsedDictionaryCheckPoints isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:parsedDictionaryCheckPoints] forKey:@"resultStandardCheckPoints"];
                }
                else if([parsedDictionaryCheckPoints isKindOfClass:[NSArray class]])
                {
                    [xmlDoc setObject:parsedDictionaryCheckPoints forKey:@"resultStandardCheckPoints"];
                }
            }
        }
        
        if ([parsedDictionaryWorkApplications objectForKey:@"EtWcmWaData"]) {
            parsedDictionaryWorkApplications = [parsedDictionaryWorkApplications objectForKey:@"EtWcmWaData"];
            if ([parsedDictionaryWorkApplications objectForKey:@"results"]) {
                parsedDictionaryWorkApplications = [parsedDictionaryWorkApplications objectForKey:@"results"];
                if ([parsedDictionaryWorkApplications isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:parsedDictionaryWorkApplications] forKey:@"resultWorkApplicationData"];
                }
                else if([parsedDictionaryWorkApplications isKindOfClass:[NSArray class]])
                {
                    [xmlDoc setObject:parsedDictionaryWorkApplications forKey:@"resultWorkApplicationData"];
                }
            }
        }
        
        if ([parsedDictionaryWcagns objectForKey:@"EtWcmWcagns"]) {
            parsedDictionaryWcagns = [parsedDictionaryWcagns objectForKey:@"EtWcmWcagns"];
            if ([parsedDictionaryWcagns objectForKey:@"results"]) {
                parsedDictionaryWcagns = [parsedDictionaryWcagns objectForKey:@"results"];
                if ([parsedDictionaryWcagns isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:parsedDictionaryWcagns] forKey:@"resultIssuePermits"];//issue permits
                }
                else if([parsedDictionaryWcagns isKindOfClass:[NSArray class]])
                {
                    [xmlDoc setObject:parsedDictionaryWcagns forKey:@"resultIssuePermits"];//issue permits
                }
            }
        }
        
        if ([parsedDictionaryOpWCDDetails objectForKey:@"EtWcmWdData"]) {
            parsedDictionaryOpWCDDetails = [parsedDictionaryOpWCDDetails objectForKey:@"EtWcmWdData"];
            if ([parsedDictionaryOpWCDDetails objectForKey:@"results"]) {
                parsedDictionaryOpWCDDetails = [parsedDictionaryOpWCDDetails objectForKey:@"results"];
                if ([parsedDictionaryOpWCDDetails isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:parsedDictionaryOpWCDDetails] forKey:@"resultOperationWCDData"];//isolation
                }
                else if([parsedDictionaryOpWCDDetails isKindOfClass:[NSArray class]])
                {
                    [xmlDoc setObject:parsedDictionaryOpWCDDetails forKey:@"resultOperationWCDData"];//isolation
                }
            }
        }
        
        if ([parsedDictionaryOpWCDItemDetails objectForKey:@"EtWcmWdItemData"]) {
            parsedDictionaryOpWCDItemDetails = [parsedDictionaryOpWCDItemDetails objectForKey:@"EtWcmWdItemData"];
            if ([parsedDictionaryOpWCDItemDetails objectForKey:@"results"]) {
                parsedDictionaryOpWCDItemDetails = [parsedDictionaryOpWCDItemDetails objectForKey:@"results"];
                if ([parsedDictionaryOpWCDItemDetails isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:parsedDictionaryOpWCDItemDetails] forKey:@"resultOperationWCDItemData"];//tagging conditions
                }
                else if([parsedDictionaryOpWCDItemDetails isKindOfClass:[NSArray class]])
                {
                    [xmlDoc setObject:parsedDictionaryOpWCDItemDetails forKey:@"resultOperationWCDItemData"];//tagging conditions
                }
            }
        }
        
        
        if ([parsedDictionaryWorkApprovalDetails objectForKey:@"EtWcmWwData"]) {
            parsedDictionaryWorkApprovalDetails = [parsedDictionaryWorkApprovalDetails objectForKey:@"EtWcmWwData"];
            if ([parsedDictionaryWorkApprovalDetails objectForKey:@"results"]) {
                parsedDictionaryWorkApprovalDetails = [parsedDictionaryWorkApprovalDetails objectForKey:@"results"];
                if ([parsedDictionaryWorkApprovalDetails isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:parsedDictionaryWorkApprovalDetails] forKey:@"resultWorkApprovalsData"];
                }
                else if([parsedDictionaryWorkApprovalDetails isKindOfClass:[NSArray class]])
                {
                    [xmlDoc setObject:parsedDictionaryWorkApprovalDetails forKey:@"resultWorkApprovalsData"];
                }
            }
            
            return xmlDoc;
        }
    }
    
    return [NSMutableDictionary dictionary];
}

- (NSMutableDictionary *)parseForListOfOrders:(NSDictionary *)resultDictionary
{
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    NSMutableDictionary *parseDictionary;
    if ([resultDictionary objectForKey:@"d"]) {
        parseDictionary = [resultDictionary objectForKey:@"d"];
        if ([parseDictionary objectForKey:@"results"]) {
            id dataObject = [parseDictionary objectForKey:@"results"];
            if ([dataObject isKindOfClass:[NSDictionary class]]) {
                [xmlDoc setObject:[NSMutableArray arrayWithObject:dataObject] forKey:@"result"];
            }
            else if([dataObject isKindOfClass:[NSArray class]])
            {
                [xmlDoc setObject:dataObject forKey:@"result"];
            }
            
            NSMutableArray *parseDictionaryOperationTransaction,*parseDictionaryComponentTransaction,*parseDictionaryLongText,*parseArrayHeader;
            parseDictionaryLongText = [[NSMutableArray alloc] init];
            
            parseDictionaryOperationTransaction = [[NSMutableArray alloc] init];
            parseDictionaryComponentTransaction = [[NSMutableArray alloc]init];            
            parseArrayHeader = [[NSMutableArray alloc] init];
            
            NSArray *orderArray = [xmlDoc objectForKey:@"result"];
            [xmlDoc removeObjectForKey:@"result"];
            for (int i=0; i<[orderArray count]; i++) {
                
                NSMutableDictionary *orderDictionary = [NSMutableDictionary dictionaryWithDictionary:[orderArray objectAtIndex:i]];
                
                if ([orderDictionary objectForKey:@"OrderLongTexts"]) {
                    if ([[orderDictionary objectForKey:@"OrderLongTexts"] objectForKey:@"results"]) {
                        id orderTextArray = [[orderDictionary objectForKey:@"OrderLongTexts"] objectForKey:@"results"];
                        if ([orderTextArray isKindOfClass:[NSDictionary class]]) {
                            [parseDictionaryLongText addObject:orderTextArray];
                        }
                        else if([orderTextArray isKindOfClass:[NSArray class]])
                        {
                            [parseDictionaryLongText addObjectsFromArray:orderTextArray];
                        }
                        [orderDictionary removeObjectForKey:@"OrderLongTexts"];
                    }
                    
                }
                id orderTransactionsArray;
                
                if ([[orderDictionary objectForKey:@"OrderOperations"] objectForKey:@"results"] ) {
                    
                    orderTransactionsArray = [[orderDictionary objectForKey:@"OrderOperations"] objectForKey:@"results"];
                    
                    for (int j =0; j<[orderTransactionsArray count]; j++) {
                        
                        NSMutableDictionary *operatationDictionary = [NSMutableDictionary dictionaryWithDictionary:[orderTransactionsArray objectAtIndex:j]];
                        if ([[operatationDictionary objectForKey:@"OrderComponents"] objectForKey:@"results"]) {
                            NSMutableArray *componenetArray = [[operatationDictionary objectForKey:@"OrderComponents"] objectForKey:@"results"];
                            if ([componenetArray count]) {
                                [parseDictionaryComponentTransaction addObjectsFromArray:componenetArray];
                            }
                        }
                        [operatationDictionary removeObjectForKey:@"OrderComponents"];
                        if ([[operatationDictionary objectForKey:@"OrderOperationLongTexts"] objectForKey:@"results"]) {
                            NSMutableArray *openLongTextArray = [[operatationDictionary objectForKey:@"OrderOperationLongTexts"] objectForKey:@"results"];
                            if ([openLongTextArray count]) {
                                [parseDictionaryLongText addObjectsFromArray:openLongTextArray];
                            }
                        }
                        [operatationDictionary removeObjectForKey:@"OrderOperationLongTexts"];
                        [parseDictionaryOperationTransaction addObject:operatationDictionary];
                        
                    }
                    
                    [orderDictionary removeObjectForKey:@"OrderOperations"];
                }
                [parseArrayHeader addObject:orderDictionary];
       
            }
            [xmlDoc removeObjectForKey:@"result"];
            [xmlDoc setObject:parseArrayHeader forKey:@"resultHeader"];
            [xmlDoc setObject:parseDictionaryOperationTransaction forKey:@"resultOperationsTransactions"];
            [xmlDoc setObject:parseDictionaryComponentTransaction forKey:@"resultComponentsTransactions"];
            
             [xmlDoc setObject:parseDictionaryLongText forKey:@"resultLongText"];
 
            return xmlDoc;
        }
    }
    else if([resultDictionary objectForKey:@"error"])
    {
        parseDictionary = [[resultDictionary objectForKey:@"error"] objectForKey:@"message"];
        [xmlDoc setObject:[parseDictionary objectForKey:@"value"] forKey:@"ERROR"];
        return xmlDoc;
    }

    return [NSMutableDictionary dictionary];
}

- (NSMutableDictionary *)parseForChangeOrder:(NSDictionary *)resultDictionary
{
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    
    NSDictionary *parseDictionary,*parseDictionaryHeaderPermits,*parseDictionaryOperationTransaction,*parseDictionaryComponentsTransaction,*parseDictionaryLongText,*parseDictionaryDocs,*parseDictionaryWSM,*parseDictionaryObjects,*parsedDictionaryOrderStatus,*parsedDictionaryOrderOlist,*parsedDictionaryCheckPoints,*parsedDictionaryWorkApplications,*parsedDictionaryWcagns,*parsedDictionaryOpWCDDetails,*parsedDictionaryOpWCDItemDetails,*parsedDictionaryWorkApprovalDetails,*parsedDictionaryMeasurementDocuments,*parseHeaderDictionary,*parseMessageDictionary;
    
    if ([resultDictionary objectForKey:@"d"])
    {
        parseDictionary = [resultDictionary objectForKey:@"d"];
        
        id dataObject = [parseDictionary copy];
        
        if ([dataObject isKindOfClass:[NSDictionary class]]) {
            
            parseDictionaryHeaderPermits = [dataObject copy];
            parseDictionaryOperationTransaction = [dataObject copy];
            parseDictionaryComponentsTransaction = [dataObject copy];
            parseDictionaryLongText = [dataObject copy];
            parseDictionaryDocs = [dataObject copy];
            parseDictionaryWSM = [dataObject copy];
            parseDictionaryObjects = [dataObject copy];
            parsedDictionaryOrderStatus = [dataObject copy];
            parsedDictionaryOrderOlist = [dataObject copy];
            parsedDictionaryCheckPoints = [dataObject copy];
            parsedDictionaryWorkApplications = [dataObject copy];
            parsedDictionaryWcagns = [dataObject copy];
            parsedDictionaryOpWCDDetails = [dataObject copy];
            parsedDictionaryOpWCDItemDetails = [dataObject copy];
            parsedDictionaryWorkApprovalDetails = [dataObject copy];
            parsedDictionaryMeasurementDocuments = [dataObject copy];
            parseHeaderDictionary = [dataObject copy];
            
            parseMessageDictionary = [dataObject copy];
            
        }
        else if ([dataObject isKindOfClass:[NSArray class]])
        {
            if ([dataObject count]) {
                parseDictionaryHeaderPermits = [[dataObject objectAtIndex:0] copy];
                parseDictionaryOperationTransaction = [[dataObject objectAtIndex:0] copy];
                parseDictionaryComponentsTransaction = [[dataObject objectAtIndex:0] copy];
                parseDictionaryLongText = [[dataObject objectAtIndex:0] copy];
                parseDictionaryDocs = [[dataObject objectAtIndex:0] copy];
                parseDictionaryWSM = [[dataObject objectAtIndex:0] copy];
                parseDictionaryObjects = [[dataObject objectAtIndex:0] copy];
                parsedDictionaryOrderStatus = [[dataObject objectAtIndex:0] copy];
                parsedDictionaryOrderOlist = [[dataObject objectAtIndex:0] copy];
                parsedDictionaryCheckPoints = [[dataObject objectAtIndex:0] copy];
                parsedDictionaryWorkApplications = [[dataObject objectAtIndex:0] copy];
                parsedDictionaryWcagns = [[dataObject objectAtIndex:0] copy];
                parsedDictionaryOpWCDDetails = [[dataObject objectAtIndex:0] copy];
                parsedDictionaryOpWCDItemDetails = [[dataObject objectAtIndex:0] copy];
                parsedDictionaryWorkApprovalDetails = [[dataObject objectAtIndex:0] copy];
                parsedDictionaryMeasurementDocuments = [[dataObject objectAtIndex:0] copy];
                parseHeaderDictionary = [[dataObject objectAtIndex:0] copy];
                
                parseMessageDictionary = [[dataObject objectAtIndex:0] copy];
                
                
            }
        }
        
        
        if ([parseHeaderDictionary objectForKey:@"EtOrderHeader"]) {
            
            if (![NullChecker isNull:[parseHeaderDictionary objectForKey:@"EtOrderHeader"]]) {
                
                parseHeaderDictionary = [parseHeaderDictionary objectForKey:@"EtOrderHeader"];
                if ([parseHeaderDictionary objectForKey:@"results"]) {
                    parseHeaderDictionary = [parseHeaderDictionary objectForKey:@"results"];
                    if ([parseHeaderDictionary isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseHeaderDictionary] forKey:@"resultHeader"];
                    }
                    else if([parseHeaderDictionary isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseHeaderDictionary forKey:@"resultHeader"];
                    }
                }
            }
        }
        
        if ([parseDictionaryObjects objectForKey:@"EtOrderOlist"]) {
            parseDictionaryObjects = [parseDictionaryObjects objectForKey:@"EtOrderOlist"];
            if ([parseDictionaryObjects objectForKey:@"results"]) {
                parseDictionaryObjects = [parseDictionaryObjects objectForKey:@"results"];
                if ([parseDictionaryObjects isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryObjects] forKey:@"resultHeaderObjects"];
                }
                else if([parseDictionaryObjects isKindOfClass:[NSArray class]])
                {
                    [xmlDoc setObject:parseDictionaryObjects forKey:@"resultHeaderObjects"];
                }
            }
        }
        
        if ([parsedDictionaryMeasurementDocuments objectForKey:@"EtImrg"]) {
            parsedDictionaryMeasurementDocuments = [parsedDictionaryMeasurementDocuments objectForKey:@"EtImrg"];
            if ([parsedDictionaryMeasurementDocuments objectForKey:@"results"]) {
                parsedDictionaryMeasurementDocuments = [parsedDictionaryMeasurementDocuments objectForKey:@"results"];
                if ([parsedDictionaryMeasurementDocuments isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:parsedDictionaryMeasurementDocuments] forKey:@"resultMeasurementDocuments"];
                }
                else if([parsedDictionaryMeasurementDocuments isKindOfClass:[NSArray class]])
                {
                    [xmlDoc setObject:parsedDictionaryMeasurementDocuments forKey:@"resultMeasurementDocuments"];
                }
            }
        }
        
        if ([parseDictionaryHeaderPermits objectForKey:@"EtOrderPermits"]) {
            parseDictionaryHeaderPermits = [parseDictionaryHeaderPermits objectForKey:@"EtOrderPermits"];
            if ([parseDictionaryHeaderPermits objectForKey:@"results"]) {
                parseDictionaryHeaderPermits = [parseDictionaryHeaderPermits objectForKey:@"results"];
                if ([parseDictionaryHeaderPermits isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryHeaderPermits] forKey:@"resultHeaderPermits"];
                }
                else if([parseDictionaryHeaderPermits isKindOfClass:[NSArray class]])
                {
                    [xmlDoc setObject:parseDictionaryHeaderPermits forKey:@"resultHeaderPermits"];
                }
            }
        }
        
        if ([parseDictionaryOperationTransaction objectForKey:@"EtOrderOperations"]) {
            
            if (![NullChecker isNull:[parseDictionaryOperationTransaction objectForKey:@"EtOrderOperations"]]) {
                
                parseDictionaryOperationTransaction = [parseDictionaryOperationTransaction objectForKey:@"EtOrderOperations"];
                
                if ([parseDictionaryOperationTransaction objectForKey:@"results"]) {
                    parseDictionaryOperationTransaction = [parseDictionaryOperationTransaction objectForKey:@"results"];
                    if ([parseDictionaryOperationTransaction isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryOperationTransaction] forKey:@"resultOperationsTransactions"];
                    }
                    else if([parseDictionaryOperationTransaction isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryOperationTransaction forKey:@"resultOperationsTransactions"];
                    }
                }
            }
        }
        
        if ([parseMessageDictionary objectForKey:@"EtMessages"]) {
            if ([[parseMessageDictionary objectForKey:@"EtMessages"] objectForKey:@"results"]) {
                id messageArray = [[parseMessageDictionary objectForKey:@"EtMessages"] objectForKey:@"results"];
                if ([messageArray isKindOfClass:[NSDictionary class]]) {
                    
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:[[[[messageArray objectForKey:@"EtMessages"] objectForKey:@"results"] objectAtIndex:0] objectForKey:@"Message"]] forKey:@"Message"];
                    
                }
                else if([messageArray isKindOfClass:[NSArray class]])
                {
                     [xmlDoc setObject:[[messageArray objectAtIndex:0] objectForKey:@"Message"] forKey:@"Message"];
                 }
            }
        }
        
        
        if ([parseDictionaryComponentsTransaction objectForKey:@"EtOrderComponents"]) {
            
            if (![NullChecker isNull:[parseDictionaryComponentsTransaction objectForKey:@"EtOrderComponents"]]) {
                
                parseDictionaryComponentsTransaction = [parseDictionaryComponentsTransaction objectForKey:@"EtOrderComponents"];
                
                if ([parseDictionaryComponentsTransaction objectForKey:@"results"]) {
                    parseDictionaryComponentsTransaction = [parseDictionaryComponentsTransaction objectForKey:@"results"];
                    if ([parseDictionaryComponentsTransaction isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryComponentsTransaction] forKey:@"resultComponentsTransactions"];
                    }
                    else if([parseDictionaryComponentsTransaction isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryComponentsTransaction forKey:@"resultComponentsTransactions"];
                    }
                }
                
            }
        }
        
        if ([parseDictionaryLongText objectForKey:@"EtOrderLongtext"]) {
            
            if (![NullChecker isNull:[parseDictionaryLongText objectForKey:@"EtOrderLongtext"]]) {
                
                parseDictionaryLongText = [parseDictionaryLongText objectForKey:@"EtOrderLongtext"];
                if ([parseDictionaryLongText objectForKey:@"results"]) {
                    parseDictionaryLongText = [parseDictionaryLongText objectForKey:@"results"];
                    if ([parseDictionaryLongText isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryLongText] forKey:@"resultLongText"];
                    }
                    else if([parseDictionaryLongText isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryLongText forKey:@"resultLongText"];
                    }
                }
            }
        }
        
        if ([parseDictionaryDocs objectForKey:@"EtDocs"]) {
             if (![NullChecker isNull:[parseDictionaryDocs objectForKey:@"EtDocs"]]) {
                 parseDictionaryDocs = [parseDictionaryDocs objectForKey:@"EtDocs"];
                if ([parseDictionaryDocs objectForKey:@"results"]) {
                    parseDictionaryDocs = [parseDictionaryDocs objectForKey:@"results"];
                    if ([parseDictionaryDocs isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryDocs] forKey:@"resultDocs"];
                    }
                    else if([parseDictionaryDocs isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryDocs forKey:@"resultDocs"];
                    }
                }
             }
        }
        
        if ([parseDictionaryWSM objectForKey:@"EtWsmOrdSafemeas"]) {
            parseDictionaryWSM = [parseDictionaryWSM objectForKey:@"EtWsmOrdSafemeas"];
            if ([parseDictionaryWSM objectForKey:@"results"]) {
                parseDictionaryWSM = [parseDictionaryWSM objectForKey:@"results"];
                if ([parseDictionaryWSM isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryWSM] forKey:@"resultWSMSafetyMeasures"];
                }
                else if([parseDictionaryWSM isKindOfClass:[NSArray class]])
                {
                    [xmlDoc setObject:parseDictionaryWSM forKey:@"resultWSMSafetyMeasures"];
                }
            }
        }
        
        if ([parsedDictionaryOrderStatus objectForKey:@"EtOrderStatus"]) {
            if (![NullChecker isNull:[parsedDictionaryOrderStatus objectForKey:@"EtOrderStatus"]]) {
                parsedDictionaryOrderStatus = [parsedDictionaryOrderStatus objectForKey:@"EtOrderStatus"];
                if ([parsedDictionaryOrderStatus objectForKey:@"results"]) {
                    parsedDictionaryOrderStatus = [parsedDictionaryOrderStatus objectForKey:@"results"];
                    if ([parsedDictionaryOrderStatus isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parsedDictionaryOrderStatus] forKey:@"resultOrderStatus"];
                    }
                    else if([parsedDictionaryOrderStatus isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parsedDictionaryOrderStatus forKey:@"resultOrderStatus"];
                    }
                }
            }
        }
        
        if ([parsedDictionaryOrderOlist objectForKey:@"EtOrderOlist"]) {
            parsedDictionaryOrderOlist = [parsedDictionaryOrderOlist objectForKey:@"EtOrderOlist"];
            if ([parsedDictionaryOrderOlist objectForKey:@"results"]) {
                parsedDictionaryOrderOlist = [parsedDictionaryOrderOlist objectForKey:@"results"];
                if ([parsedDictionaryOrderOlist isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:parsedDictionaryOrderOlist] forKey:@"resultOrderOlist"];
                }
                else if([parsedDictionaryOrderOlist isKindOfClass:[NSArray class]])
                {
                    [xmlDoc setObject:parsedDictionaryOrderOlist forKey:@"resultOrderOlist"];
                }
            }
        }
        
        //WCM
        if ([parsedDictionaryCheckPoints objectForKey:@"EtWcmWaChkReq"]) {
            parsedDictionaryCheckPoints = [parsedDictionaryCheckPoints objectForKey:@"EtWcmWaChkReq"];
            if ([parsedDictionaryCheckPoints objectForKey:@"results"]) {
                parsedDictionaryCheckPoints = [parsedDictionaryCheckPoints objectForKey:@"results"];
                if ([parsedDictionaryCheckPoints isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:parsedDictionaryCheckPoints] forKey:@"resultStandardCheckPoints"];
                }
                else if([parsedDictionaryCheckPoints isKindOfClass:[NSArray class]])
                {
                    [xmlDoc setObject:parsedDictionaryCheckPoints forKey:@"resultStandardCheckPoints"];
                }
            }
        }
        
        if ([parsedDictionaryWorkApplications objectForKey:@"EtWcmWaData"]) {
            parsedDictionaryWorkApplications = [parsedDictionaryWorkApplications objectForKey:@"EtWcmWaData"];
            if ([parsedDictionaryWorkApplications objectForKey:@"results"]) {
                parsedDictionaryWorkApplications = [parsedDictionaryWorkApplications objectForKey:@"results"];
                if ([parsedDictionaryWorkApplications isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:parsedDictionaryWorkApplications] forKey:@"resultWorkApplicationData"];
                }
                else if([parsedDictionaryWorkApplications isKindOfClass:[NSArray class]])
                {
                    [xmlDoc setObject:parsedDictionaryWorkApplications forKey:@"resultWorkApplicationData"];
                }
            }
        }
        
        if ([parsedDictionaryWcagns objectForKey:@"EtWcmWcagns"]) {
            parsedDictionaryWcagns = [parsedDictionaryWcagns objectForKey:@"EtWcmWcagns"];
            if ([parsedDictionaryWcagns objectForKey:@"results"]) {
                parsedDictionaryWcagns = [parsedDictionaryWcagns objectForKey:@"results"];
                if ([parsedDictionaryWcagns isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:parsedDictionaryWcagns] forKey:@"resultIssuePermits"];//issue permits
                }
                else if([parsedDictionaryWcagns isKindOfClass:[NSArray class]])
                {
                    [xmlDoc setObject:parsedDictionaryWcagns forKey:@"resultIssuePermits"];//issue permits
                }
            }
        }
        
        if ([parsedDictionaryOpWCDDetails objectForKey:@"EtWcmWdData"]) {
            parsedDictionaryOpWCDDetails = [parsedDictionaryOpWCDDetails objectForKey:@"EtWcmWdData"];
            if ([parsedDictionaryOpWCDDetails objectForKey:@"results"]) {
                parsedDictionaryOpWCDDetails = [parsedDictionaryOpWCDDetails objectForKey:@"results"];
                if ([parsedDictionaryOpWCDDetails isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:parsedDictionaryOpWCDDetails] forKey:@"resultOperationWCDData"];//isolation
                }
                else if([parsedDictionaryOpWCDDetails isKindOfClass:[NSArray class]])
                {
                    [xmlDoc setObject:parsedDictionaryOpWCDDetails forKey:@"resultOperationWCDData"];//isolation
                }
            }
        }
        
        if ([parsedDictionaryOpWCDItemDetails objectForKey:@"EtWcmWdItemData"]) {
            parsedDictionaryOpWCDItemDetails = [parsedDictionaryOpWCDItemDetails objectForKey:@"EtWcmWdItemData"];
            if ([parsedDictionaryOpWCDItemDetails objectForKey:@"results"]) {
                parsedDictionaryOpWCDItemDetails = [parsedDictionaryOpWCDItemDetails objectForKey:@"results"];
                if ([parsedDictionaryOpWCDItemDetails isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:parsedDictionaryOpWCDItemDetails] forKey:@"resultOperationWCDItemData"];//tagging conditions
                }
                else if([parsedDictionaryOpWCDItemDetails isKindOfClass:[NSArray class]])
                {
                    [xmlDoc setObject:parsedDictionaryOpWCDItemDetails forKey:@"resultOperationWCDItemData"];//tagging conditions
                }
            }
        }
 
        
        if ([parsedDictionaryWorkApprovalDetails objectForKey:@"EtWcmWwData"]) {
            parsedDictionaryWorkApprovalDetails = [parsedDictionaryWorkApprovalDetails objectForKey:@"EtWcmWwData"];
            if ([parsedDictionaryWorkApprovalDetails objectForKey:@"results"]) {
                parsedDictionaryWorkApprovalDetails = [parsedDictionaryWorkApprovalDetails objectForKey:@"results"];
                if ([parsedDictionaryWorkApprovalDetails isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:parsedDictionaryWorkApprovalDetails] forKey:@"resultWorkApprovalsData"];
                }
                else if([parsedDictionaryWorkApprovalDetails isKindOfClass:[NSArray class]])
                {
                    [xmlDoc setObject:parsedDictionaryWorkApprovalDetails forKey:@"resultWorkApprovalsData"];
                }
            }
            
            return xmlDoc;
        }
    }
    
    return [NSMutableDictionary dictionary];
}

- (NSMutableDictionary *)parseForCancelOrder:(NSDictionary *)resultDictionary
{
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    NSDictionary *parseDictionary;
    if ([resultDictionary objectForKey:@"d"]) {
        parseDictionary = [resultDictionary objectForKey:@"d"];
        if ([parseDictionary objectForKey:@"results"]) {
            id dataObject = [parseDictionary objectForKey:@"results"];
            if ([dataObject isKindOfClass:[NSDictionary class]]) {
                [xmlDoc setObject:[NSMutableArray arrayWithObject:dataObject] forKey:@"result"];
            }
            else if([dataObject isKindOfClass:[NSArray class]])
            {
                [xmlDoc setObject:dataObject forKey:@"result"];
            }
            NSMutableArray *resultArray = [NSMutableArray arrayWithArray:[xmlDoc objectForKey:@"result"]];
            
            NSMutableArray *messageArray = [[NSMutableArray alloc] init];
            for (int i=0; i<[resultArray count]; i++) {
                NSMutableDictionary *resultDictionary = [resultArray objectAtIndex:i];
                if ([resultDictionary objectForKey:@"ObjectNo"]) {
                    if ([resultDictionary objectForKey:@"Success"]) {
                        if ([[resultDictionary objectForKey:@"Success"] boolValue]) {
                            [messageArray addObject:[NSString stringWithFormat:@"S Order %@ is Cancelled Succesfully",[resultDictionary objectForKey:@"ObjectNo"]]];
                        }
                        else
                        {
                            [messageArray addObject:[NSString stringWithFormat:@"E Order %@ is failed to Cancel",[resultDictionary objectForKey:@"ObjectNo"]]];
                        }
                    }
                }
            }
            [xmlDoc removeAllObjects];
            if (messageArray.count) {
                [xmlDoc setObject:messageArray forKey:@"Message"];
            }
            
            return xmlDoc;
        }
    }
    else if([resultDictionary objectForKey:@"error"])
    {
        parseDictionary = [[resultDictionary objectForKey:@"error"] objectForKey:@"message"];
        [xmlDoc setObject:[parseDictionary objectForKey:@"value"] forKey:@"ERROR"];
        return xmlDoc;
    }

    return [NSMutableDictionary dictionary];
}

- (NSMutableDictionary *)parseForConfirmOrder:(NSDictionary *)resultDictionary
{
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    
    NSDictionary *parseDictionary,*parseDictionaryHeaderPermits,*parseDictionaryOperationTransaction,*parseDictionaryComponentsTransaction,*parseDictionaryLongText,*parseDictionaryDocs,*parseDictionaryWSM,*parseDictionaryObjects,*parsedDictionaryOrderStatus,*parsedDictionaryOrderOlist,*parsedDictionaryCheckPoints,*parsedDictionaryWorkApplications,*parsedDictionaryWcagns,*parsedDictionaryOpWCDDetails,*parsedDictionaryOpWCDItemDetails,*parsedDictionaryWorkApprovalDetails,*parsedDictionaryMeasurementDocuments,*parseHeaderDictionary,*parseMessageDictionary;
    
    if ([resultDictionary objectForKey:@"d"])
    {
        parseDictionary = [resultDictionary objectForKey:@"d"];
        
        id dataObject = [parseDictionary copy];
        
        if ([dataObject isKindOfClass:[NSDictionary class]]) {
            
            parseDictionaryHeaderPermits = [dataObject copy];
            parseDictionaryOperationTransaction = [dataObject copy];
            parseDictionaryComponentsTransaction = [dataObject copy];
            parseDictionaryLongText = [dataObject copy];
            parseDictionaryDocs = [dataObject copy];
            parseDictionaryWSM = [dataObject copy];
            parseDictionaryObjects = [dataObject copy];
            parsedDictionaryOrderStatus = [dataObject copy];
            parsedDictionaryOrderOlist = [dataObject copy];
            parsedDictionaryCheckPoints = [dataObject copy];
            parsedDictionaryWorkApplications = [dataObject copy];
            parsedDictionaryWcagns = [dataObject copy];
            parsedDictionaryOpWCDDetails = [dataObject copy];
            parsedDictionaryOpWCDItemDetails = [dataObject copy];
            parsedDictionaryWorkApprovalDetails = [dataObject copy];
            parsedDictionaryMeasurementDocuments = [dataObject copy];
            parseHeaderDictionary = [dataObject copy];
            
            parseMessageDictionary = [dataObject copy];
            
        }
        else if ([dataObject isKindOfClass:[NSArray class]])
        {
            if ([dataObject count]) {
                parseDictionaryHeaderPermits = [[dataObject objectAtIndex:0] copy];
                parseDictionaryOperationTransaction = [[dataObject objectAtIndex:0] copy];
                parseDictionaryComponentsTransaction = [[dataObject objectAtIndex:0] copy];
                parseDictionaryLongText = [[dataObject objectAtIndex:0] copy];
                parseDictionaryDocs = [[dataObject objectAtIndex:0] copy];
                parseDictionaryWSM = [[dataObject objectAtIndex:0] copy];
                parseDictionaryObjects = [[dataObject objectAtIndex:0] copy];
                parsedDictionaryOrderStatus = [[dataObject objectAtIndex:0] copy];
                parsedDictionaryOrderOlist = [[dataObject objectAtIndex:0] copy];
                parsedDictionaryCheckPoints = [[dataObject objectAtIndex:0] copy];
                parsedDictionaryWorkApplications = [[dataObject objectAtIndex:0] copy];
                parsedDictionaryWcagns = [[dataObject objectAtIndex:0] copy];
                parsedDictionaryOpWCDDetails = [[dataObject objectAtIndex:0] copy];
                parsedDictionaryOpWCDItemDetails = [[dataObject objectAtIndex:0] copy];
                parsedDictionaryWorkApprovalDetails = [[dataObject objectAtIndex:0] copy];
                parsedDictionaryMeasurementDocuments = [[dataObject objectAtIndex:0] copy];
                parseHeaderDictionary = [[dataObject objectAtIndex:0] copy];
                
                parseMessageDictionary = [[dataObject objectAtIndex:0] copy];
                
                
            }
        }
        
        
        if ([parseHeaderDictionary objectForKey:@"EtOrderHeader"]) {
            
            if (![NullChecker isNull:[parseHeaderDictionary objectForKey:@"EtOrderHeader"]]) {
                
                parseHeaderDictionary = [parseHeaderDictionary objectForKey:@"EtOrderHeader"];
                if ([parseHeaderDictionary objectForKey:@"results"]) {
                    parseHeaderDictionary = [parseHeaderDictionary objectForKey:@"results"];
                    if ([parseHeaderDictionary isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseHeaderDictionary] forKey:@"resultHeader"];
                    }
                    else if([parseHeaderDictionary isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseHeaderDictionary forKey:@"resultHeader"];
                    }
                }
            }
        }
        
        if ([parseDictionaryObjects objectForKey:@"EtOrderOlist"]) {
            parseDictionaryObjects = [parseDictionaryObjects objectForKey:@"EtOrderOlist"];
            if ([parseDictionaryObjects objectForKey:@"results"]) {
                parseDictionaryObjects = [parseDictionaryObjects objectForKey:@"results"];
                if ([parseDictionaryObjects isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryObjects] forKey:@"resultHeaderObjects"];
                }
                else if([parseDictionaryObjects isKindOfClass:[NSArray class]])
                {
                    [xmlDoc setObject:parseDictionaryObjects forKey:@"resultHeaderObjects"];
                }
            }
        }
        
        if ([parsedDictionaryMeasurementDocuments objectForKey:@"EtImrg"]) {
            parsedDictionaryMeasurementDocuments = [parsedDictionaryMeasurementDocuments objectForKey:@"EtImrg"];
            if ([parsedDictionaryMeasurementDocuments objectForKey:@"results"]) {
                parsedDictionaryMeasurementDocuments = [parsedDictionaryMeasurementDocuments objectForKey:@"results"];
                if ([parsedDictionaryMeasurementDocuments isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:parsedDictionaryMeasurementDocuments] forKey:@"resultMeasurementDocuments"];
                }
                else if([parsedDictionaryMeasurementDocuments isKindOfClass:[NSArray class]])
                {
                    [xmlDoc setObject:parsedDictionaryMeasurementDocuments forKey:@"resultMeasurementDocuments"];
                }
            }
        }
        
        if ([parseDictionaryHeaderPermits objectForKey:@"EtOrderPermits"]) {
            parseDictionaryHeaderPermits = [parseDictionaryHeaderPermits objectForKey:@"EtOrderPermits"];
            if ([parseDictionaryHeaderPermits objectForKey:@"results"]) {
                parseDictionaryHeaderPermits = [parseDictionaryHeaderPermits objectForKey:@"results"];
                if ([parseDictionaryHeaderPermits isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryHeaderPermits] forKey:@"resultHeaderPermits"];
                }
                else if([parseDictionaryHeaderPermits isKindOfClass:[NSArray class]])
                {
                    [xmlDoc setObject:parseDictionaryHeaderPermits forKey:@"resultHeaderPermits"];
                }
            }
        }
        
        if ([parseDictionaryOperationTransaction objectForKey:@"EtOrderOperations"]) {
            
            if (![NullChecker isNull:[parseDictionaryOperationTransaction objectForKey:@"EtOrderOperations"]]) {
                
                parseDictionaryOperationTransaction = [parseDictionaryOperationTransaction objectForKey:@"EtOrderOperations"];
                
                if ([parseDictionaryOperationTransaction objectForKey:@"results"]) {
                    parseDictionaryOperationTransaction = [parseDictionaryOperationTransaction objectForKey:@"results"];
                    if ([parseDictionaryOperationTransaction isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryOperationTransaction] forKey:@"resultOperationsTransactions"];
                    }
                    else if([parseDictionaryOperationTransaction isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryOperationTransaction forKey:@"resultOperationsTransactions"];
                    }
                }
            }
        }
        
        if ([parseMessageDictionary objectForKey:@"EtMessages"]) {
            if ([[parseMessageDictionary objectForKey:@"EtMessages"] objectForKey:@"results"]) {
                id messageArray = [[parseMessageDictionary objectForKey:@"EtMessages"] objectForKey:@"results"];
                if ([messageArray isKindOfClass:[NSDictionary class]]) {
                    
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:[[[[messageArray objectForKey:@"EtMessages"] objectForKey:@"results"] objectAtIndex:0] objectForKey:@"Message"]] forKey:@"Message"];
                    
                }
                else if([messageArray isKindOfClass:[NSArray class]])
                {
                    [xmlDoc setObject:[[messageArray objectAtIndex:0] objectForKey:@"Message"] forKey:@"Message"];
                }
            }
        }
        
        
        if ([parseDictionaryComponentsTransaction objectForKey:@"EtOrderComponents"]) {
            
            if (![NullChecker isNull:[parseDictionaryComponentsTransaction objectForKey:@"EtOrderComponents"]]) {
                
                parseDictionaryComponentsTransaction = [parseDictionaryComponentsTransaction objectForKey:@"EtOrderComponents"];
                
                if ([parseDictionaryComponentsTransaction objectForKey:@"results"]) {
                    parseDictionaryComponentsTransaction = [parseDictionaryComponentsTransaction objectForKey:@"results"];
                    if ([parseDictionaryComponentsTransaction isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryComponentsTransaction] forKey:@"resultComponentsTransactions"];
                    }
                    else if([parseDictionaryComponentsTransaction isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryComponentsTransaction forKey:@"resultComponentsTransactions"];
                    }
                }
                
            }
        }
        
        if ([parseDictionaryLongText objectForKey:@"EtOrderLongtext"]) {
            
            if (![NullChecker isNull:[parseDictionaryLongText objectForKey:@"EtOrderLongtext"]]) {
                
                parseDictionaryLongText = [parseDictionaryLongText objectForKey:@"EtOrderLongtext"];
                if ([parseDictionaryLongText objectForKey:@"results"]) {
                    parseDictionaryLongText = [parseDictionaryLongText objectForKey:@"results"];
                    if ([parseDictionaryLongText isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryLongText] forKey:@"resultLongText"];
                    }
                    else if([parseDictionaryLongText isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryLongText forKey:@"resultLongText"];
                    }
                }
            }
        }
        
        if ([parseDictionaryDocs objectForKey:@"EtDocs"]) {
            if (![NullChecker isNull:[parseDictionaryDocs objectForKey:@"EtDocs"]]) {
                parseDictionaryDocs = [parseDictionaryDocs objectForKey:@"EtDocs"];
                if ([parseDictionaryDocs objectForKey:@"results"]) {
                    parseDictionaryDocs = [parseDictionaryDocs objectForKey:@"results"];
                    if ([parseDictionaryDocs isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryDocs] forKey:@"resultDocs"];
                    }
                    else if([parseDictionaryDocs isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parseDictionaryDocs forKey:@"resultDocs"];
                    }
                }
            }
        }
        
        if ([parseDictionaryWSM objectForKey:@"EtWsmOrdSafemeas"]) {
            parseDictionaryWSM = [parseDictionaryWSM objectForKey:@"EtWsmOrdSafemeas"];
            if ([parseDictionaryWSM objectForKey:@"results"]) {
                parseDictionaryWSM = [parseDictionaryWSM objectForKey:@"results"];
                if ([parseDictionaryWSM isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:parseDictionaryWSM] forKey:@"resultWSMSafetyMeasures"];
                }
                else if([parseDictionaryWSM isKindOfClass:[NSArray class]])
                {
                    [xmlDoc setObject:parseDictionaryWSM forKey:@"resultWSMSafetyMeasures"];
                }
            }
        }
        
        if ([parsedDictionaryOrderStatus objectForKey:@"EtOrderStatus"]) {
            if (![NullChecker isNull:[parsedDictionaryOrderStatus objectForKey:@"EtOrderStatus"]]) {
                parsedDictionaryOrderStatus = [parsedDictionaryOrderStatus objectForKey:@"EtOrderStatus"];
                if ([parsedDictionaryOrderStatus objectForKey:@"results"]) {
                    parsedDictionaryOrderStatus = [parsedDictionaryOrderStatus objectForKey:@"results"];
                    if ([parsedDictionaryOrderStatus isKindOfClass:[NSDictionary class]]) {
                        [xmlDoc setObject:[NSMutableArray arrayWithObject:parsedDictionaryOrderStatus] forKey:@"resultOrderStatus"];
                    }
                    else if([parsedDictionaryOrderStatus isKindOfClass:[NSArray class]])
                    {
                        [xmlDoc setObject:parsedDictionaryOrderStatus forKey:@"resultOrderStatus"];
                    }
                }
            }
        }
        
        if ([parsedDictionaryOrderOlist objectForKey:@"EtOrderOlist"]) {
            parsedDictionaryOrderOlist = [parsedDictionaryOrderOlist objectForKey:@"EtOrderOlist"];
            if ([parsedDictionaryOrderOlist objectForKey:@"results"]) {
                parsedDictionaryOrderOlist = [parsedDictionaryOrderOlist objectForKey:@"results"];
                if ([parsedDictionaryOrderOlist isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:parsedDictionaryOrderOlist] forKey:@"resultOrderOlist"];
                }
                else if([parsedDictionaryOrderOlist isKindOfClass:[NSArray class]])
                {
                    [xmlDoc setObject:parsedDictionaryOrderOlist forKey:@"resultOrderOlist"];
                }
            }
        }
        
        //WCM
        if ([parsedDictionaryCheckPoints objectForKey:@"EtWcmWaChkReq"]) {
            parsedDictionaryCheckPoints = [parsedDictionaryCheckPoints objectForKey:@"EtWcmWaChkReq"];
            if ([parsedDictionaryCheckPoints objectForKey:@"results"]) {
                parsedDictionaryCheckPoints = [parsedDictionaryCheckPoints objectForKey:@"results"];
                if ([parsedDictionaryCheckPoints isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:parsedDictionaryCheckPoints] forKey:@"resultStandardCheckPoints"];
                }
                else if([parsedDictionaryCheckPoints isKindOfClass:[NSArray class]])
                {
                    [xmlDoc setObject:parsedDictionaryCheckPoints forKey:@"resultStandardCheckPoints"];
                }
            }
        }
        
        if ([parsedDictionaryWorkApplications objectForKey:@"EtWcmWaData"]) {
            parsedDictionaryWorkApplications = [parsedDictionaryWorkApplications objectForKey:@"EtWcmWaData"];
            if ([parsedDictionaryWorkApplications objectForKey:@"results"]) {
                parsedDictionaryWorkApplications = [parsedDictionaryWorkApplications objectForKey:@"results"];
                if ([parsedDictionaryWorkApplications isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:parsedDictionaryWorkApplications] forKey:@"resultWorkApplicationData"];
                }
                else if([parsedDictionaryWorkApplications isKindOfClass:[NSArray class]])
                {
                    [xmlDoc setObject:parsedDictionaryWorkApplications forKey:@"resultWorkApplicationData"];
                }
            }
        }
        
        if ([parsedDictionaryWcagns objectForKey:@"EtWcmWcagns"]) {
            parsedDictionaryWcagns = [parsedDictionaryWcagns objectForKey:@"EtWcmWcagns"];
            if ([parsedDictionaryWcagns objectForKey:@"results"]) {
                parsedDictionaryWcagns = [parsedDictionaryWcagns objectForKey:@"results"];
                if ([parsedDictionaryWcagns isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:parsedDictionaryWcagns] forKey:@"resultIssuePermits"];//issue permits
                }
                else if([parsedDictionaryWcagns isKindOfClass:[NSArray class]])
                {
                    [xmlDoc setObject:parsedDictionaryWcagns forKey:@"resultIssuePermits"];//issue permits
                }
            }
        }
        
        if ([parsedDictionaryOpWCDDetails objectForKey:@"EtWcmWdData"]) {
            parsedDictionaryOpWCDDetails = [parsedDictionaryOpWCDDetails objectForKey:@"EtWcmWdData"];
            if ([parsedDictionaryOpWCDDetails objectForKey:@"results"]) {
                parsedDictionaryOpWCDDetails = [parsedDictionaryOpWCDDetails objectForKey:@"results"];
                if ([parsedDictionaryOpWCDDetails isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:parsedDictionaryOpWCDDetails] forKey:@"resultOperationWCDData"];//isolation
                }
                else if([parsedDictionaryOpWCDDetails isKindOfClass:[NSArray class]])
                {
                    [xmlDoc setObject:parsedDictionaryOpWCDDetails forKey:@"resultOperationWCDData"];//isolation
                }
            }
        }
        
        if ([parsedDictionaryOpWCDItemDetails objectForKey:@"EtWcmWdItemData"]) {
            parsedDictionaryOpWCDItemDetails = [parsedDictionaryOpWCDItemDetails objectForKey:@"EtWcmWdItemData"];
            if ([parsedDictionaryOpWCDItemDetails objectForKey:@"results"]) {
                parsedDictionaryOpWCDItemDetails = [parsedDictionaryOpWCDItemDetails objectForKey:@"results"];
                if ([parsedDictionaryOpWCDItemDetails isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:parsedDictionaryOpWCDItemDetails] forKey:@"resultOperationWCDItemData"];//tagging conditions
                }
                else if([parsedDictionaryOpWCDItemDetails isKindOfClass:[NSArray class]])
                {
                    [xmlDoc setObject:parsedDictionaryOpWCDItemDetails forKey:@"resultOperationWCDItemData"];//tagging conditions
                }
            }
        }
        
        
        if ([parsedDictionaryWorkApprovalDetails objectForKey:@"EtWcmWwData"]) {
            parsedDictionaryWorkApprovalDetails = [parsedDictionaryWorkApprovalDetails objectForKey:@"EtWcmWwData"];
            if ([parsedDictionaryWorkApprovalDetails objectForKey:@"results"]) {
                parsedDictionaryWorkApprovalDetails = [parsedDictionaryWorkApprovalDetails objectForKey:@"results"];
                if ([parsedDictionaryWorkApprovalDetails isKindOfClass:[NSDictionary class]]) {
                    [xmlDoc setObject:[NSMutableArray arrayWithObject:parsedDictionaryWorkApprovalDetails] forKey:@"resultWorkApprovalsData"];
                }
                else if([parsedDictionaryWorkApprovalDetails isKindOfClass:[NSArray class]])
                {
                    [xmlDoc setObject:parsedDictionaryWorkApprovalDetails forKey:@"resultWorkApprovalsData"];
                }
            }
            
            return xmlDoc;
        }
    }
    
    return [NSMutableDictionary dictionary];
}

//- (NSMutableDictionary *)parseForListOfPMBOMS:(NSDictionary *)resultDictionary
//{
//    NSDictionary *parseDictionary;
//    NSMutableDictionary *xmlDoc = [[NSMutableDictionary alloc]init];
//
//    if ([resultDictionary objectForKey:@"d"]) {
//        id listOfPMBOMS;
//        NSMutableArray *headerArray,*transactionArray;
//        headerArray = [[NSMutableArray alloc]init];
//        transactionArray = [[NSMutableArray alloc]init];
//
//        parseDictionary = [resultDictionary objectForKey:@"d"];
//        if ([parseDictionary objectForKey:@"results"]) {
//
//            listOfPMBOMS = [parseDictionary objectForKey:@"results"];
//
//            for (int i =0; i<[listOfPMBOMS count]; i++) {
//                NSString *strBOM = [[listOfPMBOMS objectAtIndex:i] objectForKey:@"Bom"];
//                NSString *strBomDesc = [[listOfPMBOMS objectAtIndex:i] objectForKey:@"BomDesc"];
//                NSString *strPlant = [[listOfPMBOMS objectAtIndex:i] objectForKey:@"Plant"];
//                [headerArray addObject:[NSMutableArray arrayWithObjects:strBOM,strBomDesc,strPlant, nil]];
//                NSArray *equipmentItems = [[[listOfPMBOMS objectAtIndex:i] objectForKey:@"EquipmentItems"] objectForKey:@"results"];
//                for (int j =0; j<[equipmentItems count]; j++) {
//                    NSString *strBOM = [[equipmentItems objectAtIndex:j] objectForKey:@"Bom"];
//                    NSString *strBOMComponent = [[equipmentItems objectAtIndex:j] objectForKey:@"BomComponent"];
//                    NSString *strCompText = [[equipmentItems objectAtIndex:j] objectForKey:@"CompText"];
//                    NSString *strQuantity = [[equipmentItems objectAtIndex:j] objectForKey:@"Quantity"];
//                    NSString *strUnit = [[equipmentItems objectAtIndex:j] objectForKey:@"Unit"];
//
//                    [transactionArray addObject:[NSMutableArray arrayWithObjects:strBOM,strBOMComponent,strCompText,strQuantity,strUnit, nil]];
//                }
//            }
//
//            [[DataBase sharedInstance] insertintoBOMComponents :headerArray :transactionArray];
//        }
//    }
//    else if([resultDictionary objectForKey:@"error"])
//    {
//        parseDictionary = [[resultDictionary objectForKey:@"error"] objectForKey:@"message"];
//        [xmlDoc setObject:[parseDictionary objectForKey:@"value"] forKey:@"ERROR"];
//        return xmlDoc;
//    }
//
//    return [NSMutableDictionary dictionary];
//}


- (NSMutableDictionary *)parseForUtilityReserve:(NSMutableDictionary *)resultDictionary
{
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    id parseDictionary;
    if ([resultDictionary objectForKey:@"d"]) {
        
        parseDictionary = [resultDictionary objectForKey:@"d"];

//            if ([parseDictionary objectForKey:@"EtMessage"]) {
//
//            parseDictionary = [[parseDictionary objectForKey:@"EtMessage"] objectForKey:@"results"];
//
//                if ([parseDictionary isKindOfClass:[NSDictionary class]]) {
//
//                    [xmlDoc setObject:[NSMutableArray arrayWithObject:[parseDictionary objectForKey:@"Message"]] forKey:@"Message"];
//
//                }
//
 
            if ([[parseDictionary objectForKey:@"EtMessage"] objectForKey:@"results"]) {
                
                
                 parseDictionary = [[parseDictionary objectForKey:@"EtMessage"] objectForKey:@"results"];
                    
                if ([parseDictionary isKindOfClass:[NSDictionary class]]){
 
                    [xmlDoc setObject:[parseDictionary objectForKey:@"Message"] forKey:@"Message"];
                    
                    [xmlDoc setObject:[parseDictionary objectForKey:@"Resnum"] forKey:@"RESNUM"];
 
                    }
                    else if ([parseDictionary isKindOfClass:[NSArray class]]){
 
                    [xmlDoc setObject:[[parseDictionary objectAtIndex:0] objectForKey:@"Message"] forKey:@"Message"];
                        
                        [xmlDoc setObject:[[parseDictionary objectAtIndex:0] objectForKey:@"Resnum"] forKey:@"RESNUM"];

                            
                     }
                }
        
        return xmlDoc;
    }
    else if([resultDictionary objectForKey:@"error"])
    {
        parseDictionary = [[resultDictionary objectForKey:@"error"] objectForKey:@"message"];
        [xmlDoc setObject:[parseDictionary objectForKey:@"value"] forKey:@"ERROR"];
        
        return xmlDoc;
    }
    
    return [NSMutableDictionary dictionary];
}

- (NSMutableDictionary *)parseForStockOverView:(NSDictionary *)resultDictionary
{
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    NSDictionary *parseDictionary;
    if ([resultDictionary objectForKey:@"d"]) {
        parseDictionary = [resultDictionary objectForKey:@"d"];
        if ([parseDictionary objectForKey:@"results"]) {
            id dataObject = [parseDictionary objectForKey:@"results"];
            if ([dataObject isKindOfClass:[NSDictionary class]]) {
                [xmlDoc setObject:[NSMutableArray arrayWithObject:dataObject] forKey:@"result"];
            }
            else if([dataObject isKindOfClass:[NSArray class]])
            {
                [xmlDoc setObject:dataObject forKey:@"result"];
            }
            return xmlDoc;
        }
    }
    else if([resultDictionary objectForKey:@"error"])
    {
        parseDictionary = [[resultDictionary objectForKey:@"error"] objectForKey:@"message"];
        [xmlDoc setObject:[parseDictionary objectForKey:@"value"] forKey:@"ERROR"];
        return xmlDoc;
    }
    return [NSMutableDictionary dictionary];
}

- (NSMutableDictionary *)parseForLogData:(NSDictionary *)resultDictionary
{
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    NSDictionary *parseDictionary;
    if ([resultDictionary objectForKey:@"d"]) {
        parseDictionary = [resultDictionary objectForKey:@"d"];
        if ([parseDictionary objectForKey:@"results"]) {
            id dataObject = [parseDictionary objectForKey:@"results"];
            if ([dataObject isKindOfClass:[NSDictionary class]]) {
                [xmlDoc setObject:[NSMutableArray arrayWithObject:dataObject] forKey:@"result"];
            }
            else if([dataObject isKindOfClass:[NSArray class]])
            {
                [xmlDoc setObject:dataObject forKey:@"result"];
            }
            return xmlDoc;
        }
    }
    else if([resultDictionary objectForKey:@"error"])
    {
        parseDictionary = [[resultDictionary objectForKey:@"error"] objectForKey:@"message"];
        [xmlDoc setObject:[parseDictionary objectForKey:@"value"] forKey:@"ERROR"];
        return xmlDoc;
    }
    
    return [NSMutableDictionary dictionary];
}

- (NSMutableDictionary *)parseForMaterialCheckAvailability:(NSDictionary *)resultDictionary
{
    NSMutableDictionary *xmlDoc = [NSMutableDictionary dictionary];
    NSDictionary *parseDictionary;
    if ([resultDictionary objectForKey:@"d"]) {
        parseDictionary = [resultDictionary objectForKey:@"d"];
//        id dataObject = parseDictionary;
//
//            if ([dataObject isKindOfClass:[NSDictionary class]]) {
//                [xmlDoc setObject:[NSMutableArray arrayWithObject:dataObject] forKey:@"results"];
//            }
//            else if([dataObject isKindOfClass:[NSArray class]])
//            {
//                [xmlDoc setObject:dataObject forKey:@"results"];
//            }
        
        id matnrObject=parseDictionary;
        
        if ([[matnrObject objectForKey:@"ItMatnrPost"] objectForKey:@"results"]) {
            
        if ([[[matnrObject objectForKey:@"ItMatnrPost"] objectForKey:@"results"] isKindOfClass:[NSDictionary class]]){
 
            [xmlDoc setObject:[NSMutableArray arrayWithObject:[[[matnrObject objectForKey:@"ItMatnrPost"] objectForKey:@"results"] copy]] forKey:@"resultMatnr"];
            
            }
          else if ([[[matnrObject objectForKey:@"ItMatnrPost"] objectForKey:@"results"] isKindOfClass:[NSArray class]]){
                
                if ([[[matnrObject objectForKey:@"ItMatnrPost"] objectForKey:@"results"] count])
                {
                     [xmlDoc setObject:[[[matnrObject objectForKey:@"ItMatnrPost"] objectForKey:@"results"]  copy] forKey:@"resultMatnr"];
                 }
             }
         }
        
        id evAvailableObject=parseDictionary;

        if ([[evAvailableObject objectForKey:@"EvAvailable"] objectForKey:@"results"]) {
            
            if ([[[evAvailableObject objectForKey:@"EvAvailable"] objectForKey:@"results"] isKindOfClass:[NSDictionary class]]){
                
                [xmlDoc setObject:[NSMutableArray arrayWithObject:[[[[evAvailableObject objectForKey:@"EvAvailable"] objectForKey:@"results"] objectAtIndex:0] objectForKey:@"Message"]] forKey:@"Message"];
                
            }
            else if ([[[evAvailableObject objectForKey:@"EvAvailable"] objectForKey:@"results"] isKindOfClass:[NSArray class]]){
                
                if ([[[evAvailableObject objectForKey:@"EvAvailable"] objectForKey:@"results"] count])
                {
                    [xmlDoc setObject:[[[[evAvailableObject objectForKey:@"EvAvailable"] objectForKey:@"results"] objectAtIndex:0] objectForKey:@"Message"] forKey:@"Message"];
                }
            }
        }
        
//        NSMutableArray *resultArray = [NSMutableArray arrayWithArray:[xmlDoc objectForKey:@"results"]];
//
//        NSMutableArray *messageArray = [[NSMutableArray alloc] init];
//        for (int i=0; i<[resultArray count]; i++) {
//            NSMutableDictionary *resultDictionary = [resultArray objectAtIndex:i];
//            if ([resultDictionary objectForKey:@"Available"]) {
//               if ([[resultDictionary objectForKey:@"Available"] boolValue]) {
//                    [messageArray addObject:[resultDictionary objectForKey:@"Status"]];
//                }
//                else
//                {
//                    [messageArray addObject:[resultDictionary objectForKey:@"Status"]];
//                }
//            }
//        }
//        [xmlDoc removeAllObjects];
//        if (messageArray.count) {
//            [xmlDoc setObject:messageArray forKey:@"Message"];
//        }
        
        return xmlDoc;
    }
    else if([resultDictionary objectForKey:@"error"])
    {
        parseDictionary = [[resultDictionary objectForKey:@"error"] objectForKey:@"message"];
        [xmlDoc setObject:[parseDictionary objectForKey:@"value"] forKey:@"ERROR"];
        return xmlDoc;
    }
    
    return [NSMutableDictionary dictionary];
}



@end
