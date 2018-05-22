//
//  DashBoardViewController.m
//  Fieldtekpro
//
//  Created by Enstrapp Bangalore on 09/10/17.
//  Copyright © 2017 Enstrapp Bangalore. All rights reserved.
//

#import "DashBoardViewController.h"
#import "CollectionViewCell.h"
#import "UtilitiesViewController.h"

@interface DashBoardViewController ()

{
    dispatch_group_t downloadGroup;
    
}
@end

@implementation DashBoardViewController
@synthesize defaults;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
 
    imagesArray=[NSMutableArray new];
    defaults=[NSUserDefaults standardUserDefaults];
 
    [self containsAllFunctionsMethod];
    [self callServerToFetchSyncMapData];
 
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    if ([[defaults objectForKey:@"Refresh_Check"] isEqualToString:@"X"]) {
        isRefresh=YES;
    }
    else{
        isRefresh=NO;
    }
    
    [self functionCallstobeShown];
}


-(void)showAlertMessageWithTitle:(NSString*)title message:(NSString*)message cancelButtonTitle:(NSString *)cancelBtnTitle withactionType:(NSString *)actionString forMethod:(NSString *)methodNameString
{
    
    UIAlertController * alert=[UIAlertController alertControllerWithTitle:title
                                                                  message:message
                                                           preferredStyle:UIAlertControllerStyleAlert];
    
    if ([actionString isEqualToString:@"Multiple"]) {
        
        
        UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Yes"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
                                    {
                                        if ([methodNameString isEqualToString:@"logout"]) {
 
                                            [self.navigationController popToRootViewControllerAnimated:YES];
 
                                        }
                                        else if ([methodNameString isEqualToString:@"Refresh"]){
                                            
                                            isRefresh = YES;
                                            
                                             hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                            hud.mode = MBProgressHUDAnimationFade;
                                            hud.label.text = @"Data refresh in progress...";
                                            
                                            NSMutableDictionary *dataDictionary = [[NSMutableDictionary alloc]init];
                                            [dataDictionary setObject:@"REFR" forKey:@"TRANSMITTYPE"];
                                            
                                             [dataDictionary setObject:self.userNameString forKey:@"REPORTEDBY"];

                                            
                                            if ([[defaults objectForKey:@"ACTIVATELOGS"] isEqualToString:@"X"])
                                            {
                                                [[DataBase sharedInstance] writToLogFile:[NSString stringWithFormat:@"#INFO#.com.enstrapp.fieldtekpro #Activity:Refresh   #Class: Very Important #MUser:%@ #DeviceId:%@",self.userNameString,[defaults objectForKey:@"edeviceid"]]];
                                            }
                                            
                                            [Request makeWebServiceRequest:GET_SYNC_MAP_DATA parameters:dataDictionary delegate:self];
                                            
                                            NSDateFormatter *dateformatter=[[NSDateFormatter alloc]init];
                                            [dateformatter setDateFormat:@"MMM dd, yyyy HH:mm:ss"];
                                            [defaults setObject:[dateformatter stringFromDate:[NSDate date]] forKey:@"LASTREFESHDATE"];
                                            [defaults synchronize];
                                        }
                                        
                                    }];
        
        UIAlertAction* noButton = [UIAlertAction actionWithTitle:cancelBtnTitle
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action)
                                   {
                                       
                                      
                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                       
                                   }];
        
        [alert addAction:noButton];
        [alert addAction:yesButton];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    else{
        
        UIAlertAction* okButton = [UIAlertAction actionWithTitle:cancelBtnTitle
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action)
                                   {
                                       
                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                       
                                       if ([methodNameString isEqualToString:@"Notif Success"]) {
                                           
                                           [self.navigationController popViewControllerAnimated:YES];
                                           
                                       }
                                       
                                       
                                   }];
        
        [alert addAction:okButton];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }
}


-(void)functionCallstobeShown{
    
    if (imagesArray == nil) {
        imagesArray=[NSMutableArray new];
    }
    else{
        [imagesArray removeAllObjects];
    }
    
    id busfObjectID;
    
    if ([defaults objectForKey:@"BusinessFunctions"]) {
        busfObjectID = [defaults objectForKey:@"BusinessFunctions"];
    }
    
    if ([busfObjectID count]){
        
        [self dynamicBuildingAcitonsArrayMethod:busfObjectID];
    }
    else{
        
        [self containsAllFunctionsMethod];
    }
    
    [collectionViewVc reloadData];
}


-(void)containsAllFunctionsMethod
{
    [imagesArray addObject:[NSArray arrayWithObjects:@"Notification",@"Notification", nil]];
    
    [imagesArray addObject:[NSArray arrayWithObjects:@"Order",@"Order", nil]];
    
    [imagesArray addObject:[NSArray arrayWithObjects:@"Permits-List",@"Permit List", nil]];

    [imagesArray addObject:[NSArray arrayWithObjects:@"Isolation-List",@"Isolation List", nil]];
    
    [imagesArray addObject:[NSArray arrayWithObjects:@"Utilities",@"Utilities", nil]];
    
   // [imagesArray addObject:[NSArray arrayWithObjects:@"Maintenance_Plan",@"Maintenance Plan", nil]];
    
    //    [imagesArray addObject:[NSArray arrayWithObjects:@"equipment_monitor",@"Show on Map", nil]];
    
    [imagesArray addObject:[NSArray arrayWithObjects:@"equipment_monitor",@"Equipment Inspection", nil]];

     [imagesArray addObject:[NSArray arrayWithObjects:@"MIS",@"MIS", nil]];
    
    [imagesArray addObject:[NSArray arrayWithObjects:@"Send-Message",@"Send Message", nil]];
 
    // [imagesArray addObject:[NSArray arrayWithObjects:@"Work-Safety",@"Work Safety", nil]];
    
    //  [imagesArray addObject:[NSArray arrayWithObjects:@"Maint_check_list",@"Maintainance Checklist", nil]];
    
    [imagesArray addObject:[NSArray arrayWithObjects:@"History",@"User Log", nil]];
    
    [imagesArray addObject:[NSArray arrayWithObjects:@"Change-Log",@"Alert Log", nil]];
    
    [imagesArray addObject:[NSArray arrayWithObjects:@"Settings",@"Settings", nil]];
    
    //    [imagesArray addObject:[NSArray arrayWithObjects:@"equipment_monitor",@"User Manual", nil]];
    
}

-(void)dynamicBuildingAcitonsArrayMethod:(NSArray *)busfObjectID{
    
    for (int i =0; i<[busfObjectID count]; i++) {
        
        id busfObjectIDItem = [busfObjectID objectAtIndex:i];
        
        if ([[busfObjectIDItem objectForKey:@"Busftype"] isEqualToString:@"ALL"])
        {
            [self containsAllFunctionsMethod];
            return;
        }
        
        if ([[busfObjectIDItem objectForKey:@"Busftype"] isEqualToString:@"NOT"]) {
            
            [imagesArray addObject:[NSArray arrayWithObjects:@"Notification",@"Notification", nil]];
        }
        
        if ([[busfObjectIDItem objectForKey:@"Busftype"] isEqualToString:@"ORD"]) {
            
            [imagesArray addObject:[NSArray arrayWithObjects:@"Order",@"Order", nil]];
        }
        
        [imagesArray addObject:[NSArray arrayWithObjects:@"equipment_monitor",@"Equipment Monitor", nil]];
        
        [imagesArray addObject:[NSArray arrayWithObjects:@"equipment_monitor",@"Show on Map", nil]];
        
        
        
        if ([[busfObjectIDItem objectForKey:@"Busftype"] isEqualToString:@"UTL"]) {
            
            [imagesArray addObject:[NSArray arrayWithObjects:@"Utilities.png",@"Utilities", nil]];
            
            [imagesArray addObject:[NSArray arrayWithObjects:@"Utilities",@"Maintenance Plan", nil]];
            
        }
        
        if ([[busfObjectIDItem objectForKey:@"Busftype"] isEqualToString:@"MIS"]) {
            
            [imagesArray addObject:[NSArray arrayWithObjects:@"MIS.png",@"MIS", nil]];
        }
        
        //        if ([busfObjectIDItem containsObject:@"WSM"]) {
        //
        //            [imagesArray addObject:[NSArray arrayWithObjects:@"Work-Safety.png",@"Work Safety", nil]];
        //        }
        
        //        if ([busfObjectID containsObject:@"WCM"]) {
        //
        //            [imagesArray addObject:[NSArray arrayWithObjects:@"Work-Safety.png",@"Work Safety", nil]];
        //        }
        
        //        if ([[busfObjectIDItem objectForKey:@"Busftype"] isEqualToString:@"MCL"]) {
        //
        //            [imagesArray addObject:[NSArray arrayWithObjects:@"Maint_check_list",@"Maintainance Checklist", nil]];
        //        }
        
        if ([[busfObjectIDItem objectForKey:@"Busftype"] isEqualToString:@"UHST"]) {
            
            [imagesArray addObject:[NSArray arrayWithObjects:@"History.png",@"History", nil]];
        }
        
        if ([[busfObjectIDItem objectForKey:@"Busftype"] isEqualToString:@"CLOG"]) {
            
            [imagesArray addObject:[NSArray arrayWithObjects:@"Change-Log.png",@"Alert Log", nil]];
        }
        
        if ([[busfObjectIDItem objectForKey:@"Busftype"] isEqualToString:@"SETT"]) {
            
            [imagesArray addObject:[NSArray arrayWithObjects:@"Settings.png",@"Settings", nil]];
        }
        
        [imagesArray addObject:[NSArray arrayWithObjects:@"equipment_monitor",@"User Manual", nil]];
        
    }
}


-(IBAction)refreshBtn:(id)sender{
    
    if ([[ConnectionManager defaultManager] isReachable]) {
        
        [defaults setObject:@"REFRESH" forKey:@"REFRESH"];
        [defaults synchronize];
        
      //  NSString *lastRefreshedDateTime;
        
//        if ([defaults objectForKey:@"LASTREFESHDATE"] == nil) {
//
//            lastRefreshedDateTime = @"Data refresh in Progress";
//        }
//        else{
//
//            lastRefreshedDateTime = [NSString stringWithFormat:@"Data refresh in Progress"];
//        }
        
 
        [self showAlertMessageWithTitle:@"Refresh" message:@"Do you want to Refresh?" cancelButtonTitle:@"NO" withactionType:@"Multiple" forMethod:@"Refresh"];

    }
    else{
        
        if ([[defaults objectForKey:@"ACTIVATELOGS"] isEqualToString:@"X"])
        {
            [[DataBase sharedInstance] writToLogFile:[NSString stringWithFormat:@"#INFO#.com.enstrapp.fieldtekpro #Activity:Refresh   #Class: Very Important #MUser:%@ #DeviceId:%@",self.userNameString,[defaults objectForKey:@"deviceid"]]];
        }
        
         [self showAlertMessageWithTitle:@"No Network Available" message:@"Refresh cannot be performed!" cancelButtonTitle:@"Ok" withactionType:@"Single" forMethod:nil];
    }
}

-(void)callServerToFetchSyncMapData
{
     if ([[ConnectionManager defaultManager] isReachable])
    {
 
        if ([defaults objectForKey:@"INITIAL"] || [[defaults objectForKey:@"Intial_Data_Load_Check"] isEqualToString:@"X"]) {
            
            self.window = [UIApplication sharedApplication].keyWindow;
            
            blackView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.window.frame.size.height)];
             [blackView setAlpha:0.8];
            [self.window addSubview:blackView];
            
             hud = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
             hud.mode = MBProgressHUDAnimationFade;
             hud.label.textColor=[UIColor whiteColor];
            hud.contentColor=[UIColor whiteColor];
            hud.bezelView.color=[UIColor blackColor];
 
            hud.label.text = @"Initial data Load in Progress....";
            
            hud.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"splashscreen_activity_background.png"]];
 
            NSMutableDictionary *dataDictionary = [[NSMutableDictionary alloc]init];
            [dataDictionary setObject:@"LOAD" forKey:@"TRANSMITTYPE"];
            
            [dataDictionary setObject:self.userNameString forKey:@"REPORTEDBY"];
 
            if ([[defaults objectForKey:@"ACTIVATELOGS"] isEqualToString:@"X"])
            {
                [[DataBase sharedInstance] writToLogFile:[NSString stringWithFormat:@"#INFO#.com.enstrapp.fieldtekpro #Activity:Initial Load   #Class: Very Important #MUser:%@ #DeviceId:%@",self.userNameString,[defaults objectForKey:@"edeviceid"]]];
            }
            
            [Request makeWebServiceRequest:GET_SYNC_MAP_DATA parameters:dataDictionary delegate:self];
        }
        else if ([[defaults objectForKey:@"Refresh_Check"] isEqualToString:@"X"]) {
            NSString *lastRefreshedDateTime;
            if ([defaults objectForKey:@"LASTREFESHDATE"] == nil) {
                
                lastRefreshedDateTime = @"Data Refresh in Progress...";
            }
            else{
                
                lastRefreshedDateTime = [NSString stringWithFormat:@"Data Refresh in Progress..."];
            }
            
            hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeAnnularDeterminate;
            hud.label.text = lastRefreshedDateTime;
            
             NSMutableDictionary *dataDictionary = [[NSMutableDictionary alloc]init];
            
            [dataDictionary setObject:@"REFR" forKey:@"TRANSMITTYPE"];
            
            [dataDictionary setObject:self.userNameString forKey:@"REPORTEDBY"];
            
            
            if ([[defaults objectForKey:@"ACTIVATELOGS"] isEqualToString:@"X"])
            {
                [[DataBase sharedInstance] writToLogFile:[NSString stringWithFormat:@"#INFO#.com.enstrapp.fieldtekpro #Activity:Initial Load   #Class: Very Important #MUser:%@ #DeviceId:%@",self.userNameString,[defaults objectForKey:@"edeviceid"]]];
            }
            
            [Request makeWebServiceRequest:GET_SYNC_MAP_DATA parameters:dataDictionary delegate:self];
        }
        
        // [[ConnectionManager defaultManager] refreshSyncLog];
    }
}

-(void)getLoadSettings{
    NSMutableDictionary *dataDictionary = [[NSMutableDictionary alloc]init];
    [dataDictionary setObject:self.userNameString forKey:@"REPORTEDBY"];
    //    [dataDictionary setObject:[[syncMapDataMutableArray objectAtIndex:10] objectAtIndex:3] forKey:@"URL_ENDPOINT"];
    if (isRefresh) {
        [dataDictionary setObject:@"REFR" forKey:@"TRANSMITTYPE"];
        // [Request makeWebServiceRequest:GET_LOAD_SETTINGS parameters:dataDictionary delegate:self];
    }
    else{
        [dataDictionary setObject:@"LOAD" forKey:@"TRANSMITTYPE"];
        // [Request makeWebServiceRequest:GET_LOAD_SETTINGS parameters:dataDictionary delegate:self];
    }
    
    NSMutableDictionary *endPointDictionary = [NSMutableDictionary new];
    [endPointDictionary setObject:@"F4" forKey:@"ACTIVITY"];
    [endPointDictionary setObject:@"D1" forKey:@"DOCTYPE"];
    [endPointDictionary setObject:[defaults objectForKey:@"ENDPOINT"] forKey:@"ENDPOINT"];
    
    NSArray *endPointArray = [[DataBase sharedInstance] getEndPointURL:endPointDictionary];
    NSLog(@"endPoint :%@",[[endPointArray objectAtIndex:0] objectAtIndex:0]);
    [dataDictionary setObject:[[endPointArray objectAtIndex:0] objectAtIndex:0] forKey:@"URL_ENDPOINT"];
    
    [Request makeWebServiceRequest:GET_LOAD_SETTINGS parameters:dataDictionary delegate:self];
}


-(void)setDevicToken{
    
    NSMutableDictionary *dataDictionary = [[NSMutableDictionary alloc]init];
    
    [dataDictionary setObject:self.userNameString forKey:@"REPORTEDBY"];
    //    [dataDictionary setObject:[[syncMapDataMutableArray objectAtIndex:10] objectAtIndex:3] forKey:@"URL_ENDPOINT"];
    if (isRefresh) {
        [dataDictionary setObject:@"REFR" forKey:@"TRANSMITTYPE"];
     }
    else{
        [dataDictionary setObject:@"LOAD" forKey:@"TRANSMITTYPE"];
     }
    
    NSMutableDictionary *endPointDictionary = [NSMutableDictionary new];
    [endPointDictionary setObject:@"U" forKey:@"ACTIVITY"];
    [endPointDictionary setObject:@"DT" forKey:@"DOCTYPE"];
    [endPointDictionary setObject:[defaults objectForKey:@"ENDPOINT"] forKey:@"ENDPOINT"];
    
    
    NSArray *endPointArray = [[DataBase sharedInstance] getEndPointURL:endPointDictionary];
    NSLog(@"endPoint :%@",[[endPointArray objectAtIndex:0] objectAtIndex:0]);
    [dataDictionary setObject:[[endPointArray objectAtIndex:0] objectAtIndex:0] forKey:@"URL_ENDPOINT"];
    [dataDictionary setObject:[defaults objectForKey:@"DEVICETOKEN"] forKey:@"DEVICETOKEN"];
    
    [Request makeWebServiceRequest:SET_DEVICETOKENID parameters:dataDictionary delegate:self];
}

-(void)dispatchQueueForEquipments
 {
    
    dispatch_queue_t fetchAlbum = dispatch_queue_create("Album fetcher", NULL);
    
    dispatch_sync(fetchAlbum, ^{
 
        NSMutableDictionary *dataDictionary = [[NSMutableDictionary alloc]init];
        [dataDictionary setObject:self.userNameString forKey:@"REPORTEDBY"];
        //        [dataDictionary setObject:[[syncMapDataMutableArray objectAtIndex:7] objectAtIndex:3] forKey:@"URL_ENDPOINT"];
        [dataDictionary setObject:@"" forKey:@"FLOCID"];
        
        if (isRefresh) {
            if ([[defaults objectForKey:@"FLOCEQUIP_REFRESH"] isEqualToString:@"X"]) {
                [dataDictionary setObject:@"REFR" forKey:@"TRANSMITTYPE"];
                NSMutableDictionary *endPointDictionary = [NSMutableDictionary new];
                [endPointDictionary setObject:@"FE" forKey:@"ACTIVITY"];
                [endPointDictionary setObject:@"C7" forKey:@"DOCTYPE"];
                [endPointDictionary setObject:[defaults objectForKey:@"ENDPOINT"] forKey:@"ENDPOINT"];
                
                NSArray *endPointArray = [[DataBase sharedInstance] getEndPointURL:endPointDictionary];
                NSLog(@"endPoint :%@",[[endPointArray objectAtIndex:0] objectAtIndex:0]);
                [dataDictionary setObject:[[endPointArray objectAtIndex:0] objectAtIndex:0] forKey:@"URL_ENDPOINT"];
                
                [Request makeWebServiceRequest:SEARCH_FUNCLOC_EQUIPMENTS parameters:dataDictionary delegate:self];
                
            }
        }
        else{
            
            if ([[defaults objectForKey:@"FLOCEQUIP_LOAD"] isEqualToString:@"X"]) {
                [dataDictionary setObject:@"LOAD" forKey:@"TRANSMITTYPE"];
                NSMutableDictionary *endPointDictionary = [NSMutableDictionary new];
                [endPointDictionary setObject:@"FE" forKey:@"ACTIVITY"];
                [endPointDictionary setObject:@"C7" forKey:@"DOCTYPE"];
                [endPointDictionary setObject:[defaults objectForKey:@"ENDPOINT"] forKey:@"ENDPOINT"];
                
                NSArray *endPointArray = [[DataBase sharedInstance] getEndPointURL:endPointDictionary];
                NSLog(@"endPoint :%@",[[endPointArray objectAtIndex:0] objectAtIndex:0]);
                [dataDictionary setObject:[[endPointArray objectAtIndex:0] objectAtIndex:0] forKey:@"URL_ENDPOINT"];
 
                [Request makeWebServiceRequest:SEARCH_FUNCLOC_EQUIPMENTS parameters:dataDictionary delegate:self];
                
             }
            else{
                
                [self performSelectorOnMainThread:@selector(dispatchQueuesForBOM) withObject:nil waitUntilDone:YES];
            }
        }
        
         //[[DataBase sharedInstance] importLocalDataIntoCoreData];
    });
 
}


-(void)disPatchQueuesForAuthorization{
    
     dispatch_queue_t fetchAlbum = dispatch_queue_create("Album fetcher", NULL);

    dispatch_sync(fetchAlbum, ^{
        
        NSMutableDictionary *dataDictionary = [[NSMutableDictionary alloc]init];
        [dataDictionary setObject:self.userNameString forKey:@"REPORTEDBY"];
        
        if (isRefresh) {
            if ([[defaults objectForKey:@"AUTH_REFRESH"] isEqualToString:@"X"]) {
                [dataDictionary setObject:@"REFR" forKey:@"TRANSMITTYPE"];
                NSMutableDictionary *endPointDictionary = [NSMutableDictionary new];
                [endPointDictionary setObject:@"RD" forKey:@"ACTIVITY"];
                [endPointDictionary setObject:@"SA" forKey:@"DOCTYPE"];
                [endPointDictionary setObject:[defaults objectForKey:@"ENDPOINT"] forKey:@"ENDPOINT"];
                
                NSArray *endPointArray = [[DataBase sharedInstance] getEndPointURL:endPointDictionary];
                NSLog(@"endPoint :%@",[[endPointArray objectAtIndex:0] objectAtIndex:0]);
                [dataDictionary setObject:[[endPointArray objectAtIndex:0] objectAtIndex:0] forKey:@"URL_ENDPOINT"];
                [Request makeWebServiceRequest:GET_AUTH_DATA parameters:dataDictionary delegate:self];
            }
        }
        else{
            if ([[defaults objectForKey:@"AUTH_LOAD"] isEqualToString:@"X"]) {
                [dataDictionary setObject:@"LOAD" forKey:@"TRANSMITTYPE"];
                NSMutableDictionary *endPointDictionary = [NSMutableDictionary new];
                [endPointDictionary setObject:@"RD" forKey:@"ACTIVITY"];
                [endPointDictionary setObject:@"SA" forKey:@"DOCTYPE"];
                [endPointDictionary setObject:[defaults objectForKey:@"ENDPOINT"] forKey:@"ENDPOINT"];
                
                NSArray *endPointArray = [[DataBase sharedInstance] getEndPointURL:endPointDictionary];
                NSLog(@"endPoint :%@",[[endPointArray objectAtIndex:0] objectAtIndex:0]);
                [dataDictionary setObject:[[endPointArray objectAtIndex:0] objectAtIndex:0] forKey:@"URL_ENDPOINT"];
                [Request makeWebServiceRequest:GET_AUTH_DATA parameters:dataDictionary delegate:self];
                
                
            }
        }
    });
    
}


-(void)dispatchQueuesForBOM{
    
    dispatch_queue_t fetchBOM = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_sync(fetchBOM, ^
    {
        NSMutableDictionary *dataDictionary = [[NSMutableDictionary alloc]init];
        [dataDictionary setObject:@"" forKey:@"EQUIPDESCRIP"];
        [dataDictionary setObject:@"" forKey:@"EQUIPNO"];
        [dataDictionary setObject:self.userNameString forKey:@"REPORTEDBY"];
        // [dataDictionary setObject:[[syncMapDataMutableArray objectAtIndex:5] objectAtIndex:3] forKey:@"URL_ENDPOINT"];
        
        if (isRefresh)
        {
            if ([[defaults objectForKey:@"BOM_REFRESH"] isEqualToString:@"X"]) {
                [dataDictionary setObject:@"REFR" forKey:@"TRANSMITTYPE"];
                NSMutableDictionary *endPointDictionary = [NSMutableDictionary new];
                [endPointDictionary setObject:@"EQ" forKey:@"ACTIVITY"];
                [endPointDictionary setObject:@"C5" forKey:@"DOCTYPE"];
                [endPointDictionary setObject:[defaults objectForKey:@"ENDPOINT"] forKey:@"ENDPOINT"];
                
                NSArray *endPointArray = [[DataBase sharedInstance] getEndPointURL:endPointDictionary];
                NSLog(@"endPoint :%@",[[endPointArray objectAtIndex:0] objectAtIndex:0]);
                [dataDictionary setObject:[[endPointArray objectAtIndex:0] objectAtIndex:0] forKey:@"URL_ENDPOINT"];
                [Request makeWebServiceRequest:GET_LIST_OF_PM_BOMS parameters:dataDictionary delegate:self];
            }
        }
        else{
            
            if ([[defaults objectForKey:@"BOM_LOAD"] isEqualToString:@"X"]) {
                [dataDictionary setObject:@"LOAD" forKey:@"TRANSMITTYPE"];
                NSMutableDictionary *endPointDictionary = [NSMutableDictionary new];
                [endPointDictionary setObject:@"EQ" forKey:@"ACTIVITY"];
                [endPointDictionary setObject:@"C5" forKey:@"DOCTYPE"];
                [endPointDictionary setObject:[defaults objectForKey:@"ENDPOINT"] forKey:@"ENDPOINT"];
                
                NSArray *endPointArray = [[DataBase sharedInstance] getEndPointURL:endPointDictionary];
                NSLog(@"endPoint :%@",[[endPointArray objectAtIndex:0] objectAtIndex:0]);
                [dataDictionary setObject:[[endPointArray objectAtIndex:0] objectAtIndex:0] forKey:@"URL_ENDPOINT"];
                [Request makeWebServiceRequest:GET_LIST_OF_PM_BOMS parameters:dataDictionary delegate:self];            }
            else{
                
                //  [self performSelectorOnMainThread:@selector(dispatchQueuesForMeasurementDocuments) withObject:nil waitUntilDone:YES];
                
                [self performSelectorOnMainThread:@selector(dispatchQueues) withObject:nil waitUntilDone:YES];
              }
        }
    });
}

-(void)dispatchQueuesForStock{
    
    dispatch_queue_t fetchStock = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_sync(fetchStock, ^{
        
        NSMutableDictionary *searchDictionary = [[NSMutableDictionary alloc]init];
        [searchDictionary setObject:self.userNameString forKey:@"REPORTEDBY"];
        [searchDictionary setObject:@"" forKey:@"MATERIAL"];
        [searchDictionary setObject:@"" forKey:@"PLANTFROM"];
        [searchDictionary setObject:@"" forKey:@"PLANTTO"];
        [searchDictionary setObject:@"" forKey:@"STORAGELOCFROM"];
        [searchDictionary setObject:@"" forKey:@"STORAGELOCTO"];
        [searchDictionary setObject:@"" forKey:@"MATERIALDESC"];
        //[searchDictionary setObject:[[syncMapDataMutableArray objectAtIndex:8] objectAtIndex:3] forKey:@"URL_ENDPOINT"];
        
        if (isRefresh) {
            
            if ([[defaults objectForKey:@"STOCK_REFRESH"] isEqualToString:@"X"]) {
                [searchDictionary setObject:@"REFR" forKey:@"TRANSMITTYPE"];
                NSMutableDictionary *endPointDictionary = [NSMutableDictionary new];
                [endPointDictionary setObject:@"SD" forKey:@"ACTIVITY"];
                [endPointDictionary setObject:@"C8" forKey:@"DOCTYPE"];
                [endPointDictionary setObject:[defaults objectForKey:@"ENDPOINT"] forKey:@"ENDPOINT"];
                NSArray *endPointArray = [[DataBase sharedInstance] getEndPointURL:endPointDictionary];
                NSLog(@"endPoint :%@",[[endPointArray objectAtIndex:0] objectAtIndex:0]);
                [searchDictionary setObject:[[endPointArray objectAtIndex:0] objectAtIndex:0] forKey:@"URL_ENDPOINT"];
                [Request makeWebServiceRequest:GET_STOCK_DATA parameters:searchDictionary delegate:self];
            }
        }
        else{
            
            if ([[defaults objectForKey:@"STOCK_LOAD"] isEqualToString:@"X"]) {
                [searchDictionary setObject:@"LOAD" forKey:@"TRANSMITTYPE"];
                NSMutableDictionary *endPointDictionary = [NSMutableDictionary new];
                [endPointDictionary setObject:@"SD" forKey:@"ACTIVITY"];
                [endPointDictionary setObject:@"C8" forKey:@"DOCTYPE"];
                [endPointDictionary setObject:[defaults objectForKey:@"ENDPOINT"] forKey:@"ENDPOINT"];
                
                NSArray *endPointArray = [[DataBase sharedInstance] getEndPointURL:endPointDictionary];
                NSLog(@"endPoint :%@",[[endPointArray objectAtIndex:0] objectAtIndex:0]);
                [searchDictionary setObject:[[endPointArray objectAtIndex:0] objectAtIndex:0] forKey:@"URL_ENDPOINT"];
                
                [Request makeWebServiceRequest:GET_STOCK_DATA parameters:searchDictionary delegate:self];
            }
            else{
                
                [self performSelectorOnMainThread:@selector(dispatchQueuesForMeasurementDocuments) withObject:nil waitUntilDone:YES];
            }
        }
    });
}


-(void)dispatchQueuesForValueHelps{
    
    dispatch_queue_t fetchValuehelps = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    downloadGroup = dispatch_group_create(); // 2

    dispatch_sync(fetchValuehelps, ^{
        
        NSMutableDictionary *dataDictionary = [[NSMutableDictionary alloc]init];
        [dataDictionary setObject:self.userNameString forKey:@"REPORTEDBY"];
        // [dataDictionary setObject:[[syncMapDataMutableArray objectAtIndex:34] objectAtIndex:3] forKey:@"URL_ENDPOINT"];
        
        if (isRefresh) {
            
            if ([[defaults objectForKey:@"VHLP_REFRESH"] isEqualToString:@"X"]) {
                [dataDictionary setObject:@"REFR" forKey:@"TRANSMITTYPE"];
                NSMutableDictionary *endPointDictionary = [NSMutableDictionary new];
                [endPointDictionary setObject:@"F4" forKey:@"ACTIVITY"];
                [endPointDictionary setObject:@"Z" forKey:@"DOCTYPE"];
                [endPointDictionary setObject:[defaults objectForKey:@"ENDPOINT"] forKey:@"ENDPOINT"];
                
                NSArray *endPointArray = [[DataBase sharedInstance] getEndPointURL:endPointDictionary];
                NSLog(@"endPoint :%@",[[endPointArray objectAtIndex:0] objectAtIndex:0]);
                [dataDictionary setObject:[[endPointArray objectAtIndex:0] objectAtIndex:0] forKey:@"URL_ENDPOINT"];
                
                dispatch_group_enter(downloadGroup); // 3
                 dispatch_group_leave(downloadGroup); // 4
                
                dispatch_group_wait(downloadGroup, DISPATCH_TIME_FOREVER); // 5
                dispatch_async(dispatch_get_main_queue(), ^{ // 6
                    
                    [Request makeWebServiceRequest:GET_VALUE_HELPS parameters:dataDictionary delegate:self];
                    
 
                });
              }
        }
        else{
            if ([[defaults objectForKey:@"VHLP_LOAD"] isEqualToString:@"X"]) {
                [dataDictionary setObject:@"LOAD" forKey:@"TRANSMITTYPE"];
                NSMutableDictionary *endPointDictionary = [NSMutableDictionary new];
                [endPointDictionary setObject:@"F4" forKey:@"ACTIVITY"];
                [endPointDictionary setObject:@"Z" forKey:@"DOCTYPE"];
                [endPointDictionary setObject:[defaults objectForKey:@"ENDPOINT"] forKey:@"ENDPOINT"];
                
                NSArray *endPointArray = [[DataBase sharedInstance] getEndPointURL:endPointDictionary];
                NSLog(@"endPoint :%@",[[endPointArray objectAtIndex:0] objectAtIndex:0]);
                [dataDictionary setObject:[[endPointArray objectAtIndex:0] objectAtIndex:0] forKey:@"URL_ENDPOINT"];
                
                dispatch_group_enter(downloadGroup); // 3
                
                dispatch_group_leave(downloadGroup); // 4
                
                dispatch_group_wait(downloadGroup, DISPATCH_TIME_FOREVER); // 5
                dispatch_async(dispatch_get_main_queue(), ^{ // 6
                
                [Request makeWebServiceRequest:GET_VALUE_HELPS parameters:dataDictionary delegate:self];
                    
                    
                });
            }
        }

    });
}

-(void)dispatchQueuesForJSAValueHelps{
    
    dispatch_queue_t fetchValuehelps = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_sync(fetchValuehelps, ^{
        
        NSMutableDictionary *dataDictionary = [[NSMutableDictionary alloc]init];
        [dataDictionary setObject:self.userNameString forKey:@"REPORTEDBY"];
        // [dataDictionary setObject:[[syncMapDataMutableArray objectAtIndex:34] objectAtIndex:3] forKey:@"URL_ENDPOINT"];
        
        if (isRefresh) {
            if ([[defaults objectForKey:@"VHLP_REFRESH"] isEqualToString:@"X"]) {
                [dataDictionary setObject:@"REFR" forKey:@"TRANSMITTYPE"];
                NSMutableDictionary *endPointDictionary = [NSMutableDictionary new];
                [endPointDictionary setObject:@"F4" forKey:@"ACTIVITY"];
                [endPointDictionary setObject:@"Z2" forKey:@"DOCTYPE"];
                [endPointDictionary setObject:[defaults objectForKey:@"ENDPOINT"] forKey:@"ENDPOINT"];
                
                NSArray *endPointArray = [[DataBase sharedInstance] getEndPointURL:endPointDictionary];
                NSLog(@"endPoint :%@",[[endPointArray objectAtIndex:0] objectAtIndex:0]);
                [dataDictionary setObject:[[endPointArray objectAtIndex:0] objectAtIndex:0] forKey:@"URL_ENDPOINT"];
                [Request makeWebServiceRequest:JSA_VALUE_HELPS parameters:dataDictionary delegate:self];
            }
        }
        else{
            if ([[defaults objectForKey:@"VHLP_LOAD"] isEqualToString:@"X"]) {
                [dataDictionary setObject:@"LOAD" forKey:@"TRANSMITTYPE"];
                NSMutableDictionary *endPointDictionary = [NSMutableDictionary new];
                [endPointDictionary setObject:@"F4" forKey:@"ACTIVITY"];
                [endPointDictionary setObject:@"Z2" forKey:@"DOCTYPE"];
                [endPointDictionary setObject:[defaults objectForKey:@"ENDPOINT"] forKey:@"ENDPOINT"];
                
                NSArray *endPointArray = [[DataBase sharedInstance] getEndPointURL:endPointDictionary];
                NSLog(@"endPoint :%@",[[endPointArray objectAtIndex:0] objectAtIndex:0]);
                [dataDictionary setObject:[[endPointArray objectAtIndex:0] objectAtIndex:0] forKey:@"URL_ENDPOINT"];
                
                [Request makeWebServiceRequest:JSA_VALUE_HELPS parameters:dataDictionary delegate:self];
            }
        }
        
    });
}

-(void)dispatchQueuesForWCMValueHelps{
    
    dispatch_queue_t fetchValuehelps = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
     dispatch_sync(fetchValuehelps, ^{
        
        NSMutableDictionary *dataDictionary = [[NSMutableDictionary alloc]init];
        [dataDictionary setObject:self.userNameString forKey:@"REPORTEDBY"];
        // [dataDictionary setObject:[[syncMapDataMutableArray objectAtIndex:34] objectAtIndex:3] forKey:@"URL_ENDPOINT"];
        
        if (isRefresh) {
            
            if ([[defaults objectForKey:@"VHLP_REFRESH"] isEqualToString:@"X"]) {
                [dataDictionary setObject:@"REFR" forKey:@"TRANSMITTYPE"];
                NSMutableDictionary *endPointDictionary = [NSMutableDictionary new];
                [endPointDictionary setObject:@"F4" forKey:@"ACTIVITY"];
                [endPointDictionary setObject:@"Z1" forKey:@"DOCTYPE"];
                [endPointDictionary setObject:[defaults objectForKey:@"ENDPOINT"] forKey:@"ENDPOINT"];
                
                NSArray *endPointArray = [[DataBase sharedInstance] getEndPointURL:endPointDictionary];
                NSLog(@"endPoint :%@",[[endPointArray objectAtIndex:0] objectAtIndex:0]);
                [dataDictionary setObject:[[endPointArray objectAtIndex:0] objectAtIndex:0] forKey:@"URL_ENDPOINT"];
                [Request makeWebServiceRequest:WCM_VALUE_HELPS parameters:dataDictionary delegate:self];
            }
        }
        else{
            if ([[defaults objectForKey:@"VHLP_LOAD"] isEqualToString:@"X"]) {
                [dataDictionary setObject:@"LOAD" forKey:@"TRANSMITTYPE"];
                NSMutableDictionary *endPointDictionary = [NSMutableDictionary new];
                [endPointDictionary setObject:@"F4" forKey:@"ACTIVITY"];
                [endPointDictionary setObject:@"Z1" forKey:@"DOCTYPE"];
                [endPointDictionary setObject:[defaults objectForKey:@"ENDPOINT"] forKey:@"ENDPOINT"];
                
                NSArray *endPointArray = [[DataBase sharedInstance] getEndPointURL:endPointDictionary];
                NSLog(@"endPoint :%@",[[endPointArray objectAtIndex:0] objectAtIndex:0]);
                [dataDictionary setObject:[[endPointArray objectAtIndex:0] objectAtIndex:0] forKey:@"URL_ENDPOINT"];
                
                [Request makeWebServiceRequest:WCM_VALUE_HELPS parameters:dataDictionary delegate:self];
            }
        }
        
    });
}

-(void)dispatchQueuesForMeasurementDocuments{
    
    NSLog(@"Mspoints Called");
    
    dispatch_queue_t fetchData = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_sync(fetchData, ^{
        
        NSMutableDictionary *dataDictionary = [[NSMutableDictionary alloc]init];
        [dataDictionary setObject:self.userNameString forKey:@"REPORTEDBY"];
        //[dataDictionary setObject:[[syncMapDataMutableArray objectAtIndex:16] objectAtIndex:3] forKey:@"URL_ENDPOINT"];
        
        if (isRefresh) {
            
            if ([[defaults objectForKey:@"FLOCEQUIP_REFRESH"] isEqualToString:@"X"]) {
                [dataDictionary setObject:@"REFR" forKey:@"TRANSMITTYPE"];
                NSMutableDictionary *endPointDictionary = [NSMutableDictionary new];
                [endPointDictionary setObject:@"RD" forKey:@"ACTIVITY"];
                [endPointDictionary setObject:@"MP" forKey:@"DOCTYPE"];
                [endPointDictionary setObject:[defaults objectForKey:@"ENDPOINT"] forKey:@"ENDPOINT"];
                
                NSArray *endPointArray = [[DataBase sharedInstance] getEndPointURL:endPointDictionary];
                NSLog(@"endPoint :%@",[[endPointArray objectAtIndex:0] objectAtIndex:0]);
                [dataDictionary setObject:[[endPointArray objectAtIndex:0] objectAtIndex:0] forKey:@"URL_ENDPOINT"];
                [Request makeWebServiceRequest:ORDER_MDOCS parameters:dataDictionary delegate:self];
            }
            else{
                
             }
        }
        else{
            
            if ([[defaults objectForKey:@"FLOCEQUIP_LOAD"] isEqualToString:@"X"]) {
                [dataDictionary setObject:@"LOAD" forKey:@"TRANSMITTYPE"];
                NSMutableDictionary *endPointDictionary = [NSMutableDictionary new];
                [endPointDictionary setObject:@"RD" forKey:@"ACTIVITY"];
                [endPointDictionary setObject:@"MP" forKey:@"DOCTYPE"];
                [endPointDictionary setObject:[defaults objectForKey:@"ENDPOINT"] forKey:@"ENDPOINT"];
                
                NSArray *endPointArray = [[DataBase sharedInstance] getEndPointURL:endPointDictionary];
                NSLog(@"endPoint :%@",[[endPointArray objectAtIndex:0] objectAtIndex:0]);
                [dataDictionary setObject:[[endPointArray objectAtIndex:0] objectAtIndex:0] forKey:@"URL_ENDPOINT"];
                [Request makeWebServiceRequest:ORDER_MDOCS parameters:dataDictionary delegate:self];
            }
            else{
                
             }
            
        }
    });
}

-(void)dispatchQueues{
    
    dispatch_queue_t fetchData = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    
    dispatch_sync(fetchData, ^{
        
        NSMutableDictionary *dataDictionary = [[NSMutableDictionary alloc]init];
        [dataDictionary setObject:self.userNameString forKey:@"REPORTEDBY"];
        //        [dataDictionary setObject:[[syncMapDataMutableArray objectAtIndex:2] objectAtIndex:3] forKey:@"URL_ENDPOINT"];
        
        if (isRefresh) {
            if ([[defaults objectForKey:@"DNOT_REFRESH"] isEqualToString:@"X"]) {
                [dataDictionary setObject:@"REFR" forKey:@"TRANSMITTYPE"];
                NSMutableDictionary *endPointDictionary = [NSMutableDictionary new];
                [endPointDictionary setObject:@"DN" forKey:@"ACTIVITY"];
                [endPointDictionary setObject:@"C1" forKey:@"DOCTYPE"];
                [endPointDictionary setObject:[defaults objectForKey:@"ENDPOINT"] forKey:@"ENDPOINT"];
                
                NSArray *endPointArray = [[DataBase sharedInstance] getEndPointURL:endPointDictionary];
                NSLog(@"endPoint :%@",[[endPointArray objectAtIndex:0] objectAtIndex:0]);
                [dataDictionary setObject:[[endPointArray objectAtIndex:0] objectAtIndex:0] forKey:@"URL_ENDPOINT"];
                [Request makeWebServiceRequest:GET_LIST_OF_DUE_NOTIFICATIONS parameters:dataDictionary delegate:self];
            }
        }
        else{
            if ([[defaults objectForKey:@"DNOT_LOAD"] isEqualToString:@"X"]) {
                [dataDictionary setObject:@"LOAD" forKey:@"TRANSMITTYPE"];
                NSMutableDictionary *endPointDictionary = [NSMutableDictionary new];
                [endPointDictionary setObject:@"DN" forKey:@"ACTIVITY"];
                [endPointDictionary setObject:@"C1" forKey:@"DOCTYPE"];
                [endPointDictionary setObject:[defaults objectForKey:@"ENDPOINT"] forKey:@"ENDPOINT"];
                
                NSArray *endPointArray = [[DataBase sharedInstance] getEndPointURL:endPointDictionary];
                NSLog(@"endPoint :%@",[[endPointArray objectAtIndex:0] objectAtIndex:0]);
                [dataDictionary setObject:[[endPointArray objectAtIndex:0] objectAtIndex:0] forKey:@"URL_ENDPOINT"];
                
             

                
                [Request makeWebServiceRequest:GET_LIST_OF_DUE_NOTIFICATIONS parameters:dataDictionary delegate:self];
            }
        }
    });
    
    
 
//    dispatch_sync(fetchData, ^{
//
//        NSMutableDictionary *dataDictionary = [[NSMutableDictionary alloc]init];
//        [dataDictionary setObject:self.userNameString forKey:@"REPORTEDBY"];
//        //        [dataDictionary setObject:[[syncMapDataMutableArray objectAtIndex:0] objectAtIndex:3] forKey:@"URL_ENDPOINT"];
//
//        if (isRefresh) {
//            if ([[defaults objectForKey:@"SETT_REFRESH"] isEqualToString:@"X"]) {
//                [dataDictionary setObject:@"REFR" forKey:@"TRANSMITTYPE"];
//                NSMutableDictionary *endPointDictionary = [NSMutableDictionary new];
//                [endPointDictionary setObject:@"RD" forKey:@"ACTIVITY"];
//                [endPointDictionary setObject:@"AS" forKey:@"DOCTYPE"];
//                [endPointDictionary setObject:[defaults objectForKey:@"ENDPOINT"] forKey:@"ENDPOINT"];
//
//                NSArray *endPointArray = [[DataBase sharedInstance] getEndPointURL:endPointDictionary];
//                NSLog(@"endPoint :%@",[[endPointArray objectAtIndex:0] objectAtIndex:0]);
//                [dataDictionary setObject:[[endPointArray objectAtIndex:0] objectAtIndex:0] forKey:@"URL_ENDPOINT"];
//                [Request makeWebServiceRequest:GET_APP_SETTINGS parameters:dataDictionary delegate:self];
//            }
//        }
//        else{
//            if ([[defaults objectForKey:@"SETT_LOAD"] isEqualToString:@"X"]) {
//                [dataDictionary setObject:@"LOAD" forKey:@"TRANSMITTYPE"];
//                NSMutableDictionary *endPointDictionary = [NSMutableDictionary new];
//                [endPointDictionary setObject:@"RD" forKey:@"ACTIVITY"];
//                [endPointDictionary setObject:@"AS" forKey:@"DOCTYPE"];
//                [endPointDictionary setObject:[defaults objectForKey:@"ENDPOINT"] forKey:@"ENDPOINT"];
//                 NSArray *endPointArray = [[DataBase sharedInstance] getEndPointURL:endPointDictionary];
//                NSLog(@"endPoint :%@",[[endPointArray objectAtIndex:0] objectAtIndex:0]);
//                [dataDictionary setObject:[[endPointArray objectAtIndex:0] objectAtIndex:0] forKey:@"URL_ENDPOINT"];
//                [Request makeWebServiceRequest:GET_APP_SETTINGS parameters:dataDictionary delegate:self];
//            }
//        }
//    });
//
//    dispatch_sync(fetchData, ^{
//
//        NSMutableDictionary *dataDictionary = [[NSMutableDictionary alloc]init];
//        [dataDictionary setObject:self.userNameString forKey:@"REPORTEDBY"];
//        //        [dataDictionary setObject:[[syncMapDataMutableArray objectAtIndex:13] objectAtIndex:3] forKey:@"URL_ENDPOINT"];
//
//        if (isRefresh) {
//            if ([[defaults objectForKey:@"NFC_REFRESH"] isEqualToString:@"X"]) {
//                [dataDictionary setObject:@"REFR" forKey:@"TRANSMITTYPE"];
//                NSMutableDictionary *endPointDictionary = [NSMutableDictionary new];
//                [endPointDictionary setObject:@"RD" forKey:@"ACTIVITY"];
//                [endPointDictionary setObject:@"NF" forKey:@"DOCTYPE"];
//                [endPointDictionary setObject:[defaults objectForKey:@"ENDPOINT"] forKey:@"ENDPOINT"];
//
//                NSArray *endPointArray = [[DataBase sharedInstance] getEndPointURL:endPointDictionary];
//                NSLog(@"endPoint :%@",[[endPointArray objectAtIndex:0] objectAtIndex:0]);
//                [dataDictionary setObject:[[endPointArray objectAtIndex:0] objectAtIndex:0] forKey:@"URL_ENDPOINT"];
//                [Request makeWebServiceRequest:GET_NFC_SETTINGS parameters:dataDictionary delegate:self];
//            }
//        }
//        else{
//            if ([[defaults objectForKey:@"NFC_LOAD"] isEqualToString:@"X"]) {
//                [dataDictionary setObject:@"LOAD" forKey:@"TRANSMITTYPE"];
//                NSMutableDictionary *endPointDictionary = [NSMutableDictionary new];
//                [endPointDictionary setObject:@"RD" forKey:@"ACTIVITY"];
//                [endPointDictionary setObject:@"NF" forKey:@"DOCTYPE"];
//                [endPointDictionary setObject:[defaults objectForKey:@"ENDPOINT"] forKey:@"ENDPOINT"];
//
//                NSArray *endPointArray = [[DataBase sharedInstance] getEndPointURL:endPointDictionary];
//                NSLog(@"endPoint :%@",[[endPointArray objectAtIndex:0] objectAtIndex:0]);
//                [dataDictionary setObject:[[endPointArray objectAtIndex:0] objectAtIndex:0] forKey:@"URL_ENDPOINT"];
//                [Request makeWebServiceRequest:GET_NFC_SETTINGS parameters:dataDictionary delegate:self];
//            }
//        }
//    });

 
        dispatch_sync(fetchData, ^{
            
            NSMutableDictionary *dataDictionary = [[NSMutableDictionary alloc]init];
            [dataDictionary setObject:self.userNameString forKey:@"REPORTEDBY"];
            //        [dataDictionary setObject:[[syncMapDataMutableArray objectAtIndex:3] objectAtIndex:3] forKey:@"URL_ENDPOINT"];
            
            if (isRefresh) {
                
                if ([[defaults objectForKey:@"DORD_REFRESH"] isEqualToString:@"X"]) {
                    [dataDictionary setObject:@"REFR" forKey:@"TRANSMITTYPE"];
                    NSMutableDictionary *endPointDictionary = [NSMutableDictionary new];
                    [endPointDictionary setObject:@"DO" forKey:@"ACTIVITY"];
                    [endPointDictionary setObject:@"C2" forKey:@"DOCTYPE"];
                    [endPointDictionary setObject:[defaults objectForKey:@"ENDPOINT"] forKey:@"ENDPOINT"];
                    
                    NSArray *endPointArray = [[DataBase sharedInstance] getEndPointURL:endPointDictionary];
                    NSLog(@"endPoint :%@",[[endPointArray objectAtIndex:0] objectAtIndex:0]);
                    [dataDictionary setObject:[[endPointArray objectAtIndex:0] objectAtIndex:0] forKey:@"URL_ENDPOINT"];
                    [Request makeWebServiceRequest:GET_LIST_OF_DUE_ORDERS parameters:dataDictionary delegate:self];
                }
            }
            else{
                
                if ([[defaults objectForKey:@"DORD_LOAD"] isEqualToString:@"X"]) {
                    [dataDictionary setObject:@"LOAD" forKey:@"TRANSMITTYPE"];
                    NSMutableDictionary *endPointDictionary = [NSMutableDictionary new];
                    [endPointDictionary setObject:@"DO" forKey:@"ACTIVITY"];
                    [endPointDictionary setObject:@"C2" forKey:@"DOCTYPE"];
                    [endPointDictionary setObject:[defaults objectForKey:@"ENDPOINT"] forKey:@"ENDPOINT"];
                    
                    NSArray *endPointArray = [[DataBase sharedInstance] getEndPointURL:endPointDictionary];
                    NSLog(@"endPoint :%@",[[endPointArray objectAtIndex:0] objectAtIndex:0]);
                    [dataDictionary setObject:[[endPointArray objectAtIndex:0] objectAtIndex:0] forKey:@"URL_ENDPOINT"];
                    
                    [Request makeWebServiceRequest:GET_LIST_OF_DUE_ORDERS parameters:dataDictionary delegate:self];
                }
            }
 
    });
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [imagesArray count];
    
}


// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    
    CollectionViewCell *cell = (CollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    cell.layer.borderColor=[[UIColor grayColor]CGColor];
    cell.layer.borderWidth=2;
    
    cell.imageView.image=[UIImage imageNamed:[[imagesArray objectAtIndex:indexPath.row] objectAtIndex:0]];
    cell.textLabel.text=[[imagesArray objectAtIndex:indexPath.row] objectAtIndex:1];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[[imagesArray objectAtIndex:indexPath.row] objectAtIndex:1] isEqualToString:@"Notification"])
    {
        UIViewController *dashVc = [self.storyboard instantiateViewControllerWithIdentifier:@"myNotificationsidentifier"];
        [self showViewController:dashVc sender:self];
    }
    else if ([[[imagesArray objectAtIndex:indexPath.row] objectAtIndex:1] isEqualToString:@"Order"]){
        
        UIViewController *dashVc = [self.storyboard instantiateViewControllerWithIdentifier:@"myOrdersVC"];
        
        [self showViewController:dashVc sender:self];
        
    }
    else if ([[[imagesArray objectAtIndex:indexPath.row] objectAtIndex:1] isEqualToString:@"Permit List"]){
        
         IsolationViewController *isoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"isolationVC"];
          isoVC.isIsolation=@"";
          [self showViewController:isoVC sender:self];
        
    }
    else if ([[[imagesArray objectAtIndex:indexPath.row] objectAtIndex:1] isEqualToString:@"Isolation List"]){
        
        IsolationViewController *isoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"isolationVC"];
        isoVC.isIsolation=@"X";
         [self showViewController:isoVC sender:self];
        
    }
    else if ([[[imagesArray objectAtIndex:indexPath.row] objectAtIndex:1] isEqualToString:@"Utilities"]){
        
        UtilitiesViewController *dashVc = [self.storyboard instantiateViewControllerWithIdentifier:@"UtilitiesIdentifier"];
        [self showViewController:dashVc sender:self];
    }
    else if ([[[imagesArray objectAtIndex:indexPath.row] objectAtIndex:1] isEqualToString:@"Maintenance Plan"]){
        
        UtilitiesViewController *dashVc = [self.storyboard instantiateViewControllerWithIdentifier:@"MaintPlanView"];
        [self showViewController:dashVc sender:self];
    }
    else if ([[[imagesArray objectAtIndex:indexPath.row] objectAtIndex:1] isEqualToString:@"User Log"]){
        
        ViewHistoryViewController *dashVc = [self.storyboard instantiateViewControllerWithIdentifier:@"HistoryView"];
        
        [defaults setObject:@"ONLINE" forKey:@"ViewHistory"];
        [defaults synchronize];
        
        [self showViewController:dashVc sender:self];
 
    }
    else if ([[[imagesArray objectAtIndex:indexPath.row] objectAtIndex:1] isEqualToString:@"Alert Log"]){
        
        ViewHistoryViewController *dashVc = [self.storyboard instantiateViewControllerWithIdentifier:@"HistoryView"];
        
        [defaults setObject:@"OFFLINE" forKey:@"ViewHistory"];
        [defaults synchronize];
        
        [self showViewController:dashVc sender:self];
     }
    
    else if ([[[imagesArray objectAtIndex:indexPath.row] objectAtIndex:1] isEqualToString:@"Equipment Inspection"]){
        

            
        UIViewController *dashVc = [self.storyboard instantiateViewControllerWithIdentifier:@"InspectionVC"];
        [self showViewController:dashVc sender:self];
        
    }
    
    else if ([[[imagesArray objectAtIndex:indexPath.row] objectAtIndex:1] isEqualToString:@"Settings"])
    {
         UIViewController *dashVc = [self.storyboard instantiateViewControllerWithIdentifier:@"AppSettingsVC"];
        [self showViewController:dashVc sender:self];
        
     }
    
    else if ([[[imagesArray objectAtIndex:indexPath.row] objectAtIndex:1] isEqualToString:@"MIS"])
    {
        UIViewController *dashVc = [self.storyboard instantiateViewControllerWithIdentifier:@"MISVC"];
        [self showViewController:dashVc sender:self];
        
    }
 
 }


-(void)functionForSyncMapData{
    
    syncMapDataMutableArray = [NSMutableArray new];
    [syncMapDataMutableArray removeAllObjects];
    
    [syncMapDataMutableArray addObjectsFromArray:[[DataBase sharedInstance] getSyncMapData:@"ODATA"]];
    
    if ([syncMapDataMutableArray count]) {
        
        if ([[ConnectionManager defaultManager] isReachable]) {
            
            [self performSelectorOnMainThread:@selector(getLoadSettings) withObject:nil waitUntilDone:YES];
        }
    }
}

-(IBAction)logoutBtnClicked:(id)sender{
 
    [self showAlertMessageWithTitle:@"Decision?" message:@"Do you want to logout?" cancelButtonTitle:@"No" withactionType:@"Multiple" forMethod:@"logout"];
    
 }

#pragma mark- request Delegate

- (void)resultData:(NSDictionary *)resultData withErrorDescription:(NSString *)errorDescription requestID:(WebServiceRequest)requestID :(int)statusCode
{
    switch (requestID) {
            
        case GET_SYNC_MAP_DATA:
            
            if (!errorDescription.length) {
                
                [[Response sharedInstance] parseForSyncMapData:resultData];
                
                NSLog(@"Syncmap called");
                
                [self functionForSyncMapData];
            }
            
            break;
            
        case DEVICE_TOKEN:
            
            if (!errorDescription.length) {
                
                NSLog(@"Device Token Success");
                
            }
            
            break;
            
        case GET_LOAD_SETTINGS:
            
            if (!errorDescription.length) {
                
                NSMutableDictionary *parsedDictionary = [[Response sharedInstance] parseForLoadSettings:resultData];
                
                NSLog(@"load settings called");

                
                [defaults removeObjectForKey:@"AUTH_LOAD"];
                [defaults removeObjectForKey:@"SETT_LOAD"];
                [defaults removeObjectForKey:@"NFC_LOAD"];
                [defaults removeObjectForKey:@"VHLP_LOAD"];
                [defaults removeObjectForKey:@"FLOCEQUIP_LOAD"];
                [defaults removeObjectForKey:@"MAT_LOAD"];
                [defaults removeObjectForKey:@"STOCK_LOAD"];
                [defaults removeObjectForKey:@"BOM_LOAD"];
                [defaults removeObjectForKey:@"DNOT_LOAD"];
                [defaults removeObjectForKey:@"DORD_LOAD"];
                
                [defaults removeObjectForKey:@"AUTH_REFRESH"];
                [defaults removeObjectForKey:@"SETT_REFRESH"];
                [defaults removeObjectForKey:@"NFC_REFRESH"];
                [defaults removeObjectForKey:@"VHLP_REFRESH"];
                [defaults removeObjectForKey:@"FLOCEQUIP_REFRESH"];
                [defaults removeObjectForKey:@"MAT_REFRESH"];
                [defaults removeObjectForKey:@"STOCK_REFRESH"];
                [defaults removeObjectForKey:@"BOM_REFRESH"];
                [defaults removeObjectForKey:@"DNOT_REFRESH"];
                [defaults removeObjectForKey:@"DORD_REFRESH"];
                
                [defaults synchronize];
                
                if ([parsedDictionary objectForKey:@"resultILoad"]) {
                    
                    if ([[parsedDictionary objectForKey:@"resultILoad"] isKindOfClass:[NSArray class]]) {
                        
                        if ([[parsedDictionary objectForKey:@"resultILoad"] objectAtIndex:0]) {
                            
                            if ([[[parsedDictionary objectForKey:@"resultILoad"] objectAtIndex:0] objectForKey:@"Auth"]) {
                                if ([[[[parsedDictionary objectForKey:@"resultILoad"] objectAtIndex:0] objectForKey:@"Auth"] isEqualToString:@"X"]) {
                                    [defaults setObject:@"X" forKey:@"AUTH_LOAD"];
                                }
                            }
                            
                            if ([[[parsedDictionary objectForKey:@"resultILoad"] objectAtIndex:0] objectForKey:@"Sett"]) {
                                if ([[[[parsedDictionary objectForKey:@"resultILoad"] objectAtIndex:0] objectForKey:@"Sett"] isEqualToString:@"X"]) {
                                    [defaults setObject:@"X" forKey:@"SETT_LOAD"];
                                }
                            }
                            
                            if ([[[parsedDictionary objectForKey:@"resultILoad"] objectAtIndex:0] objectForKey:@"Vhlp"]) {
                                if ([[[[parsedDictionary objectForKey:@"resultILoad"] objectAtIndex:0] objectForKey:@"Vhlp"] isEqualToString:@"X"]) {
                                    [defaults setObject:@"X" forKey:@"VHLP_LOAD"];
                                }
                            }
                            
                            if ([[[parsedDictionary objectForKey:@"resultILoad"] objectAtIndex:0] objectForKey:@"Floc"]) {
                                if ([[[[parsedDictionary objectForKey:@"resultILoad"] objectAtIndex:0] objectForKey:@"Floc"] isEqualToString:@"X"]) {
                                    [defaults setObject:@"X" forKey:@"FLOCEQUIP_LOAD"];
                                }
                            }
                            
                            if ([[[parsedDictionary objectForKey:@"resultILoad"] objectAtIndex:0] objectForKey:@"Mat"]) {
                                if ([[[[parsedDictionary objectForKey:@"resultILoad"] objectAtIndex:0] objectForKey:@"Mat"] isEqualToString:@"X"]) {
                                    [defaults setObject:@"X" forKey:@"MAT_LOAD"];
                                }
                            }
                            
                            if ([[[parsedDictionary objectForKey:@"resultILoad"] objectAtIndex:0] objectForKey:@"Stock"]) {
                                if ([[[[parsedDictionary objectForKey:@"resultILoad"] objectAtIndex:0] objectForKey:@"Stock"] isEqualToString:@"X"]) {
                                    [defaults setObject:@"X" forKey:@"STOCK_LOAD"];
                                }
                            }
                            
                            if ([[[parsedDictionary objectForKey:@"resultILoad"] objectAtIndex:0] objectForKey:@"Ebom"]) {
                                if ([[[[parsedDictionary objectForKey:@"resultILoad"] objectAtIndex:0] objectForKey:@"Ebom"] isEqualToString:@"X"]) {
                                    [defaults setObject:@"X" forKey:@"BOM_LOAD"];
                                }
                            }
                            
                            if ([[[parsedDictionary objectForKey:@"resultILoad"] objectAtIndex:0] objectForKey:@"Dnot"]) {
                                if ([[[[parsedDictionary objectForKey:@"resultILoad"] objectAtIndex:0] objectForKey:@"Dnot"] isEqualToString:@"X"]) {
                                    [defaults setObject:@"X" forKey:@"DNOT_LOAD"];
                                }
                            }
                            
                            if ([[[parsedDictionary objectForKey:@"resultILoad"] objectAtIndex:0] objectForKey:@"Dord"]) {
                                if ([[[[parsedDictionary objectForKey:@"resultILoad"] objectAtIndex:0] objectForKey:@"Dord"] isEqualToString:@"X"]) {
                                    [defaults setObject:@"X" forKey:@"DORD_LOAD"];
                                }
                            }
                            
                            if ([[[parsedDictionary objectForKey:@"resultILoad"] objectAtIndex:0] objectForKey:@"NFCD"]) {
                                if ([[[[parsedDictionary objectForKey:@"resultILoad"] objectAtIndex:0] objectForKey:@"NFCD"] isEqualToString:@"X"]) {
                                    [defaults setObject:@"X" forKey:@"NFC_LOAD"];
                                }
                            }
                            
                            [defaults setObject:@"X" forKey:@"NFC_LOAD"];
                        }
                    }
                    else if ([[parsedDictionary objectForKey:@"resultILoad"] isKindOfClass:[NSDictionary class]]){
                        if ([[parsedDictionary objectForKey:@"resultILoad"] objectForKey:@"Auth"]) {
                            if ([[[parsedDictionary objectForKey:@"resultILoad"] objectForKey:@"Auth"] isEqualToString:@"X"]) {
                                [defaults setObject:@"X" forKey:@"AUTH_LOAD"];
                            }
                        }
                        if ([[parsedDictionary objectForKey:@"resultILoad"] objectForKey:@"Sett"]) {
                            if ([[[parsedDictionary objectForKey:@"resultILoad"] objectForKey:@"Sett"] isEqualToString:@"X"]) {
                                [defaults setObject:@"X" forKey:@"SETT_LOAD"];
                            }
                        }
                        if ([[parsedDictionary objectForKey:@"resultILoad"] objectForKey:@"Vhlp"]) {
                            if ([[[parsedDictionary objectForKey:@"resultILoad"] objectForKey:@"Vhlp"] isEqualToString:@"X"]) {
                                [defaults setObject:@"X" forKey:@"VHLP_LOAD"];
                            }
                        }
                        if ([[parsedDictionary objectForKey:@"resultILoad"] objectForKey:@"Floc"]) {
                            if ([[[parsedDictionary objectForKey:@"resultILoad"] objectForKey:@"Floc"] isEqualToString:@"X"]) {
                                [defaults setObject:@"X" forKey:@"FLOCEQUIP_LOAD"];
                            }
                        }
                        if ([[parsedDictionary objectForKey:@"resultILoad"] objectForKey:@"Mat"]) {
                            if ([[[parsedDictionary objectForKey:@"resultILoad"] objectForKey:@"Mat"] isEqualToString:@"X"]) {
                                [defaults setObject:@"X" forKey:@"MAT_LOAD"];
                            }
                        }
                        if ([[parsedDictionary objectForKey:@"resultILoad"] objectForKey:@"Stock"]) {
                            if ([[[parsedDictionary objectForKey:@"resultILoad"] objectForKey:@"Stock"] isEqualToString:@"X"]) {
                                [defaults setObject:@"X" forKey:@"STOCK_LOAD"];
                            }
                        }
                        if ([[parsedDictionary objectForKey:@"resultILoad"] objectForKey:@"Ebom"]) {
                            if ([[[parsedDictionary objectForKey:@"resultILoad"] objectForKey:@"Ebom"] isEqualToString:@"X"]) {
                                [defaults setObject:@"X" forKey:@"BOM_LOAD"];
                            }
                        }
                        if ([[parsedDictionary objectForKey:@"resultILoad"] objectForKey:@"Dnot"]) {
                            if ([[[parsedDictionary objectForKey:@"resultILoad"] objectForKey:@"Dnot"] isEqualToString:@"X"]) {
                                [defaults setObject:@"X" forKey:@"DNOT_LOAD"];
                            }
                        }
                        if ([[parsedDictionary objectForKey:@"resultILoad"] objectForKey:@"Dord"]) {
                            if ([[[parsedDictionary objectForKey:@"resultILoad"] objectForKey:@"Dord"] isEqualToString:@"X"]) {
                                [defaults setObject:@"X" forKey:@"DORD_LOAD"];
                            }
                        }
                        
                        if ([[[parsedDictionary objectForKey:@"resultILoad"] objectAtIndex:0] objectForKey:@"NFCD"]) {
                            if ([[[[parsedDictionary objectForKey:@"resultILoad"] objectAtIndex:0] objectForKey:@"NFCD"] isEqualToString:@"X"]) {
                                [defaults setObject:@"X" forKey:@"NFC_LOAD"];
                            }
                        }
                        
                        [defaults setObject:@"X" forKey:@"NFC_LOAD"];
                    }
                }
                
                if ([parsedDictionary objectForKey:@"resultRefresh"]) {
                    if ([[parsedDictionary objectForKey:@"resultRefresh"] isKindOfClass:[NSArray class]]) {
                        if ([[parsedDictionary objectForKey:@"resultRefresh"] objectAtIndex:0]) {
                            if ([[[parsedDictionary objectForKey:@"resultRefresh"] objectAtIndex:0] objectForKey:@"Auth"]) {
                                if ([[[[parsedDictionary objectForKey:@"resultRefresh"] objectAtIndex:0] objectForKey:@"Auth"] isEqualToString:@"X"]) {
                                    [defaults setObject:@"X" forKey:@"AUTH_REFRESH"];
                                }
                            }
                            if ([[[parsedDictionary objectForKey:@"resultRefresh"] objectAtIndex:0] objectForKey:@"Sett"]) {
                                if ([[[[parsedDictionary objectForKey:@"resultRefresh"] objectAtIndex:0] objectForKey:@"Sett"] isEqualToString:@"X"]) {
                                    [defaults setObject:@"X" forKey:@"SETT_REFRESH"];
                                }
                            }
                            if ([[[parsedDictionary objectForKey:@"resultRefresh"] objectAtIndex:0] objectForKey:@"Vhlp"]) {
                                if ([[[[parsedDictionary objectForKey:@"resultRefresh"] objectAtIndex:0] objectForKey:@"Vhlp"] isEqualToString:@"X"]) {
                                    [defaults setObject:@"X" forKey:@"VHLP_REFRESH"];
                                }
                            }
                            if ([[[parsedDictionary objectForKey:@"resultRefresh"] objectAtIndex:0] objectForKey:@"Floc"]) {
                                if ([[[[parsedDictionary objectForKey:@"resultRefresh"] objectAtIndex:0] objectForKey:@"Floc"] isEqualToString:@"X"]) {
                                    [defaults setObject:@"X" forKey:@"FLOCEQUIP_REFRESH"];
                                }
                            }
                            if ([[[parsedDictionary objectForKey:@"resultRefresh"] objectAtIndex:0] objectForKey:@"Mat"]) {
                                if ([[[[parsedDictionary objectForKey:@"resultRefresh"] objectAtIndex:0] objectForKey:@"Mat"] isEqualToString:@"X"]) {
                                    [defaults setObject:@"X" forKey:@"MAT_REFRESH"];
                                }
                            }
                            if ([[[parsedDictionary objectForKey:@"resultRefresh"] objectAtIndex:0] objectForKey:@"Stock"]) {
                                if ([[[[parsedDictionary objectForKey:@"resultRefresh"] objectAtIndex:0] objectForKey:@"Stock"] isEqualToString:@"X"]) {
                                    [defaults setObject:@"X" forKey:@"STOCK_REFRESH"];
                                }
                            }
                            if ([[[parsedDictionary objectForKey:@"resultRefresh"] objectAtIndex:0] objectForKey:@"Ebom"]) {
                                if ([[[[parsedDictionary objectForKey:@"resultRefresh"] objectAtIndex:0] objectForKey:@"Ebom"] isEqualToString:@"X"]) {
                                    [defaults setObject:@"X" forKey:@"BOM_REFRESH"];
                                }
                            }
                            if ([[[parsedDictionary objectForKey:@"resultRefresh"] objectAtIndex:0] objectForKey:@"Dnot"]) {
                                if ([[[[parsedDictionary objectForKey:@"resultRefresh"] objectAtIndex:0] objectForKey:@"Dnot"] isEqualToString:@"X"]) {
                                    [defaults setObject:@"X" forKey:@"DNOT_REFRESH"];
                                }
                            }
                            if ([[[parsedDictionary objectForKey:@"resultRefresh"] objectAtIndex:0] objectForKey:@"Dord"]) {
                                if ([[[[parsedDictionary objectForKey:@"resultRefresh"] objectAtIndex:0] objectForKey:@"Dord"] isEqualToString:@"X"]) {
                                    [defaults setObject:@"X" forKey:@"DORD_REFRESH"];
                                }
                            }
                            
                            if ([[[parsedDictionary objectForKey:@"resultRefresh"] objectAtIndex:0] objectForKey:@"NFCD"]) {
                                if ([[[[parsedDictionary objectForKey:@"resultRefresh"] objectAtIndex:0] objectForKey:@"NFCD"] isEqualToString:@"X"]) {
                                    [defaults setObject:@"X" forKey:@"NFC_REFRESH"];
                                }
                            }
                            [defaults setObject:@"X" forKey:@"NFC_REFRESH"];
                        }
                    }
                    else if ([[parsedDictionary objectForKey:@"resultRefresh"] isKindOfClass:[NSDictionary class]]){
                        if ([[parsedDictionary objectForKey:@"resultRefresh"] objectForKey:@"Auth"]) {
                            if ([[[parsedDictionary objectForKey:@"resultRefresh"] objectForKey:@"Auth"] isEqualToString:@"X"]) {
                                [defaults setObject:@"X" forKey:@"AUTH_REFRESH"];
                            }
                        }
                        if ([[parsedDictionary objectForKey:@"resultRefresh"] objectForKey:@"Sett"]) {
                            if ([[[parsedDictionary objectForKey:@"resultRefresh"] objectForKey:@"Sett"] isEqualToString:@"X"]) {
                                [defaults setObject:@"X" forKey:@"SETT_REFRESH"];
                            }
                        }
                        
                        if ([[parsedDictionary objectForKey:@"resultRefresh"] objectForKey:@"Vhlp"]) {
                            if ([[[parsedDictionary objectForKey:@"resultRefresh"] objectForKey:@"Vhlp"] isEqualToString:@"X"]) {
                                [defaults setObject:@"X" forKey:@"VHLP_REFRESH"];
                            }
                        }
                        if ([[parsedDictionary objectForKey:@"resultRefresh"] objectForKey:@"Floc"]) {
                            if ([[[parsedDictionary objectForKey:@"resultRefresh"] objectForKey:@"Floc"] isEqualToString:@"X"]) {
                                [defaults setObject:@"X" forKey:@"FLOCEQUIP_REFRESH"];
                            }
                        }
                        if ([[parsedDictionary objectForKey:@"resultRefresh"] objectForKey:@"Mat"]) {
                            if ([[[parsedDictionary objectForKey:@"resultRefresh"] objectForKey:@"Mat"] isEqualToString:@"X"]) {
                                [defaults setObject:@"X" forKey:@"MAT_REFRESH"];
                            }
                        }
                        if ([[parsedDictionary objectForKey:@"resultRefresh"] objectForKey:@"Stock"]) {
                            if ([[[parsedDictionary objectForKey:@"resultRefresh"] objectForKey:@"Stock"] isEqualToString:@"X"]) {
                                [defaults setObject:@"X" forKey:@"STOCK_REFRESH"];
                            }
                        }
                        if ([[parsedDictionary objectForKey:@"resultRefresh"] objectForKey:@"Ebom"]) {
                            if ([[[parsedDictionary objectForKey:@"resultRefresh"] objectForKey:@"Ebom"] isEqualToString:@"X"]) {
                                [defaults setObject:@"X" forKey:@"BOM_REFRESH"];
                            }
                        }
                        if ([[parsedDictionary objectForKey:@"resultRefresh"] objectForKey:@"Dnot"]) {
                            if ([[[parsedDictionary objectForKey:@"resultRefresh"] objectForKey:@"Dnot"] isEqualToString:@"X"]) {
                                [defaults setObject:@"X" forKey:@"DNOT_REFRESH"];
                            }
                        }
                        if ([[parsedDictionary objectForKey:@"resultRefresh"] objectForKey:@"Dord"]) {
                            if ([[[parsedDictionary objectForKey:@"resultRefresh"] objectForKey:@"Dord"] isEqualToString:@"X"]) {
                                [defaults setObject:@"X" forKey:@"DORD_REFRESH"];
                            }
                        }
                        
                        if ([[[parsedDictionary objectForKey:@"resultRefresh"] objectAtIndex:0] objectForKey:@"NFCD"]) {
                            if ([[[[parsedDictionary objectForKey:@"resultRefresh"] objectAtIndex:0] objectForKey:@"NFCD"] isEqualToString:@"X"]) {
                                [defaults setObject:@"X" forKey:@"NFC_REFRESH"];
                            }
                        }
                        
                        [defaults setObject:@"X" forKey:@"NFC_REFRESH"];
                    }
                }
                
                [defaults synchronize];
                
                if ([syncMapDataMutableArray count]) {
                    
                    if ([[ConnectionManager defaultManager] isReachable])
                    {
                        if (isRefresh) {
                            if ([defaults objectForKey:@"AUTH_REFRESH"] || [defaults objectForKey:@"SETT_REFRESH"] || [defaults objectForKey:@"VHLP_REFRESH"] || [defaults objectForKey:@"FLOCEQUIP_REFRESH"] || [defaults objectForKey:@"MAT_REFRESH"] || [defaults objectForKey:@"STOCK_REFRESH"] || [defaults objectForKey:@"BOM_REFRESH"] || [defaults objectForKey:@"DNOT_REFRESH"] || [defaults objectForKey:@"DORD_REFRESH"] || [defaults objectForKey:@"NFC_REFRESH"]) {
 
                                if ([[defaults objectForKey:@"VHLP_REFRESH"] isEqualToString:@"X"]) {
                                    
                                    [self performSelectorOnMainThread:@selector(dispatchQueuesForValueHelps) withObject:nil waitUntilDone:YES];

                                }
                                
                                if ([[defaults objectForKey:@"FLOCEQUIP_REFRESH"] isEqualToString:@"X"]) {
                                    
                                    [self performSelectorOnMainThread:@selector(dispatchQueueForEquipments) withObject:nil waitUntilDone:YES];
                                    

                                }
                                
                                    [self performSelectorOnMainThread:@selector(dispatchQueuesForWCMValueHelps) withObject:nil waitUntilDone:YES];
                                
                                   // [self performSelectorOnMainThread:@selector(dispatchQueuesForJSAValueHelps) withObject:nil waitUntilDone:YES];
                            
                       //     [self performSelectorOnMainThread:@selector(dispatchQueuesForMeasurementDocuments) withObject:nil waitUntilDone:YES];
                                
                                [self performSelectorOnMainThread:@selector(disPatchQueuesForAuthorization) withObject:nil waitUntilDone:YES];

                                [self performSelectorOnMainThread:@selector(dispatchQueues) withObject:nil waitUntilDone:YES];

                                
                                 //  [self performSelectorOnMainThread:@selector(setDevicToken) withObject:nil waitUntilDone:YES];
                            }
                            else{
                                
                                [MBProgressHUD hideHUDForView:self.view animated:YES];
                             }
                        }
                        else{
                            
                           
                            if ([defaults objectForKey:@"AUTH_LOAD"] || [defaults objectForKey:@"SETT_LOAD"] || [defaults objectForKey:@"VHLP_LOAD"] || [defaults objectForKey:@"FLOCEQUIP_LOAD"] || [defaults objectForKey:@"MAT_LOAD"] || [defaults objectForKey:@"STOCK_LOAD"] || [defaults objectForKey:@"BOM_LOAD"] || [defaults objectForKey:@"DNOT_LOAD"] || [defaults objectForKey:@"DORD_LOAD"]) {
                                
                                [self performSelectorOnMainThread:@selector(dispatchQueueForEquipments) withObject:nil waitUntilDone:YES];
 
                                [self performSelectorOnMainThread:@selector(disPatchQueuesForAuthorization) withObject:nil waitUntilDone:YES];
                                
                                [self performSelectorOnMainThread:@selector(dispatchQueuesForMeasurementDocuments) withObject:nil waitUntilDone:YES];
                                
                                [self performSelectorOnMainThread:@selector(dispatchQueuesForValueHelps) withObject:nil waitUntilDone:YES];
                                
                                [self performSelectorOnMainThread:@selector(dispatchQueuesForWCMValueHelps) withObject:nil waitUntilDone:YES];
                                
 
                             //   [self performSelectorOnMainThread:@selector(dispatchQueuesForJSAValueHelps) withObject:nil waitUntilDone:YES];
                                
                                [self performSelectorOnMainThread:@selector(dispatchQueues) withObject:nil waitUntilDone:YES];

 
                                [self performSelectorOnMainThread:@selector(setDevicToken) withObject:nil waitUntilDone:YES];
                            }
                            else{
                                
                                [MBProgressHUD hideHUDForView:self.view animated:YES];
                             }
                        }
                    }
                    else{
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                     }
                }
            }
            
            break;
            
        case GET_VALUE_HELPS:
            
            if (!errorDescription.length) {
                
                NSMutableDictionary *parsedDictionary = [[Response sharedInstance] parseForValueHelps:resultData];
                
                NSLog(@"get value help called %@",resultData);

                [DashBoardViewController functionForActivityTypeData:[parsedDictionary objectForKey:@"resultLstar"]];
                [DashBoardViewController functionForNotifType:[parsedDictionary objectForKey:@"resultNotifTypes"]];
                [DashBoardViewController functionForNotifPriority:[parsedDictionary objectForKey:@"resultNotifPriority"]];
                [DashBoardViewController functionForOrderPriority:[parsedDictionary objectForKey:@"resultOrderPriority"]];
                [DashBoardViewController functionForOrderType:[parsedDictionary objectForKey:@"resultOrderTypes"]];
                [DashBoardViewController functionForGetUnits:[parsedDictionary objectForKey:@"resultUnits"]];
                [DashBoardViewController functionForAccIndicator:[parsedDictionary objectForKey:@"resultBemot"]];
                [DashBoardViewController functionForCostCenter:[parsedDictionary objectForKey:@"resultKostl"]];
                [DashBoardViewController functionForConfirmReason:[parsedDictionary objectForKey:@"resultConfReason"]];
                [DashBoardViewController functionForListOfPlants:[parsedDictionary objectForKey:@"resultPlants"]];
                [DashBoardViewController functionForListOfStorageLocation:[parsedDictionary objectForKey:@"resultStloc"]];
                [DashBoardViewController functionForAllNotifCodes:[parsedDictionary objectForKey:@"resultNotifCodes"]];
                [DashBoardViewController functionForListOfMovementTypes:[parsedDictionary objectForKey:@"resultMovementTypes"]];
                [DashBoardViewController functionForListOfWorkCenter:[parsedDictionary objectForKey:@"resultWkctrPlant"]];
                [DashBoardViewController functionForCustomFields:[parsedDictionary objectForKey:@"CustomFields"]];
                [DashBoardViewController functionForControlKeys:[parsedDictionary objectForKey:@"resultControlKeys"]];
                [DashBoardViewController functionForNotifEffect:[parsedDictionary objectForKey:@"resultNotifEffect"]];
                [DashBoardViewController functionForOrderSystemCondition:[parsedDictionary objectForKey:@"resultOrderSystemCondition"]];
                [DashBoardViewController functionForNotifOrderTypeRelationMaster:[parsedDictionary objectForKey:@"resultEtTq80"]];
                 [DashBoardViewController functionForPlannerGroupMaster:[parsedDictionary objectForKey:@"resultInGrp"]];//PlannerGroup
                
                [DashBoardViewController functionForPersonResponsibleMaster:[parsedDictionary objectForKey:@"resultPernr"]];//PersonResponsible
                
                [DashBoardViewController functionForETUsers:[parsedDictionary objectForKey:@"resultEtUserTokenId"]];//ET
                
                 [DashBoardViewController functionForETUsers:[parsedDictionary objectForKey:@"resultEtUserTokenId"]];//ET
                
                [DashBoardViewController functionForEtMeasCodes:[parsedDictionary objectForKey:@"resultInpectionmeasDocs"]];//ET
                
                 if ([defaults objectForKey:@"VHLP_REFRESH"]) {
                    
                    [MBProgressHUD hideHUDForView:self.view animated:YES];

                 }

 
                [MBProgressHUD hideHUDForView:self.window animated:YES];
                
                [blackView removeFromSuperview];
 
             }
            
            break;
            
        case WCM_VALUE_HELPS:
            
            if (!errorDescription.length) {
 
                 NSMutableDictionary *parsedDictionary = [[Response sharedInstance] parseForWCMValueHelps:resultData];
                
                NSLog(@"wcm value called");

                [DashBoardViewController functionForWsmDocument:[parsedDictionary objectForKey:@"resultWSMDocument"]];
                
                //WCM
                 [DashBoardViewController functionForWcmChkReq:[parsedDictionary objectForKey:@"resultChkRequests"]];
                [DashBoardViewController functionForWcmTgtyp:[parsedDictionary objectForKey:@"resultWcmTgTypes"]];
                // [DashBoardViewController functionForWcmWcvp6:parsedDictionary];
                [DashBoardViewController functionForWcmTypes:[parsedDictionary objectForKey:@"resultWcmTypes"]];
 
                 [DashBoardViewController functionForAuthorizationGroupMaster:[parsedDictionary objectForKey:@"resultAuthorizationGroups"]];//WCMAuthorizationGroup
                [DashBoardViewController functionForUsagesMaster:[parsedDictionary objectForKey:@"resultUsages"]];//WCMUsage
                 [DashBoardViewController functionForWCMWork:[parsedDictionary objectForKey:@"resultWcmWork"]];//WCMWork
                 [DashBoardViewController functionForWCMRequirements:[parsedDictionary objectForKey:@"resultWcmRequirements"]];//WCMRequirements
 
                [DashBoardViewController functionForEtwbs:[parsedDictionary objectForKey:@"resultWBS"]];//resultWBS
                [DashBoardViewController functionForEvRevnr:[parsedDictionary objectForKey:@"resultRevnr"]];//resultRevnr

 
                //WSM
                /*  [DashBoardViewController functionForWsmRisks:[parsedDictionary objectForKey:@"resultWSMRisks"]];
                 [DashBoardViewController functionForWsmResponses:[parsedDictionary objectForKey:@"resultWSMResponses"]];
                 [DashBoardViewController functionForWsmObjAvail:[parsedDictionary objectForKey:@"resultWSMObjAvail"]];
                 [DashBoardViewController functionForWsmMaterial:[parsedDictionary objectForKey:@"resultWSMMaterial"]];
                 
                 [DashBoardViewController functionForWsmEqui:[parsedDictionary objectForKey:@"resultWSMEqui"]];
                 [DashBoardViewController functionForWsmPermit:[parsedDictionary objectForKey:@"resultWSMPermit"]];
                 [DashBoardViewController functionForWsmWcmr:[parsedDictionary objectForKey:@"resultWSMWcmr"]];
                 [DashBoardViewController functionForWsmPlants:[parsedDictionary objectForKey:@"resultWSMPlants"]];  //newlyadded
                 // [DashBoardViewController functionForWsmSafetyMeasures:parsedDictionary];
                 
                 //newlyadded
                 [DashBoardViewController functionForWsmDocument:[parsedDictionary objectForKey:@"resultWSMDocument"]];

                 */
                
            }
            
        case JSA_VALUE_HELPS:
            
            if (!errorDescription.length) {
                
            NSMutableDictionary *parsedDictionary = [[Response sharedInstance] parseForJSAValueHelps:resultData];
                
              NSLog(@"jsa value called");
 
            [DashBoardViewController functionForJSAEHSOpstat:[parsedDictionary objectForKey:@"resultEHSOpstat"]];
                
            [DashBoardViewController functionForJSAShazcat:[parsedDictionary objectForKey:@"resultEHSHazcat"]];

            [DashBoardViewController functionForJSAShazard:[parsedDictionary objectForKey:@"resultEHSHazard"]];
                
            [DashBoardViewController functionForJSAShazaimp:[parsedDictionary objectForKey:@"resultEHSHazimp"]];
                
            [DashBoardViewController functionForJSAShazctrl:[parsedDictionary objectForKey:@"EtEHSHazctrl"]];
 
            [DashBoardViewController functionForJSAEHSLoctyp:[parsedDictionary objectForKey:@"resultEHSLocTyp"]];
 
            [DashBoardViewController functionForJSAEHSLocrev:[parsedDictionary objectForKey:@"resultEHSLocRev"]];

            [DashBoardViewController functionForJSAShaJobtyp:[parsedDictionary objectForKey:@"resultEHSJobTyp"]];

            [DashBoardViewController functionForJSRasRole:[parsedDictionary objectForKey:@"resultEHSRasrole"]];

            [DashBoardViewController functionForJSAEHSrastep:[parsedDictionary objectForKey:@"resultEHSRasstep"]];

            [DashBoardViewController functionForJSAEHSReason:[parsedDictionary objectForKey:@"resultEHSRasstep"]];
 
                
            }
            
        case GET_AUTH_DATA:
            
            if (!errorDescription.length) {
                
                NSMutableDictionary *parsedDictionary = [[Response sharedInstance] parseForAuthData:resultData];
                
                 NSLog(@"auth data called");
 
                [self functionForAutherization:parsedDictionary];
            }
            
            break;
            
        case GET_SETTINGS_DATA:
            
            if (!errorDescription.length) {
                
                NSMutableDictionary *parsedDictionary = [[Response sharedInstance] parseForSettingsData:resultData];
                
                 NSLog(@"Syncmap called");
 
                [DashBoardViewController functionForSettings:parsedDictionary];
            }
            
            break;
            
        case GET_APP_SETTINGS:
            
            if (!errorDescription.length) {
                
                [[Response sharedInstance] parseForSettingsData:resultData];
                
                // [DashBoardViewController functionForAppSettingsData:parsedDictionary];
            }
            
            break;
            
        case GET_NFC_SETTINGS:
            
            if (!errorDescription.length) {
                
                NSLog(@"nfc settings called");
                
                NSMutableDictionary *parsedDictionary = [[Response sharedInstance] parseForNFCSettings:resultData];
                
                [DashBoardViewController functionForNFCSettingsData:[parsedDictionary objectForKey:@"resultNFC"]];
            }
            
            break;
            
        case GET_ACTIVITY_TYPE:
            
            if (!errorDescription.length) {
                NSMutableDictionary *parsedDictionary = [[Response sharedInstance] parseForActivityType:resultData];
                
                [DashBoardViewController functionForActivityTypeData:parsedDictionary];
            }
            
            break;
            
        case NOTIFICATION_TYPES:
            if (!errorDescription.length) {
                NSMutableDictionary *parsedDictionary = [[Response sharedInstance] parseForNotifTypes:resultData];
                
                [DashBoardViewController functionForNotifType:parsedDictionary];
                
            }
            
            break;
            
        case NOTIFICATION_PRIORITY_TYPES:
            
            if (!errorDescription.length) {
                
                NSMutableDictionary *parsedDictionary = [[Response sharedInstance] parseForNotifPriorityTypes:resultData];
                
                [DashBoardViewController functionForNotifPriority:parsedDictionary];
                
            }
            
            break;
            
        case ORDER_PRIORITY_TYPES:
            
            if (!errorDescription.length) {
                
                NSMutableDictionary *parsedDictionary = [[Response sharedInstance] parseForOrderPriorityTypes:resultData];
                
                [DashBoardViewController functionForOrderPriority:parsedDictionary];
                
            }
            
            break;
            
        case ORDER_TYPES:
            if (!errorDescription.length) {
                NSMutableDictionary *parsedDictionary = [[Response sharedInstance] parseForOrderTypes:resultData];
                
                [DashBoardViewController functionForOrderType:parsedDictionary];
            }
            break;
            
        case GET_UNITS:
            if (!errorDescription.length) {
                NSMutableDictionary *parsedDictionary = [[Response sharedInstance] parseForGetUnits:resultData];
                
                [DashBoardViewController functionForGetUnits:parsedDictionary];
            }
            break;
            
        case ACCIND_TYPES:
            if (!errorDescription.length) {
                NSMutableDictionary *parsedDictionary = [[Response sharedInstance] parseForAccIndicator:resultData];
                
                [DashBoardViewController functionForAccIndicator:parsedDictionary];
            }
            break;
            
        case COSTCENTER_LIST:
            
            if (!errorDescription.length) {
                NSMutableDictionary *parsedDictionary = [[Response sharedInstance] parseForCostCenterList:resultData];
                
                [DashBoardViewController functionForCostCenter:parsedDictionary];
            }
            
            break;
            
        case USER_DATA:
            
            if (!errorDescription.length) {
                NSMutableDictionary *parsedDictionary = [[Response sharedInstance] parseForUserData:resultData];
                
                [DashBoardViewController functionForUserData:parsedDictionary];
            }
            
            break;
            
        case GET_CONFRIM_REASON:
            
            if (!errorDescription.length) {
                
                NSMutableDictionary *parsedDictionary = [[Response sharedInstance] parseForConfirmReason:resultData];
                
                [DashBoardViewController functionForConfirmReason:parsedDictionary];
            }
            
            break;
            
        case GET_LIST_OF_PLANTS:
            
            if (!errorDescription.length) {
                NSMutableDictionary *parsedDictionary = [[Response sharedInstance] parseForListOfPlants:resultData];
                
                [DashBoardViewController functionForListOfPlants:parsedDictionary];
                
            }
            
            break;
            
        case GET_LIST_OF_STORAGELOCATION:
            
            if (!errorDescription.length) {
                NSMutableDictionary *parsedDictionary = [[Response sharedInstance] parseForListOfStorageLocation:resultData];
                
                [DashBoardViewController functionForListOfStorageLocation:parsedDictionary];
                
            }
            
            break;
            
        case ALLNOTIFICATION_CODES:
            
            if (!errorDescription.length) {
                
                NSMutableDictionary *parsedDictionary = [[Response sharedInstance] parseForALLNotifTypes:resultData];
                
                [DashBoardViewController functionForAllNotifCodes:parsedDictionary];
                
            }
            
            break;
            
        case GET_LIST_OF_MOVEMENTTYPES:
            
            if (!errorDescription.length) {
                NSMutableDictionary *parsedDictionary = [[Response sharedInstance] parseForListOFMovementTypes:resultData];
                
                [DashBoardViewController functionForListOfMovementTypes:parsedDictionary];
                
            }
            
            break;
            
        case GET_LIST_OF_WORKCENTER:
            
            if (!errorDescription.length) {
                NSMutableDictionary *parsedDictionary = [[Response sharedInstance] parseForListOfWorkCenter:resultData];
                
                [DashBoardViewController functionForListOfWorkCenter:parsedDictionary];
                
            }
            
            break;
            
        case FUNCTIONLOC_COSTCENTER:
            
            if (!errorDescription.length) {
                
                [[Response sharedInstance] parseForFuncLocCostCenter:resultData];
                
            }
            
            break;
            
        case EQUIPMENT_COSTCENTER:
            
            if (!errorDescription.length) {
                
                [[Response sharedInstance] parseForEquipCostCenter:resultData];
            }
            
            break;
            
        case SEARCH_FUNCLOC_EQUIPMENTS:
            
            if (!errorDescription.length) {
                
                NSMutableDictionary *parsedDictionary = [[Response sharedInstance] parseForSearchFunclocEquipments:resultData];
                
                NSLog(@"function location called");

                if ([parsedDictionary objectForKey:@"resultFloc"]) {
                    
                    NSArray *arr_searchFuncLocResponse = [parsedDictionary objectForKey:@"resultFloc"];
                    
                    if ([arr_searchFuncLocResponse count]) {
                        
                        AppDelegate *tempDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
 
                        [tempDelegate.coreDataControlObject removeContextForFuncLoc:@""];
                        
                        [[DataBase sharedInstance] insertFunctionalocationToCoreData:arr_searchFuncLocResponse];
                        
                        //[[DataBase sharedInstance] insertFuncLocEquimentsToCoreDataFromArray:arr_searchFuncLocEquipmentsResponse];
                    }
                }
                
                if ([parsedDictionary objectForKey:@"resultEquip"]) {
                    
                    NSArray *arr_searchEquipmentsResponse = [parsedDictionary objectForKey:@"resultEquip"];
                    
                    if ([arr_searchEquipmentsResponse count]) {
                        
                        AppDelegate *tempDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                        
                        [tempDelegate.coreDataControlObject removeContextForEquipment:@""];
                        
                        [[DataBase sharedInstance] insertEquipmentToCoreData:arr_searchEquipmentsResponse];
                    }
                }
              }
 
            [self performSelectorOnMainThread:@selector(dispatchQueuesForBOM) withObject:nil waitUntilDone:YES];
            
            break;
            
        case GET_LIST_OF_PM_BOMS:
            
            if (!errorDescription.length) {
                
              //  NSLog(@"PmBoms Called");
                
                NSLog(@"stock response is%@",resultData);

                 if ([resultData count])
                {
                     AppDelegate *tempDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                     [tempDelegate.coreDataControlObject removeContextForEquipmentBOM:@""];
                }
                
                [[Response sharedInstance] parseForListOfPMBOMS:resultData];
            }
            
            // [self performSelectorOnMainThread:@selector(dispatchQueuesForMeasurementDocuments) withObject:nil waitUntilDone:YES];
 
            break;
            
        case GET_LIST_OF_COMPONENTS:
            
            if (!errorDescription.length) {
                
                NSMutableDictionary *parsedDictionary = [[Response sharedInstance]parseForListOfComponents:resultData];
                
               // NSLog(@"components called");

                if ([parsedDictionary objectForKey:@"result"]) {
                    NSArray *arr_ComponentsResponse = [parsedDictionary objectForKey:@"result"];
                    if ([arr_ComponentsResponse count]) {
                        AppDelegate *tempDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                        
                        [tempDelegate.coreDataControlObject removeContextForMaterial:@""];
                        
                        [[DataBase sharedInstance] insertMaterialsToCoreDataFromArray:(NSMutableArray *)arr_ComponentsResponse];
                    }
                }
            }
            
            break;
            
        case GET_LIST_OF_DUE_NOTIFICATIONS:
            
            if (!errorDescription.length) {
                NSMutableDictionary *parsedDictionary = [[Response sharedInstance] parseForListOfDueNotification:resultData];
                
                NSLog(@"Due Notifications called");

                //  if ([parsedDictionary count] == 0) {
                [[DataBase sharedInstance] deleteinsertDataIntoHeader:@"N"];
                // }
                if ([parsedDictionary objectForKey:@"resultHeader"]) {
                    NSMutableDictionary *notificationDetailDictionary = [[NSMutableDictionary alloc] init];
                    
                    id responseObject = [parsedDictionary objectForKey:@"resultHeader"];
                    
                    NSMutableArray *notificatinHeaderArray = [[NSMutableArray alloc] init];
                    
                    NSMutableArray *inspectionResultDataArray = [NSMutableArray new];
                    
                    
                    [notificatinHeaderArray addObjectsFromArray:responseObject];
                    
                    NSDictionary *headerDictionary;
                    NSDateFormatter *dateFormate = [[NSDateFormatter alloc] init];
                    [dateFormate setDateFormat:@"yyyy-MM-dd"];
                    
                    for (int i=0; i<[notificatinHeaderArray count]; i++) {
                        if ([[notificatinHeaderArray objectAtIndex:i] isKindOfClass:[NSDictionary class]]) {
                            headerDictionary = [notificatinHeaderArray objectAtIndex:i];
                            NSMutableDictionary *currentHeaderDictionary = [[NSMutableDictionary alloc] init];
                            if ([headerDictionary objectForKey:@"BreakdownInd"]) {
                                [currentHeaderDictionary setObject:[[headerDictionary objectForKey:@"BreakdownInd"] copy] forKey:@"BREAKDOWN"];
                            }
                            else
                            {
                                [currentHeaderDictionary setObject:@" " forKey:@"BREAKDOWN"];
                            }
                            
                            if ([headerDictionary objectForKey:@"FunctionLoc"]) {
                                
                                [currentHeaderDictionary setObject:[[headerDictionary objectForKey:@"FunctionLoc"] copy] forKey:@"FID"];
                            }
                            else{
                                [currentHeaderDictionary setObject:@"" forKey:@"FID"];
                            }
                            if ([headerDictionary objectForKey:@"Pltxt"]) {
                                
                                [currentHeaderDictionary setObject:[[headerDictionary objectForKey:@"Pltxt"] copy] forKey:@"FNAME"];
                            }
                            else{
                                [currentHeaderDictionary setObject:@"" forKey:@"FNAME"];
                            }
                            
                            if ([headerDictionary objectForKey:@"NotifShorttxt"]) {
                                [currentHeaderDictionary setObject:[[headerDictionary objectForKey:@"NotifShorttxt"] copy] forKey:@"SHORTTEXT"];
                            }
                            else{
                                [currentHeaderDictionary setObject:@"" forKey:@"SHORTTEXT"];
                            }
                            if ([headerDictionary objectForKey:@"NotifType"]) {
                                [currentHeaderDictionary setObject:[[headerDictionary objectForKey:@"NotifType"] copy] forKey:@"NID"];
                            }
                            else{
                                [currentHeaderDictionary setObject:@"" forKey:@"NID"];
                            }
                            
                            if ([headerDictionary objectForKey:@"Qmartx"]) {
                                [currentHeaderDictionary setObject:[[headerDictionary objectForKey:@"Qmartx"] copy] forKey:@"NNAME"];
                            }
                            else{
                                [currentHeaderDictionary setObject:@"" forKey:@"NNAME"];
                            }
                            
                            if ([headerDictionary objectForKey:@"Qmnum"]) {
                                [currentHeaderDictionary setObject:[[headerDictionary objectForKey:@"Qmnum"] copy] forKey:@"OBJECTID"];
                            }
                            else{
                                [currentHeaderDictionary setObject:@"" forKey:@"OBJECTID"];
                            }
                            
                            if ([headerDictionary objectForKey:@"Qmdat"]) {
                                [currentHeaderDictionary setObject:[[headerDictionary objectForKey:@"Qmdat"] copy] forKey:@"QMDAT"];
                            }
                            else{
                                [currentHeaderDictionary setObject:@"" forKey:@"QMDAT"];
                            }
                            
                            [currentHeaderDictionary setObject:@"" forKey:@"REPORTEDBY"];
                            
                            if ([headerDictionary objectForKey:@"ReportedBy"]) {
                                [currentHeaderDictionary setObject:[[headerDictionary objectForKey:@"ReportedBy"] copy] forKey:@"NREPORTEDBY"];
                            }
                            else{
                                
                                [currentHeaderDictionary setObject:@"" forKey:@"NREPORTEDBY"];
                                
                            }
                            
                            if ([headerDictionary objectForKey:@"Equipment"]) {
                                [currentHeaderDictionary setObject:[[headerDictionary objectForKey:@"Equipment"] copy] forKey:@"EQID"];
                            }
                            else{
                                [currentHeaderDictionary setObject:@"" forKey:@"EQID"];
                            }
                            
                            if ([headerDictionary objectForKey:@"Eqktx"]) {
                                [currentHeaderDictionary setObject:[[headerDictionary objectForKey:@"Eqktx"] copy] forKey:@"EQNAME"];
                            }
                            else{
                                [currentHeaderDictionary setObject:@"" forKey:@"EQNAME"];
                            }
                            
                            if ([headerDictionary objectForKey:@"Priority"]) {
                                [currentHeaderDictionary setObject:[[headerDictionary objectForKey:@"Priority"] copy] forKey:@"NPID"];
                            }
                            else{
                                [currentHeaderDictionary setObject:@"" forKey:@"NPID"];
                            }
                            
                            if ([headerDictionary objectForKey:@"Priokx"]) {
                                [currentHeaderDictionary setObject:[[headerDictionary objectForKey:@"Priokx"] copy] forKey:@"NPNAME"];
                            }
                            else{
                                [currentHeaderDictionary setObject:@"" forKey:@"NPNAME"];
                            }
                            
                            if ([headerDictionary objectForKey:@"MalfuncEddate"]) {
                                
                                NSString *malfunctionEndDateString;
                                
                                if (![NullChecker isNull:[headerDictionary objectForKey:@"MalfuncEddate"]]) {
                                    
                                    if ([[headerDictionary objectForKey:@"MalfuncEddate"] rangeOfString:@"Date"].length) {
                                        
                                        malfunctionEndDateString=[NSString stringWithFormat:@"%@",[dateFormate stringFromDate:[NSDate dateWithTimeIntervalSince1970:[[[[headerDictionary objectForKey:@"MalfuncEddate"] stringByReplacingOccurrencesOfString:@"/Date(" withString:@""] stringByReplacingOccurrencesOfString:@")/" withString:@""] doubleValue]/1000.0]]];
                                        
                                    }
                                    else
                                    {
                                        malfunctionEndDateString=[NSString stringWithFormat:@"%@",[headerDictionary objectForKey:@"MalfuncEddate"]];
                                    }
                                }
                                
                                
                                
                                if (malfunctionEndDateString.length) {
                                    
                                    if ([headerDictionary objectForKey:@"MalfuncEdtime"]) {
                                        
                                        [currentHeaderDictionary setObject:[NSString stringWithFormat:@"%@ %@",malfunctionEndDateString,[headerDictionary objectForKey:@"MalfuncEdtime"]] forKey:@"EDATE"];
                                    }
                                    else{
                                        
                                        [currentHeaderDictionary setObject:malfunctionEndDateString forKey:@"EDATE"];
                                    }
                                }
                                
                            }
                            else{
                                [currentHeaderDictionary setObject:@"" forKey:@"EDATE"];
                            }
                            
                            if (![NullChecker isNull:[headerDictionary objectForKey:@"MalfuncStdate"]]) {
                                
                                NSString *malfunctionStartDateString;
                                
                                if ([[headerDictionary objectForKey:@"MalfuncStdate"] rangeOfString:@"Date"].length) {
                                    
                                    malfunctionStartDateString=[NSString stringWithFormat:@"%@",[dateFormate stringFromDate:[NSDate dateWithTimeIntervalSince1970:[[[[headerDictionary objectForKey:@"MalfuncStdate"] stringByReplacingOccurrencesOfString:@"/Date(" withString:@""] stringByReplacingOccurrencesOfString:@")/" withString:@""] doubleValue]/1000.0]]];
                                }
                                else{
                                    
                                    malfunctionStartDateString=[NSString stringWithFormat:@"%@",[headerDictionary objectForKey:@"MalfuncStdate"]];
                                    [currentHeaderDictionary setObject:[NSString stringWithFormat:@"%@",[headerDictionary objectForKey:@"MalfuncStdate"]] forKey:@"SDATE"];
                                }
                                
                                if (malfunctionStartDateString.length) {
                                    
                                    if ([headerDictionary objectForKey:@"MalfuncSttime"]) {
                                        
                                        [currentHeaderDictionary setObject:[NSString stringWithFormat:@"%@ %@",malfunctionStartDateString,[headerDictionary objectForKey:@"MalfuncSttime"]] forKey:@"SDATE"];
                                    }
                                    else{
                                        
                                        [currentHeaderDictionary setObject:malfunctionStartDateString forKey:@"SDATE"];
                                    }
                                }
                                
                            }
                            else{
                                [currentHeaderDictionary setObject:@"" forKey:@"SDATE"];
                            }
                            
                            if ([headerDictionary objectForKey:@"Werks"]) {
                                [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Werks"] forKey:@"PLANTID"];
                                [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Plantname"] forKey:@"PLANTNAME"];
                            }
                            else{
                                [currentHeaderDictionary setObject:@"" forKey:@"PLANTID"];
                                [currentHeaderDictionary setObject:@"" forKey:@"PLANTNAME"];
                            }
                            
                            if ([headerDictionary objectForKey:@"Arbpl"]) {
                                [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Arbpl"] forKey:@"WORKCENTERID"];
                                [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Wkctrname"] forKey:@"WORKCENTERNAME"];
                            }
                            else{
                                [currentHeaderDictionary setObject:@"" forKey:@"WORKCENTERID"];
                                [currentHeaderDictionary setObject:@"" forKey:@"WORKCENTERNAME"];
                            }
                            
                            if ([headerDictionary objectForKey:@"Xstatus"]) {
                                [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Xstatus"] forKey:@"NSTATUS"];
                            }
                            else{
                                
                                [currentHeaderDictionary setObject:@"OSNO" forKey:@"NSTATUS"];
                            }
                            
                            [currentHeaderDictionary setObject:@"" forKey:@"DOCS"];
                            
                            if ([headerDictionary objectForKey:@"Docs"]) {
                                [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Docs"] forKey:@"DOCS"];
                            }
                            
                            [currentHeaderDictionary setObject:@"" forKey:@"RSDATE"];
                            
                            if ([headerDictionary objectForKey:@"Strmn"]) {
                                
                                if ([headerDictionary objectForKey:@"Strur"]) {
                                    
                                    [currentHeaderDictionary setObject:[NSString stringWithFormat:@"%@ %@",[headerDictionary objectForKey:@"Strmn"],[headerDictionary objectForKey:@"Strur"]] forKey:@"RSDATE"];
                                }
                                else{
                                    
                                    [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Strmn"] forKey:@"RSDATE"];
                                }
                                
                                
                                //                                [currentHeaderDictionary setObject:[NSString stringWithFormat:@"%@ %@",[headerDictionary objectForKey:@"Strmn"],[headerDictionary objectForKey:@"Strur"]] forKey:@"RSDATE"];
                            }
                            
                            [currentHeaderDictionary setObject:@"" forKey:@"REDATE"];
                            
                            if ([headerDictionary objectForKey:@"Ltrmn"]) {
                                
                                if ([headerDictionary objectForKey:@"Ltrur"]) {
                                    
                                    [currentHeaderDictionary setObject:[NSString stringWithFormat:@"%@ %@",[headerDictionary objectForKey:@"Ltrmn"],[headerDictionary objectForKey:@"Ltrur"]] forKey:@"REDATE"];
                                }
                                else{
                                    
                                    [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Ltrmn"] forKey:@"REDATE"];
                                    
                                }
                                //                                [currentHeaderDictionary setObject:[NSString stringWithFormat:@"%@ %@",[headerDictionary objectForKey:@"Ltrmn"],[headerDictionary objectForKey:@"Ltrur"]] forKey:@"REDATE"];
                            }
                            
                            
                            if ([headerDictionary objectForKey:@"ParnrVw"]) {
                                [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"ParnrVw"] forKey:@"PARNRID"];
                            }
                            else{
                                
                                [currentHeaderDictionary setObject:@"" forKey:@"PARNRID"];
                            }
                            
                            if ([headerDictionary objectForKey:@"NameVw"]) {
                                [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"NameVw"] forKey:@"PARNRTEXT"];
                            }
                            else{
                                
                                [currentHeaderDictionary setObject:@"" forKey:@"PARNRTEXT"];
                                
                            }
                            
                            if ([headerDictionary objectForKey:@"Ingrp"]) {
                                [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Ingrp"] forKey:@"PLANNERGROUP"];
                            }
                            else{
                                
                                [currentHeaderDictionary setObject:@"" forKey:@"PLANNERGROUP"];
                                
                            }
                            
                            if ([headerDictionary objectForKey:@"Ingrpname"]) {
                                [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Ingrpname"] forKey:@"PLANNERGROUPNAME"];
                            }
                            else{
                                
                                [currentHeaderDictionary setObject:@"" forKey:@"PLANNERGROUPNAME"];
                                
                            }
                            
                            [currentHeaderDictionary setObject:@"" forKey:@"SHIFT"];
                            if ([headerDictionary objectForKey:@"Shift"]) {
                                [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Shift"] forKey:@"SHIFT"];
                            }
                            
                            [currentHeaderDictionary setObject:@"" forKey:@"NOOFPERSON"];
                            if ([headerDictionary objectForKey:@"Noofperson"]) {
                                [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Noofperson"] forKey:@"NOOFPERSON"];
                            }
                            
                            [currentHeaderDictionary setObject:@"" forKey:@"EFFECTID"];
                            if ([headerDictionary objectForKey:@"Auswk"]) {
                                [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Auswk"] forKey:@"EFFECTID"];
                            }
                            
                            [currentHeaderDictionary setObject:@"" forKey:@"EFFECTNAME"];
                            if ([headerDictionary objectForKey:@"Auswkt"]) {
                                [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Auswkt"] forKey:@"EFFECTNAME"];
                            }
                            
                            [currentHeaderDictionary setObject:@"" forKey:@"AUFNR"];
                            if ([headerDictionary objectForKey:@"Aufnr"]) {
                                [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Aufnr"] forKey:@"AUFNR"];
                            }
                            
                            [currentHeaderDictionary setObject:@"" forKey:@"LONGTEXT"];
                            [currentHeaderDictionary setObject:[[DataBase sharedInstance] fetchNameForIDKey:@"OBJECTID" forValue:[currentHeaderDictionary objectForKey:@"OBJECTID"]] forKey:@"ID"];
                            if (![[currentHeaderDictionary objectForKey:@"ID"] length]) {
                                
                            }
                            
                            [currentHeaderDictionary setObject:@"" forKey:@"USR01"];
                            if ([headerDictionary objectForKey:@"Usr01"]) {
                                [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Usr01"] forKey:@"USR01"];
                            }
                            
                            [currentHeaderDictionary setObject:@"" forKey:@"USR02"];
                            if ([headerDictionary objectForKey:@"Usr02"]) {
                                [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Usr02"] forKey:@"USR02"];
                            }
                            
                            
                            [currentHeaderDictionary setObject:@"" forKey:@"NOSYNCLOG"];
                            [currentHeaderDictionary setObject:@"" forKey:@"LATITUDES"];
                            [currentHeaderDictionary setObject:@"" forKey:@"LONGITUDES"];
                            [currentHeaderDictionary setObject:@"" forKey:@"ALTITUDES"];
                            
                            if ([headerDictionary objectForKey:@"EquiHistory"]) {
                                id equipmentHisory = [headerDictionary objectForKey:@"EquiHistory"];
                                if ([equipmentHisory objectForKey:@"item"]) {
                                    equipmentHisory = [equipmentHisory objectForKey:@"item"];
                                    if ([equipmentHisory isKindOfClass:[NSDictionary class]]) {
                                        [currentHeaderDictionary setObject:[NSMutableArray arrayWithObject:equipmentHisory] forKey:@"EQUIPMENTHISTORY"];
                                    }
                                    else if ([equipmentHisory isKindOfClass:[NSArray class]]){
                                        [currentHeaderDictionary setObject:equipmentHisory forKey:@"EQUIPMENTHISTORY"];
                                    }
                                }
                            }
                            
                            if ([headerDictionary objectForKey:@"Fields"]) {
                                NSMutableArray *fieldsMutArray = [NSMutableArray new];
                                NSMutableArray *tempfieldsMutArray = [NSMutableArray new];
                                
                                if ([[[headerDictionary objectForKey:@"Fields"] objectForKey:@"item"] isKindOfClass:[NSDictionary class]]) {
                                    [tempfieldsMutArray addObjectsFromArray:[NSMutableArray arrayWithObject:[[headerDictionary objectForKey:@"Fields"] objectForKey:@"item"]]];
                                }
                                else if ([[[headerDictionary objectForKey:@"Fields"] objectForKey:@"item"] isKindOfClass:[NSArray class]]) {
                                    [tempfieldsMutArray addObjectsFromArray:[[headerDictionary objectForKey:@"Fields"] objectForKey:@"item"]];
                                }
                                
                                //                                NSArray *fieldsArray = [[headerDictionary objectForKey:@"Fields"] objectForKey:@"item"];
                                for (int i =0; i<[tempfieldsMutArray count]; i++) {
                                    NSString *fieldValue,*fieldName,*fLabel,*tabName,*dataType,*sequence,*length;
                                    if ([NullChecker isNull:[[tempfieldsMutArray objectAtIndex:i] objectForKey:@"Fieldname"]]) {
                                        fieldName = @"";
                                    }
                                    else{
                                        fieldName = [[tempfieldsMutArray objectAtIndex:i] objectForKey:@"Fieldname"];
                                    }
                                    
                                    if ([NullChecker isNull:[[tempfieldsMutArray objectAtIndex:i] objectForKey:@"Flabel"]]) {
                                        fLabel = @"";
                                    }
                                    else{
                                        fLabel = [[tempfieldsMutArray objectAtIndex:i] objectForKey:@"Flabel"];
                                    }
                                    
                                    if ([NullChecker isNull:[[tempfieldsMutArray objectAtIndex:i] objectForKey:@"Tabname"]]) {
                                        tabName = @"";
                                    }
                                    else{
                                        tabName = [[tempfieldsMutArray objectAtIndex:i] objectForKey:@"Tabname"];
                                    }
                                    
                                    if ([NullChecker isNull:[[tempfieldsMutArray objectAtIndex:i] objectForKey:@"Value"]]) {
                                        fieldValue = @"";
                                    }
                                    else{
                                        fieldValue = [[tempfieldsMutArray objectAtIndex:i] objectForKey:@"Value"];
                                    }
                                    
                                    if ([NullChecker isNull:[[tempfieldsMutArray objectAtIndex:i] objectForKey:@"Datatype"]]) {
                                        dataType = @"";
                                    }
                                    else{
                                        dataType = [[tempfieldsMutArray objectAtIndex:i] objectForKey:@"Datatype"];
                                    }
                                    
                                    if ([NullChecker isNull:[[tempfieldsMutArray objectAtIndex:i] objectForKey:@"Sequence"]]) {
                                        sequence = @"";
                                    }
                                    else{
                                        sequence = [[tempfieldsMutArray objectAtIndex:i] objectForKey:@"Sequence"];
                                    }
                                    
                                    if ([NullChecker isNull:[[tempfieldsMutArray objectAtIndex:i] objectForKey:@"Length"]]) {
                                        length = @"";
                                    }
                                    else{
                                        length = [[tempfieldsMutArray objectAtIndex:i] objectForKey:@"Length"];
                                    }
                                    
                                    
                                    [fieldsMutArray addObject:[NSMutableArray arrayWithObjects:@"W",@"WH",tabName,fieldName,fieldValue,fLabel,dataType,sequence,length, nil]];
                                }
                                
                                [currentHeaderDictionary setObject:fieldsMutArray forKey:@"CFH"];
                            }
                            
                            [notificationDetailDictionary setObject:[NSMutableArray arrayWithObjects:currentHeaderDictionary,[NSMutableArray array],[NSMutableArray array],[NSMutableArray array],[NSMutableArray array],[NSMutableArray array], nil] forKey:[currentHeaderDictionary objectForKey:@"OBJECTID"]];
                        }
                    }
                    
                    [notificatinHeaderArray removeAllObjects];
                    
                    //    resultInspection
                    // resultActivities
                    
                    responseObject = nil;
                    
                    responseObject = [parsedDictionary objectForKey:@"resultInspection"];
                    
                    
                    for (int i = 0; i<[responseObject  count]; i++) {
                        NSDictionary *inspectionresultDictionary;
                        
                        NSMutableArray *resultInpectionsDataArray = [NSMutableArray new];
                        
                        inspectionresultDictionary = [responseObject  objectAtIndex:i];
                        if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Qmnum"]]) {
                            [resultInpectionsDataArray addObject:@""];
                        }
                        else{
                            [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Qmnum"]];
                        }
                        
                        if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Aufnr"]]) {
                            [resultInpectionsDataArray addObject:@""];
                        }
                        else{
                            
                            [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Aufnr"]];
                        }
                        
                        if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Vornr"]]) {
                            [resultInpectionsDataArray addObject:@""];
                        }
                        else{
                            [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Vornr"]];
                        }
                        
                        if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Equnr"]]) {
                            [resultInpectionsDataArray addObject:@""];
                        }
                        else{
                            [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Equnr"]];
                        }
                        
                        if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Mdocm"]]) {
                            [resultInpectionsDataArray addObject:@""];
                        }
                        else{
                            [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Mdocm"]];
                        }
                        
                        if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Point"]]) {
                            [resultInpectionsDataArray addObject:@""];
                        }
                        else{
                            [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Point"]];
                        }
                        
                        if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Mpobj"]]) {
                            [resultInpectionsDataArray addObject:@""];
                        }
                        else{
                            [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Mpobj"]];
                        }
                        
                        if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Mpobt"]]) {
                            [resultInpectionsDataArray addObject:@""];
                        }
                        else{
                            [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Mpobt"]];
                        }
                        
                        if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Psort"]]) {
                            [resultInpectionsDataArray addObject:@""];
                        }
                        else{
                            [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Psort"]];
                        }
                        
                        if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Pttxt"]]) {
                            [resultInpectionsDataArray addObject:@""];
                        }
                        else{
                            [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Pttxt"]];
                        }
                        
                        if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Atinn"]]) {
                            [resultInpectionsDataArray addObject:@""];
                        }
                        else{
                            [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Atinn"]];
                        }
                        
                        if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Idate"]]) {
                            [resultInpectionsDataArray addObject:@""];
                        }
                        else{
                            [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Idate"]];
                        }
                        
                        if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Itime"]]) {
                            [resultInpectionsDataArray addObject:@""];
                        }
                        else{
                            [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Itime"]];
                        }
                        
                        if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Mdtxt"]]) {
                            [resultInpectionsDataArray addObject:@""];
                        }
                        else{
                            [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Mdtxt"]];
                        }
                        
                        if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Readr"]]) {
                            [resultInpectionsDataArray addObject:@""];
                        }
                        else{
                            [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Readr"]];
                        }
                        
                        
                        if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Atbez"]]) {
                            [resultInpectionsDataArray addObject:@""];
                        }
                        else{
                            [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Atbez"]];
                        }
                        
                        if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Msehi"]]) {
                            [resultInpectionsDataArray addObject:@""];
                        }
                        else{
                            [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Msehi"]];
                        }
                        
                        
                        if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Msehl"]]) {
                            [resultInpectionsDataArray addObject:@""];
                        }
                        else{
                            [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Msehl"]];
                        }
                        
                        
                        if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Readc"]]) {
                            [resultInpectionsDataArray addObject:@""];
                        }
                        else{
                            [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Readc"]];
                        }
                        
                        if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Desic"]]) {
                            [resultInpectionsDataArray addObject:@""];
                        }
                        else{
                            [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Desic"]];
                        }
                        
                        if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Prest"]]) {
                            [resultInpectionsDataArray addObject:@""];
                        }
                        else{
                            [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Prest"]];
                        }
                        
                        
                        if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Docaf"]]) {
                            [resultInpectionsDataArray addObject:@""];
                        }
                        else{
                            [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Docaf"]];
                        }
                        
                        if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Codct"]]) {
                            [resultInpectionsDataArray addObject:@""];
                        }
                        else{
                            [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Codct"]];
                        }
                        
                        if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Codgr"]]) {
                            [resultInpectionsDataArray addObject:@""];
                        }
                        else{
                            [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Codgr"]];
                        }
                        
                        if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Vlcod"]]) {
                            [resultInpectionsDataArray addObject:@""];
                        }
                        else{
                            [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Vlcod"]];
                        }
                        
                        if ([NullChecker isNull:[inspectionresultDictionary objectForKey:@"Action"]]) {
                            [resultInpectionsDataArray addObject:@""];
                        }
                        else{
                            [resultInpectionsDataArray addObject:[inspectionresultDictionary objectForKey:@"Action"]];
                        }
                        
                        [inspectionResultDataArray addObject:resultInpectionsDataArray];
                    }
                    
                    
                    responseObject = nil;
                    NSMutableArray *notificationDocs = [[NSMutableArray alloc] init];
                    
                    if ([parsedDictionary objectForKey:@"resultDocs"]) {
                        responseObject = [parsedDictionary objectForKey:@"resultDocs"];
                        [notificationDocs addObjectsFromArray:responseObject];
                        
                        NSDictionary *DocsDictionary;
                        for (int i =0; i<[notificationDocs count]; i++) {
                            if ([[notificationDocs objectAtIndex:i] isKindOfClass:[NSDictionary class]]) {
                                DocsDictionary = [notificationDocs objectAtIndex:i];
                                if ([notificationDetailDictionary objectForKey:[NSString stringWithFormat:@"%lld",[[DocsDictionary objectForKey:@"Zobjid"] longLongValue]]]) {
                                    NSMutableArray *Docs = [NSMutableArray array];
                                    [Docs addObject:@""];
                                    if ([DocsDictionary objectForKey:@"DocId"]) {
                                        [Docs addObject:[[DocsDictionary objectForKey:@"DocId"] copy]];
                                    }
                                    else{
                                        [Docs addObject:@""];
                                    }
                                    
                                    if ([DocsDictionary objectForKey:@"DocType"]) {
                                        [Docs addObject:[[DocsDictionary objectForKey:@"DocType"] copy]];
                                    }
                                    else{
                                        [Docs addObject:@""];
                                    }
                                    
                                    if ([DocsDictionary objectForKey:@"Filename"]) {
                                        [Docs addObject:[[DocsDictionary objectForKey:@"Filename"] copy]];
                                    }
                                    else{
                                        [Docs addObject:@""];
                                    }
                                    
                                    if ([DocsDictionary objectForKey:@"Filetype"]) {
                                        [Docs addObject:[[DocsDictionary objectForKey:@"Filetype"] copy]];
                                    }
                                    else{
                                        [Docs addObject:@""];
                                    }
                                    
                                    if ([DocsDictionary objectForKey:@"Fsize"]) {
                                        [Docs addObject:[[DocsDictionary objectForKey:@"Fsize"] copy]];
                                    }
                                    else{
                                        [Docs addObject:@""];
                                    }
                                    
                                    if ([DocsDictionary objectForKey:@"Objtype"]) {
                                        [Docs addObject:[[DocsDictionary objectForKey:@"Objtype"] copy]];
                                    }
                                    else{
                                        
                                        [Docs addObject:@""];
                                    }
                                    
                                    if ([DocsDictionary objectForKey:@"Content"]) {
                                        [Docs addObject:[[DocsDictionary objectForKey:@"Content"] copy]];
                                    }
                                    else{
                                        
                                        [Docs addObject:@""];

                                    }
                                    
                                    [Docs addObject:@""];//Action
                                    
                                    [[[notificationDetailDictionary objectForKey:[DocsDictionary objectForKey:@"Zobjid"]] objectAtIndex:1] addObject:Docs];
                                }
                            }
                        }
                    }
                    
                    responseObject = nil;
                    NSMutableArray *notificationTransactionArray = [[NSMutableArray alloc] init];
                    
                    if ([parsedDictionary objectForKey:@"resultTransactions"]) {
                        responseObject = [parsedDictionary objectForKey:@"resultTransactions"];
                        
                        [notificationTransactionArray addObjectsFromArray:responseObject];
                        
                        NSDictionary *transactionDictionary;
                        
                        for (int i=0; i<[notificationTransactionArray count]; i++) {
                            if ([[notificationTransactionArray objectAtIndex:i] isKindOfClass:[NSDictionary class]]) {
                                transactionDictionary = [notificationTransactionArray objectAtIndex:i];
                                if ([notificationDetailDictionary objectForKey:[transactionDictionary objectForKey:@"Qmnum"]]) {
                                    NSMutableArray *transactions = [NSMutableArray array];
                                    
                                    [transactions addObject:@""];
                                    [transactions addObject:@""];
                                    if ([transactionDictionary objectForKey:@"ItemdefectGrp"]) {
                                        [transactions addObject:[[transactionDictionary objectForKey:@"ItemdefectGrp"] copy]];
                                    }
                                    else{
                                        [transactions addObject:@""];
                                    }
                                    
                                    if ([transactionDictionary objectForKey:@"Defectgrptext"]) {
                                        [transactions addObject:[[transactionDictionary objectForKey:@"Defectgrptext"] copy]];
                                    }
                                    else{
                                        [transactions addObject:@""];
                                    }
                                    
                                    if ([transactionDictionary objectForKey:@"ItemdefectCod"]) {
                                        [transactions addObject:[[transactionDictionary objectForKey:@"ItemdefectCod"] copy]];
                                    }
                                    else{
                                        [transactions addObject:@""];
                                    }
                                    
                                    if ([transactionDictionary objectForKey:@"Defectcodetext"]) {
                                        [transactions addObject:[[transactionDictionary objectForKey:@"Defectcodetext"] copy]];
                                    }
                                    else{
                                        [transactions addObject:@""];
                                        
                                    }
                                    
                                    if ([transactionDictionary objectForKey:@"CauseGrp"]) {
                                        [transactions addObject:[[transactionDictionary objectForKey:@"CauseGrp"] copy]];
                                    }
                                    else{
                                        [transactions addObject:@""];
                                    }
                                    
                                    if ([transactionDictionary objectForKey:@"Causegrptext"]) {
                                        [transactions addObject:[[transactionDictionary objectForKey:@"Causegrptext"] copy]];
                                    }
                                    else{
                                        [transactions addObject:@""];
                                    }
                                    
                                    if ([transactionDictionary objectForKey:@"CauseCod"]) {
                                        [transactions addObject:[[transactionDictionary objectForKey:@"CauseCod"] copy]];
                                    }
                                    else{
                                        [transactions addObject:@""];
                                    }
                                    
                                    if ([transactionDictionary objectForKey:@"Causecodetext"]) {
                                        [transactions addObject:[[transactionDictionary objectForKey:@"Causecodetext"] copy]];
                                    }
                                    else{
                                        [transactions addObject:@""];
                                    }
                                    
                                    if ([transactionDictionary objectForKey:@"ItemdefectShtxt"]) {
                                        [transactions addObject:[[transactionDictionary objectForKey:@"ItemdefectShtxt"] copy]];
                                    }
                                    else{
                                        [transactions addObject:@""];
                                    }
                                    if ([transactionDictionary objectForKey:@"CauseShtxt"]) {
                                        [transactions addObject:[[transactionDictionary objectForKey:@"CauseShtxt"] copy]];
                                    }
                                    else{
                                        [transactions addObject:@""];
                                    }
                                    
                                    if ([transactionDictionary objectForKey:@"ItemKey"]) {
                                        [transactions addObject:[[transactionDictionary objectForKey:@"ItemKey"] copy]];
                                    }
                                    else{
                                        [transactions addObject:@""];
                                    }
                                    
                                    if ([transactionDictionary objectForKey:@"CauseKey"]) {
                                        [transactions addObject:[[transactionDictionary objectForKey:@"CauseKey"] copy]];
                                    }
                                    else{
                                        [transactions addObject:@""];
                                    }
                                    
                                    [transactions addObject:@""];//Component Status
                                    [transactions addObject:@""];//Item Status
                                    
                                    if ([transactionDictionary objectForKey:@"ItempartGrp"]) {
                                        [transactions addObject:[transactionDictionary objectForKey:@"ItempartGrp"]];
                                    }
                                    else{
                                        
                                        [transactions addObject:@""];//objectPartGroupid
                                    }
                                    
                                    if ([transactionDictionary objectForKey:@"ItempartCod"]) {
                                        [transactions addObject:[transactionDictionary objectForKey:@"ItempartCod"]];
                                    }
                                    else{
                                        
                                        [transactions addObject:@""];//ObjectPartid
                                    }
                                    
                                    if ([transactionDictionary objectForKey:@"Partgrptext"]) {
                                        [transactions addObject:[transactionDictionary objectForKey:@"Partgrptext"]];
                                    }
                                    else{
                                        
                                        [transactions addObject:@""];//objectPartGrouptext
                                    }
                                    
                                    if ([transactionDictionary objectForKey:@"Partcodetext"])
                                    {
                                        [transactions addObject:[transactionDictionary objectForKey:@"Partcodetext"]];
                                    }
                                    else{
                                        
                                        [transactions addObject:@""];//ObjectParttext
                                    }
                                    
                                    id customFieldsDamageTransactionsID,customFieldsCauseTransactionsID;
                                    if ([transactionDictionary objectForKey:@"Fields"]) {
                                        NSArray *fieldsArray = [[transactionDictionary objectForKey:@"Fields"] objectForKey:@"item"];
                                        NSMutableArray *transactionsDamageCustomFields = [NSMutableArray array];
                                        NSMutableArray *transactionsCauseCustomFields = [NSMutableArray array];
                                        for (int i =0; i<[fieldsArray count]; i++) {
                                            NSString *fieldValue,*fieldName,*fLabel,*tabName,*docType,*docTypeItem,*dataType,*sequence,*length;
                                            if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Fieldname"]]) {
                                                fieldName = @"";
                                            }
                                            else{
                                                fieldName = [[fieldsArray objectAtIndex:i] objectForKey:@"Fieldname"];
                                            }
                                            
                                            if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Flabel"]]) {
                                                fLabel = @"";
                                            }
                                            else{
                                                fLabel = [[fieldsArray objectAtIndex:i] objectForKey:@"Flabel"];
                                            }
                                            
                                            if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Tabname"]]) {
                                                tabName = @"";
                                            }
                                            else{
                                                tabName = [[fieldsArray objectAtIndex:i] objectForKey:@"Tabname"];
                                            }
                                            
                                            if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Value"]]) {
                                                fieldValue = @"";
                                            }
                                            else{
                                                fieldValue = [[fieldsArray objectAtIndex:i] objectForKey:@"Value"];
                                            }
                                            
                                            if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Zdoctype"]]) {
                                                docType = @"";
                                            }
                                            else{
                                                docType = [[fieldsArray objectAtIndex:i] objectForKey:@"Zdoctype"];
                                            }
                                            
                                            if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"ZdoctypeItem"]]) {
                                                docTypeItem = @"";
                                            }
                                            else{
                                                docTypeItem = [[fieldsArray objectAtIndex:i] objectForKey:@"ZdoctypeItem"];
                                            }
                                            
                                            
                                            if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Datatype"]]) {
                                                dataType = @"";
                                            }
                                            else{
                                                dataType = [[fieldsArray objectAtIndex:i] objectForKey:@"Datatype"];
                                            }
                                            
                                            if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Sequence"]]) {
                                                sequence = @"";
                                            }
                                            else{
                                                sequence = [[fieldsArray objectAtIndex:i] objectForKey:@"Sequence"];
                                            }
                                            
                                            if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Length"]]) {
                                                length = @"";
                                            }
                                            else{
                                                length = [[fieldsArray objectAtIndex:i] objectForKey:@"Length"];
                                            }
                                            
                                            if ([docTypeItem isEqualToString:@"QI"]) {
                                                [transactionsDamageCustomFields addObject:[NSMutableArray arrayWithObjects:docType,docTypeItem,tabName,fieldName,fieldValue,fLabel,dataType,sequence,length, nil]];
                                            }
                                            else if ([docTypeItem isEqualToString:@"QC"]){
                                                [transactionsCauseCustomFields addObject:[NSMutableArray arrayWithObjects:docType,docTypeItem,tabName,fieldName,fieldValue,fLabel,dataType,sequence,length, nil]];
                                            }
                                        }
                                        
                                        customFieldsDamageTransactionsID = transactionsDamageCustomFields;
                                        customFieldsCauseTransactionsID = transactionsCauseCustomFields;
                                    }
                                    
                                    [[[notificationDetailDictionary objectForKey:[transactionDictionary objectForKey:@"Qmnum"]] objectAtIndex:2] addObject:[NSArray arrayWithObjects:transactions,customFieldsDamageTransactionsID,customFieldsCauseTransactionsID, nil]];
                                }
                            }
                        }
                        
                        [notificationTransactionArray removeAllObjects];
                    }
                    
                    
                    responseObject = nil;
                    NSMutableArray *notificationActivitiesArray = [[NSMutableArray alloc] init];
                    
                    if ([parsedDictionary objectForKey:@"resultActivities"]) {
                        responseObject = [parsedDictionary objectForKey:@"resultActivities"];
                        
                        [notificationActivitiesArray addObjectsFromArray:responseObject];
                        
                        NSDictionary *activitiesDictionary;
                        
                        for (int i=0; i<[notificationActivitiesArray count]; i++) {
                            
                            if ([[notificationActivitiesArray objectAtIndex:i] isKindOfClass:[NSDictionary class]]) {
                                
                                activitiesDictionary = [notificationActivitiesArray objectAtIndex:i];
                                
                                if ([notificationDetailDictionary objectForKey:[NSString stringWithFormat:@"%lli",[[activitiesDictionary objectForKey:@"Qmnum"] longLongValue]]]) {
                                    
                                    NSMutableDictionary *resulActivityDictionary=[NSMutableDictionary new];
                                    
                                    [resulActivityDictionary setObject:@"" forKey:@"notificationa_id"];
                                    
                                    [resulActivityDictionary setObject:@"" forKey:@"notificationa_header_id"];
                                    
                                    
                                    if ([activitiesDictionary objectForKey:@"Actcodetext"]) {
                                        
                                        [resulActivityDictionary setObject:[[activitiesDictionary objectForKey:@"Actcodetext"] copy] forKey:@"notificationa_Actcodetext"];
                                        
                                    }
                                    else{
                                        
                                        [resulActivityDictionary setObject:@"" forKey:@"notificationa_Actgrptext"];
                                        
                                    }
                                    
                                    if ([activitiesDictionary objectForKey:@"Actgrptext"]) {
                                        
                                        [resulActivityDictionary setObject:[[activitiesDictionary objectForKey:@"Actgrptext"] copy] forKey:@"notificationa_Actgrptext"];
                                        
                                    }
                                    else{
                                        
                                        [resulActivityDictionary setObject:@"" forKey:@"notificationa_Actgrptext"];
                                        
                                    }
                                    
                                    if ([activitiesDictionary objectForKey:@"Action"]) {
                                        
                                        [resulActivityDictionary setObject:[activitiesDictionary objectForKey:@"Action"] forKey:@"notificationa_Action"];
                                        
                                    }
                                    else{
                                        
                                        [resulActivityDictionary setObject:@"" forKey:@"notificationa_Action"];
                                        
                                    }
                                    
                                    if ([activitiesDictionary objectForKey:@"ActvCod"]) {
                                        
                                        [resulActivityDictionary setObject:[activitiesDictionary objectForKey:@"ActvCod"] forKey:@"notificationa_ActvCod"];
                                        
                                        
                                    }
                                    else{
                                        
                                        [resulActivityDictionary setObject:@"" forKey:@"notificationa_ActvCod"];
                                        
                                    }
                                    
                                    if ([activitiesDictionary objectForKey:@"ActvGrp"]) {
                                        
                                        [resulActivityDictionary setObject:[[activitiesDictionary objectForKey:@"ActvGrp"] copy] forKey:@"notificationa_ActvGrp"];
                                        
                                    }
                                    else{
                                        
                                        [resulActivityDictionary setObject:@"" forKey:@"notificationa_ActvGrp"];
                                    }
                                    
                                    if ([activitiesDictionary objectForKey:@"ActvKey"]) {
                                        
                                        [resulActivityDictionary setObject:[[activitiesDictionary objectForKey:@"ActvKey"] copy] forKey:@"notificationa_ActvKey"];
                                        
                                    }
                                    else{
                                        
                                        [resulActivityDictionary setObject:@"" forKey:@"notificationa_ActvKey"];
                                        
                                    }
                                    
                                    if ([activitiesDictionary objectForKey:@"ActvShtxt"]) {
                                        
                                        [resulActivityDictionary setObject:[[activitiesDictionary objectForKey:@"ActvShtxt"] copy] forKey:@"notificationa_ActvShtxt"];
                                        
                                    }
                                    else{
                                        
                                        [resulActivityDictionary setObject:@"" forKey:@"notificationa_ActvShtxt"];
                                    }
                                    
                                    if ([activitiesDictionary objectForKey:@"CauseKey"]) {
                                        [resulActivityDictionary setObject:[[activitiesDictionary objectForKey:@"CauseKey"] copy] forKey:@"notificationa_CauseKey"];
                                    }
                                    else{
                                        [resulActivityDictionary setObject:@"" forKey:@"notificationa_CauseKey"];
                                    }
                                    
                                    if ([activitiesDictionary objectForKey:@"Defectcodetext"]) {
                                        
                                        [resulActivityDictionary setObject:[[activitiesDictionary objectForKey:@"Defectcodetext"] copy] forKey:@"notificationa_Defectcodetext"];
                                        
                                    }
                                    else{
                                        [resulActivityDictionary setObject:@"" forKey:@"notificationa_Defectcodetext"];
                                    }
                                    
                                    if ([activitiesDictionary objectForKey:@"Defectgrptext"]) {
                                        
                                        [resulActivityDictionary setObject:[[activitiesDictionary objectForKey:@"Defectgrptext"] copy] forKey:@"notificationa_Defectgrptext"];
                                    }
                                    else{
                                        
                                        [resulActivityDictionary setObject:@"" forKey:@"notificationa_Defectgrptext"];
                                        
                                    }
                                    
                                    if ([activitiesDictionary objectForKey:@"ItemKey"]) {
                                        
                                        [resulActivityDictionary setObject:[[activitiesDictionary objectForKey:@"ItemKey"] copy] forKey:@"notificationa_ItemKey"];
                                        
                                    }
                                    else{
                                        
                                        [resulActivityDictionary setObject:[[activitiesDictionary objectForKey:@"ItemKey"] copy] forKey:@"notificationa_ItemdefectCod"];
                                        
                                    }
                                    
                                    if ([activitiesDictionary objectForKey:@"ItemdefectCod"]) {
                                        
                                        [resulActivityDictionary setObject:[[activitiesDictionary objectForKey:@"ItemdefectCod"] copy] forKey:@"notificationa_ItemdefectCod"];
                                    }
                                    else{
                                        [resulActivityDictionary setObject:@"" forKey:@"notificationa_ItemdefectCod"];
                                    }
                                    
                                    
                                    if ([activitiesDictionary objectForKey:@"ItemdefectGrp"]) {
                                        [resulActivityDictionary setObject:[[activitiesDictionary objectForKey:@"ItemdefectGrp"] copy] forKey:@"notificationa_ItemdefectGrp"];
                                    }
                                    else{
                                        
                                        [resulActivityDictionary setObject:@"" forKey:@"notificationa_ItemdefectGrp"];
                                        
                                    }
                                    
                                    if ([activitiesDictionary objectForKey:@"ItemdefectShtxt"]) {
                                        
                                        [resulActivityDictionary setObject:[[activitiesDictionary objectForKey:@"ItemdefectShtxt"] copy] forKey:@"notificationa_ItemdefectShtxt"];
                                        
                                    }
                                    else{
                                        
                                        [resulActivityDictionary setObject:@"" forKey:@"notificationa_ItemdefectShtxt"];
                                        
                                    }
                                    
                                    if ([activitiesDictionary objectForKey:@"ItempartCod"]) {
                                        
                                        [resulActivityDictionary setObject:[[activitiesDictionary objectForKey:@"ItempartCod"] copy] forKey:@"notificationa_ItempartCod"];
                                        
                                    }
                                    else{
                                        
                                        [resulActivityDictionary setObject:@"" forKey:@"notificationa_ItempartCod"];
                                        
                                    }
                                    
                                    if ([activitiesDictionary objectForKey:@"ItempartGrp"])
                                    {
                                        
                                        [resulActivityDictionary setObject:[[activitiesDictionary objectForKey:@"ItempartGrp"] copy] forKey:@"notificationa_ItempartGrp"];
                                        
                                    }
                                    else{
                                        
                                        [resulActivityDictionary setObject:@"" forKey:@"notificationa_ItempartGrp"];
                                        
                                    }
                                    
                                    if ([activitiesDictionary objectForKey:@"Partcodetext"])
                                    {
                                        [resulActivityDictionary setObject:[[activitiesDictionary objectForKey:@"Partcodetext"] copy] forKey:@"notificationa_Partcodetext"];
                                        
                                    }
                                    else{
                                        
                                        [resulActivityDictionary setObject:@"" forKey:@"notificationa_Partcodetext"];
                                        
                                    }
                                    
                                    if ([activitiesDictionary objectForKey:@"Partgrptext"])
                                    {
                                        
                                        [resulActivityDictionary setObject:[[activitiesDictionary objectForKey:@"Partgrptext"] copy] forKey:@"notificationa_Partgrptext"];
                                        
                                    }
                                    else{
                                        
                                        [resulActivityDictionary setObject:@"" forKey:@"notificationa_Partgrptext"];
                                        
                                    }
                                    
                                    if ([activitiesDictionary objectForKey:@"Qmnum"])
                                    {
                                        [resulActivityDictionary setObject:[[activitiesDictionary objectForKey:@"Qmnum"] copy] forKey:@"Qmnum"];
                                        
                                    }
                                    else{
                                        
                                        [resulActivityDictionary setObject:@"" forKey:@"Qmnum"];
                                        
                                    }
                                    
                                    if ([activitiesDictionary objectForKey:@"Usr01"])
                                    {
                                        [resulActivityDictionary setObject:[[activitiesDictionary objectForKey:@"Usr01"] copy] forKey:@"Qmnum"];
                                    }
                                    else{
                                        
                                        [resulActivityDictionary setObject:@"" forKey:@"Usr01"];
                                        
                                    }
                                    
                                    if ([activitiesDictionary objectForKey:@"Usr02"])
                                    {
                                        
                                        [resulActivityDictionary setObject:[[activitiesDictionary objectForKey:@"Usr02"] copy] forKey:@"Usr02"];
                                        
                                    }
                                    else{
                                        
                                        [resulActivityDictionary setObject:@"" forKey:@"Usr02"];
                                        
                                    }
                                    
                                    if ([activitiesDictionary objectForKey:@"Usr03"])
                                    {
                                        
                                        [resulActivityDictionary setObject:[[activitiesDictionary objectForKey:@"Usr03"] copy] forKey:@"Usr03"];
                                        
                                    }
                                    else{
                                        
                                        [resulActivityDictionary setObject:@"" forKey:@"Usr03"];
                                        
                                    }
                                    
                                    if ([activitiesDictionary objectForKey:@"Usr04"])
                                    {
                                        
                                        [resulActivityDictionary setObject:[[activitiesDictionary objectForKey:@"Usr04"] copy] forKey:@"Usr04"];
                                        
                                    }
                                    else{
                                        
                                        [resulActivityDictionary setObject:@"" forKey:@"Usr04"];
                                        
                                    }
                                    
                                    if ([activitiesDictionary objectForKey:@"Usr05"])
                                    {
                                        [resulActivityDictionary setObject:[[activitiesDictionary objectForKey:@"Usr05"] copy] forKey:@"Usr05"];
                                    }
                                    else{
                                        
                                        [resulActivityDictionary setObject:@"" forKey:@"Usr05"];
                                        
                                    }
                                    
                                    id customFieldsDamageTransactionsID,customFieldsCauseTransactionsID;
                                    
                                    if ([activitiesDictionary objectForKey:@"Fields"]) {
                                        NSArray *fieldsArray = [[activitiesDictionary objectForKey:@"Fields"] objectForKey:@"item"];
                                        NSMutableArray *transactionsDamageCustomFields = [NSMutableArray array];
                                        NSMutableArray *transactionsCauseCustomFields = [NSMutableArray array];
                                        for (int i =0; i<[fieldsArray count]; i++) {
                                            NSString *fieldValue,*fieldName,*fLabel,*tabName,*docType,*docTypeItem,*dataType,*sequence,*length;
                                            if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Fieldname"]]) {
                                                fieldName = @"";
                                            }
                                            else{
                                                fieldName = [[fieldsArray objectAtIndex:i] objectForKey:@"Fieldname"];
                                            }
                                            
                                            if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Flabel"]]) {
                                                fLabel = @"";
                                            }
                                            else{
                                                fLabel = [[fieldsArray objectAtIndex:i] objectForKey:@"Flabel"];
                                            }
                                            
                                            if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Tabname"]]) {
                                                tabName = @"";
                                            }
                                            else{
                                                tabName = [[fieldsArray objectAtIndex:i] objectForKey:@"Tabname"];
                                            }
                                            
                                            if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Value"]]) {
                                                fieldValue = @"";
                                            }
                                            else{
                                                fieldValue = [[fieldsArray objectAtIndex:i] objectForKey:@"Value"];
                                            }
                                            
                                            if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Zdoctype"]]) {
                                                docType = @"";
                                            }
                                            else{
                                                docType = [[fieldsArray objectAtIndex:i] objectForKey:@"Zdoctype"];
                                            }
                                            
                                            if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"ZdoctypeItem"]]) {
                                                docTypeItem = @"";
                                            }
                                            else{
                                                docTypeItem = [[fieldsArray objectAtIndex:i] objectForKey:@"ZdoctypeItem"];
                                            }
                                            
                                            
                                            if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Datatype"]]) {
                                                dataType = @"";
                                            }
                                            else{
                                                dataType = [[fieldsArray objectAtIndex:i] objectForKey:@"Datatype"];
                                            }
                                            
                                            if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Sequence"]]) {
                                                sequence = @"";
                                            }
                                            else{
                                                sequence = [[fieldsArray objectAtIndex:i] objectForKey:@"Sequence"];
                                            }
                                            
                                            if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Length"]]) {
                                                length = @"";
                                            }
                                            else{
                                                length = [[fieldsArray objectAtIndex:i] objectForKey:@"Length"];
                                            }
                                            
                                            if ([docTypeItem isEqualToString:@"QI"]) {
                                                [transactionsDamageCustomFields addObject:[NSMutableArray arrayWithObjects:docType,docTypeItem,tabName,fieldName,fieldValue,fLabel,dataType,sequence,length, nil]];
                                            }
                                            else if ([docTypeItem isEqualToString:@"QC"]){
                                                [transactionsCauseCustomFields addObject:[NSMutableArray arrayWithObjects:docType,docTypeItem,tabName,fieldName,fieldValue,fLabel,dataType,sequence,length, nil]];
                                            }
                                        }
                                        
                                        customFieldsDamageTransactionsID = transactionsDamageCustomFields;
                                        customFieldsCauseTransactionsID = transactionsCauseCustomFields;
                                    }
                                    
                                    [[[notificationDetailDictionary objectForKey:[NSString stringWithFormat:@"%lli",[[activitiesDictionary objectForKey:@"Qmnum"] longLongValue]]] objectAtIndex:3] addObject:[NSArray arrayWithObjects:resulActivityDictionary,[NSMutableArray array],[NSMutableArray array], nil]];
                                    
                                }
                            }
                        }
                        
                        [notificationActivitiesArray removeAllObjects];
                    }
                    
                    responseObject = nil;
                    NSMutableArray *notificationTasksArray = [[NSMutableArray alloc] init];
                    
                    if ([parsedDictionary objectForKey:@"resultTasks"]) {
                        
                        responseObject = [parsedDictionary objectForKey:@"resultTasks"];
                        
                        [notificationTasksArray addObjectsFromArray:responseObject];
                        
                        NSDictionary *tasksDictionary;
                        
                        for (int i=0; i<[notificationTasksArray count]; i++) {
                            
                            if ([[notificationTasksArray objectAtIndex:i] isKindOfClass:[NSDictionary class]]) {
                                tasksDictionary = [notificationTasksArray objectAtIndex:i];
                                if ([notificationDetailDictionary objectForKey:[NSString stringWithFormat:@"%lli",[[tasksDictionary objectForKey:@"Qmnum"] longLongValue]]]) {
                                    
                                    NSMutableArray *tasks = [NSMutableArray array];
                                    
                                    [tasks addObject:@""];
                                    [tasks addObject:@""];
                                    
                                    if ([tasksDictionary objectForKey:@"TaskKey"]) {
                                        [tasks addObject:[[tasksDictionary objectForKey:@"TaskKey"] copy]];
                                    }
                                    else{
                                        [tasks addObject:@""];
                                    }
                                    
                                    if ([tasksDictionary objectForKey:@"TaskGrp"]) {
                                        [tasks addObject:[[tasksDictionary objectForKey:@"TaskGrp"] copy]];
                                    }
                                    else{
                                        [tasks addObject:@""];
                                    }
                                    
                                    if ([tasksDictionary objectForKey:@"Taskgrptext"]) {
                                        [tasks addObject:[[tasksDictionary objectForKey:@"Taskgrptext"] copy]];
                                    }
                                    else{
                                        [tasks addObject:@""];
                                    }
                                    
                                    if ([tasksDictionary objectForKey:@"TaskCod"]) {
                                        [tasks addObject:[tasksDictionary objectForKey:@"TaskCod"]];
                                    }
                                    else{
                                        
                                        [tasks addObject:@""];
                                    }
                                    
                                    if ([tasksDictionary objectForKey:@"Taskcodetext"]) {
                                        [tasks addObject:[tasksDictionary objectForKey:@"Taskcodetext"]];
                                    }
                                    else{
                                        
                                        [tasks addObject:@""];
                                    }
                                    
                                    if ([tasksDictionary objectForKey:@"TaskShtxt"]) {
                                        [tasks addObject:[tasksDictionary objectForKey:@"TaskShtxt"]];
                                    }
                                    else{
                                        
                                        [tasks addObject:@""];
                                    }
                                    
                                    if ([tasksDictionary objectForKey:@"Parvw"])
                                    {
                                        [tasks addObject:[tasksDictionary objectForKey:@"Parvw"]];
                                    }
                                    else{
                                        
                                        [tasks addObject:@""];
                                    }
                                    
                                    [tasks addObject:@""];//processername
                                    
                                    if ([tasksDictionary objectForKey:@"Parnr"])
                                    {
                                        [tasks addObject:[tasksDictionary objectForKey:@"Parnr"]];
                                    }
                                    else{
                                        
                                        [tasks addObject:@""];
                                    }
                                    
                                    if ([tasksDictionary objectForKey:@"Pster"])
                                    {
                                        [tasks addObject:[tasksDictionary objectForKey:@"Pster"]];
                                    }
                                    else{
                                        
                                        [tasks addObject:@""];
                                    }
                                    
                                    if ([tasksDictionary objectForKey:@"Peter"])
                                    {
                                        [tasks addObject:[tasksDictionary objectForKey:@"Peter"]];
                                    }
                                    else{
                                        
                                        [tasks addObject:@""];
                                    }
                                    
                                    if ([tasksDictionary objectForKey:@"Release"]) {
                                        [tasks addObject:[tasksDictionary objectForKey:@"Release"]];
                                    }
                                    else{
                                        
                                        [tasks addObject:@""];
                                    }
                                    
                                    if ([tasksDictionary objectForKey:@"Complete"]) {
                                        [tasks addObject:[tasksDictionary objectForKey:@"Complete"]];
                                    }
                                    else{
                                        
                                        [tasks addObject:@""];
                                    }
                                    
                                    if ([tasksDictionary objectForKey:@"Success"]) {
                                        [tasks addObject:[tasksDictionary objectForKey:@"Success"]];
                                    }
                                    else{
                                        
                                        [tasks addObject:@""];
                                    }
                                    
                                    if ([tasksDictionary objectForKey:@"ItemKey"]) {
                                        [tasks addObject:[tasksDictionary objectForKey:@"ItemKey"]];
                                    }
                                    else{
                                        
                                        [tasks addObject:@""];
                                    }
                                    
                                    
                                    [tasks addObject:@""];//item status
                                    
                                    ////////////////
                                    
                                    if ([tasksDictionary objectForKey:@"ItempartGrp"]) {
                                        [tasks addObject:[[tasksDictionary objectForKey:@"ItempartGrp"] copy]];
                                    }
                                    else{
                                        [tasks addObject:@""];
                                    }
                                    
                                    if ([tasksDictionary objectForKey:@"Partgrptext"]) {
                                        [tasks addObject:[[tasksDictionary objectForKey:@"Partgrptext"] copy]];
                                    }
                                    else{
                                        [tasks addObject:@""];
                                    }
                                    
                                    if ([tasksDictionary objectForKey:@"ItempartCod"]) {
                                        [tasks addObject:[[tasksDictionary objectForKey:@"ItempartCod"] copy]];
                                    }
                                    else{
                                        [tasks addObject:@""];
                                    }
                                    
                                    if ([tasksDictionary objectForKey:@"Partcodetext"]) {
                                        [tasks addObject:[[tasksDictionary objectForKey:@"Partcodetext"] copy]];
                                    }
                                    else{
                                        [tasks addObject:@""];
                                        
                                    }
                                    
                                    if ([tasksDictionary objectForKey:@"ItemdefectGrp"]) {
                                        [tasks addObject:[[tasksDictionary objectForKey:@"ItemdefectGrp"] copy]];
                                    }
                                    else{
                                        [tasks addObject:@""];
                                    }
                                    
                                    if ([tasksDictionary objectForKey:@"Defectgrptext"]) {
                                        [tasks addObject:[[tasksDictionary objectForKey:@"Defectgrptext"] copy]];
                                    }
                                    else{
                                        [tasks addObject:@""];
                                    }
                                    
                                    if ([tasksDictionary objectForKey:@"ItemdefectCod"]) {
                                        [tasks addObject:[[tasksDictionary objectForKey:@"ItemdefectCod"] copy]];
                                    }
                                    else{
                                        [tasks addObject:@""];
                                    }
                                    
                                    if ([tasksDictionary objectForKey:@"Defectcodetext"]) {
                                        [tasks addObject:[[tasksDictionary objectForKey:@"Defectcodetext"] copy]];
                                    }
                                    else{
                                        [tasks addObject:@""];
                                    }
                                    
                                    if ([tasksDictionary objectForKey:@"ItemdefectShtxt"]) {
                                        [tasks addObject:[[tasksDictionary objectForKey:@"ItemdefectShtxt"] copy]];
                                    }
                                    else{
                                        [tasks addObject:@""];
                                    }
                                    
                                    if ([tasksDictionary objectForKey:@"UserStatus"]) {
                                        [tasks addObject:[tasksDictionary objectForKey:@"UserStatus"]];
                                    }
                                    else{
                                        
                                        [tasks addObject:@""];
                                    }
                                    
                                    if ([tasksDictionary objectForKey:@"SysStatus"]) {
                                        [tasks addObject:[tasksDictionary objectForKey:@"SysStatus"]];
                                    }
                                    else{
                                        
                                        [tasks addObject:@""];
                                    }
                                    
                                    if ([tasksDictionary objectForKey:@"Smsttxt"]) {
                                        [tasks addObject:[tasksDictionary objectForKey:@"Smsttxt"]];
                                    }
                                    else{
                                        
                                        [tasks addObject:@""];
                                    }
                                    
                                    if ([tasksDictionary objectForKey:@"Smastxt"]) {
                                        [tasks addObject:[tasksDictionary objectForKey:@"Smastxt"]];
                                    }
                                    else{
                                        
                                        [tasks addObject:@""];
                                    }
                                    
                                    if ([tasksDictionary objectForKey:@"Usr01"]) {
                                        [tasks addObject:[tasksDictionary objectForKey:@"Usr01"]];
                                    }
                                    else{
                                        
                                        [tasks addObject:@""];
                                    }
                                    
                                    if ([tasksDictionary objectForKey:@"Usr02"]) {
                                        [tasks addObject:[tasksDictionary objectForKey:@"Usr02"]];
                                    }
                                    else{
                                        
                                        [tasks addObject:@""];
                                    }
                                    
                                    if ([tasksDictionary objectForKey:@"Usr03"]) {
                                        [tasks addObject:[tasksDictionary objectForKey:@"Usr03"]];
                                    }
                                    else{
                                        
                                        [tasks addObject:@""];
                                    }
                                    
                                    if ([tasksDictionary objectForKey:@"Usr04"]) {
                                        [tasks addObject:[tasksDictionary objectForKey:@"Usr04"]];
                                    }
                                    else{
                                        
                                        [tasks addObject:@""];
                                    }
                                    
                                    if ([tasksDictionary objectForKey:@"Usr05"]) {
                                        [tasks addObject:[tasksDictionary objectForKey:@"Usr05"]];
                                    }
                                    else{
                                        
                                        [tasks addObject:@""];
                                    }
                                    
                                    if ([tasksDictionary objectForKey:@"Pstur"]) {
                                        [tasks addObject:[[tasksDictionary objectForKey:@"Pstur"] copy]];
                                    }
                                    else{
                                        [tasks addObject:@""];
                                    }
                                    
                                    if ([tasksDictionary objectForKey:@"Petur"]) {
                                        [tasks addObject:[[tasksDictionary objectForKey:@"Petur"] copy]];
                                    }
                                    else{
                                        [tasks addObject:@""];
                                    }
                                    
                                    if ([tasksDictionary objectForKey:@"Erldat"]) {
                                        [tasks addObject:[[tasksDictionary objectForKey:@"Erldat"] copy]];
                                    }
                                    else{
                                        [tasks addObject:@""];
                                    }
                                    
                                    if ([tasksDictionary objectForKey:@"Erlzeit"]) {
                                        [tasks addObject:[[tasksDictionary objectForKey:@"Erlzeit"] copy]];
                                    }
                                    else{
                                        [tasks addObject:@""];
                                    }
                                    
                                    if ([tasksDictionary objectForKey:@"Erlnam"]) {
                                        [tasks addObject:[[tasksDictionary objectForKey:@"Erlnam"] copy]];
                                    }
                                    else{
                                        [tasks addObject:@""];
                                    }
                                    
                                    
                                    id customFieldsTaskTransactionsID;
                                    if ([tasksDictionary objectForKey:@"Fields"]) {
                                        
                                        NSMutableArray *fieldsArray=[NSMutableArray new];
                                        if ([[[tasksDictionary objectForKey:@"Fields"] objectForKey:@"item"] isKindOfClass:[NSDictionary class]]) {
                                            
                                            [fieldsArray addObjectsFromArray:[NSMutableArray arrayWithObject:[[tasksDictionary objectForKey:@"Fields"] objectForKey:@"item"]]];
                                        }
                                        else if ([[[tasksDictionary objectForKey:@"Fields"] objectForKey:@"item"] isKindOfClass:[NSArray class]]){
                                            
                                            [fieldsArray addObjectsFromArray:[[tasksDictionary objectForKey:@"Fields"] objectForKey:@"item"]];
                                        }
                                        
                                        NSMutableArray *taskCodeCustomFields = [NSMutableArray array];
                                        
                                        for (int i =0; i<[fieldsArray count]; i++) {
                                            NSString *fieldValue,*fieldName,*fLabel,*tabName,*docType,*docTypeItem,*dataType,*sequence,*length;
                                            if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Fieldname"]]) {
                                                fieldName = @"";
                                            }
                                            else{
                                                fieldName = [[fieldsArray objectAtIndex:i] objectForKey:@"Fieldname"];
                                            }
                                            
                                            if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Flabel"]]) {
                                                fLabel = @"";
                                            }
                                            else{
                                                fLabel = [[fieldsArray objectAtIndex:i] objectForKey:@"Flabel"];
                                            }
                                            
                                            if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Tabname"]]) {
                                                tabName = @"";
                                            }
                                            else{
                                                tabName = [[fieldsArray objectAtIndex:i] objectForKey:@"Tabname"];
                                            }
                                            
                                            if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Value"]]) {
                                                fieldValue = @"";
                                            }
                                            else{
                                                fieldValue = [[fieldsArray objectAtIndex:i] objectForKey:@"Value"];
                                            }
                                            
                                            if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Zdoctype"]]) {
                                                docType = @"";
                                            }
                                            else{
                                                docType = [[fieldsArray objectAtIndex:i] objectForKey:@"Zdoctype"];
                                            }
                                            
                                            if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"ZdoctypeItem"]]) {
                                                docTypeItem = @"";
                                            }
                                            else{
                                                docTypeItem = [[fieldsArray objectAtIndex:i] objectForKey:@"ZdoctypeItem"];
                                            }
                                            
                                            
                                            if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Datatype"]]) {
                                                dataType = @"";
                                            }
                                            else{
                                                dataType = [[fieldsArray objectAtIndex:i] objectForKey:@"Datatype"];
                                            }
                                            
                                            if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Sequence"]]) {
                                                sequence = @"";
                                            }
                                            else{
                                                sequence = [[fieldsArray objectAtIndex:i] objectForKey:@"Sequence"];
                                            }
                                            
                                            if ([NullChecker isNull:[[fieldsArray objectAtIndex:i] objectForKey:@"Length"]]) {
                                                length = @"";
                                            }
                                            else{
                                                length = [[fieldsArray objectAtIndex:i] objectForKey:@"Length"];
                                            }
                                            
                                            if ([docTypeItem isEqualToString:@"QT"]) {
                                                [taskCodeCustomFields addObject:[NSMutableArray arrayWithObjects:docType,docTypeItem,tabName,fieldName,fieldValue,fLabel,dataType,sequence,length, nil]];
                                            }
                                            
                                        }
                                        
                                        customFieldsTaskTransactionsID = taskCodeCustomFields;
                                        
                                    }
                                    
                                    [[[notificationDetailDictionary objectForKey:[NSString stringWithFormat:@"%lli",[[tasksDictionary objectForKey:@"Qmnum"] longLongValue]]] objectAtIndex:4] addObject:[NSArray arrayWithObjects:tasks,customFieldsTaskTransactionsID, nil]];
                                }
                            }
                        }
                        
                        [notificationTasksArray removeAllObjects];
                    }
                    
                    responseObject = nil;
                    NSMutableArray *notificationStatusArray = [[NSMutableArray alloc] init];
                    
                    if ([parsedDictionary objectForKey:@"resultNotifStatus"]) {
                        
                        responseObject = [parsedDictionary objectForKey:@"resultNotifStatus"];
                        
                        [notificationStatusArray addObjectsFromArray:responseObject];
                        
                        NSDictionary *notifStatusDictionary;
                        
                        for (int i=0; i<[notificationStatusArray count]; i++) {
                            if ([[notificationStatusArray objectAtIndex:i] isKindOfClass:[NSDictionary class]]) {
                                notifStatusDictionary = [notificationStatusArray objectAtIndex:i];
                                if ([notificationDetailDictionary objectForKey:[NSString stringWithFormat:@"%lli",[[notifStatusDictionary objectForKey:@"Qmnum"] longLongValue]]]) {
                                    
                                    NSMutableArray *notifStatus = [NSMutableArray array];
                                    
                                    if ([notifStatusDictionary objectForKey:@"Qmnum"]) {
                                        [notifStatus addObject:[notifStatusDictionary objectForKey:@"Qmnum"]];
                                    }
                                    else{
                                        
                                        [notifStatus addObject:@""];
                                    }
                                    
                                    if ([notifStatusDictionary objectForKey:@"Aufnr"]) {
                                        [notifStatus addObject:[notifStatusDictionary objectForKey:@"Aufnr"]];
                                    }
                                    else{
                                        
                                        [notifStatus addObject:@""];
                                    }
                                    
                                    if ([notifStatusDictionary objectForKey:@"Objnr"]) {
                                        [notifStatus addObject:[notifStatusDictionary objectForKey:@"Objnr"]];
                                    }
                                    else{
                                        [notifStatus addObject:@""];
                                    }
                                    
                                    if ([notifStatusDictionary objectForKey:@"Manum"]) {
                                        [notifStatus addObject:[notifStatusDictionary objectForKey:@"Manum"]];
                                    }
                                    else{
                                        [notifStatus addObject:@""];
                                    }
                                    
                                    if ([notifStatusDictionary objectForKey:@"Stsma"]) {
                                        [notifStatus addObject:[notifStatusDictionary objectForKey:@"Stsma"]];
                                    }
                                    else{
                                        [notifStatus addObject:@""];
                                    }
                                    
                                    if ([notifStatusDictionary objectForKey:@"Inist"]) {
                                        [notifStatus addObject:[notifStatusDictionary objectForKey:@"Inist"]];
                                    }
                                    else{
                                        [notifStatus addObject:@""];
                                    }
                                    
                                    if ([notifStatusDictionary objectForKey:@"Stonr"]) {
                                        [notifStatus addObject:[notifStatusDictionary objectForKey:@"Stonr"]];
                                    }
                                    else{
                                        [notifStatus addObject:@""];
                                    }
                                    
                                    if ([notifStatusDictionary objectForKey:@"Hsonr"]) {
                                        [notifStatus addObject:[notifStatusDictionary objectForKey:@"Hsonr"]];
                                    }
                                    else{
                                        [notifStatus addObject:@""];
                                    }
                                    
                                    if ([notifStatusDictionary objectForKey:@"Nsonr"]) {
                                        [notifStatus addObject:[notifStatusDictionary objectForKey:@"Nsonr"]];
                                    }
                                    else{
                                        [notifStatus addObject:@""];
                                    }
                                    
                                    if ([notifStatusDictionary objectForKey:@"Stat"]) {
                                        [notifStatus addObject:[[notifStatusDictionary objectForKey:@"Stat"] substringToIndex:1]];
                                    }
                                    else{
                                        [notifStatus addObject:@""];
                                    }
                                    
                                    if ([notifStatusDictionary objectForKey:@"Act"]) {
                                        [notifStatus addObject:[notifStatusDictionary objectForKey:@"Act"]];
                                    }
                                    else{
                                        [notifStatus addObject:@""];
                                    }
                                    
                                    if ([notifStatusDictionary objectForKey:@"Txt04"]) {
                                        [notifStatus addObject:[notifStatusDictionary objectForKey:@"Txt04"]];
                                    }
                                    else{
                                        [notifStatus addObject:@""];
                                    }
                                    
                                    if ([notifStatusDictionary objectForKey:@"Txt30"]) {
                                        [notifStatus addObject:[notifStatusDictionary objectForKey:@"Txt30"]];
                                    }
                                    else{
                                        [notifStatus addObject:@""];
                                    }
                                    
                                    if ([notifStatusDictionary objectForKey:@"Action"]) {
                                        [notifStatus addObject:[notifStatusDictionary objectForKey:@"Action"]];
                                    }
                                    else{
                                        [notifStatus addObject:@""];
                                    }
                                    
                                    [[[notificationDetailDictionary objectForKey:[NSString stringWithFormat:@"%lli",[[notifStatusDictionary objectForKey:@"Qmnum"] longLongValue]]] lastObject] addObject:notifStatus];
                                }
                            }
                        }
                        
                        [notificationStatusArray removeAllObjects];
                    }
                    
                    responseObject = nil;
                    
                    if ([parsedDictionary objectForKey:@"resultLongText"]) {
                        responseObject = [parsedDictionary objectForKey:@"resultLongText"];
                        NSMutableArray *notificatioTextnArray = [[NSMutableArray alloc] init];
                        
                        [notificatioTextnArray addObjectsFromArray:responseObject];
                        
                        NSDictionary *textDictionary;
                        for (int i=0; i<[notificatioTextnArray count]; i++) {
                            if ([[notificatioTextnArray objectAtIndex:i] isKindOfClass:[NSDictionary class]]) {
                                textDictionary = [notificatioTextnArray objectAtIndex:i];
                                if ([notificationDetailDictionary objectForKey:[textDictionary objectForKey:@"Qmnum"]]) {
                                    NSMutableDictionary *headerDictionary = [[notificationDetailDictionary objectForKey:[textDictionary objectForKey:@"Qmnum"]] firstObject];
                                    if ([[headerDictionary objectForKey:@"LONGTEXT"] length]) {
                                        [headerDictionary setObject:[NSString stringWithFormat:@"%@\n%@",[headerDictionary objectForKey:@"LONGTEXT"],[textDictionary objectForKey:@"TextLine"]] forKey:@"LONGTEXT"];
                                    }
                                    else
                                    {
                                        [headerDictionary setObject:[NSString stringWithFormat:@"%@",[textDictionary objectForKey:@"TextLine"]] forKey:@"LONGTEXT"];
                                    }
                                }
                            }
                        }
                        
                        [notificationTransactionArray removeAllObjects];
                        responseObject = nil;
                    }
                    
                    NSLog(@"%@",notificationDetailDictionary);
                    
                    NSArray *objectIds = [notificationDetailDictionary allKeys];
                    [[DataBase sharedInstance] deleteinsertDataIntoHeader:@"N"];
                    
                    if ([[defaults objectForKey:@"ACTIVATELOGS"] isEqualToString:@"X"])
                    {
                        [[DataBase sharedInstance] writToLogFile:[NSString stringWithFormat:@"#INFO#.com.enstrapp.fieldtekpro#No of Due Notifications received:%lu",(unsigned long)[objectIds count]]];
                    }
                    
                    for (int i=0; i<[objectIds count]; i++) {
                        
                        [[DataBase sharedInstance] insertDataIntoNotificationHeader:[[notificationDetailDictionary objectForKey:[objectIds objectAtIndex:i]] firstObject] withAttachments:[[notificationDetailDictionary objectForKey:[objectIds objectAtIndex:i]] objectAtIndex:1] withTransaction:[[notificationDetailDictionary objectForKey:[objectIds objectAtIndex:i]] objectAtIndex:2] withActivityCodes:[[notificationDetailDictionary objectForKey:[objectIds objectAtIndex:i]] objectAtIndex:3] withTaskcodes:[[notificationDetailDictionary objectForKey:[objectIds objectAtIndex:i]] objectAtIndex:4] withInspectionResult:[inspectionResultDataArray copy] withNotifStatusCode:[[notificationDetailDictionary objectForKey:[objectIds objectAtIndex:i]] objectAtIndex:5]];
                    }
                    
                 }
            }
            
            break;
            
        case GET_LIST_OF_DUE_ORDERS:
            
            if (!errorDescription.length) {
                
                NSLog(@"Due orders called");

                 NSMutableDictionary *parsedDictionary = [[Response sharedInstance] parseForListOfDueOrders:resultData];
                
              //  NSLog(@"Parsed Data is %@",parsedDictionary);
                
                 [[DataBase sharedInstance] deleteinsertDataIntoHeader:@"O"];
 
                if ([parsedDictionary objectForKey:@"resultHeader"]) {
                    
                    NSMutableDictionary *orderDetailDictionary = [[NSMutableDictionary alloc] init];
                    id responseObject;
                    NSMutableArray *orderOperationArray = [[NSMutableArray alloc] init];
                    NSMutableArray *orderDocsArray = [[NSMutableArray alloc] init];
                    NSMutableArray *orderHeaderArray = [[NSMutableArray alloc] init];
                    NSMutableArray *orderWsmSafetyMeasuresArray = [[NSMutableArray alloc]init];
                    NSMutableArray *orderWcmWorkApprovalListArray = [[NSMutableArray alloc]init];
                    NSMutableArray *orderWcmWorkApplicationListArray = [[NSMutableArray alloc]init];
                    NSMutableArray *orderWcmIssuePermitsArray = [[NSMutableArray alloc]init];
                    NSMutableArray *orderWcmOperationWCDArray = [[NSMutableArray alloc]init];
                    NSMutableArray *orderWcmOperationWCDTaggingConditionsArray = [[NSMutableArray alloc] init];
                    NSMutableArray *orderWcmPermitsStandardCheckPoints = [NSMutableArray new];
                    
                    NSMutableArray *orderStatusArray = [[NSMutableArray alloc] init];
                    NSMutableArray *orderOlistArray = [[NSMutableArray alloc] init];
                    
                    NSMutableArray *orderMeasurementDocumentsArray = [NSMutableArray new];
                    
                    NSDictionary *headerDictionary;
                    
                    responseObject = nil;
                    responseObject = [parsedDictionary objectForKey:@"resultHeader"];
                    
                    [orderHeaderArray addObjectsFromArray:responseObject];
                    
                    NSDateFormatter *dateFormate = [[NSDateFormatter alloc] init];
                    [dateFormate setDateFormat:@"yyyy-MM-dd"];
                    NSMutableDictionary *currentHeaderDictionary;
                    
                    for (int i=0; i<[orderHeaderArray count]; i++) {
                        
                        if ([[orderHeaderArray objectAtIndex:i] isKindOfClass:[NSDictionary class]]) {
                            headerDictionary = [orderHeaderArray objectAtIndex:i];
                            currentHeaderDictionary = [[NSMutableDictionary alloc] init];
                            if ([headerDictionary objectForKey:@"Aufnr"]) {
                                [currentHeaderDictionary setObject:[[headerDictionary objectForKey:@"Aufnr"] copy] forKey:@"OBJECTID"];
                                
                            }
                            else
                            {
                                [currentHeaderDictionary setObject:@" " forKey:@"OBJECTID"];
                            }
                            
                            
                            
                            [currentHeaderDictionary setObject:[[headerDictionary objectForKey:@"Auart"] copy] forKey:@"OID"];
                            
                            if ([NullChecker isNull:[headerDictionary objectForKey:@"Ktext"]]) {
                                [currentHeaderDictionary setObject:@"" forKey:@"SHORTTEXT"];
                            }
                            else{
                                [currentHeaderDictionary setObject:[[headerDictionary objectForKey:@"Ktext"] copy] forKey:@"SHORTTEXT"];
                            }
                            
                            if ([headerDictionary objectForKey:@"Gltrp"]) {
                                
                                [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Gltrp"] forKey:@"EDATE"];
                                
                            }
                            else{
                                [currentHeaderDictionary setObject:@"" forKey:@"EDATE"];
                            }
                            
                            if ([headerDictionary objectForKey:@"Gstrp"]) {
                                
                                [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Gstrp"] forKey:@"SDATE"];
                            }
                            else{
                                
                                [currentHeaderDictionary setObject:@"" forKey:@"SDATE"];
                            }
                            
                            [currentHeaderDictionary setObject:[[headerDictionary objectForKey:@"Ernam"] copy] forKey:@"REPORTEDBY"];
                            if ([headerDictionary objectForKey:@"Priok"]) {
                                [currentHeaderDictionary setObject:[[headerDictionary objectForKey:@"Priok"] copy] forKey:@"OPID"];
                            }
                            else{
                                [currentHeaderDictionary setObject:@"" forKey:@"OPID"];
                            }
                            
                            if ([headerDictionary objectForKey:@"Equnr"]) {
                                [currentHeaderDictionary setObject:[[headerDictionary objectForKey:@"Equnr"] copy] forKey:@"EQID"];
                            }
                            else{
                                [currentHeaderDictionary setObject:@"" forKey:@"EQID"];
                            }
                            
                            if ([headerDictionary objectForKey:@"Strno"]) {
                                [currentHeaderDictionary setObject:[[headerDictionary objectForKey:@"Strno"] copy] forKey:@"FID"];
                            }
                            else{
                                [currentHeaderDictionary setObject:@"" forKey:@"FID"];
                            }
                            
                            if ([headerDictionary objectForKey:@"Xstatus"]) {
                                [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Xstatus"] forKey:@"OSTATUS"];
                            }
                            else{
                                [currentHeaderDictionary setObject:@"Assigned" forKey:@"OSTATUS"];
                            }
                            
                            if ([headerDictionary objectForKey:@"Docs"]) {
                                [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Docs"] forKey:@"DOCS"];
                            }
                            else{
                                [currentHeaderDictionary setObject:@"" forKey:@"DOCS"];
                            }
                            
                            if ([headerDictionary objectForKey:@"Werks"]) {
                                [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Werks"] forKey:@"PLANTID"];
                            }
                            else{
                                [currentHeaderDictionary setObject:@"" forKey:@"PLANTID"];
                            }
                            
                            if ([headerDictionary objectForKey:@"Plantname"]) {
                                
                                [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Plantname"] forKey:@"PLANTNAME"];
                            }
                            else{
                                [currentHeaderDictionary setObject:@"" forKey:@"PLANTNAME"];
                            }
                            
                            if ([headerDictionary objectForKey:@"Arbpl"]) {
                                [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Arbpl"] forKey:@"WORKCENTERID"];
                            }
                            else{
                                [currentHeaderDictionary setObject:@"" forKey:@"WORKCENTERID"];
                            }
                            
                            if ([headerDictionary objectForKey:@"Wkctrname"]) {
                                
                                [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Wkctrname"] forKey:@"WORKCENTERNAME"];
                            }
                            else{
                                [currentHeaderDictionary setObject:@"" forKey:@"WORKCENTERNAME"];
                            }
                            
                            if ([headerDictionary objectForKey:@"Ausvn"]) {
                                [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Ausvn"] forKey:@"MALFUNCTIONSTARTDATE"];
                            }
                            else{
                                
                                [currentHeaderDictionary setObject:@"" forKey:@"MALFUNCTIONSTARTDATE"];
                            }
                            
                            if ([headerDictionary objectForKey:@"Ausbs"]) {
                                [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Ausbs"] forKey:@"MALFUNCTIONENDDATE"];
                            }
                            else{
                                
                                [currentHeaderDictionary setObject:@"" forKey:@"MALFUNCTIONENDDATE"];
                            }
                            
                            if ([headerDictionary objectForKey:@"Qmnam"]) {
                                [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Qmnam"] forKey:@"NREPORTEDBY"];
                            }
                            else{
                                [currentHeaderDictionary setObject:@"" forKey:@"NREPORTEDBY"];
                            }
                            
                            if ([headerDictionary objectForKey:@"Msaus"]) {
                                [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Msaus"] forKey:@"BREAKDOWN"];
                            }
                            else{
                                [currentHeaderDictionary setObject:@"" forKey:@"BREAKDOWN"];
                            }
                            
                            if ([headerDictionary objectForKey:@"Auswk"]) {
                                [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Auswk"] forKey:@"EFFECTID"];
                            }
                            else{
                                
                                [currentHeaderDictionary setObject:@"" forKey:@"EFFECTID"];
                            }
                            
                            if ([headerDictionary objectForKey:@"Auswkt"]) {
                                [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Auswkt"] forKey:@"EFFECTNAME"];
                            }
                            else{
                                
                                [currentHeaderDictionary setObject:@"" forKey:@"EFFECTNAME"];
                            }
                            
                            
                            if ([headerDictionary objectForKey:@"Anlzu"]) {
                                [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Anlzu"] forKey:@"SYSTEMCONDITIONID"];
                            }
                            else{
                                [currentHeaderDictionary setObject:@"" forKey:@"SYSTEMCONDITIONID"];
                            }
                            
                            if ([headerDictionary objectForKey:@"Anlzux"]) {
                                [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Anlzux"] forKey:@"SYSTEMCONDITIONTEXT"];
                            }
                            else{
                                [currentHeaderDictionary setObject:@"" forKey:@"SYSTEMCONDITIONTEXT"];
                            }
                            
                            
                            
                            if ([headerDictionary objectForKey:@"ParnrVw"]) {
                                [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"ParnrVw"] forKey:@"PARNRID"];
                            }
                            else{
                                
                                [currentHeaderDictionary setObject:@"" forKey:@"PARNRID"];
                            }
                            
                            if ([headerDictionary objectForKey:@"NameVw"]) {
                                [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"NameVw"] forKey:@"NAMEVW"];
                            }
                            else{
                                
                                [currentHeaderDictionary setObject:@"" forKey:@"NAMEVW"];
                                
                            }
                            
                            if ([headerDictionary objectForKey:@"Ingrp"]) {
                                [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Ingrp"] forKey:@"PLANNERGROUP"];
                            }
                            else{
                                
                                [currentHeaderDictionary setObject:@"" forKey:@"PLANNERGROUP"];
                                
                            }
                            
                            if ([headerDictionary objectForKey:@"Ingrpname"]) {
                                [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Ingrpname"] forKey:@"PLANNERGROUPNAME"];
                            }
                            else{
                                
                                [currentHeaderDictionary setObject:@"" forKey:@"PLANNERGROUPNAME"];
                                
                            }
                            
                            
                            [currentHeaderDictionary setObject:@"" forKey:@"LATITUDE"];
                            [currentHeaderDictionary setObject:@"" forKey:@"LONGITUDE"];
                            [currentHeaderDictionary setObject:@"" forKey:@"ALTITUDE"];
                            
                            [currentHeaderDictionary setObject:@"" forKey:@"workarea"];
                            [currentHeaderDictionary setObject:@"" forKey:@"costcenter"];
                            
                            if ([headerDictionary objectForKey:@"Kokrs"]) {
                                
                                [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Kokrs"] forKey:@"workarea"];
                            }
                            
                            if ([headerDictionary objectForKey:@"Kostl"]) {
                                
                                [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Kostl"] forKey:@"costcenter"];
                            }
                            
                            
                            if ([headerDictionary objectForKey:@"EquiHistory"]) {
                                id equipmentHisory = [headerDictionary objectForKey:@"EquiHistory"];
                                if ([equipmentHisory objectForKey:@"item"]) {
                                    equipmentHisory = [equipmentHisory objectForKey:@"item"];
                                    if ([equipmentHisory isKindOfClass:[NSDictionary class]]) {
                                        [currentHeaderDictionary setObject:[NSMutableArray arrayWithObject:equipmentHisory] forKey:@"EQUIPMENTHISTORY"];
                                    }
                                    else if ([equipmentHisory isKindOfClass:[NSArray class]]){
                                        [currentHeaderDictionary setObject:equipmentHisory forKey:@"EQUIPMENTHISTORY"];
                                    }
                                }
                            }
                            
                            if ([headerDictionary objectForKey:@"Fields"]) {
                                NSMutableArray *fieldsMutArray = [NSMutableArray new];
                                NSMutableArray *tempfieldsMutArray = [NSMutableArray new];
                                
                                if ([[[headerDictionary objectForKey:@"Fields"] objectForKey:@"item"] isKindOfClass:[NSDictionary class]]) {
                                    [tempfieldsMutArray addObjectsFromArray:[NSMutableArray arrayWithObject:[[headerDictionary objectForKey:@"Fields"] objectForKey:@"item"]]];
                                }
                                else if ([[[headerDictionary objectForKey:@"Fields"] objectForKey:@"item"] isKindOfClass:[NSArray class]]) {
                                    [tempfieldsMutArray addObjectsFromArray:[[headerDictionary objectForKey:@"Fields"] objectForKey:@"item"]];
                                }
                                
                                //                                NSArray *fieldsArray = [[headerDictionary objectForKey:@"Fields"] objectForKey:@"item"];
                                for (int i =0; i<[tempfieldsMutArray count]; i++) {
                                    NSString *fieldValue,*fieldName,*fLabel,*tabName,*dataType,*sequence,*length;
                                    if ([NullChecker isNull:[[tempfieldsMutArray objectAtIndex:i] objectForKey:@"Fieldname"]]) {
                                        fieldName = @"";
                                    }
                                    else{
                                        fieldName = [[tempfieldsMutArray objectAtIndex:i] objectForKey:@"Fieldname"];
                                    }
                                    
                                    if ([NullChecker isNull:[[tempfieldsMutArray objectAtIndex:i] objectForKey:@"Flabel"]]) {
                                        fLabel = @"";
                                    }
                                    else{
                                        fLabel = [[tempfieldsMutArray objectAtIndex:i] objectForKey:@"Flabel"];
                                    }
                                    
                                    if ([NullChecker isNull:[[tempfieldsMutArray objectAtIndex:i] objectForKey:@"Tabname"]]) {
                                        tabName = @"";
                                    }
                                    else{
                                        tabName = [[tempfieldsMutArray objectAtIndex:i] objectForKey:@"Tabname"];
                                    }
                                    
                                    if ([NullChecker isNull:[[tempfieldsMutArray objectAtIndex:i] objectForKey:@"Value"]]) {
                                        fieldValue = @"";
                                    }
                                    else{
                                        fieldValue = [[tempfieldsMutArray objectAtIndex:i] objectForKey:@"Value"];
                                    }
                                    
                                    if ([NullChecker isNull:[[tempfieldsMutArray objectAtIndex:i] objectForKey:@"Datatype"]]) {
                                        dataType = @"";
                                    }
                                    else{
                                        dataType = [[tempfieldsMutArray objectAtIndex:i] objectForKey:@"Datatype"];
                                    }
                                    
                                    if ([NullChecker isNull:[[tempfieldsMutArray objectAtIndex:i] objectForKey:@"Sequence"]]) {
                                        sequence = @"";
                                    }
                                    else{
                                        sequence = [[tempfieldsMutArray objectAtIndex:i] objectForKey:@"Sequence"];
                                    }
                                    
                                    if ([NullChecker isNull:[[tempfieldsMutArray objectAtIndex:i] objectForKey:@"Length"]]) {
                                        length = @"";
                                    }
                                    else{
                                        length = [[tempfieldsMutArray objectAtIndex:i] objectForKey:@"Length"];
                                    }
                                    
                                    
                                    [fieldsMutArray addObject:[NSMutableArray arrayWithObjects:@"W",@"WH",tabName,fieldName,fieldValue,fLabel,dataType,sequence,length, nil]];
                                }
                                
                                [currentHeaderDictionary setObject:fieldsMutArray forKey:@"CFH"];
                            }
                            
                            [currentHeaderDictionary setObject:@"" forKey:@"LONGTEXT"];
                            [currentHeaderDictionary setObject:[[DataBase sharedInstance] fetchNameForIDKey:@"ORDEROBJECTID" forValue:[currentHeaderDictionary objectForKey:@"OBJECTID"]] forKey:@"ID"];
                            if (![[currentHeaderDictionary objectForKey:@"ID"] length]) {
                                
                            }
                            
                            if ([headerDictionary objectForKey:@"Auarttext"]) {
                                [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Auarttext"] forKey:@"ONAME"];
                            }
                            
                            if ([headerDictionary objectForKey:@"Priokx"]) {
                                [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Priokx"] forKey:@"OPNAME"];
                            }
                            else{
                                [currentHeaderDictionary setObject:@"" forKey:@"OPNAME"];
                            }
                            
                            if ([headerDictionary objectForKey:@"Pltxt"]) {
                                [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Pltxt"] forKey:@"FNAME"];
                            }
                            else{
                                [currentHeaderDictionary setObject:@"" forKey:@"FNAME"];
                            }
                            
                            if ([headerDictionary objectForKey:@"Eqktx"]) {
                                [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Eqktx"] forKey:@"EQNAME"];
                            }
                            else{
                                
                                [currentHeaderDictionary setObject:@"" forKey:@"EQNAME"];
                            }
                            
                            if ([headerDictionary  objectForKey:@"Bemot"]) {
                                [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Bemot"] forKey:@"ACCINCID"];
                                [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Bemot"] forKey:@"ACCINCNAME"];
                            }
                            else{
                                [currentHeaderDictionary setObject:@"" forKey:@"ACCINCID"];
                                [currentHeaderDictionary setObject:@"" forKey:@"ACCINCNAME"];
                            }
                            
                            if ([headerDictionary objectForKey:@"Kokrs"]) {
                                [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Kokrs"] forKey:@"workarea"];
                            }
                            else{
                                
                                [currentHeaderDictionary setObject:@"" forKey:@"workarea"];
                            }
                            
                            if ([headerDictionary objectForKey:@"Kostl"]) {
                                [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Kostl"] forKey:@"costcenter"];
                            }
                            else{
                                
                                [currentHeaderDictionary setObject:@"" forKey:@"costcenter"];
                            }
                            
                            [currentHeaderDictionary setObject:@"" forKey:@"NOSYNCLOG"];
                            
                            [currentHeaderDictionary setObject:@"" forKey:@"QMNUM"];
                            
                            if ([headerDictionary objectForKey:@"Qmnum"]) {
                                
                                [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Qmnum"] forKey:@"QMNUM"];
                            }
                            
                            [currentHeaderDictionary setObject:@"" forKey:@"usr01"];
                            if ([headerDictionary objectForKey:@"Usr01"]) {
                                
                                [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Usr01"] forKey:@"usr01"];
                            }
                            
                            [currentHeaderDictionary setObject:@"" forKey:@"usr02"];
                            if ([headerDictionary objectForKey:@"Usr02"]) {
                                
                                [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Usr02"] forKey:@"usr02"];
                            }
                            
                            [currentHeaderDictionary setObject:@"" forKey:@"usr03"];
                            if ([headerDictionary objectForKey:@"Usr03"]) {
                                
                                [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Usr03"] forKey:@"usr03"];
                            }
                            
                            [currentHeaderDictionary setObject:@"" forKey:@"usr04"];
                            if ([headerDictionary objectForKey:@"Usr04"]) {
                                
                                [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Usr04"] forKey:@"usr04"];
                            }
                            
                            [currentHeaderDictionary setObject:@"" forKey:@"usr05"];
                            if ([headerDictionary objectForKey:@"Usr05"]) {
                                
                                [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Usr04"] forKey:@"usr05"];
                            }
                            
                            
                            [currentHeaderDictionary setObject:@"" forKey:@"POSID"];
                            if ([headerDictionary objectForKey:@"Posid"]) {
                                
                                [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"Posid"] forKey:@"POSID"];
                            }
                            
                            [currentHeaderDictionary setObject:@"" forKey:@"REVNR"];
                            if ([headerDictionary objectForKey:@"REVNR"]) {
                                
                                [currentHeaderDictionary setObject:[headerDictionary objectForKey:@"REVNR"] forKey:@"REVNR"];
                            }
                            

                            
                            [orderDetailDictionary setObject:[NSMutableArray arrayWithObjects:currentHeaderDictionary,[NSMutableArray array],[NSMutableArray array],[NSMutableArray array],[NSMutableArray array],[NSMutableArray array],[NSMutableArray array],[NSMutableArray array],[NSMutableArray array],[NSMutableArray array],[NSMutableArray array],[NSMutableArray array], nil] forKey:[currentHeaderDictionary objectForKey:@"OBJECTID"]];
                        }
                    }
                    
                    [orderHeaderArray removeAllObjects];
                    
                    NSMutableDictionary *orderOlistDictionary = [[NSMutableDictionary alloc] init];
                    responseObject = nil;
                    NSMutableDictionary *tempOlistDictionary;
                    
                    if ([parsedDictionary objectForKey:@"resultOrderOlist"]) {
                        
                        responseObject = [parsedDictionary objectForKey:@"resultOrderOlist"];
                        
                        [orderOlistArray addObjectsFromArray:responseObject];
                        
                        for (int i=0; i<[orderOlistArray count]; i++) {
                            if ([[orderOlistArray objectAtIndex:i] isKindOfClass:[NSDictionary class]]) {
                                headerDictionary = [orderOlistArray objectAtIndex:i];
                                if ([orderDetailDictionary objectForKey:[NSString stringWithFormat:@"%lld",[[headerDictionary objectForKey:@"Aufnr"] longLongValue]]]) {
                                    if ([orderOlistDictionary objectForKey:[NSString stringWithFormat:@"%lld",[[headerDictionary objectForKey:@"Aufnr"] longLongValue]]]) {
                                        tempOlistDictionary = [orderOlistDictionary objectForKey:[NSString stringWithFormat:@"%lld",[[headerDictionary objectForKey:@"Aufnr"] longLongValue]]];
                                        if ([tempOlistDictionary objectForKey:[headerDictionary objectForKey:@"Obknr"]]) {
                                            tempOlistDictionary = [tempOlistDictionary objectForKey:[headerDictionary objectForKey:@"Obknr"]];
                                            [tempOlistDictionary addEntriesFromDictionary:headerDictionary];
                                        }
                                        else{
                                            [tempOlistDictionary setObject:[NSMutableDictionary dictionaryWithDictionary:headerDictionary] forKey:[headerDictionary objectForKey:@"Obknr"]];
                                        }
                                    }
                                    else
                                    {
                                        [orderOlistDictionary setObject:[NSMutableDictionary dictionaryWithObject:[NSMutableDictionary dictionaryWithDictionary:headerDictionary] forKey:[headerDictionary objectForKey:@"Obknr"]] forKey:[NSString stringWithFormat:@"%lld",[[headerDictionary objectForKey:@"Aufnr"] longLongValue]]];
                                    }
                                }
                            }
                        }
                    }
                    
                    [orderOlistArray removeAllObjects];
                    
                    NSMutableDictionary *orderDocsDictionary = [[NSMutableDictionary alloc] init];
                    responseObject = nil;
                    NSMutableDictionary *tempDocsDictionary;
                    
                    if ([parsedDictionary objectForKey:@"resultDocs"]) {
                        
                        responseObject = [parsedDictionary objectForKey:@"resultDocs"];
                        
                        [orderDocsArray addObjectsFromArray:responseObject];
                        
                        for (int i=0; i<[orderDocsArray count]; i++) {
                            if ([[orderDocsArray objectAtIndex:i] isKindOfClass:[NSDictionary class]]) {
                                headerDictionary = [orderDocsArray objectAtIndex:i];
                                if ([orderDetailDictionary objectForKey:[NSString stringWithFormat:@"%lld",[[headerDictionary objectForKey:@"Zobjid"] longLongValue]]]) {
                                    if ([orderDocsDictionary objectForKey:[NSString stringWithFormat:@"%lld",[[headerDictionary objectForKey:@"Zobjid"] longLongValue]]]) {
                                        tempDocsDictionary = [orderDocsDictionary objectForKey:[NSString stringWithFormat:@"%lld",[[headerDictionary objectForKey:@"Zobjid"] longLongValue]]];
                                        if ([tempDocsDictionary objectForKey:[headerDictionary objectForKey:@"Filename"]]) {
                                            tempDocsDictionary = [tempDocsDictionary objectForKey:[headerDictionary objectForKey:@"Filename"]];
                                            [tempDocsDictionary addEntriesFromDictionary:headerDictionary];
                                        }
                                        else{
                                            [tempDocsDictionary setObject:[NSMutableDictionary dictionaryWithDictionary:headerDictionary] forKey:[headerDictionary objectForKey:@"Filename"]];
                                        }
                                    }
                                    else
                                    {
                                        [orderDocsDictionary setObject:[NSMutableDictionary dictionaryWithObject:[NSMutableDictionary dictionaryWithDictionary:headerDictionary] forKey:[headerDictionary objectForKey:@"Filename"]] forKey:[NSString stringWithFormat:@"%lld",[[headerDictionary objectForKey:@"Zobjid"] longLongValue]]];
                                    }
                                }
                            }
                        }
                    }
                    
                    [orderDocsArray removeAllObjects];
                    
                    NSMutableDictionary *orderTransactionDictionary = [[NSMutableDictionary alloc] init];
                    responseObject = nil;
                    
                    NSMutableDictionary *tempDictionary;
                    
                    if ([parsedDictionary objectForKey:@"resultOperationsTransactions"]) {
                        
                        responseObject = [parsedDictionary objectForKey:@"resultOperationsTransactions"];
                        
                        [orderOperationArray addObjectsFromArray:responseObject];
                        
                        for (int i=0; i<[orderOperationArray count]; i++) {
                            if ([[orderOperationArray objectAtIndex:i] isKindOfClass:[NSDictionary class]]) {
                                headerDictionary = [orderOperationArray objectAtIndex:i];
                                
                                if ([orderDetailDictionary objectForKey:[headerDictionary objectForKey:@"Aufnr"]]) {
                                    if ([orderTransactionDictionary objectForKey:[headerDictionary objectForKey:@"Aufnr"]]) {
                                        tempDictionary = [orderTransactionDictionary objectForKey:[headerDictionary objectForKey:@"Aufnr"]];
                                        if ([tempDictionary objectForKey:[headerDictionary objectForKey:@"Vornr"]]) {
                                            tempDictionary = [tempDictionary objectForKey:[headerDictionary objectForKey:@"Vornr"]];
                                            [tempDictionary addEntriesFromDictionary:headerDictionary];
                                        }
                                        else
                                        {
                                            [tempDictionary setObject:[NSMutableDictionary dictionaryWithDictionary:headerDictionary] forKey:[headerDictionary objectForKey:@"Vornr"]];
                                        }
                                    }
                                    else
                                    {
                                        [orderTransactionDictionary setObject:[NSMutableDictionary dictionaryWithObject:[NSMutableDictionary dictionaryWithDictionary:headerDictionary] forKey:[headerDictionary objectForKey:@"Vornr"]] forKey:[headerDictionary objectForKey:@"Aufnr"]];
                                    }
                                }
                            }
                        }
                    }
                    
                    [orderOperationArray removeAllObjects];
                    
                    responseObject = nil;
                    NSMutableArray *orderTransactionArray = [[NSMutableArray alloc] init];
                    
                    if ([parsedDictionary objectForKey:@"resultComponentsTransactions"]) {
                        
                        responseObject = [parsedDictionary objectForKey:@"resultComponentsTransactions"];
                        
                        if ([responseObject isKindOfClass:[NSDictionary class]]) {
                            [orderTransactionArray addObject:responseObject];
                        }
                        else if ([responseObject isKindOfClass:[NSArray class]])
                        {
                            [orderTransactionArray addObjectsFromArray:responseObject];
                        }
                        
                        NSDictionary *transactionDictionary;
                        
                        for (int i=0; i<[orderTransactionArray count]; i++) {
                            
                            if ([[orderTransactionArray objectAtIndex:i] isKindOfClass:[NSDictionary class]]) {
                                
                                transactionDictionary = [orderTransactionArray objectAtIndex:i];
                                
                                if ([orderDetailDictionary objectForKey:[transactionDictionary objectForKey:@"Aufnr"]]) {
                                    
                                    if ([orderTransactionDictionary objectForKey:[transactionDictionary objectForKey:@"Aufnr"]]) {
                                        
                                        tempDictionary = [orderTransactionDictionary objectForKey:[transactionDictionary objectForKey:@"Aufnr"]];
                                        
                                        if ([tempDictionary objectForKey:[transactionDictionary objectForKey:@"Vornr"]]) {
                                            
                                            tempDictionary = [tempDictionary objectForKey:[transactionDictionary objectForKey:@"Vornr"]];
                                            
                                            if ([tempDictionary objectForKey:@"Components"]) {
                                                
                                                NSMutableArray *componentArray = [tempDictionary objectForKey:@"Components"];
                                                
                                                [componentArray addObject:[NSMutableDictionary dictionaryWithDictionary:transactionDictionary]];
                                            }
                                            else
                                            {
                                                [tempDictionary setObject:[NSMutableArray arrayWithObject:[NSMutableDictionary dictionaryWithDictionary:transactionDictionary]] forKey:@"Components"];
                                            }
                                        }
                                        else
                                        {
                                            [tempDictionary setObject:[NSMutableDictionary dictionaryWithDictionary:transactionDictionary] forKey:[transactionDictionary objectForKey:@"Vornr"]];
                                        }
                                    }
                                    else
                                    {
                                        [orderTransactionDictionary setObject:[NSMutableDictionary dictionaryWithObject:[NSMutableDictionary dictionaryWithDictionary:transactionDictionary] forKey:[transactionDictionary objectForKey:@"Vornr"]] forKey:[transactionDictionary objectForKey:@"Aufnr"]];
                                    }
                                }
                            }
                        }
                        
                        [orderTransactionArray removeAllObjects];
                    }
                    
                    NSMutableDictionary *orderMeasurementDocumentsDictionary = [[NSMutableDictionary alloc] init];
                    responseObject = nil;
                    
                    NSMutableDictionary *measureMentDocsDictionary;
                    
                    if ([parsedDictionary objectForKey:@"resultMeasurementDocuments"]) {
                        
                        responseObject = [parsedDictionary objectForKey:@"resultMeasurementDocuments"];
                        
                        [orderMeasurementDocumentsArray addObjectsFromArray:responseObject];
                        
                        for (int i=0; i<[orderMeasurementDocumentsArray count]; i++) {
                            if ([[orderMeasurementDocumentsArray objectAtIndex:i] isKindOfClass:[NSDictionary class]]) {
                                headerDictionary = [orderMeasurementDocumentsArray objectAtIndex:i];
                                
                                if ([orderDetailDictionary objectForKey:[headerDictionary objectForKey:@"Aufnr"]]) {
                                    if ([orderMeasurementDocumentsDictionary objectForKey:[headerDictionary objectForKey:@"Aufnr"]]) {
                                        tempDictionary = [orderMeasurementDocumentsDictionary objectForKey:[headerDictionary objectForKey:@"Aufnr"]];
                                        if ([tempDictionary objectForKey:[headerDictionary objectForKey:@"Mdocm"]]) {
                                            measureMentDocsDictionary = [tempDictionary objectForKey:[headerDictionary objectForKey:@"Mdocm"]];
                                            [measureMentDocsDictionary addEntriesFromDictionary:headerDictionary];
                                        }
                                        else
                                        {
                                            [measureMentDocsDictionary setObject:[NSMutableDictionary dictionaryWithDictionary:headerDictionary] forKey:[headerDictionary objectForKey:@"Mdocm"]];
                                        }
                                    }
                                    else
                                    {
                                        [orderMeasurementDocumentsDictionary setObject:[NSMutableDictionary dictionaryWithObject:[NSMutableDictionary dictionaryWithDictionary:headerDictionary] forKey:[headerDictionary objectForKey:@"Mdocm"]] forKey:[headerDictionary objectForKey:@"Aufnr"]];
                                    }
                                }
                            }
                        }
                    }
                    
                    [orderMeasurementDocumentsArray removeAllObjects];
                    
                    NSMutableDictionary *orderWSMSafetyMeasuresDictionary = [[NSMutableDictionary alloc] init];
                    responseObject = nil;
                    NSMutableDictionary *tempWSMSafetyMeasuresDictionary;
                    
                    if ([parsedDictionary objectForKey:@"resultWSMSafetyMeasures"]) {
                        
                        responseObject = [parsedDictionary objectForKey:@"resultWSMSafetyMeasures"];
                        
                        [orderWsmSafetyMeasuresArray addObjectsFromArray:responseObject];
                        
                        for (int i=0; i<[orderWsmSafetyMeasuresArray count]; i++) {
                            
                            if ([[orderWsmSafetyMeasuresArray objectAtIndex:i] isKindOfClass:[NSDictionary class]]) {
                                headerDictionary = [orderWsmSafetyMeasuresArray objectAtIndex:i];
                                if ([orderDetailDictionary objectForKey:[NSString stringWithFormat:@"%lld",[[headerDictionary objectForKey:@"EamsAufnr"] longLongValue]]]) {
                                    if ([orderWSMSafetyMeasuresDictionary objectForKey:[NSString stringWithFormat:@"%lld",[[headerDictionary objectForKey:@"EamsAufnr"] longLongValue]]]) {
                                        tempWSMSafetyMeasuresDictionary = [orderWSMSafetyMeasuresDictionary objectForKey:[NSString stringWithFormat:@"%lld",[[headerDictionary objectForKey:@"EamsAufnr"] longLongValue]]];
                                        if ([tempWSMSafetyMeasuresDictionary objectForKey:[headerDictionary objectForKey:@"ObjId"]]) {
                                            tempWSMSafetyMeasuresDictionary = [tempWSMSafetyMeasuresDictionary objectForKey:[headerDictionary objectForKey:@"ObjId"]];
                                            [tempWSMSafetyMeasuresDictionary addEntriesFromDictionary:headerDictionary];
                                        }
                                        else{
                                            [tempWSMSafetyMeasuresDictionary setObject:[NSMutableDictionary dictionaryWithDictionary:headerDictionary] forKey:[headerDictionary objectForKey:@"ObjId"]];
                                        }
                                    }
                                    else
                                    {
                                        [orderWSMSafetyMeasuresDictionary setObject:[NSMutableDictionary dictionaryWithObject:[NSMutableDictionary dictionaryWithDictionary:headerDictionary] forKey:[headerDictionary objectForKey:@"ObjId"]] forKey:[NSString stringWithFormat:@"%lld",[[headerDictionary objectForKey:@"EamsAufnr"] longLongValue]]];
                                    }
                                }
                            }
                        }
                    }
                    
                    [orderWsmSafetyMeasuresArray removeAllObjects];
                    
                    NSMutableDictionary *orderWCMWorkApprovalListDictionary = [[NSMutableDictionary alloc] init];
                    responseObject = nil;
                    NSMutableDictionary *tempWCMWorkApprovalListDictionary;
                    
                    if ([parsedDictionary objectForKey:@"resultWorkApprovalsData"]) {
                        
                        responseObject = [parsedDictionary objectForKey:@"resultWorkApprovalsData"];
                        
                        [orderWcmWorkApprovalListArray addObjectsFromArray:responseObject];
                        
                        for (int i=0; i<[orderWcmWorkApprovalListArray count]; i++) {
                            
                            if ([[orderWcmWorkApprovalListArray objectAtIndex:i] isKindOfClass:[NSDictionary class]]) {
                                headerDictionary = [orderWcmWorkApprovalListArray objectAtIndex:i];
                                if ([orderDetailDictionary objectForKey:[NSString stringWithFormat:@"%lld",[[headerDictionary objectForKey:@"Aufnr"] longLongValue]]]) {
                                    if ([orderWCMWorkApprovalListDictionary objectForKey:[NSString stringWithFormat:@"%lld",[[headerDictionary objectForKey:@"Aufnr"] longLongValue]]]) {
                                        tempWCMWorkApprovalListDictionary = [orderWCMWorkApprovalListDictionary objectForKey:[NSString stringWithFormat:@"%lld",[[headerDictionary objectForKey:@"Aufnr"] longLongValue]]];
                                        if ([tempWCMWorkApprovalListDictionary objectForKey:[headerDictionary objectForKey:@"Wapnr"]]) {
                                            tempWCMWorkApprovalListDictionary = [tempWCMWorkApprovalListDictionary objectForKey:[headerDictionary objectForKey:@"Wapnr"]];
                                            [tempWCMWorkApprovalListDictionary addEntriesFromDictionary:headerDictionary];
                                        }
                                        else{
                                            [tempWCMWorkApprovalListDictionary setObject:[NSMutableDictionary dictionaryWithDictionary:headerDictionary] forKey:[headerDictionary objectForKey:@"Wapnr"]];
                                        }
                                    }
                                    else
                                    {
                                        [orderWCMWorkApprovalListDictionary setObject:[NSMutableDictionary dictionaryWithObject:[NSMutableDictionary dictionaryWithDictionary:headerDictionary] forKey:[headerDictionary objectForKey:@"Wapnr"]] forKey:[NSString stringWithFormat:@"%lld",[[headerDictionary objectForKey:@"Aufnr"] longLongValue]]];
                                    }
                                }
                            }
                        }
                    }
                    
                    [orderWcmWorkApprovalListArray removeAllObjects];
                    
                    
                    NSMutableDictionary *orderWCMWorkApplicationListDictionary = [[NSMutableDictionary alloc] init];
                    responseObject = nil;
                    NSMutableDictionary *tempWCMWorkApplicationListDictionary;
                    
                    if ([parsedDictionary objectForKey:@"resultWorkApplicationData"]) {
                        
                        responseObject = [parsedDictionary objectForKey:@"resultWorkApplicationData"];
                        
                        [orderWcmWorkApplicationListArray addObjectsFromArray:responseObject];
                        
                        for (int i=0; i<[orderWcmWorkApplicationListArray count]; i++) {
                            
                            if ([[orderWcmWorkApplicationListArray objectAtIndex:i] isKindOfClass:[NSDictionary class]]) {
                                headerDictionary = [orderWcmWorkApplicationListArray objectAtIndex:i];
                                if ([orderDetailDictionary objectForKey:[NSString stringWithFormat:@"%lld",[[headerDictionary objectForKey:@"Aufnr"] longLongValue]]]) {
                                    if ([orderWCMWorkApplicationListDictionary objectForKey:[NSString stringWithFormat:@"%lld",[[headerDictionary objectForKey:@"Aufnr"] longLongValue]]]) {
                                        tempWCMWorkApplicationListDictionary = [orderWCMWorkApplicationListDictionary objectForKey:[NSString stringWithFormat:@"%lld",[[headerDictionary objectForKey:@"Aufnr"] longLongValue]]];
                                        if ([tempWCMWorkApplicationListDictionary objectForKey:[headerDictionary objectForKey:@"Wapinr"]]) {
                                            tempWCMWorkApplicationListDictionary = [tempWCMWorkApprovalListDictionary objectForKey:[headerDictionary objectForKey:@"Wapinr"]];
                                            [tempWCMWorkApplicationListDictionary addEntriesFromDictionary:headerDictionary];
                                        }
                                        else{
                                            [tempWCMWorkApplicationListDictionary setObject:[NSMutableDictionary dictionaryWithDictionary:headerDictionary] forKey:[headerDictionary objectForKey:@"Wapinr"]];
                                        }
                                    }
                                    else
                                    {
                                        [orderWCMWorkApplicationListDictionary setObject:[NSMutableDictionary dictionaryWithObject:[NSMutableDictionary dictionaryWithDictionary:headerDictionary] forKey:[headerDictionary objectForKey:@"Wapinr"]] forKey:[NSString stringWithFormat:@"%lld",[[headerDictionary objectForKey:@"Aufnr"] longLongValue]]];
                                    }
                                }
                            }
                        }
                    }
                    
                    [orderWcmWorkApplicationListArray removeAllObjects];
                    
                    ///
                    NSMutableDictionary *orderWCMIssuePermitsDictionary = [[NSMutableDictionary alloc] init];
                    responseObject = nil;
                    NSMutableDictionary *tempWCMIssuePermitsDictionary;
                    
                    if ([parsedDictionary objectForKey:@"resultIssuePermits"]) {
                        
                        
                        responseObject = [parsedDictionary objectForKey:@"resultIssuePermits"];
                        
                        
                        [orderWcmIssuePermitsArray addObjectsFromArray:responseObject];
                        
                        
                        for (int i=0; i<[orderWcmIssuePermitsArray count]; i++) {
                            
                            
                            if ([[orderWcmIssuePermitsArray objectAtIndex:i] isKindOfClass:[NSDictionary class]]) {
                                headerDictionary = [orderWcmIssuePermitsArray objectAtIndex:i];
                                if ([orderDetailDictionary objectForKey:[NSString stringWithFormat:@"%lld",[[headerDictionary objectForKey:@"Aufnr"] longLongValue]]]) {
                                    
                                    
                                    if ([orderWCMIssuePermitsDictionary objectForKey:[NSString stringWithFormat:@"%lld",[[headerDictionary objectForKey:@"Aufnr"] longLongValue]]]) {
                                        tempWCMIssuePermitsDictionary = [orderWCMIssuePermitsDictionary objectForKey:[NSString stringWithFormat:@"%lld",[[headerDictionary objectForKey:@"Aufnr"] longLongValue]]];
                                        if ([tempWCMIssuePermitsDictionary objectForKey:[headerDictionary objectForKey:@"Werks"]]) {
                                            
                                            tempWCMIssuePermitsDictionary = [tempWCMIssuePermitsDictionary objectForKey:[headerDictionary objectForKey:@"Werks"]];
                                            
                                            
                                            if ([tempWCMIssuePermitsDictionary objectForKey:@"Objects"]) {
                                                NSMutableArray *objectsArray = [tempWCMIssuePermitsDictionary objectForKey:@"Objects"];
                                                [objectsArray addObject:[NSMutableDictionary dictionaryWithDictionary:headerDictionary]];
                                            }
                                            else{
                                                
                                                
                                                [tempWCMIssuePermitsDictionary setObject:[NSMutableArray arrayWithObject:[NSMutableDictionary dictionaryWithDictionary:headerDictionary]] forKey:@"Objects"];
                                            }
                                        }
                                        else{
                                            
                                            
                                            [tempWCMIssuePermitsDictionary setObject:[NSMutableDictionary dictionaryWithDictionary:headerDictionary] forKey:[headerDictionary objectForKey:@"Werks"]];
                                        }
                                    }
                                    else
                                    {
                                        [orderWCMIssuePermitsDictionary setObject:[NSMutableDictionary dictionaryWithObject:[NSMutableDictionary dictionaryWithDictionary:headerDictionary] forKey:[headerDictionary objectForKey:@"Werks"]] forKey:[NSString stringWithFormat:@"%lld",[[headerDictionary objectForKey:@"Aufnr"] longLongValue]]];
                                    }
                                }
                            }
                        }
                    }
                    [orderWcmIssuePermitsArray removeAllObjects];
                    
                    //
                    
                    responseObject = [parsedDictionary objectForKey:@"resultOperationWCDItemData"];
                    
                    for (int i = 0; i<[responseObject count]; i++) {
                        NSMutableArray *orderDetailWCMOperationWCDTaggingConditionsArray = [NSMutableArray new];
                        
                        tempDictionary = [responseObject objectAtIndex:i];
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Wcnr"]]) {
                            [orderDetailWCMOperationWCDTaggingConditionsArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMOperationWCDTaggingConditionsArray addObject:[tempDictionary objectForKey:@"Wcnr"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Wcitm"]]) {
                            [orderDetailWCMOperationWCDTaggingConditionsArray addObject:@""];
                        }
                        else{
                            
                            [orderDetailWCMOperationWCDTaggingConditionsArray addObject:[tempDictionary objectForKey:@"Wcitm"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Objnr"]]) {
                            [orderDetailWCMOperationWCDTaggingConditionsArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMOperationWCDTaggingConditionsArray addObject:[tempDictionary objectForKey:@"Objnr"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Itmtyp"]]) {
                            [orderDetailWCMOperationWCDTaggingConditionsArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMOperationWCDTaggingConditionsArray addObject:[tempDictionary objectForKey:@"Itmtyp"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Seq"]]) {
                            [orderDetailWCMOperationWCDTaggingConditionsArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMOperationWCDTaggingConditionsArray addObject:[tempDictionary objectForKey:@"Seq"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Pred"]]) {
                            [orderDetailWCMOperationWCDTaggingConditionsArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMOperationWCDTaggingConditionsArray addObject:[tempDictionary objectForKey:@"Pred"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Succ"]]) {
                            [orderDetailWCMOperationWCDTaggingConditionsArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMOperationWCDTaggingConditionsArray addObject:[tempDictionary objectForKey:@"Succ"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Ccobj"]]) {
                            [orderDetailWCMOperationWCDTaggingConditionsArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMOperationWCDTaggingConditionsArray addObject:[tempDictionary objectForKey:@"Ccobj"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Cctyp"]]) {
                            [orderDetailWCMOperationWCDTaggingConditionsArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMOperationWCDTaggingConditionsArray addObject:[tempDictionary objectForKey:@"Cctyp"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Stxt"]]) {
                            [orderDetailWCMOperationWCDTaggingConditionsArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMOperationWCDTaggingConditionsArray addObject:[tempDictionary objectForKey:@"Stxt"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Tggrp"]]) {
                            [orderDetailWCMOperationWCDTaggingConditionsArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMOperationWCDTaggingConditionsArray addObject:[tempDictionary objectForKey:@"Tggrp"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Tgstep"]]) {
                            [orderDetailWCMOperationWCDTaggingConditionsArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMOperationWCDTaggingConditionsArray addObject:[tempDictionary objectForKey:@"Tgstep"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Tgproc"]]) {
                            [orderDetailWCMOperationWCDTaggingConditionsArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMOperationWCDTaggingConditionsArray addObject:[tempDictionary objectForKey:@"Tgproc"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Tgtyp"]]) {
                            [orderDetailWCMOperationWCDTaggingConditionsArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMOperationWCDTaggingConditionsArray addObject:[tempDictionary objectForKey:@"Tgtyp"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Tgseq"]]) {
                            [orderDetailWCMOperationWCDTaggingConditionsArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMOperationWCDTaggingConditionsArray addObject:[tempDictionary objectForKey:@"Tgseq"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Tgtxt"]]) {
                            [orderDetailWCMOperationWCDTaggingConditionsArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMOperationWCDTaggingConditionsArray addObject:[tempDictionary objectForKey:@"Tgtxt"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Unstep"]]) {
                            [orderDetailWCMOperationWCDTaggingConditionsArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMOperationWCDTaggingConditionsArray addObject:[tempDictionary objectForKey:@"Unstep"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Unproc"]]) {
                            [orderDetailWCMOperationWCDTaggingConditionsArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMOperationWCDTaggingConditionsArray addObject:[tempDictionary objectForKey:@"Unproc"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Untyp"]]) {
                            [orderDetailWCMOperationWCDTaggingConditionsArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMOperationWCDTaggingConditionsArray addObject:[tempDictionary objectForKey:@"Untyp"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Unseq"]]) {
                            [orderDetailWCMOperationWCDTaggingConditionsArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMOperationWCDTaggingConditionsArray addObject:[tempDictionary objectForKey:@"Unseq"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Untxt"]]) {
                            [orderDetailWCMOperationWCDTaggingConditionsArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMOperationWCDTaggingConditionsArray addObject:[tempDictionary objectForKey:@"Untxt"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Phblflg"]]) {
                            [orderDetailWCMOperationWCDTaggingConditionsArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMOperationWCDTaggingConditionsArray addObject:[tempDictionary objectForKey:@"Phblflg"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Phbltyp"]]) {
                            [orderDetailWCMOperationWCDTaggingConditionsArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMOperationWCDTaggingConditionsArray addObject:[tempDictionary objectForKey:@"Phbltyp"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Phblnr"]]) {
                            [orderDetailWCMOperationWCDTaggingConditionsArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMOperationWCDTaggingConditionsArray addObject:[tempDictionary objectForKey:@"Phblnr"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Tgflg"]]) {
                            [orderDetailWCMOperationWCDTaggingConditionsArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMOperationWCDTaggingConditionsArray addObject:[tempDictionary objectForKey:@"Tgflg"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Tgform"]]) {
                            [orderDetailWCMOperationWCDTaggingConditionsArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMOperationWCDTaggingConditionsArray addObject:[tempDictionary objectForKey:@"Tgform"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Tgnr"]]) {
                            [orderDetailWCMOperationWCDTaggingConditionsArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMOperationWCDTaggingConditionsArray addObject:[tempDictionary objectForKey:@"Tgnr"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Unform"]]) {
                            [orderDetailWCMOperationWCDTaggingConditionsArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMOperationWCDTaggingConditionsArray addObject:[tempDictionary objectForKey:@"Unform"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Unnr"]]) {
                            [orderDetailWCMOperationWCDTaggingConditionsArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMOperationWCDTaggingConditionsArray addObject:[tempDictionary objectForKey:@"Unnr"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Control"]]) {
                            [orderDetailWCMOperationWCDTaggingConditionsArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMOperationWCDTaggingConditionsArray addObject:[tempDictionary objectForKey:@"Control"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Location"]]) {
                            [orderDetailWCMOperationWCDTaggingConditionsArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMOperationWCDTaggingConditionsArray addObject:[tempDictionary objectForKey:@"Location"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Btg"]]) {
                            [orderDetailWCMOperationWCDTaggingConditionsArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMOperationWCDTaggingConditionsArray addObject:[tempDictionary objectForKey:@"Btg"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Etg"]]) {
                            [orderDetailWCMOperationWCDTaggingConditionsArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMOperationWCDTaggingConditionsArray addObject:[tempDictionary objectForKey:@"Etg"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Bug"]]) {
                            [orderDetailWCMOperationWCDTaggingConditionsArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMOperationWCDTaggingConditionsArray addObject:[tempDictionary objectForKey:@"Bug"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Eug"]]) {
                            [orderDetailWCMOperationWCDTaggingConditionsArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMOperationWCDTaggingConditionsArray addObject:[tempDictionary objectForKey:@"Eug"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Refobj"]]) {
                            [orderDetailWCMOperationWCDTaggingConditionsArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMOperationWCDTaggingConditionsArray addObject:[tempDictionary objectForKey:@"Refobj"]];
                        }
                        
                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Action"]]) {
                            [orderDetailWCMOperationWCDTaggingConditionsArray addObject:@""];
                        }
                        else{
                            [orderDetailWCMOperationWCDTaggingConditionsArray addObject:[tempDictionary objectForKey:@"Action"]];
                        }
                        
                        [orderWcmOperationWCDTaggingConditionsArray addObject:orderDetailWCMOperationWCDTaggingConditionsArray];
                    }
                    
                    ///
                    responseObject = nil;
                    
                    if ([parsedDictionary objectForKey:@"resultStandardCheckPoints"])
                    {
                        
                        responseObject = [parsedDictionary objectForKey:@"resultStandardCheckPoints"];
                        
                        for (int i = 0; i<[responseObject  count]; i++) {
                            
                            NSMutableArray *orderDetailWCMStandardCheckPointsArray = [NSMutableArray new];
                            
                            tempDictionary = [responseObject objectAtIndex:i];
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Wapinr"]]) {
                                [orderDetailWCMStandardCheckPointsArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMStandardCheckPointsArray addObject:[tempDictionary objectForKey:@"Wapinr"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Wapityp"]]) {
                                [orderDetailWCMStandardCheckPointsArray addObject:@""];
                            }
                            else{
                                
                                [orderDetailWCMStandardCheckPointsArray addObject:[tempDictionary objectForKey:@"Wapityp"]];
                            }
                            
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"ChkPointType"]]) {
                                [orderDetailWCMStandardCheckPointsArray addObject:@""];
                            }
                            else{
                                
                                [orderDetailWCMStandardCheckPointsArray addObject:[tempDictionary objectForKey:@"ChkPointType"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Wkid"]]) {
                                [orderDetailWCMStandardCheckPointsArray addObject:@""];
                            }
                            else{
                                
                                [orderDetailWCMStandardCheckPointsArray addObject:[tempDictionary objectForKey:@"Wkid"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Needid"]]) {
                                [orderDetailWCMStandardCheckPointsArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMStandardCheckPointsArray addObject:[tempDictionary objectForKey:@"Needid"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Value"]]) {
                                [orderDetailWCMStandardCheckPointsArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMStandardCheckPointsArray addObject:[tempDictionary objectForKey:@"Value"]];
                            }
                            
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Desctext"]]) {
                                [orderDetailWCMStandardCheckPointsArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMStandardCheckPointsArray addObject:[tempDictionary objectForKey:@"Desctext"]];
                            }
                            
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Wkgrp"]]) {
                                [orderDetailWCMStandardCheckPointsArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMStandardCheckPointsArray addObject:[tempDictionary objectForKey:@"Wkgrp"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Needgrp"]]) {
                                [orderDetailWCMStandardCheckPointsArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMStandardCheckPointsArray addObject:[tempDictionary objectForKey:@"Needgrp"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Tplnr"]]) {
                                [orderDetailWCMStandardCheckPointsArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMStandardCheckPointsArray addObject:[tempDictionary objectForKey:@"Tplnr"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Equnr"]]) {
                                [orderDetailWCMStandardCheckPointsArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMStandardCheckPointsArray addObject:[tempDictionary objectForKey:@"Equnr"]];
                            }
                            
                            [orderDetailWCMStandardCheckPointsArray addObject:@""];
                            
                            [orderDetailWCMStandardCheckPointsArray addObject:@""];
                            
                            
                            [orderWcmPermitsStandardCheckPoints addObject:orderDetailWCMStandardCheckPointsArray];
                        }
                    }
                    
                    
                    NSMutableDictionary *orderWCMOperationWCDDictionary = [[NSMutableDictionary alloc] init];
                    responseObject = nil;
                    
                    NSMutableDictionary *tempWCMOperationWCDDictionary;
                    
                    if ([parsedDictionary objectForKey:@"resultOperationWCDData"]) {
                        
                        responseObject = [parsedDictionary objectForKey:@"resultOperationWCDData"];
                        
                        [orderWcmOperationWCDArray addObjectsFromArray:responseObject];
                        
                        for (int i=0; i<[orderWcmOperationWCDArray count]; i++) {
                            
                            if ([[orderWcmOperationWCDArray objectAtIndex:i] isKindOfClass:[NSDictionary class]]) {
                                headerDictionary = [orderWcmOperationWCDArray objectAtIndex:i];
                                if ([orderDetailDictionary objectForKey:[NSString stringWithFormat:@"%lld",[[headerDictionary objectForKey:@"Aufnr"] longLongValue]]]) {
                                    if ([orderWCMOperationWCDDictionary objectForKey:[NSString stringWithFormat:@"%lld",[[headerDictionary objectForKey:@"Aufnr"] longLongValue]]]) {
                                        tempWCMOperationWCDDictionary = [orderWCMOperationWCDDictionary objectForKey:[NSString stringWithFormat:@"%lld",[[headerDictionary objectForKey:@"Aufnr"] longLongValue]]];
                                        if ([tempWCMOperationWCDDictionary objectForKey:[headerDictionary objectForKey:@"Wcnr"]]) {
                                            tempWCMOperationWCDDictionary = [tempWCMOperationWCDDictionary objectForKey:[headerDictionary objectForKey:@"Wcnr"]];
                                            [tempWCMOperationWCDDictionary addEntriesFromDictionary:headerDictionary];
                                        }
                                        else{
                                            [tempWCMOperationWCDDictionary setObject:[NSMutableDictionary dictionaryWithDictionary:headerDictionary] forKey:[headerDictionary objectForKey:@"Wcnr"]];
                                        }
                                    }
                                    else
                                    {
                                        [orderWCMOperationWCDDictionary setObject:[NSMutableDictionary dictionaryWithObject:[NSMutableDictionary dictionaryWithDictionary:headerDictionary] forKey:[headerDictionary objectForKey:@"Wcnr"]] forKey:[NSString stringWithFormat:@"%lld",[[headerDictionary objectForKey:@"Aufnr"] longLongValue]]];
                                    }
                                }
                            }
                        }
                    }
                    
                    [orderWcmOperationWCDArray removeAllObjects];
                    
                    ///
                    responseObject = nil;
                    
                    NSMutableDictionary *orderStatusDictionary = [[NSMutableDictionary alloc] init];
                    
                    NSMutableDictionary *tempOrderStatusDictionary;
                    
                    if ([parsedDictionary objectForKey:@"resultOrderStatus"]) {
                        
                        responseObject = [parsedDictionary objectForKey:@"resultOrderStatus"];
                        
                        [orderStatusArray addObjectsFromArray:responseObject];
                        
                        for (int i=0; i<[orderStatusArray count]; i++) {
                            
                            if ([[orderStatusArray objectAtIndex:i] isKindOfClass:[NSDictionary class]]) {
                                
                                headerDictionary = [orderStatusArray objectAtIndex:i];
                                
                                if ([orderDetailDictionary objectForKey:[headerDictionary objectForKey:@"Aufnr"]]) {
                                    
                                    if ([orderStatusDictionary objectForKey:[headerDictionary objectForKey:@"Aufnr"]]) {
                                        
                                        tempOrderStatusDictionary = [orderStatusDictionary objectForKey:[headerDictionary objectForKey:@"Aufnr"]];
                                        
                                        if ([tempOrderStatusDictionary objectForKey:[headerDictionary objectForKey:@"Objnr"]]) {
                                            
                                            tempOrderStatusDictionary = [tempOrderStatusDictionary objectForKey:[headerDictionary objectForKey:@"Objnr"]];
                                            
                                            if ([tempOrderStatusDictionary objectForKey:@"SystemStatus"]) {
                                                
                                                NSMutableArray *systemStatusArray = [tempOrderStatusDictionary objectForKey:@"SystemStatus"];
                                                
                                                [systemStatusArray addObject:[NSMutableDictionary dictionaryWithDictionary:headerDictionary]];
                                            }
                                            else
                                            {
                                                [tempOrderStatusDictionary setObject:[NSMutableArray arrayWithObject:[NSMutableDictionary dictionaryWithDictionary:headerDictionary]] forKey:@"SystemStatus"];
                                            }
                                        }
                                        else
                                        {
                                            [tempOrderStatusDictionary setObject:[NSMutableDictionary dictionaryWithDictionary:headerDictionary] forKey:[headerDictionary objectForKey:@"Objnr"]];
                                        }
                                    }
                                    else
                                    {
                                        [orderStatusDictionary setObject:[NSMutableDictionary dictionaryWithObject:[NSMutableDictionary dictionaryWithDictionary:headerDictionary] forKey:[headerDictionary objectForKey:@"Objnr"]] forKey:[headerDictionary objectForKey:@"Aufnr"]];
                                    }
                                }
                            }
                        }
                    }
                    
                    [orderStatusArray removeAllObjects];
                    
                    if ([parsedDictionary objectForKey:@"resultLongText"]) {
                        
                        responseObject = [parsedDictionary objectForKey:@"resultLongText"];
                        
                        NSMutableArray *orderTextnArray = [[NSMutableArray alloc] init];
                        if ([responseObject isKindOfClass:[NSDictionary class]]) {
                            [orderTextnArray addObject:responseObject];
                        }
                        else if ([responseObject isKindOfClass:[NSArray class]])
                        {
                            [orderTextnArray addObjectsFromArray:responseObject];
                        }
                        
                        NSDictionary *textDictionary;
                        for (int i=0; i<[orderTextnArray count]; i++) {
                            if ([[orderTextnArray objectAtIndex:i] isKindOfClass:[NSDictionary class]]) {
                                textDictionary = [orderTextnArray objectAtIndex:i];
                                if ([orderDetailDictionary objectForKey:[textDictionary objectForKey:@"Aufnr"]]) {
                                    if ([textDictionary objectForKey:@"Activity"]) {
                                        tempDictionary = [orderTransactionDictionary objectForKey:[textDictionary objectForKey:@"Aufnr"]];
                                        if (tempDictionary) {
                                            tempDictionary = [tempDictionary objectForKey:[textDictionary objectForKey:@"Activity"]];
                                            if (tempDictionary) {
                                                id longText = [tempDictionary objectForKey:@"OPTLONGTEXT"];
                                                NSString *textLine = [textDictionary objectForKey:@"TextLine"];
                                                if (!textLine.length) {
                                                    textLine = @"";
                                                }
                                                if ([longText length]) {
                                                    [tempDictionary setObject:[NSString stringWithFormat:@"%@\n%@",longText,textLine] forKey:@"OPTLONGTEXT"];
                                                }
                                                else
                                                {
                                                    [tempDictionary setObject:[NSString stringWithString:textLine] forKey:@"OPTLONGTEXT"];
                                                }
                                            }
                                        }
                                    }
                                    else
                                    {
                                        NSMutableDictionary *headerDictionary = [[orderDetailDictionary objectForKey:[textDictionary objectForKey:@"Aufnr"]] firstObject];
                                        NSString *textLine = [textDictionary objectForKey:@"TextLine"];
                                        
                                        if (!textLine.length) {
                                            textLine = @"";
                                        }
                                        
                                        if ([[headerDictionary objectForKey:@"LONGTEXT"] length]) {
                                            [headerDictionary setObject:[NSString stringWithFormat:@"%@\n%@",[headerDictionary objectForKey:@"LONGTEXT"],textLine] forKey:@"LONGTEXT"];
                                        }
                                        else
                                        {
                                            [headerDictionary setObject:[NSString stringWithFormat:@"%@",textLine] forKey:@"LONGTEXT"];
                                        }
                                    }
                                }
                            }
                        }
                        
                        [orderTransactionArray removeAllObjects];
                    }
                    
                    /////
                    responseObject = nil;
                    
                    [orderWcmWorkApplicationListArray addObjectsFromArray:[orderWCMWorkApplicationListDictionary allKeys]];
                    
                    NSArray *recordIDWCMWorkApplicationListArray;
                    NSDictionary *WCMWorkApplicationListDictionary;
                    
                    for (int i =0; i<[orderWcmWorkApplicationListArray  count]; i++) {
                        
                        NSMutableArray *wcmWorkApplicationListArray = [NSMutableArray new];
                        
                        WCMWorkApplicationListDictionary = [orderWCMWorkApplicationListDictionary objectForKey:[orderWcmWorkApplicationListArray objectAtIndex:i]];
                        recordIDWCMWorkApplicationListArray = [WCMWorkApplicationListDictionary allKeys];
                        
                        for (int j=0; j<[recordIDWCMWorkApplicationListArray count]; j++) {
                            
                            NSMutableArray *orderDetailWCMWorkApplicationListArray = [NSMutableArray new];
                            
                            tempDictionary = [WCMWorkApplicationListDictionary objectForKey:[recordIDWCMWorkApplicationListArray objectAtIndex:j]];
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Aufnr"]]) {
                                [orderDetailWCMWorkApplicationListArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMWorkApplicationListArray addObject:[NSString stringWithFormat:@"%lld",[[tempDictionary objectForKey:@"Aufnr"] longLongValue]]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Objart"]]) {
                                [orderDetailWCMWorkApplicationListArray addObject:@""];
                            }
                            else{
                                
                                [orderDetailWCMWorkApplicationListArray addObject:[tempDictionary objectForKey:@"Objart"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Wapinr"]]) {
                                [orderDetailWCMWorkApplicationListArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMWorkApplicationListArray addObject:[tempDictionary objectForKey:@"Wapinr"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Iwerk"]]) {
                                [orderDetailWCMWorkApplicationListArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMWorkApplicationListArray addObject:[tempDictionary objectForKey:@"Iwerk"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Objtyp"]]) {
                                [orderDetailWCMWorkApplicationListArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMWorkApplicationListArray addObject:[tempDictionary objectForKey:@"Objtyp"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Usage"]]) {
                                [orderDetailWCMWorkApplicationListArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMWorkApplicationListArray addObject:[tempDictionary objectForKey:@"Usage"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Usagex"]]) {
                                [orderDetailWCMWorkApplicationListArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMWorkApplicationListArray addObject:[tempDictionary objectForKey:@"Usagex"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Train"]]) {
                                [orderDetailWCMWorkApplicationListArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMWorkApplicationListArray addObject:[tempDictionary objectForKey:@"Train"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Trainx"]]) {
                                [orderDetailWCMWorkApplicationListArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMWorkApplicationListArray addObject:[tempDictionary objectForKey:@"Trainx"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Anlzu"]]) {
                                [orderDetailWCMWorkApplicationListArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMWorkApplicationListArray addObject:[tempDictionary objectForKey:@"Anlzu"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Anlzux"]]) {
                                [orderDetailWCMWorkApplicationListArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMWorkApplicationListArray addObject:[tempDictionary objectForKey:@"Anlzux"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Etape"]]) {
                                [orderDetailWCMWorkApplicationListArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMWorkApplicationListArray addObject:[tempDictionary objectForKey:@"Etape"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Etapex"]]) {
                                [orderDetailWCMWorkApplicationListArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMWorkApplicationListArray addObject:[tempDictionary objectForKey:@"Etapex"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Stxt"]]) {
                                [orderDetailWCMWorkApplicationListArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMWorkApplicationListArray addObject:[tempDictionary objectForKey:@"Stxt"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Datefr"]]) {
                                [orderDetailWCMWorkApplicationListArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMWorkApplicationListArray addObject:[tempDictionary objectForKey:@"Datefr"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Timefr"]]) {
                                [orderDetailWCMWorkApplicationListArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMWorkApplicationListArray addObject:[tempDictionary objectForKey:@"Timefr"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Dateto"]]) {
                                [orderDetailWCMWorkApplicationListArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMWorkApplicationListArray addObject:[tempDictionary objectForKey:@"Dateto"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Timeto"]]) {
                                [orderDetailWCMWorkApplicationListArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMWorkApplicationListArray addObject:[tempDictionary objectForKey:@"Timeto"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Priok"]]) {
                                [orderDetailWCMWorkApplicationListArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMWorkApplicationListArray addObject:[tempDictionary objectForKey:@"Priok"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Priokx"]]) {
                                [orderDetailWCMWorkApplicationListArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMWorkApplicationListArray addObject:[tempDictionary objectForKey:@"Priokx"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Rctime"]]) {
                                [orderDetailWCMWorkApplicationListArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMWorkApplicationListArray addObject:[tempDictionary objectForKey:@"Rctime"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Rcunit"]]) {
                                [orderDetailWCMWorkApplicationListArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMWorkApplicationListArray addObject:[tempDictionary objectForKey:@"Rcunit"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Objnr"]]) {
                                [orderDetailWCMWorkApplicationListArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMWorkApplicationListArray addObject:[tempDictionary objectForKey:@"Objnr"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Refobj"]]) {
                                [orderDetailWCMWorkApplicationListArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMWorkApplicationListArray addObject:[tempDictionary objectForKey:@"Refobj"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Crea"]]) {
                                [orderDetailWCMWorkApplicationListArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMWorkApplicationListArray addObject:[tempDictionary objectForKey:@"Crea"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Prep"]]) {
                                [orderDetailWCMWorkApplicationListArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMWorkApplicationListArray addObject:[tempDictionary objectForKey:@"Prep"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Comp"]]) {
                                [orderDetailWCMWorkApplicationListArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMWorkApplicationListArray addObject:[tempDictionary objectForKey:@"Comp"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Appr"]]) {
                                [orderDetailWCMWorkApplicationListArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMWorkApplicationListArray addObject:[tempDictionary objectForKey:@"Appr"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Action"]]) {
                                [orderDetailWCMWorkApplicationListArray addObject:@""];//Action
                            }
                            else{
                                [orderDetailWCMWorkApplicationListArray addObject:[tempDictionary objectForKey:@"Action"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Begru"]]) {
                                [orderDetailWCMWorkApplicationListArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMWorkApplicationListArray addObject:[tempDictionary objectForKey:@"Begru"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Begtx"]]) {
                                [orderDetailWCMWorkApplicationListArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMWorkApplicationListArray addObject:[tempDictionary objectForKey:@"Begtx"]];
                            }
                            
                            [wcmWorkApplicationListArray addObject:orderDetailWCMWorkApplicationListArray];
                        }
                        
                        [[orderDetailDictionary objectForKey:[orderWcmWorkApplicationListArray objectAtIndex:i]] replaceObjectAtIndex:8 withObject:wcmWorkApplicationListArray];
                    }
                    
                    [orderWcmWorkApplicationListArray removeAllObjects];
                    
                    /////
                    responseObject = nil;
                    
                    [orderWcmOperationWCDArray addObjectsFromArray:[orderWCMOperationWCDDictionary allKeys]];
                    
                    NSArray *recordIDWCMOperationWCDListArray;
                    NSDictionary *WCMOperationWCDListDictionary;
                    
                    for (int i =0; i<[orderWcmOperationWCDArray  count]; i++) {
                        
                        NSMutableArray *wcmOperationWCDListArray = [NSMutableArray new];
                        
                        WCMOperationWCDListDictionary = [orderWCMOperationWCDDictionary objectForKey:[orderWcmOperationWCDArray objectAtIndex:i]];
                        recordIDWCMOperationWCDListArray = [WCMOperationWCDListDictionary allKeys];
                        
                        for (int j=0; j<[recordIDWCMOperationWCDListArray count]; j++) {
                            
                            NSMutableArray *orderDetailWCMOperationWCDListArray = [NSMutableArray new];
                            
                            tempDictionary = [WCMOperationWCDListDictionary objectForKey:[recordIDWCMOperationWCDListArray objectAtIndex:j]];
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Aufnr"]]) {
                                [orderDetailWCMOperationWCDListArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMOperationWCDListArray addObject:[NSString stringWithFormat:@"%lld",[[tempDictionary objectForKey:@"Aufnr"] longLongValue]]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Objart"]]) {
                                [orderDetailWCMOperationWCDListArray addObject:@""];
                            }
                            else{
                                
                                [orderDetailWCMOperationWCDListArray addObject:[tempDictionary objectForKey:@"Objart"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Wcnr"]]) {
                                [orderDetailWCMOperationWCDListArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMOperationWCDListArray addObject:[tempDictionary objectForKey:@"Wcnr"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Iwerk"]]) {
                                [orderDetailWCMOperationWCDListArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMOperationWCDListArray addObject:[tempDictionary objectForKey:@"Iwerk"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Objtyp"]]) {
                                [orderDetailWCMOperationWCDListArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMOperationWCDListArray addObject:[tempDictionary objectForKey:@"Objtyp"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Usage"]]) {
                                [orderDetailWCMOperationWCDListArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMOperationWCDListArray addObject:[tempDictionary objectForKey:@"Usage"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Usagex"]]) {
                                [orderDetailWCMOperationWCDListArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMOperationWCDListArray addObject:[tempDictionary objectForKey:@"Usagex"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Train"]]) {
                                [orderDetailWCMOperationWCDListArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMOperationWCDListArray addObject:[tempDictionary objectForKey:@"Train"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Trainx"]]) {
                                [orderDetailWCMOperationWCDListArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMOperationWCDListArray addObject:[tempDictionary objectForKey:@"Trainx"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Anlzu"]]) {
                                [orderDetailWCMOperationWCDListArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMOperationWCDListArray addObject:[tempDictionary objectForKey:@"Anlzu"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Anlzux"]]) {
                                [orderDetailWCMOperationWCDListArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMOperationWCDListArray addObject:[tempDictionary objectForKey:@"Anlzux"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Etape"]]) {
                                [orderDetailWCMOperationWCDListArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMOperationWCDListArray addObject:[tempDictionary objectForKey:@"Etape"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Etapex"]]) {
                                [orderDetailWCMOperationWCDListArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMOperationWCDListArray addObject:[tempDictionary objectForKey:@"Etapex"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Stxt"]]) {
                                [orderDetailWCMOperationWCDListArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMOperationWCDListArray addObject:[tempDictionary objectForKey:@"Stxt"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Datefr"]]) {
                                [orderDetailWCMOperationWCDListArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMOperationWCDListArray addObject:[tempDictionary objectForKey:@"Datefr"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Timefr"]]) {
                                [orderDetailWCMOperationWCDListArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMOperationWCDListArray addObject:[tempDictionary objectForKey:@"Timefr"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Dateto"]]) {
                                [orderDetailWCMOperationWCDListArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMOperationWCDListArray addObject:[tempDictionary objectForKey:@"Dateto"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Timeto"]]) {
                                [orderDetailWCMOperationWCDListArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMOperationWCDListArray addObject:[tempDictionary objectForKey:@"Timeto"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Priok"]]) {
                                [orderDetailWCMOperationWCDListArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMOperationWCDListArray addObject:[tempDictionary objectForKey:@"Priok"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Priokx"]]) {
                                [orderDetailWCMOperationWCDListArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMOperationWCDListArray addObject:[tempDictionary objectForKey:@"Priokx"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Rctime"]]) {
                                [orderDetailWCMOperationWCDListArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMOperationWCDListArray addObject:[tempDictionary objectForKey:@"Rctime"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Rcunit"]]) {
                                [orderDetailWCMOperationWCDListArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMOperationWCDListArray addObject:[tempDictionary objectForKey:@"Rcunit"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Objnr"]]) {
                                [orderDetailWCMOperationWCDListArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMOperationWCDListArray addObject:[tempDictionary objectForKey:@"Objnr"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Refobj"]]) {
                                [orderDetailWCMOperationWCDListArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMOperationWCDListArray addObject:[tempDictionary objectForKey:@"Refobj"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Crea"]]) {
                                [orderDetailWCMOperationWCDListArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMOperationWCDListArray addObject:[tempDictionary objectForKey:@"Crea"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Prep"]]) {
                                [orderDetailWCMOperationWCDListArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMOperationWCDListArray addObject:[tempDictionary objectForKey:@"Prep"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Comp"]]) {
                                [orderDetailWCMOperationWCDListArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMOperationWCDListArray addObject:[tempDictionary objectForKey:@"Comp"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Appr"]]) {
                                [orderDetailWCMOperationWCDListArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMOperationWCDListArray addObject:[tempDictionary objectForKey:@"Appr"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Action"]]) {
                                [orderDetailWCMOperationWCDListArray addObject:@""];//Action
                            }
                            else{
                                [orderDetailWCMOperationWCDListArray addObject:[tempDictionary objectForKey:@"Action"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Begru"]]) {
                                [orderDetailWCMOperationWCDListArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMOperationWCDListArray addObject:[tempDictionary objectForKey:@"Begru"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Begtx"]]) {
                                [orderDetailWCMOperationWCDListArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMOperationWCDListArray addObject:[tempDictionary objectForKey:@"Begtx"]];
                            }
                            
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Tagtext"]]) {
                                [orderDetailWCMOperationWCDListArray addObject:@""];
                            }
                            else{
                                
                                id   responseTagObject = [tempDictionary objectForKey:@"Tagtext"];
                                
                                NSMutableArray *orderTagTextArray = [[NSMutableArray alloc] init];
                                if ([[responseTagObject objectForKey:@"item"] isKindOfClass:[NSDictionary class]]) {
                                    [orderTagTextArray addObject:[responseTagObject objectForKey:@"item"]];
                                }
                                else if ([[responseTagObject objectForKey:@"item"] isKindOfClass:[NSArray class]])
                                {
                                    [orderTagTextArray addObjectsFromArray:[responseTagObject objectForKey:@"item"]];
                                }
                                
                                NSMutableString *taggingText=[[NSMutableString alloc] initWithString:@""];
                                
                                for (int t=0; t<[orderTagTextArray count]; t++) {
                                    
                                    NSString *textLine = [[orderTagTextArray objectAtIndex:t] objectForKey:@"TextLine"];
                                    if (!textLine.length) {
                                        textLine = @"";
                                    }
                                    
                                    [taggingText appendString:[NSString stringWithFormat:@"%@\n",textLine]];
                                    
                                }
                                
                                [orderDetailWCMOperationWCDListArray addObject:taggingText];
                                
                            }
                            
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Untagtext"]]) {
                                [orderDetailWCMOperationWCDListArray addObject:@""];
                            }
                            else{
                                
                                id   responseUnTagObject = [tempDictionary objectForKey:@"Untagtext"];
                                
                                NSMutableArray *orderUnTagTextArray = [[NSMutableArray alloc] init];
                                if ([[responseUnTagObject objectForKey:@"item"] isKindOfClass:[NSDictionary class]]) {
                                    [orderUnTagTextArray addObject:[responseUnTagObject objectForKey:@"item"]];
                                }
                                else if ([[responseUnTagObject objectForKey:@"item"] isKindOfClass:[NSArray class]])
                                {
                                    [orderUnTagTextArray addObjectsFromArray:[responseUnTagObject objectForKey:@"item"]];
                                }
                                
                                NSMutableString *unTaggingText=[[NSMutableString alloc] initWithString:@""];
                                
                                for (int t=0; t<[orderUnTagTextArray count]; t++) {
                                    
                                    NSString *textLine = [[orderUnTagTextArray objectAtIndex:t] objectForKey:@"TextLine"];
                                    if (!textLine.length) {
                                        textLine = @"";
                                    }
                                    
                                    [unTaggingText appendString:[NSString stringWithFormat:@"%@\n",textLine]];
                                }
                                
                                [orderDetailWCMOperationWCDListArray addObject:unTaggingText];
                                
                            }
                            
                            
                            //                            CREATE TABLE "ORDER_WCM_OPERATIONWCD" ("orderwcm_header_id" VARCHAR,"orderwcm_objart" VARCHAR,"orderwcm_wcnr" VARCHAR,"orderwcm_iwerk" VARCHAR,"orderwcm_objtyp" VARCHAR,"orderwcm_usage" VARCHAR,"orderwcm_usagex" VARCHAR,"orderwcm_train" VARCHAR,"orderwcm_trainx" VARCHAR,"orderwcm_anlzu" VARCHAR,"orderwcm_anlzux" VARCHAR,"orderwcm_etape" VARCHAR,"orderwcm_etapex" VARCHAR,"orderwcm_stxt" VARCHAR,"orderwcm_datefr" VARCHAR,"orderwcm_timefr" VARCHAR,"orderwcm_dateto" VARCHAR,"orderwcm_timeto" VARCHAR,"orderwcm_priok" VARCHAR,"orderwcm_priokx" VARCHAR,"orderwcm_rctime" VARCHAR,"orderwcm_rcunit" VARCHAR,"orderwcm_objnr" VARCHAR,"orderwcm_refobj" VARCHAR,"orderwcm_crea" VARCHAR,"orderwcm_prep" VARCHAR,"orderwcm_comp" VARCHAR,"orderwcm_appr" VARCHAR,"orderwcm_action" VARCHAR, "orderwcm_Begru" VARCHAR, "orderwcm_Begtx" VARCHAR, "orderwcm_tagging_text" VARCHAR, "orderwcm_untagging_text" VARCHAR)
                            
                            [wcmOperationWCDListArray addObject:orderDetailWCMOperationWCDListArray];
                        }
                        
                        [[orderDetailDictionary objectForKey:[orderWcmOperationWCDArray objectAtIndex:i]] replaceObjectAtIndex:10 withObject:wcmOperationWCDListArray];
                    }
                    
                    [orderWcmWorkApplicationListArray removeAllObjects];
                    
                    /////
                    responseObject = nil;
                    
                    [orderWcmWorkApprovalListArray addObjectsFromArray:[orderWCMWorkApprovalListDictionary allKeys]];
                    
                    NSArray *recordIDWCMWorkApprovalListArray;
                    NSDictionary *WCMWorkApprovalListDictionary;
                    
                    for (int i =0; i<[orderWcmWorkApprovalListArray  count]; i++) {
                        
                        WCMWorkApprovalListDictionary = [orderWCMWorkApprovalListDictionary objectForKey:[orderWcmWorkApprovalListArray objectAtIndex:i]];
                        recordIDWCMWorkApprovalListArray = [WCMWorkApprovalListDictionary allKeys];
                        NSMutableArray *wcmWorkApprovalListArray = [NSMutableArray new];
                        
                        for (int j=0; j<[recordIDWCMWorkApprovalListArray count]; j++) {
                            
                            NSMutableArray *orderDetailWCMWorkApprovalListArray = [NSMutableArray new];
                            
                            tempDictionary = [WCMWorkApprovalListDictionary objectForKey:[recordIDWCMWorkApprovalListArray objectAtIndex:j]];
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Aufnr"]]) {
                                [orderDetailWCMWorkApprovalListArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMWorkApprovalListArray addObject:[NSString stringWithFormat:@"%lld",[[tempDictionary objectForKey:@"Aufnr"] longLongValue]]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Objart"]]) {
                                [orderDetailWCMWorkApprovalListArray addObject:@""];
                            }
                            else{
                                
                                [orderDetailWCMWorkApprovalListArray addObject:[tempDictionary objectForKey:@"Objart"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Wapnr"]]) {
                                [orderDetailWCMWorkApprovalListArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMWorkApprovalListArray addObject:[tempDictionary objectForKey:@"Wapnr"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Iwerk"]]) {
                                [orderDetailWCMWorkApprovalListArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMWorkApprovalListArray addObject:[tempDictionary objectForKey:@"Iwerk"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Usage"]]) {
                                [orderDetailWCMWorkApprovalListArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMWorkApprovalListArray addObject:[tempDictionary objectForKey:@"Usage"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Usagex"]]) {
                                [orderDetailWCMWorkApprovalListArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMWorkApprovalListArray addObject:[tempDictionary objectForKey:@"Usagex"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Train"]]) {
                                [orderDetailWCMWorkApprovalListArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMWorkApprovalListArray addObject:[tempDictionary objectForKey:@"Train"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Trainx"]]) {
                                [orderDetailWCMWorkApprovalListArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMWorkApprovalListArray addObject:[tempDictionary objectForKey:@"Trainx"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Anlzu"]]) {
                                [orderDetailWCMWorkApprovalListArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMWorkApprovalListArray addObject:[tempDictionary objectForKey:@"Anlzu"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Anlzux"]]) {
                                [orderDetailWCMWorkApprovalListArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMWorkApprovalListArray addObject:[tempDictionary objectForKey:@"Anlzux"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Etape"]]) {
                                [orderDetailWCMWorkApprovalListArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMWorkApprovalListArray addObject:[tempDictionary objectForKey:@"Etape"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Etapex"]]) {
                                [orderDetailWCMWorkApprovalListArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMWorkApprovalListArray addObject:[tempDictionary objectForKey:@"Etapex"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Stxt"]]) {
                                [orderDetailWCMWorkApprovalListArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMWorkApprovalListArray addObject:[tempDictionary objectForKey:@"Stxt"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Datefr"]]) {
                                [orderDetailWCMWorkApprovalListArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMWorkApprovalListArray addObject:[tempDictionary objectForKey:@"Datefr"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Timefr"]]) {
                                [orderDetailWCMWorkApprovalListArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMWorkApprovalListArray addObject:[tempDictionary objectForKey:@"Timefr"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Dateto"]]) {
                                [orderDetailWCMWorkApprovalListArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMWorkApprovalListArray addObject:[tempDictionary objectForKey:@"Dateto"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Timeto"]]) {
                                [orderDetailWCMWorkApprovalListArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMWorkApprovalListArray addObject:[tempDictionary objectForKey:@"Timeto"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Priok"]]) {
                                [orderDetailWCMWorkApprovalListArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMWorkApprovalListArray addObject:[tempDictionary objectForKey:@"Priok"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Priokx"]]) {
                                [orderDetailWCMWorkApprovalListArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMWorkApprovalListArray addObject:[tempDictionary objectForKey:@"Priokx"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Rctime"]]) {
                                [orderDetailWCMWorkApprovalListArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMWorkApprovalListArray addObject:[tempDictionary objectForKey:@"Rctime"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Rcunit"]]) {
                                [orderDetailWCMWorkApprovalListArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMWorkApprovalListArray addObject:[tempDictionary objectForKey:@"Rcunit"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Objnr"]]) {
                                [orderDetailWCMWorkApprovalListArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMWorkApprovalListArray addObject:[tempDictionary objectForKey:@"Objnr"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Refobj"]]) {
                                [orderDetailWCMWorkApprovalListArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMWorkApprovalListArray addObject:[tempDictionary objectForKey:@"Refobj"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Crea"]]) {
                                [orderDetailWCMWorkApprovalListArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMWorkApprovalListArray addObject:[tempDictionary objectForKey:@"Crea"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Prep"]]) {
                                [orderDetailWCMWorkApprovalListArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMWorkApprovalListArray addObject:[tempDictionary objectForKey:@"Prep"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Comp"]]) {
                                [orderDetailWCMWorkApprovalListArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMWorkApprovalListArray addObject:[tempDictionary objectForKey:@"Comp"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Appr"]]) {
                                [orderDetailWCMWorkApprovalListArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMWorkApprovalListArray addObject:[tempDictionary objectForKey:@"Appr"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Pappr"]]) {
                                [orderDetailWCMWorkApprovalListArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMWorkApprovalListArray addObject:[tempDictionary objectForKey:@"Pappr"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Action"]]) {
                                [orderDetailWCMWorkApprovalListArray addObject:@""];//Action
                            }
                            else{
                                [orderDetailWCMWorkApprovalListArray addObject:[tempDictionary objectForKey:@"Action"]];
                            }
                            
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Begru"]]) {
                                [orderDetailWCMWorkApprovalListArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMWorkApprovalListArray addObject:[tempDictionary objectForKey:@"Begru"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Begtx"]]) {
                                [orderDetailWCMWorkApprovalListArray addObject:@""];
                            }
                            else{
                                [orderDetailWCMWorkApprovalListArray addObject:[tempDictionary objectForKey:@"Begtx"]];
                            }
                            
                            
                            [wcmWorkApprovalListArray addObject:orderDetailWCMWorkApprovalListArray];
                        }
                        
                        [[orderDetailDictionary objectForKey:[orderWcmWorkApprovalListArray objectAtIndex:i]] replaceObjectAtIndex:1 withObject:wcmWorkApprovalListArray];
                    }
                    
                    [orderWcmWorkApprovalListArray removeAllObjects];
                    
                    /////
                    responseObject = nil;
                    
                    [orderWcmIssuePermitsArray addObjectsFromArray:[orderWCMIssuePermitsDictionary allKeys]];
                    
                    NSArray *recordIDWCMIssuePermitsArray;
                    NSDictionary *WCMIssuePermitsDictionary;
                    
                    for (int i =0; i<[orderWcmIssuePermitsArray  count]; i++) {
                        
                        WCMIssuePermitsDictionary = [orderWCMIssuePermitsDictionary objectForKey:[orderWcmIssuePermitsArray objectAtIndex:i]];
                        recordIDWCMIssuePermitsArray = [WCMIssuePermitsDictionary allKeys];
                        
                        NSMutableArray *wcmIssuePermitsArray = [NSMutableArray new];
                        
                        
                        for (int j=0; j<[recordIDWCMIssuePermitsArray count]; j++) {
                            
                            
                            tempDictionary = [WCMIssuePermitsDictionary objectForKey:[recordIDWCMIssuePermitsArray objectAtIndex:j]];
                            
                            
                            NSMutableArray *temPArray=[NSMutableArray new];
                            
                            
                            if ([tempDictionary isKindOfClass:[NSDictionary class]]){
                                
                                
                                if ([tempDictionary objectForKey:@"Objects"]) {
                                    
                                    
                                    [temPArray addObjectsFromArray:[tempDictionary objectForKey:@"Objects"]];
                                    
                                    
                                    for (int k=0; k<[temPArray count]; k++) {
                                        
                                        
                                        NSMutableArray *orderDetailWCMIssuePermitsArray = [NSMutableArray new];
                                        
                                        
                                        NSDictionary *tempObjectsDictionary = [temPArray objectAtIndex:k];
                                        
                                        
                                        if ([NullChecker isNull:[tempObjectsDictionary objectForKey:@"Aufnr"]]) {
                                            [orderDetailWCMIssuePermitsArray addObject:@""];
                                        }
                                        else{
                                            [orderDetailWCMIssuePermitsArray addObject:[NSString stringWithFormat:@"%lld",[[tempObjectsDictionary objectForKey:@"Aufnr"] longLongValue]]];
                                        }
                                        
                                        
                                        if ([NullChecker isNull:[tempObjectsDictionary objectForKey:@"Objnr"]]) {
                                            [orderDetailWCMIssuePermitsArray addObject:@""];
                                        }
                                        else{
                                            
                                            
                                            [orderDetailWCMIssuePermitsArray addObject:[tempObjectsDictionary objectForKey:@"Objnr"]];
                                        }
                                        
                                        
                                        if ([NullChecker isNull:[tempObjectsDictionary objectForKey:@"Counter"]]) {
                                            [orderDetailWCMIssuePermitsArray addObject:@""];
                                        }
                                        else{
                                            [orderDetailWCMIssuePermitsArray addObject:[tempObjectsDictionary objectForKey:@"Counter"]];
                                        }
                                        
                                        
                                        if ([NullChecker isNull:[tempObjectsDictionary objectForKey:@"Werks"]]) {
                                            [orderDetailWCMIssuePermitsArray addObject:@""];
                                        }
                                        else{
                                            [orderDetailWCMIssuePermitsArray addObject:[tempObjectsDictionary objectForKey:@"Werks"]];
                                        }
                                        
                                        
                                        if ([NullChecker isNull:[tempObjectsDictionary objectForKey:@"Crname"]]) {
                                            [orderDetailWCMIssuePermitsArray addObject:@""];
                                        }
                                        else{
                                            [orderDetailWCMIssuePermitsArray addObject:[tempObjectsDictionary objectForKey:@"Crname"]];
                                        }
                                        
                                        
                                        if ([NullChecker isNull:[tempObjectsDictionary objectForKey:@"Objart"]]) {
                                            [orderDetailWCMIssuePermitsArray addObject:@""];
                                        }
                                        else{
                                            [orderDetailWCMIssuePermitsArray addObject:[tempObjectsDictionary objectForKey:@"Objart"]];
                                        }
                                        
                                        
                                        if ([NullChecker isNull:[tempObjectsDictionary objectForKey:@"Objtyp"]]) {
                                            [orderDetailWCMIssuePermitsArray addObject:@""];
                                        }
                                        else{
                                            [orderDetailWCMIssuePermitsArray addObject:[tempObjectsDictionary objectForKey:@"Objtyp"]];
                                        }
                                        
                                        
                                        if ([NullChecker isNull:[tempObjectsDictionary objectForKey:@"Pmsog"]]) {
                                            [orderDetailWCMIssuePermitsArray addObject:@""];
                                        }
                                        else{
                                            [orderDetailWCMIssuePermitsArray addObject:[tempObjectsDictionary objectForKey:@"Pmsog"]];
                                        }
                                        
                                        
                                        if ([NullChecker isNull:[tempObjectsDictionary objectForKey:@"Gntxt"]]) {
                                            [orderDetailWCMIssuePermitsArray addObject:@""];
                                        }
                                        else{
                                            [orderDetailWCMIssuePermitsArray addObject:[tempObjectsDictionary objectForKey:@"Gntxt"]];
                                        }
                                        
                                        
                                        if ([NullChecker isNull:[tempObjectsDictionary objectForKey:@"Geniakt"]]) {
                                            [orderDetailWCMIssuePermitsArray addObject:@""];
                                        }
                                        else{
                                            [orderDetailWCMIssuePermitsArray addObject:[tempObjectsDictionary objectForKey:@"Geniakt"]];
                                        }
                                        
                                        
                                        if ([NullChecker isNull:[tempObjectsDictionary objectForKey:@"Genvname"]]) {
                                            [orderDetailWCMIssuePermitsArray addObject:@""];
                                        }
                                        else{
                                            [orderDetailWCMIssuePermitsArray addObject:[tempObjectsDictionary objectForKey:@"Genvname"]];
                                        }
                                        
                                        
                                        if ([NullChecker isNull:[tempObjectsDictionary objectForKey:@"Hilvl"]]) {
                                            [orderDetailWCMIssuePermitsArray addObject:@""];
                                        }
                                        else{
                                            [orderDetailWCMIssuePermitsArray addObject:[tempObjectsDictionary objectForKey:@"Hilvl"]];
                                        }
                                        
                                        
                                        if ([NullChecker isNull:[tempObjectsDictionary objectForKey:@"Procflg"]]) {
                                            [orderDetailWCMIssuePermitsArray addObject:@""];
                                        }
                                        else{
                                            [orderDetailWCMIssuePermitsArray addObject:[tempObjectsDictionary objectForKey:@"Procflg"]];
                                        }
                                        
                                        
                                        if ([NullChecker isNull:[tempObjectsDictionary objectForKey:@"Direction"]]) {
                                            [orderDetailWCMIssuePermitsArray addObject:@""];
                                        }
                                        else{
                                            [orderDetailWCMIssuePermitsArray addObject:[tempObjectsDictionary objectForKey:@"Direction"]];
                                        }
                                        
                                        
                                        if ([NullChecker isNull:[tempObjectsDictionary objectForKey:@"Copyflg"]]) {
                                            [orderDetailWCMIssuePermitsArray addObject:@""];
                                        }
                                        else{
                                            [orderDetailWCMIssuePermitsArray addObject:[tempObjectsDictionary objectForKey:@"Copyflg"]];
                                        }
                                        
                                        
                                        if ([NullChecker isNull:[tempObjectsDictionary objectForKey:@"Mandflg"]]) {
                                            [orderDetailWCMIssuePermitsArray addObject:@""];
                                        }
                                        else{
                                            [orderDetailWCMIssuePermitsArray addObject:[tempObjectsDictionary objectForKey:@"Mandflg"]];
                                        }
                                        
                                        
                                        if ([NullChecker isNull:[tempObjectsDictionary objectForKey:@"Deacflg"]]) {
                                            [orderDetailWCMIssuePermitsArray addObject:@""];
                                        }
                                        else{
                                            [orderDetailWCMIssuePermitsArray addObject:[tempObjectsDictionary objectForKey:@"Deacflg"]];
                                        }
                                        
                                        
                                        if ([NullChecker isNull:[tempObjectsDictionary objectForKey:@"Status"]]) {
                                            [orderDetailWCMIssuePermitsArray addObject:@""];
                                        }
                                        else{
                                            [orderDetailWCMIssuePermitsArray addObject:[tempObjectsDictionary objectForKey:@"Status"]];
                                        }
                                        
                                        
                                        if ([NullChecker isNull:[tempObjectsDictionary objectForKey:@"Asgnflg"]]) {
                                            [orderDetailWCMIssuePermitsArray addObject:@""];
                                        }
                                        else{
                                            [orderDetailWCMIssuePermitsArray addObject:[tempObjectsDictionary objectForKey:@"Asgnflg"]];
                                        }
                                        
                                        
                                        if ([NullChecker isNull:[tempObjectsDictionary objectForKey:@"Autoflg"]]) {
                                            [orderDetailWCMIssuePermitsArray addObject:@""];
                                        }
                                        else{
                                            [orderDetailWCMIssuePermitsArray addObject:[tempObjectsDictionary objectForKey:@"Autoflg"]];
                                        }
                                        
                                        
                                        if ([NullChecker isNull:[tempObjectsDictionary objectForKey:@"Agent"]]) {
                                            [orderDetailWCMIssuePermitsArray addObject:@""];
                                        }
                                        else{
                                            [orderDetailWCMIssuePermitsArray addObject:[tempObjectsDictionary objectForKey:@"Agent"]];
                                        }
                                        
                                        
                                        if ([NullChecker isNull:[tempObjectsDictionary objectForKey:@"Valflg"]]) {
                                            [orderDetailWCMIssuePermitsArray addObject:@""];
                                        }
                                        else{
                                            [orderDetailWCMIssuePermitsArray addObject:[tempObjectsDictionary objectForKey:@"Valflg"]];
                                        }
                                        
                                        
                                        if ([NullChecker isNull:[tempObjectsDictionary objectForKey:@"Wcmuse"]]) {
                                            [orderDetailWCMIssuePermitsArray addObject:@""];
                                        }
                                        else{
                                            [orderDetailWCMIssuePermitsArray addObject:[tempObjectsDictionary objectForKey:@"Wcmuse"]];
                                        }
                                        
                                        
                                        if ([NullChecker isNull:[tempObjectsDictionary objectForKey:@"Action"]]) {
                                            [orderDetailWCMIssuePermitsArray addObject:@""];
                                        }
                                        else{
                                            [orderDetailWCMIssuePermitsArray addObject:[tempObjectsDictionary objectForKey:@"Action"]];
                                        }
                                        
                                        
                                        [wcmIssuePermitsArray addObject:orderDetailWCMIssuePermitsArray];
                                    }
                                }
                                
                                
                                NSMutableArray *orderDetailWCMIssuePermitsArray = [NSMutableArray new];
                                
                                if ([NullChecker isNull:[tempDictionary objectForKey:@"Aufnr"]]) {
                                    [orderDetailWCMIssuePermitsArray addObject:@""];
                                }
                                else{
                                    [orderDetailWCMIssuePermitsArray addObject:[NSString stringWithFormat:@"%lld",[[tempDictionary objectForKey:@"Aufnr"] longLongValue]]];
                                }
                                
                                
                                if ([NullChecker isNull:[tempDictionary objectForKey:@"Objnr"]]) {
                                    [orderDetailWCMIssuePermitsArray addObject:@""];
                                }
                                else{
                                    
                                    
                                    [orderDetailWCMIssuePermitsArray addObject:[tempDictionary objectForKey:@"Objnr"]];
                                }
                                
                                
                                if ([NullChecker isNull:[tempDictionary objectForKey:@"Counter"]]) {
                                    [orderDetailWCMIssuePermitsArray addObject:@""];
                                }
                                else{
                                    [orderDetailWCMIssuePermitsArray addObject:[tempDictionary objectForKey:@"Counter"]];
                                }
                                
                                
                                if ([NullChecker isNull:[tempDictionary objectForKey:@"Werks"]]) {
                                    [orderDetailWCMIssuePermitsArray addObject:@""];
                                }
                                else{
                                    [orderDetailWCMIssuePermitsArray addObject:[tempDictionary objectForKey:@"Werks"]];
                                }
                                
                                
                                if ([NullChecker isNull:[tempDictionary objectForKey:@"Crname"]]) {
                                    [orderDetailWCMIssuePermitsArray addObject:@""];
                                }
                                else{
                                    [orderDetailWCMIssuePermitsArray addObject:[tempDictionary objectForKey:@"Crname"]];
                                }
                                
                                
                                if ([NullChecker isNull:[tempDictionary objectForKey:@"Objart"]]) {
                                    [orderDetailWCMIssuePermitsArray addObject:@""];
                                }
                                else{
                                    [orderDetailWCMIssuePermitsArray addObject:[tempDictionary objectForKey:@"Objart"]];
                                }
                                
                                
                                if ([NullChecker isNull:[tempDictionary objectForKey:@"Objtyp"]]) {
                                    [orderDetailWCMIssuePermitsArray addObject:@""];
                                }
                                else{
                                    [orderDetailWCMIssuePermitsArray addObject:[tempDictionary objectForKey:@"Objtyp"]];
                                }
                                
                                
                                if ([NullChecker isNull:[tempDictionary objectForKey:@"Pmsog"]]) {
                                    [orderDetailWCMIssuePermitsArray addObject:@""];
                                }
                                else{
                                    [orderDetailWCMIssuePermitsArray addObject:[tempDictionary objectForKey:@"Pmsog"]];
                                }
                                
                                
                                if ([NullChecker isNull:[tempDictionary objectForKey:@"Gntxt"]]) {
                                    [orderDetailWCMIssuePermitsArray addObject:@""];
                                }
                                else{
                                    [orderDetailWCMIssuePermitsArray addObject:[tempDictionary objectForKey:@"Gntxt"]];
                                }
                                
                                
                                if ([NullChecker isNull:[tempDictionary objectForKey:@"Geniakt"]]) {
                                    [orderDetailWCMIssuePermitsArray addObject:@""];
                                }
                                else{
                                    [orderDetailWCMIssuePermitsArray addObject:[tempDictionary objectForKey:@"Geniakt"]];
                                }
                                
                                
                                if ([NullChecker isNull:[tempDictionary objectForKey:@"Genvname"]]) {
                                    [orderDetailWCMIssuePermitsArray addObject:@""];
                                }
                                else{
                                    [orderDetailWCMIssuePermitsArray addObject:[tempDictionary objectForKey:@"Genvname"]];
                                }
                                
                                
                                if ([NullChecker isNull:[tempDictionary objectForKey:@"Hilvl"]]) {
                                    [orderDetailWCMIssuePermitsArray addObject:@""];
                                }
                                else{
                                    [orderDetailWCMIssuePermitsArray addObject:[tempDictionary objectForKey:@"Hilvl"]];
                                }
                                
                                
                                if ([NullChecker isNull:[tempDictionary objectForKey:@"Procflg"]]) {
                                    [orderDetailWCMIssuePermitsArray addObject:@""];
                                }
                                else{
                                    [orderDetailWCMIssuePermitsArray addObject:[tempDictionary objectForKey:@"Procflg"]];
                                }
                                
                                
                                if ([NullChecker isNull:[tempDictionary objectForKey:@"Direction"]]) {
                                    [orderDetailWCMIssuePermitsArray addObject:@""];
                                }
                                else{
                                    [orderDetailWCMIssuePermitsArray addObject:[tempDictionary objectForKey:@"Direction"]];
                                }
                                
                                
                                if ([NullChecker isNull:[tempDictionary objectForKey:@"Copyflg"]]) {
                                    [orderDetailWCMIssuePermitsArray addObject:@""];
                                }
                                else{
                                    [orderDetailWCMIssuePermitsArray addObject:[tempDictionary objectForKey:@"Copyflg"]];
                                }
                                
                                
                                if ([NullChecker isNull:[tempDictionary objectForKey:@"Mandflg"]]) {
                                    [orderDetailWCMIssuePermitsArray addObject:@""];
                                }
                                else{
                                    [orderDetailWCMIssuePermitsArray addObject:[tempDictionary objectForKey:@"Mandflg"]];
                                }
                                
                                
                                if ([NullChecker isNull:[tempDictionary objectForKey:@"Deacflg"]]) {
                                    [orderDetailWCMIssuePermitsArray addObject:@""];
                                }
                                else{
                                    [orderDetailWCMIssuePermitsArray addObject:[tempDictionary objectForKey:@"Deacflg"]];
                                }
                                
                                
                                if ([NullChecker isNull:[tempDictionary objectForKey:@"Status"]]) {
                                    [orderDetailWCMIssuePermitsArray addObject:@""];
                                }
                                else{
                                    [orderDetailWCMIssuePermitsArray addObject:[tempDictionary objectForKey:@"Status"]];
                                }
                                
                                
                                if ([NullChecker isNull:[tempDictionary objectForKey:@"Asgnflg"]]) {
                                    [orderDetailWCMIssuePermitsArray addObject:@""];
                                }
                                else{
                                    [orderDetailWCMIssuePermitsArray addObject:[tempDictionary objectForKey:@"Asgnflg"]];
                                }
                                
                                
                                if ([NullChecker isNull:[tempDictionary objectForKey:@"Autoflg"]]) {
                                    [orderDetailWCMIssuePermitsArray addObject:@""];
                                }
                                else{
                                    [orderDetailWCMIssuePermitsArray addObject:[tempDictionary objectForKey:@"Autoflg"]];
                                }
                                
                                
                                if ([NullChecker isNull:[tempDictionary objectForKey:@"Agent"]]) {
                                    [orderDetailWCMIssuePermitsArray addObject:@""];
                                }
                                else{
                                    [orderDetailWCMIssuePermitsArray addObject:[tempDictionary objectForKey:@"Agent"]];
                                }
                                
                                
                                if ([NullChecker isNull:[tempDictionary objectForKey:@"Valflg"]]) {
                                    [orderDetailWCMIssuePermitsArray addObject:@""];
                                }
                                else{
                                    [orderDetailWCMIssuePermitsArray addObject:[tempDictionary objectForKey:@"Valflg"]];
                                }
                                
                                
                                if ([NullChecker isNull:[tempDictionary objectForKey:@"Wcmuse"]]) {
                                    [orderDetailWCMIssuePermitsArray addObject:@""];
                                }
                                else{
                                    [orderDetailWCMIssuePermitsArray addObject:[tempDictionary objectForKey:@"Wcmuse"]];
                                }
                                
                                
                                if ([NullChecker isNull:[tempDictionary objectForKey:@"Action"]]) {
                                    [orderDetailWCMIssuePermitsArray addObject:@""];
                                }
                                else{
                                    [orderDetailWCMIssuePermitsArray addObject:[tempDictionary objectForKey:@"Action"]];
                                }
                                
                                
                                [wcmIssuePermitsArray addObject:orderDetailWCMIssuePermitsArray];
                            }
                            
                            
                            [[orderDetailDictionary objectForKey:[orderWcmIssuePermitsArray objectAtIndex:i]] replaceObjectAtIndex:9 withObject:wcmIssuePermitsArray];
                            
                        }
                    }
                    [orderWcmIssuePermitsArray removeAllObjects];
                    
                    //////////
                    [orderDocsArray addObjectsFromArray:[orderDocsDictionary allKeys]];
                    NSArray *recordIDDocsArray;
                    NSDictionary *docsDictionary;
                    
                    for (int i =0; i<[orderDocsArray  count]; i++) {
                        docsDictionary = [orderDocsDictionary objectForKey:[orderDocsArray objectAtIndex:i]];
                        recordIDDocsArray = [docsDictionary allKeys];
                        NSMutableArray *orderDocsListArray = [NSMutableArray new];
                        
                        for (int j=0; j<[recordIDDocsArray count]; j++) {
                            NSMutableArray *orderDetailDocsListArray = [NSMutableArray new];
                            
                            tempDictionary = [docsDictionary objectForKey:[recordIDDocsArray objectAtIndex:j]];
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Zobjid"]]) {
                                [orderDetailDocsListArray addObject:@""];
                            }
                            else{
                                [orderDetailDocsListArray addObject:[tempDictionary objectForKey:@"Zobjid"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"DocId"]]) {
                                [orderDetailDocsListArray addObject:@""];
                            }
                            else{
                                [orderDetailDocsListArray addObject:[tempDictionary objectForKey:@"DocId"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"DocType"]]) {
                                [orderDetailDocsListArray addObject:@""];
                            }
                            else{
                                [orderDetailDocsListArray addObject:[tempDictionary objectForKey:@"DocType"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Filename"]]) {
                                [orderDetailDocsListArray addObject:@""];
                            }
                            else{
                                [orderDetailDocsListArray addObject:[tempDictionary objectForKey:@"Filename"]];
                            }
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Filetype"]]) {
                                [orderDetailDocsListArray addObject:@""];
                            }
                            else{
                                [orderDetailDocsListArray addObject:[tempDictionary objectForKey:@"Filetype"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Fsize"]]) {
                                
                                [orderDetailDocsListArray addObject:@""];//Size
                            }
                            else{
                                [orderDetailDocsListArray addObject:[tempDictionary objectForKey:@"Fsize"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Objtype"]]) {
                                
                                [orderDetailDocsListArray addObject:@""];//Objtype
                            }
                            else{
                                [orderDetailDocsListArray addObject:[tempDictionary objectForKey:@"Objtype"]];
                            }
                            
                            [orderDetailDocsListArray addObject:@""];//Content
                            [orderDetailDocsListArray addObject:@""];//Action
                            
                            [orderDocsListArray addObject:orderDetailDocsListArray];
                        }
                        
                        [[orderDetailDictionary objectForKey:[orderDocsArray objectAtIndex:i]] replaceObjectAtIndex:2 withObject:orderDocsListArray];
                    }
                    
                    [orderDocsArray removeAllObjects];
                    
                    [orderTransactionArray addObjectsFromArray:[orderTransactionDictionary allKeys]];
                    NSArray *recordIDArray;
                    NSDictionary *componentDictionary;
                    
                    for (int i =0; i<[orderTransactionArray  count]; i++) {
                        componentDictionary = [orderTransactionDictionary objectForKey:[orderTransactionArray objectAtIndex:i]];
                        recordIDArray = [componentDictionary allKeys];
                        NSMutableArray *orderTransactionListArray = [NSMutableArray new];
                        NSMutableArray *orderPartsListArray = [NSMutableArray new];
                        
                        for (int j=0; j<[recordIDArray count]; j++) {
                            
                            NSMutableArray *orderDetailTransactionListArray = [NSMutableArray new];
                            
                            tempDictionary = [componentDictionary objectForKey:[recordIDArray objectAtIndex:j]];
                            
                            //CREATE TABLE "ORDER_TRANSACTION" ("ordert_header_id" VARCHAR,"ordert_vornr_operation" VARCHAR,"ordert_operation_name" VARCHAR,"ordert_duration_name" VARCHAR,"ordert_duration_id" VARCHAR,"ordert_fsavd" VARCHAR,"ordert_ssedd" VARCHAR,"ordert_rueck" VARCHAR,"ordert_aueru" VARCHAR,"ordert_operation_action" VARCHAR,"ordert_status" VARCHAR,"ordert_conftext" VARCHAR,"ordert_actwork" VARCHAR,"ordert_unwork" VARCHAR,"ordert_larnt" VARCHAR,"ordert_pernr" VARCHAR,"ordert_plnal" VARCHAR,"ordert_plnnr" VARCHAR,"ordert_plnty" VARCHAR,"ordert_steus" VARCHAR,"ordert_operationlongtext" VARCHAR,"usr01" VARCHAR,"bemot" VARCHAR,"grund" VARCHAR,"learr" VARCHAR,"leknw" VARCHAR,"operation_plantid" VARCHAR,"operation_plantname" VARCHAR,"operation_workcenterid" VARCHAR,"operation_workcentertext" VARCHAR,"ordert_steustext" VARCHAR)
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Aufnr"]]) {
                                [orderDetailTransactionListArray addObject:@""];
                            }
                            else{
                                [orderDetailTransactionListArray addObject:[tempDictionary objectForKey:@"Aufnr"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Vornr"]]) {
                                [orderDetailTransactionListArray addObject:@""];
                            }
                            else{
                                [orderDetailTransactionListArray addObject:[tempDictionary objectForKey:@"Vornr"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Ltxa1"]]) {
                                [orderDetailTransactionListArray addObject:@""];
                            }
                            else{
                                [orderDetailTransactionListArray addObject:[tempDictionary objectForKey:@"Ltxa1"]];//Operation short text
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Dauno"]]) {
                                [orderDetailTransactionListArray addObject:@""];
                            }
                            else{
                                [orderDetailTransactionListArray addObject:[tempDictionary objectForKey:@"Dauno"]];//duration
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Daune"]]) {
                                [orderDetailTransactionListArray addObject:@""];
                            }
                            else{
                                [orderDetailTransactionListArray addObject:[tempDictionary objectForKey:@"Daune"]];//duration id
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Fsavd"]]) {
                                [orderDetailTransactionListArray addObject:@""];
                            }
                            else{
                                [orderDetailTransactionListArray addObject:[tempDictionary objectForKey:@"Fsavd"]];//date
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Ssedd"]]) {
                                [orderDetailTransactionListArray addObject:@""];
                            }
                            else{
                                [orderDetailTransactionListArray addObject:[tempDictionary objectForKey:@"Ssedd"]];//date
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Rueck"]]) {
                                [orderDetailTransactionListArray addObject:@""];
                            }
                            else{
                                [orderDetailTransactionListArray addObject:[tempDictionary objectForKey:@"Rueck"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Aueru"]]) {
                                [orderDetailTransactionListArray addObject:@""];//for aueru
                            }
                            else{
                                [orderDetailTransactionListArray addObject:[tempDictionary objectForKey:@"Aueru"]];
                            }
                            
                            [orderDetailTransactionListArray addObject:@""];//For OperationAction
                            [orderDetailTransactionListArray addObject:@""];//For Status
                            [orderDetailTransactionListArray addObject:@""];//For Confirmation text in Confirm Order
                            [orderDetailTransactionListArray addObject:@""];//For Actual Work Text
                            [orderDetailTransactionListArray addObject:@""];//For Actual Work Units
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Larnt"]]) {
                                [orderDetailTransactionListArray addObject:@""];
                            }
                            else{
                                [orderDetailTransactionListArray addObject:[tempDictionary objectForKey:@"Larnt"]];//Activity Type
                            }
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Pernr"]]) {
                                [orderDetailTransactionListArray addObject:@""];
                            }
                            else{
                                [orderDetailTransactionListArray addObject:[tempDictionary objectForKey:@"Pernr"]];//Personal No
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Plnal"]]) {
                                [orderDetailTransactionListArray addObject:@""];
                            }
                            else{
                                [orderDetailTransactionListArray addObject:[tempDictionary objectForKey:@"Plnal"]];//Group Counter
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Plnnr"]]) {
                                [orderDetailTransactionListArray addObject:@""];
                            }
                            else{
                                [orderDetailTransactionListArray addObject:[tempDictionary objectForKey:@"Plnnr"]];//key for task list group
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Plnty"]]) {
                                [orderDetailTransactionListArray addObject:@""];
                            }
                            else{
                                [orderDetailTransactionListArray addObject:[tempDictionary objectForKey:@"Plnty"]];//Task list type
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Steus"]]) {
                                [orderDetailTransactionListArray addObject:@""];
                            }
                            else{
                                [orderDetailTransactionListArray addObject:[tempDictionary objectForKey:@"Steus"]];//Control Key
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"OPTLONGTEXT"]]) {
                                [orderDetailTransactionListArray addObject:@""];
                            }
                            else{
                                [orderDetailTransactionListArray addObject:[tempDictionary objectForKey:@"OPTLONGTEXT"]];
                            }//For Long Text
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Usr01"]]) {
                                [orderDetailTransactionListArray addObject:@""];
                            }
                            else{
                                [orderDetailTransactionListArray addObject:[tempDictionary objectForKey:@"Usr01"]];
                            }//For Actual Work
                            
                            [orderDetailTransactionListArray addObject:@""];//Bemot(Accounting Indicator)
                            [orderDetailTransactionListArray addObject:@""];//grund(ConfirmReason)
                            [orderDetailTransactionListArray addObject:@""];//Learr(noRemainingWork)
                            [orderDetailTransactionListArray addObject:@""];//Leknw(confirmreason)
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Werks"]]) {
                                [orderDetailTransactionListArray addObject:@""];//Werks
                                
                            }
                            else{
                                [orderDetailTransactionListArray addObject:[tempDictionary objectForKey:@"Werks"]];//Werks
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"WerksText"]]) {
                                [orderDetailTransactionListArray addObject:@""];//WerksText
                                
                            }
                            else{
                                [orderDetailTransactionListArray addObject:[tempDictionary objectForKey:@"WerksText"]];//WersText
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Arbpl"]]) {
                                [orderDetailTransactionListArray addObject:@""];//Arbpl
                            }
                            else{
                                [orderDetailTransactionListArray addObject:[tempDictionary objectForKey:@"Arbpl"]];//Arbpl
                                
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"ArbplText"]]) {
                                [orderDetailTransactionListArray addObject:@""];//ArbplText
                            }
                            else{
                                [orderDetailTransactionListArray addObject:[tempDictionary objectForKey:@"ArbplText"]];//ArbplText
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"SteusText"]]) {
                                [orderDetailTransactionListArray addObject:@""];//SteusText
                            }
                            else{
                                [orderDetailTransactionListArray addObject:[tempDictionary objectForKey:@"SteusText"]];//SteusText
                            }
                            //
                            //                            id customFieldsOperationsTransactionsID;
                            //                            if ([tempDictionary objectForKey:@"Fields"]) {
                            //                                NSArray *fieldsArray = [[tempDictionary objectForKey:@"Fields"] objectForKey:@"item"];
                            //                                NSMutableArray *transactionsOperationsCustomFields = [NSMutableArray new];
                            //                                for (int l =0; l<[fieldsArray count]; l++) {
                            //                                    NSString *fieldValue,*fieldName,*fLabel,*tabName,*docType,*docTypeItem,*dataType,*sequence,*length;
                            //                                    if ([NullChecker isNull:[[fieldsArray objectAtIndex:l] objectForKey:@"Fieldname"]]) {
                            //                                        fieldName = @"";
                            //                                    }
                            //                                    else{
                            //                                        fieldName = [[fieldsArray objectAtIndex:l] objectForKey:@"Fieldname"];
                            //                                    }
                            //
                            //                                    if ([NullChecker isNull:[[fieldsArray objectAtIndex:l] objectForKey:@"Flabel"]]) {
                            //                                        fLabel = @"";
                            //                                    }
                            //                                    else{
                            //                                        fLabel = [[fieldsArray objectAtIndex:l] objectForKey:@"Flabel"];
                            //                                    }
                            //
                            //                                    if ([NullChecker isNull:[[fieldsArray objectAtIndex:l] objectForKey:@"Tabname"]]) {
                            //                                        tabName = @"";
                            //                                    }
                            //                                    else{
                            //                                        tabName = [[fieldsArray objectAtIndex:l] objectForKey:@"Tabname"];
                            //                                    }
                            //
                            //                                    if ([NullChecker isNull:[[fieldsArray objectAtIndex:l] objectForKey:@"Value"]]) {
                            //                                        fieldValue = @"";
                            //                                    }
                            //                                    else{
                            //                                        fieldValue = [[fieldsArray objectAtIndex:l] objectForKey:@"Value"];
                            //                                    }
                            //
                            //                                    if ([NullChecker isNull:[[fieldsArray objectAtIndex:l] objectForKey:@"Zdoctype"]]) {
                            //                                        docType = @"";
                            //                                    }
                            //                                    else{
                            //                                        docType = [[fieldsArray objectAtIndex:l] objectForKey:@"Zdoctype"];
                            //                                    }
                            //
                            //                                    if ([NullChecker isNull:[[fieldsArray objectAtIndex:l] objectForKey:@"ZdoctypeItem"]]) {
                            //                                        docTypeItem = @"";
                            //                                    }
                            //                                    else{
                            //                                        docTypeItem = [[fieldsArray objectAtIndex:l] objectForKey:@"ZdoctypeItem"];
                            //                                    }
                            //
                            //                                    if ([NullChecker isNull:[[fieldsArray objectAtIndex:l] objectForKey:@"Datatype"]]) {
                            //                                        dataType = @"";
                            //                                    }
                            //                                    else{
                            //                                        dataType = [[fieldsArray objectAtIndex:l] objectForKey:@"Datatype"];
                            //                                    }
                            //
                            //                                    if ([NullChecker isNull:[[fieldsArray objectAtIndex:l] objectForKey:@"Sequence"]]) {
                            //                                        sequence = @"";
                            //                                    }
                            //                                    else{
                            //                                        sequence = [[fieldsArray objectAtIndex:l] objectForKey:@"Sequence"];
                            //                                    }
                            //
                            //                                    if ([NullChecker isNull:[[fieldsArray objectAtIndex:l] objectForKey:@"Length"]]) {
                            //                                        length = @"";
                            //                                    }
                            //                                    else{
                            //                                        length = [[fieldsArray objectAtIndex:l] objectForKey:@"Length"];
                            //                                    }
                            //
                            //                                    if ([docTypeItem isEqualToString:@"WO"]) {
                            //                                        [transactionsOperationsCustomFields addObject:[NSMutableArray arrayWithObjects:docType,docTypeItem,tabName,fieldName,fieldValue,fLabel,dataType,sequence,length, nil]];
                            //                                    }
                            //                                }
                            //
                            //                                customFieldsOperationsTransactionsID = transactionsOperationsCustomFields;
                            //                            }
                            
                            [orderTransactionListArray addObject:[NSArray arrayWithObjects:orderDetailTransactionListArray,[NSArray array], nil]];
                            
                            if ([tempDictionary objectForKey:@"Components"]) {
                                
                                //CREATE TABLE "ORDER_PARTS" ("ordert_header_id" VARCHAR, "ordert_vornr_operation" VARCHAR, "ordert_quantity" INTEGER, "ordert_lgort" VARCHAR, "ordert_lgorttext" VARCHAR, "ordert_matnr" VARCHAR, "ordert_matnrtext" VARCHAR, "ordert_meins" VARCHAR, "ordert_posnr" VARCHAR, "ordert_postp" VARCHAR, "ordert_postptext" VARCHAR, "ordert_rsnum" VARCHAR, "ordert_rspos" VARCHAR, "ordert_werks" VARCHAR, "ordert_werkstext" VARCHAR)
                                
                                for (int k =0; k<[[tempDictionary objectForKey:@"Components"] count]; k++) {
                                    
                                    NSMutableArray *orderDetailComponentTransactionListArray = [NSMutableArray new];
                                    
                                    NSDictionary *tempCompenetsDictionary = [[tempDictionary objectForKey:@"Components"] objectAtIndex:k];
                                    if ([NullChecker isNull:[tempCompenetsDictionary objectForKey:@"Aufnr"]]) {
                                        [orderDetailComponentTransactionListArray addObject:@""];
                                    }
                                    else{
                                        [orderDetailComponentTransactionListArray addObject:[tempCompenetsDictionary objectForKey:@"Aufnr"]];
                                    }
                                    
                                    if ([NullChecker isNull:[tempCompenetsDictionary objectForKey:@"Vornr"]]) {
                                        [orderDetailComponentTransactionListArray addObject:@""];
                                    }
                                    else{
                                        [orderDetailComponentTransactionListArray addObject:[tempCompenetsDictionary objectForKey:@"Vornr"]];
                                    }
                                    
                                    if ([NullChecker isNull:[tempCompenetsDictionary objectForKey:@"Bdmng"]]) {
                                        
                                        [orderDetailComponentTransactionListArray addObject:@""];
                                    }
                                    else{
                                        [orderDetailComponentTransactionListArray addObject:[tempCompenetsDictionary objectForKey:@"Bdmng"]];//Quantity
                                    }
                                    
                                    if ([NullChecker isNull:[tempCompenetsDictionary objectForKey:@"Lgort"]]) {
                                        [orderDetailComponentTransactionListArray addObject:@""];
                                    }
                                    else{
                                        [orderDetailComponentTransactionListArray addObject:[tempCompenetsDictionary objectForKey:@"Lgort"]];
                                    }
                                    
                                    if ([NullChecker isNull:[tempCompenetsDictionary objectForKey:@"LgortText"]]) {
                                        [orderDetailComponentTransactionListArray addObject:@""];
                                    }
                                    else{
                                        [orderDetailComponentTransactionListArray addObject:[tempCompenetsDictionary objectForKey:@"LgortText"]];
                                    }
                                    
                                    if ([NullChecker isNull:[tempCompenetsDictionary objectForKey:@"Matnr"]]) {
                                        [orderDetailComponentTransactionListArray addObject:@""];
                                        [orderDetailComponentTransactionListArray addObject:@""];
                                    }
                                    else{
                                        [orderDetailComponentTransactionListArray addObject:[tempCompenetsDictionary objectForKey:@"Matnr"]];//ComponentID
                                    }
                                    
                                    if ([NullChecker isNull:[tempCompenetsDictionary objectForKey:@"MatnrText"]]) {
                                        [orderDetailComponentTransactionListArray addObject:@""];
                                    }
                                    else{
                                        
                                        [orderDetailComponentTransactionListArray addObject:[tempCompenetsDictionary objectForKey:@"MatnrText"]];//ComponentName
                                    }
                                    
                                    if ([NullChecker isNull:[tempCompenetsDictionary objectForKey:@"Meins"]]) {
                                        [orderDetailComponentTransactionListArray addObject:@""];
                                    }
                                    else{
                                        [orderDetailComponentTransactionListArray addObject:[tempCompenetsDictionary objectForKey:@"Meins"]];//Meins
                                        
                                    }
                                    
                                    if ([NullChecker isNull:[tempCompenetsDictionary objectForKey:@"Posnr"]]) {
                                        [orderDetailComponentTransactionListArray addObject:@""];
                                    }
                                    else{
                                        [orderDetailComponentTransactionListArray addObject:[tempCompenetsDictionary objectForKey:@"Posnr"]];
                                    }
                                    
                                    if([NullChecker isNull:[tempCompenetsDictionary objectForKey:@"Postp"]]){
                                        [orderDetailComponentTransactionListArray addObject:@""];
                                    }
                                    else{
                                        [orderDetailComponentTransactionListArray addObject:[tempCompenetsDictionary objectForKey:@"Postp"]];//Item Category in Components
                                    }
                                    
                                    if([NullChecker isNull:[tempCompenetsDictionary objectForKey:@"PostpText"]]){
                                        [orderDetailComponentTransactionListArray addObject:@""];
                                    }
                                    else{
                                        [orderDetailComponentTransactionListArray addObject:[tempCompenetsDictionary objectForKey:@"PostpText"]];//Item Category in Components
                                    }
                                    
                                    if ([NullChecker isNull:[tempCompenetsDictionary objectForKey:@"Rsnum"]]) {
                                        [orderDetailComponentTransactionListArray addObject:@""];
                                    }
                                    else{
                                        [orderDetailComponentTransactionListArray addObject:[tempCompenetsDictionary objectForKey:@"Rsnum"]];
                                    }
                                    
                                    if ([NullChecker isNull:[tempCompenetsDictionary objectForKey:@"Rspos"]]) {
                                        [orderDetailComponentTransactionListArray addObject:@""];
                                    }
                                    else{
                                        [orderDetailComponentTransactionListArray addObject:[tempCompenetsDictionary objectForKey:@"Rspos"]];
                                    }
                                    
                                    if ([tempCompenetsDictionary objectForKey:@"Werks"]) {
                                        [orderDetailComponentTransactionListArray addObject:[tempCompenetsDictionary objectForKey:@"Werks"]];//Werks
                                    }
                                    else{
                                        [orderDetailComponentTransactionListArray addObject:@""];//Werks
                                    }
                                    
                                    if ([tempCompenetsDictionary objectForKey:@"WerksText"]) {
                                        [orderDetailComponentTransactionListArray addObject:[tempCompenetsDictionary objectForKey:@"WerksText"]];//Werks
                                    }
                                    else{
                                        [orderDetailComponentTransactionListArray addObject:@""];//WerksText
                                    }
                                    
                                    [orderDetailComponentTransactionListArray addObject:@""];//ComponentAction
                                    
                                    if([NullChecker isNull:[tempCompenetsDictionary objectForKey:@"Wempf"]]){
                                        [orderDetailComponentTransactionListArray addObject:@""];
                                    }
                                    else{
                                        [orderDetailComponentTransactionListArray addObject:[tempCompenetsDictionary objectForKey:@"Wempf"]];//receipt
                                    }
                                    
                                    if([NullChecker isNull:[tempCompenetsDictionary objectForKey:@"Ablad"]]){
                                        [orderDetailComponentTransactionListArray addObject:@""];
                                    }
                                    else{
                                        [orderDetailComponentTransactionListArray addObject:[tempCompenetsDictionary objectForKey:@"Ablad"]];//unload
                                    }
                                    
                                    
                                    
                                    id customFieldsComponentsTransactionsID;
                                    NSMutableArray *transactionsComponentsCustomFields = [NSMutableArray new];
                                    
                                    if ([tempCompenetsDictionary objectForKey:@"Fields"]) {
                                        
                                        NSMutableArray *fieldsArray=[NSMutableArray new];
                                        
                                        if ([[[tempCompenetsDictionary objectForKey:@"Fields"] objectForKey:@"item"] isKindOfClass:[NSDictionary class]]) {
                                            
                                            [fieldsArray addObjectsFromArray:[NSMutableArray arrayWithObject:[[tempCompenetsDictionary objectForKey:@"Fields"] objectForKey:@"item"]]];
                                        }
                                        else if ([[[tempCompenetsDictionary objectForKey:@"Fields"] objectForKey:@"item"] isKindOfClass:[NSArray class]]){
                                            
                                            [fieldsArray addObjectsFromArray:[[tempCompenetsDictionary objectForKey:@"Fields"] objectForKey:@"item"]];
                                            
                                        }
                                        
                                        
                                        for (int l =0; l<[fieldsArray count]; l++) {
                                            NSString *fieldValue,*fieldName,*fLabel,*tabName,*docType,*docTypeItem,*dataType,*sequence,*length;
                                            if ([NullChecker isNull:[[fieldsArray objectAtIndex:l] objectForKey:@"Fieldname"]]) {
                                                fieldName = @"";
                                            }
                                            else{
                                                fieldName = [[fieldsArray objectAtIndex:l] objectForKey:@"Fieldname"];
                                            }
                                            
                                            if ([NullChecker isNull:[[fieldsArray objectAtIndex:l] objectForKey:@"Flabel"]]) {
                                                fLabel = @"";
                                            }
                                            else{
                                                fLabel = [[fieldsArray objectAtIndex:l] objectForKey:@"Flabel"];
                                            }
                                            
                                            if ([NullChecker isNull:[[fieldsArray objectAtIndex:l] objectForKey:@"Tabname"]]) {
                                                tabName = @"";
                                            }
                                            else{
                                                tabName = [[fieldsArray objectAtIndex:l] objectForKey:@"Tabname"];
                                            }
                                            
                                            if ([NullChecker isNull:[[fieldsArray objectAtIndex:l] objectForKey:@"Value"]]) {
                                                fieldValue = @"";
                                            }
                                            else{
                                                fieldValue = [[fieldsArray objectAtIndex:l] objectForKey:@"Value"];
                                            }
                                            
                                            if ([NullChecker isNull:[[fieldsArray objectAtIndex:l] objectForKey:@"Zdoctype"]]) {
                                                docType = @"";
                                            }
                                            else{
                                                docType = [[fieldsArray objectAtIndex:l] objectForKey:@"Zdoctype"];
                                            }
                                            
                                            if ([NullChecker isNull:[[fieldsArray objectAtIndex:l] objectForKey:@"ZdoctypeItem"]]) {
                                                docTypeItem = @"";
                                            }
                                            else{
                                                docTypeItem = [[fieldsArray objectAtIndex:l] objectForKey:@"ZdoctypeItem"];
                                            }
                                            
                                            if ([NullChecker isNull:[[fieldsArray objectAtIndex:l] objectForKey:@"Datatype"]]) {
                                                dataType = @"";
                                            }
                                            else{
                                                dataType = [[fieldsArray objectAtIndex:l] objectForKey:@"Datatype"];
                                            }
                                            
                                            if ([NullChecker isNull:[[fieldsArray objectAtIndex:l] objectForKey:@"Sequence"]]) {
                                                sequence = @"";
                                            }
                                            else{
                                                sequence = [[fieldsArray objectAtIndex:l] objectForKey:@"Sequence"];
                                            }
                                            
                                            if ([NullChecker isNull:[[fieldsArray objectAtIndex:l] objectForKey:@"Length"]]) {
                                                length = @"";
                                            }
                                            else{
                                                length = [[fieldsArray objectAtIndex:l] objectForKey:@"Length"];
                                            }
                                            
                                            if ([docTypeItem isEqualToString:@"WC"]){
                                                [transactionsComponentsCustomFields addObject:[NSMutableArray arrayWithObjects:docType,docTypeItem,tabName,fieldName,fieldValue,fLabel,dataType,sequence,length, nil]];
                                            }
                                        }
                                        
                                        customFieldsComponentsTransactionsID = transactionsComponentsCustomFields;
                                    }
                                    
                                    [orderPartsListArray addObject:[NSArray arrayWithObjects:orderDetailComponentTransactionListArray,customFieldsComponentsTransactionsID, nil]];
                                    
                                    [orderPartsListArray addObject:[NSArray arrayWithObjects:orderDetailComponentTransactionListArray,[NSArray array], nil]];
                                    
                                }
                            }
                        }
                        
                        [[orderDetailDictionary objectForKey:[orderTransactionArray objectAtIndex:i]] replaceObjectAtIndex:3 withObject:orderTransactionListArray];
                        
                        [[orderDetailDictionary objectForKey:[orderTransactionArray objectAtIndex:i]] replaceObjectAtIndex:4 withObject:orderPartsListArray];
                    }
                    
                    [orderTransactionArray removeAllObjects];
                    
                    ////////////
                    
                    [orderWsmSafetyMeasuresArray addObjectsFromArray:[orderWSMSafetyMeasuresDictionary allKeys]];
                    
                    NSArray *recordIDWSMSafetyMeasuresArray;
                    NSDictionary *WSMSafetyMeasuresDictionary;
                    
                    for (int i =0; i<[orderWsmSafetyMeasuresArray count]; i++) {
                        
                        WSMSafetyMeasuresDictionary = [orderWSMSafetyMeasuresDictionary objectForKey:[orderWsmSafetyMeasuresArray objectAtIndex:i]];
                        recordIDWSMSafetyMeasuresArray = [WSMSafetyMeasuresDictionary allKeys];
                        NSMutableArray *orderWSMSafetyMeasuresListArray = [NSMutableArray new];
                        
                        //CREATE TABLE "ORDER_WSM_SAFETYMEASURES" ("orderwsm_header_id" VARCHAR, "orderwsm_aufnr" VARCHAR, "orderwsm_vornr_operation" VARCHAR,"orderwsm_description" VARCHAR, "orderwsm_safety_text_no" VARCHAR, "orderwsm_objid" VARCHAR, "orderwsm_objtype" VARCHAR, "orderwsm_safetychar" VARCHAR, "orderwsm_safetychar_text" VARCHAR, "orderwsm_action" VARCHAR)
                        
                        for (int j=0; j<[recordIDWSMSafetyMeasuresArray count]; j++) {
                            
                            NSMutableArray *orderDetailWSMSafetyListArray = [NSMutableArray new];
                            
                            tempDictionary = [WSMSafetyMeasuresDictionary objectForKey:[recordIDWSMSafetyMeasuresArray objectAtIndex:j]];
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"EamsAufnr"]]) {
                                [orderDetailWSMSafetyListArray addObject:@""];
                            }
                            else{
                                [orderDetailWSMSafetyListArray addObject:[NSString stringWithFormat:@"%lld",[[tempDictionary objectForKey:@"EamsAufnr"] longLongValue]]];
                            }
                            
                            
                            [orderDetailWSMSafetyListArray addObject:@""];//operation
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Description"]]) {
                                [orderDetailWSMSafetyListArray addObject:@""];
                            }
                            else{
                                [orderDetailWSMSafetyListArray addObject:[tempDictionary objectForKey:@"Description"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"EamsSafetyTextNo"]]) {
                                [orderDetailWSMSafetyListArray addObject:@""];
                            }
                            else{
                                [orderDetailWSMSafetyListArray addObject:[tempDictionary objectForKey:@"EamsSafetyTextNo"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"ObjId"]]) {
                                [orderDetailWSMSafetyListArray addObject:@""];
                            }
                            else{
                                [orderDetailWSMSafetyListArray addObject:[tempDictionary objectForKey:@"ObjId"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"ObjType"]]) {
                                [orderDetailWSMSafetyListArray addObject:@""];
                            }
                            else{
                                
                                if ([[tempDictionary objectForKey:@"ObjType"] isEqualToString:@"DO"]) {
                                    
                                    [orderDetailWSMSafetyListArray addObject:@"Document"];
                                }
                                else{
                                    
                                    [orderDetailWSMSafetyListArray addObject:[tempDictionary objectForKey:@"ObjType"]];
                                }
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"SafetyChar"]]) {
                                [orderDetailWSMSafetyListArray addObject:@""];
                            }
                            else{
                                [orderDetailWSMSafetyListArray addObject:[tempDictionary objectForKey:@"SafetyChar"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"SafetyCharTxt"]]) {
                                [orderDetailWSMSafetyListArray addObject:@""];
                            }
                            else{
                                [orderDetailWSMSafetyListArray addObject:[tempDictionary objectForKey:@"SafetyCharTxt"]];
                            }
                            
                            [orderDetailWSMSafetyListArray addObject:@""];//selection
                            
                            [orderWSMSafetyMeasuresListArray addObject:orderDetailWSMSafetyListArray];
                        }
                        
                        [[orderDetailDictionary objectForKey:[orderWsmSafetyMeasuresArray objectAtIndex:i]] replaceObjectAtIndex:5 withObject:orderWSMSafetyMeasuresListArray];
                    }
                    
                    [orderWsmSafetyMeasuresArray removeAllObjects];
                    
                    ///////////
                    
                    [orderStatusArray addObjectsFromArray:[orderStatusDictionary allKeys]];
                    
                    NSArray *recordIDorderStatusArray;
                    NSDictionary *EtorderStatusDictionary;
                    
                    for (int i =0; i<[orderStatusArray count]; i++) {
                        
                        EtorderStatusDictionary = [orderStatusDictionary objectForKey:[orderStatusArray objectAtIndex:i]];
                        recordIDorderStatusArray = [EtorderStatusDictionary allKeys];
                        
                        NSMutableArray *orderStatusDetailArray = [NSMutableArray new];
                        
                        BOOL act = NO;
                        
                        for (int j=0; j<[recordIDorderStatusArray count]; j++) {
                            
                            NSMutableDictionary *orderStatusListDictionary = [NSMutableDictionary new];
                            
                            tempDictionary = [EtorderStatusDictionary objectForKey:[recordIDorderStatusArray objectAtIndex:j]];
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Aufnr"]]) {
                                [orderStatusListDictionary setObject:@"" forKey:@"orders_aufnr"];
                            }
                            else{
                                
                                [orderStatusListDictionary setObject:[NSString stringWithFormat:@"%lld",[[tempDictionary objectForKey:@"Aufnr"] longLongValue]] forKey:@"orders_aufnr"];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Vornr"]]) {
                                [orderStatusListDictionary setObject:@"" forKey:@"orders_vornr_operation"];
                            }
                            else{
                                
                                [orderStatusListDictionary setObject:[tempDictionary objectForKey:@"Vornr"] forKey:@"orders_vornr_operation"];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Objnr"]]) {
                                
                                [orderStatusListDictionary setObject:@"" forKey:@"orders_objnr"];
                            }
                            else{
                                
                                [orderStatusListDictionary setObject:[tempDictionary objectForKey:@"Objnr"] forKey:@"orders_objnr"];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Stsma"]]) {
                                
                                [orderStatusListDictionary setObject:@"" forKey:@"orders_stsma"];
                            }
                            else{
                                
                                [orderStatusListDictionary setObject:[tempDictionary objectForKey:@"Stsma"] forKey:@"orders_stsma"];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Inist"]]) {
                                
                                [orderStatusListDictionary setObject:@"" forKey:@"orders_inist"];
                            }
                            else{
                                
                                [orderStatusListDictionary setObject:[tempDictionary objectForKey:@"Inist"] forKey:@"orders_inist"];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Stonr"]]) {
                                [orderStatusListDictionary setObject:@"" forKey:@"orders_stonr"];
                            }
                            else{
                                
                                [orderStatusListDictionary setObject:[tempDictionary objectForKey:@"Stonr"] forKey:@"orders_stonr"];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Hsonr"]]) {
                                
                                [orderStatusListDictionary setObject:@"" forKey:@"orders_hsonr"];
                            }
                            else{
                                
                                [orderStatusListDictionary setObject:[tempDictionary objectForKey:@"Hsonr"] forKey:@"orders_hsonr"];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Nsonr"]]) {
                                
                                [orderStatusListDictionary setObject:@"" forKey:@"orders_nsonr"];
                            }
                            else{
                                
                                [orderStatusListDictionary setObject:[tempDictionary objectForKey:@"Nsonr"] forKey:@"orders_nsonr"];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Stat"]]) {
                                [orderStatusListDictionary setObject:@"" forKey:@"orders_stat"];
                            }
                            else{
                                
                                [orderStatusListDictionary setObject:[[tempDictionary objectForKey:@"Stat"] substringToIndex:1] forKey:@"orders_stat"];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Act"]]) {
                                [orderStatusListDictionary setObject:@"" forKey:@"orders_act"];
                                
                                if (act ==YES) {
                                    [orderStatusListDictionary setObject:@"" forKey:@"orders_selected"];//Selection
                                }
                                else{
                                    
                                    [orderStatusListDictionary setObject:@"Y" forKey:@"orders_selected"];//Selection
                                }
                            }
                            else{
                                
                                [orderStatusListDictionary setObject:[tempDictionary objectForKey:@"Act"] forKey:@"orders_act"];
                                [orderStatusListDictionary setObject:@"X" forKey:@"orders_selected"];//Selection
                                if ([[[tempDictionary objectForKey:@"Stat"] substringToIndex:1] isEqualToString:@"E"]) {
                                    act = YES;
                                }
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Txt04"]]) {
                                [orderStatusListDictionary setObject:@"" forKey:@"orders_txt04"];
                            }
                            else{
                                [orderStatusListDictionary setObject:[tempDictionary objectForKey:@"Txt04"] forKey:@"orders_txt04"];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Txt30"]]) {
                                [orderStatusListDictionary setObject:@"" forKey:@"orders_txt30"];
                            }
                            else{
                                
                                [orderStatusListDictionary setObject:[tempDictionary objectForKey:@"Txt30"] forKey:@"orders_txt30"];
                            }
                            
                            [orderStatusDetailArray addObject:orderStatusListDictionary];
                            
                            if ([tempDictionary objectForKey:@"SystemStatus"]) {
                                
                                if ([[tempDictionary objectForKey:@"SystemStatus"] isKindOfClass:[NSArray class]]) {
                                    
                                    id systemStatus = [tempDictionary objectForKey:@"SystemStatus"];
                                    
                                    for (int k =0 ; k <[systemStatus count]; k++) {
                                        
                                        NSMutableDictionary *orderStatusListDictionary = [NSMutableDictionary new];
                                        
                                        tempDictionary = [systemStatus objectAtIndex:k];
                                        
                                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Aufnr"]]) {
                                            [orderStatusListDictionary setObject:@"" forKey:@"orders_aufnr"];
                                        }
                                        else{
                                            
                                            [orderStatusListDictionary setObject:[NSString stringWithFormat:@"%lld",[[tempDictionary objectForKey:@"Aufnr"] longLongValue]] forKey:@"orders_aufnr"];
                                        }
                                        
                                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Vornr"]]) {
                                            [orderStatusListDictionary setObject:@"" forKey:@"orders_vornr_operation"];
                                        }
                                        else{
                                            
                                            [orderStatusListDictionary setObject:[tempDictionary objectForKey:@"Vornr"] forKey:@"orders_vornr_operation"];
                                        }
                                        
                                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Objnr"]]) {
                                            
                                            [orderStatusListDictionary setObject:@"" forKey:@"orders_objnr"];
                                        }
                                        else{
                                            
                                            [orderStatusListDictionary setObject:[tempDictionary objectForKey:@"Objnr"] forKey:@"orders_objnr"];
                                        }
                                        
                                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Stsma"]]) {
                                            
                                            [orderStatusListDictionary setObject:@"" forKey:@"orders_stsma"];
                                        }
                                        else{
                                            
                                            [orderStatusListDictionary setObject:[tempDictionary objectForKey:@"Stsma"] forKey:@"orders_stsma"];
                                        }
                                        
                                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Inist"]]) {
                                            
                                            [orderStatusListDictionary setObject:@"" forKey:@"orders_inist"];
                                        }
                                        else{
                                            
                                            [orderStatusListDictionary setObject:[tempDictionary objectForKey:@"Inist"] forKey:@"orders_inist"];
                                        }
                                        
                                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Stonr"]]) {
                                            [orderStatusListDictionary setObject:@"" forKey:@"orders_stonr"];
                                        }
                                        else{
                                            
                                            [orderStatusListDictionary setObject:[tempDictionary objectForKey:@"Stonr"] forKey:@"orders_stonr"];
                                        }
                                        
                                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Hsonr"]]) {
                                            
                                            [orderStatusListDictionary setObject:@"" forKey:@"orders_hsonr"];
                                        }
                                        else{
                                            
                                            [orderStatusListDictionary setObject:[tempDictionary objectForKey:@"Hsonr"] forKey:@"orders_hsonr"];
                                        }
                                        
                                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Nsonr"]]) {
                                            
                                            [orderStatusListDictionary setObject:@"" forKey:@"orders_nsonr"];
                                        }
                                        else{
                                            
                                            [orderStatusListDictionary setObject:[tempDictionary objectForKey:@"Nsonr"] forKey:@"orders_nsonr"];
                                        }
                                        
                                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Stat"]]) {
                                            
                                            [orderStatusListDictionary setObject:@"" forKey:@"orders_stat"];
                                        }
                                        else{
                                            
                                            if ([[[tempDictionary objectForKey:@"Stat"] substringToIndex:1] isEqualToString:@"I"]) {
                                                
                                                [orderStatusListDictionary setObject:[[tempDictionary objectForKey:@"Stat"] substringToIndex:1] forKey:@"orders_stat"];
                                            }
                                            else{
                                                
                                                [orderStatusListDictionary setObject:[[tempDictionary objectForKey:@"Stat"] substringToIndex:1] forKey:@"orders_stat"];
                                                
                                            }
                                        }
                                        
                                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Act"]]) {
                                            [orderStatusListDictionary setObject:@"" forKey:@"orders_act"];
                                            if (act ==YES) {
                                                [orderStatusListDictionary setObject:@"" forKey:@"orders_selected"];//Selection
                                            }
                                            else{
                                                [orderStatusListDictionary setObject:@"Y" forKey:@"orders_selected"];//Selection
                                            }
                                        }
                                        else{
                                            
                                            [orderStatusListDictionary setObject:[tempDictionary objectForKey:@"Act"] forKey:@"orders_act"];
                                            
                                            [orderStatusListDictionary setObject:@"X" forKey:@"orders_selected"];//Selection
                                            
                                            if ([[[tempDictionary objectForKey:@"Stat"] substringToIndex:1] isEqualToString:@"E"]) {
                                                act = YES;
                                            }
                                            
                                        }
                                        
                                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Txt04"]]) {
                                            [orderStatusListDictionary setObject:@"" forKey:@"orders_txt04"];
                                        }
                                        else{
                                            [orderStatusListDictionary setObject:[tempDictionary objectForKey:@"Txt04"] forKey:@"orders_txt04"];
                                        }
                                        
                                        if ([NullChecker isNull:[tempDictionary objectForKey:@"Txt30"]]) {
                                            [orderStatusListDictionary setObject:@"" forKey:@"orders_txt30"];
                                        }
                                        else{
                                            
                                            [orderStatusListDictionary setObject:[tempDictionary objectForKey:@"Txt30"] forKey:@"orders_txt30"];
                                        }
                                        
                                        [orderStatusDetailArray addObject:orderStatusListDictionary];
                                    }
                                }
                            }
                        }
                        
                        [[orderDetailDictionary objectForKey:[orderStatusArray objectAtIndex:i]] replaceObjectAtIndex:6 withObject:orderStatusDetailArray];
                    }
                    
                    [orderStatusArray removeAllObjects];
                    
                    ////////////
                    
                    [orderOlistArray addObjectsFromArray:[orderOlistDictionary allKeys]];
                    
                    NSArray *recordOlistArray;
                    NSDictionary *orderObjectlistDictionary;
                    
                    for (int i =0; i<[orderOlistArray count]; i++) {
                        
                        orderObjectlistDictionary = [orderOlistDictionary objectForKey:[orderOlistArray objectAtIndex:i]];
                        recordOlistArray = [orderObjectlistDictionary allKeys];
                        NSMutableArray *orderObjectListArray = [NSMutableArray new];
                        
                        //CREATE TABLE "ORDER_OBJECTS" ("orderobject_header_id" VARCHAR, "orderobject_aufnr" VARCHAR, "orderobject_obknr" VARCHAR, "orderobject_obzae" VARCHAR, "orderobject_qmnum" VARCHAR, "orderobject_equnr" VARCHAR, "orderobject_strno" VARCHAR, "orderobject_tplnr" VARCHAR, "orderobject_bautl" VARCHAR, "orderobject_qmtxt" VARCHAR, "orderobject_pltxt" VARCHAR, "orderobject_eqktx" VARCHAR, "orderobject_maktx" VARCHAR, "orderobject_action" VARCHAR)
                        
                        for (int j=0; j<[recordOlistArray count]; j++) {
                            
                            NSMutableArray *orderDetailObjectListArray = [NSMutableArray new];
                            
                            tempDictionary = [orderObjectlistDictionary objectForKey:[recordOlistArray objectAtIndex:j]];
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Aufnr"]]) {
                                [orderDetailObjectListArray addObject:@""];
                            }
                            else{
                                [orderDetailObjectListArray addObject:[NSString stringWithFormat:@"%lld",[[tempDictionary objectForKey:@"Aufnr"] longLongValue]]];
                            }
                            
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Obknr"]]) {
                                [orderDetailObjectListArray addObject:@""];
                            }
                            else{
                                [orderDetailObjectListArray addObject:[tempDictionary objectForKey:@"Obknr"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Obzae"]]) {
                                [orderDetailObjectListArray addObject:@""];
                            }
                            else{
                                [orderDetailObjectListArray addObject:[tempDictionary objectForKey:@"Obzae"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Qmnum"]]) {
                                [orderDetailObjectListArray addObject:@""];
                            }
                            else{
                                [orderDetailObjectListArray addObject:[tempDictionary objectForKey:@"Qmnum"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Equnr"]]) {
                                [orderDetailObjectListArray addObject:@""];
                            }
                            else{
                                
                                [orderDetailObjectListArray addObject:[tempDictionary objectForKey:@"Equnr"]];
                                
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Strno"]]) {
                                [orderDetailObjectListArray addObject:@""];
                            }
                            else{
                                [orderDetailObjectListArray addObject:[tempDictionary objectForKey:@"Strno"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Tplnr"]]) {
                                [orderDetailObjectListArray addObject:@""];
                            }
                            else{
                                [orderDetailObjectListArray addObject:[tempDictionary objectForKey:@"Tplnr"]];
                            }
                            
                            if([NullChecker isNull:[tempDictionary objectForKey:@"Bautl"]]){
                                
                                [orderDetailObjectListArray addObject:@""];
                            }
                            else{
                                [orderDetailObjectListArray addObject:[tempDictionary objectForKey:@"Bautl"]];
                            }
                            
                            if([NullChecker isNull:[tempDictionary objectForKey:@"Qmtxt"]]){
                                
                                [orderDetailObjectListArray addObject:@""];
                            }
                            else{
                                [orderDetailObjectListArray addObject:[tempDictionary objectForKey:@"Qmtxt"]];
                            }
                            
                            if([NullChecker isNull:[tempDictionary objectForKey:@"Pltxt"]]){
                                
                                [orderDetailObjectListArray addObject:@""];
                            }
                            else{
                                [orderDetailObjectListArray addObject:[tempDictionary objectForKey:@"Pltxt"]];
                            }
                            
                            if([NullChecker isNull:[tempDictionary objectForKey:@"Eqktx"]]){
                                
                                [orderDetailObjectListArray addObject:@""];
                            }
                            else{
                                [orderDetailObjectListArray addObject:[tempDictionary objectForKey:@"Eqktx"]];
                            }
                            
                            if([NullChecker isNull:[tempDictionary objectForKey:@"Maktx"]]){
                                
                                [orderDetailObjectListArray addObject:@""];
                            }
                            else{
                                [orderDetailObjectListArray addObject:[tempDictionary objectForKey:@"Maktx"]];
                            }
                            
                            if([NullChecker isNull:[tempDictionary objectForKey:@"Action"]]){
                                
                                [orderDetailObjectListArray addObject:@""];
                            }
                            else{
                                [orderDetailObjectListArray addObject:[tempDictionary objectForKey:@"Action"]];
                            }
                            
                            [orderObjectListArray addObject:orderDetailObjectListArray];
                        }
                        
                        [[orderDetailDictionary objectForKey:[orderOlistArray objectAtIndex:i]] replaceObjectAtIndex:7 withObject:orderObjectListArray];
                    }
                    
                    [orderOlistArray removeAllObjects];
                    
                    ////////////
                    
                    responseObject = nil;
                    
                    [orderMeasurementDocumentsArray addObjectsFromArray:[orderMeasurementDocumentsDictionary allKeys]];
                    
                    NSArray *recordIDMDocsArray;
                    NSDictionary *mDocsDictionary;
                    
                    for (int i =0; i<[orderMeasurementDocumentsArray  count]; i++) {
                        mDocsDictionary = [orderMeasurementDocumentsDictionary objectForKey:[orderMeasurementDocumentsArray objectAtIndex:i]];
                        recordIDMDocsArray = [mDocsDictionary allKeys];
                        NSMutableArray *orderMDocsListArray = [NSMutableArray new];
                        
                        for (int j=0; j<[recordIDMDocsArray count]; j++) {
                            NSMutableArray *orderDetailMDocsListArray = [NSMutableArray new];
                            
                            tempDictionary = [mDocsDictionary objectForKey:[recordIDMDocsArray objectAtIndex:j]];
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Qmnum"]]) {
                                [orderDetailMDocsListArray addObject:@""];
                            }
                            else{
                                [orderDetailMDocsListArray addObject:[tempDictionary objectForKey:@"Qmnum"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Aufnr"]]) {
                                [orderDetailMDocsListArray addObject:@""];
                            }
                            else{
                                [orderDetailMDocsListArray addObject:[tempDictionary objectForKey:@"Aufnr"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Vornr"]]) {
                                [orderDetailMDocsListArray addObject:@""];
                            }
                            else{
                                [orderDetailMDocsListArray addObject:[tempDictionary objectForKey:@"Vornr"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Mdocm"]]) {
                                [orderDetailMDocsListArray addObject:@""];
                            }
                            else{
                                [orderDetailMDocsListArray addObject:[tempDictionary objectForKey:@"Mdocm"]];
                            }
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Point"]]) {
                                [orderDetailMDocsListArray addObject:@""];
                            }
                            else{
                                [orderDetailMDocsListArray addObject:[tempDictionary objectForKey:@"Point"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Mpobj"]]) {
                                
                                [orderDetailMDocsListArray addObject:@""];
                            }
                            else{
                                [orderDetailMDocsListArray addObject:[tempDictionary objectForKey:@"Mpobj"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Mpobt"]]) {
                                
                                [orderDetailMDocsListArray addObject:@""];
                            }
                            else{
                                [orderDetailMDocsListArray addObject:[tempDictionary objectForKey:@"Mpobt"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Psort"]]) {
                                
                                [orderDetailMDocsListArray addObject:@""];
                            }
                            else{
                                [orderDetailMDocsListArray addObject:[tempDictionary objectForKey:@"Psort"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Pttxt"]]) {
                                
                                [orderDetailMDocsListArray addObject:@""];
                            }
                            else{
                                [orderDetailMDocsListArray addObject:[tempDictionary objectForKey:@"Pttxt"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Atinn"]]) {
                                
                                [orderDetailMDocsListArray addObject:@""];
                            }
                            else{
                                [orderDetailMDocsListArray addObject:[tempDictionary objectForKey:@"Atinn"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Idate"]]) {
                                
                                [orderDetailMDocsListArray addObject:@""];
                            }
                            else{
                                [orderDetailMDocsListArray addObject:[tempDictionary objectForKey:@"Idate"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Itime"]]) {
                                
                                [orderDetailMDocsListArray addObject:@""];
                            }
                            else{
                                [orderDetailMDocsListArray addObject:[tempDictionary objectForKey:@"Itime"]];
                            }
                            
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Mdtxt"]]) {
                                
                                [orderDetailMDocsListArray addObject:@""];
                            }
                            else{
                                [orderDetailMDocsListArray addObject:[tempDictionary objectForKey:@"Mdtxt"]];
                            }
                            
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Readr"]]) {
                                
                                [orderDetailMDocsListArray addObject:@""];
                            }
                            else{
                                [orderDetailMDocsListArray addObject:[tempDictionary objectForKey:@"Readr"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Atbez"]]) {
                                
                                [orderDetailMDocsListArray addObject:@""];
                            }
                            else{
                                [orderDetailMDocsListArray addObject:[tempDictionary objectForKey:@"Atbez"]];
                            }
                            
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Msehi"]]) {
                                
                                [orderDetailMDocsListArray addObject:@""];//
                            }
                            else{
                                [orderDetailMDocsListArray addObject:[tempDictionary objectForKey:@"Msehi"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Msehl"]]) {
                                
                                [orderDetailMDocsListArray addObject:@""];
                            }
                            else{
                                [orderDetailMDocsListArray addObject:[tempDictionary objectForKey:@"Msehl"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Readc"]]) {
                                
                                [orderDetailMDocsListArray addObject:@""];
                            }
                            else{
                                [orderDetailMDocsListArray addObject:[tempDictionary objectForKey:@"Readc"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Desic"]]) {
                                
                                [orderDetailMDocsListArray addObject:@""];
                            }
                            else{
                                [orderDetailMDocsListArray addObject:[tempDictionary objectForKey:@"Desic"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Prest"]]) {
                                
                                [orderDetailMDocsListArray addObject:@""];
                            }
                            else{
                                [orderDetailMDocsListArray addObject:[tempDictionary objectForKey:@"Prest"]];
                            }
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Docaf"]]) {
                                
                                [orderDetailMDocsListArray addObject:@""];
                            }
                            else{
                                [orderDetailMDocsListArray addObject:[tempDictionary objectForKey:@"Docaf"]];
                            }
                            
                            
                            if ([NullChecker isNull:[tempDictionary objectForKey:@"Action"]]) {
                                
                                [orderDetailMDocsListArray addObject:@""];
                            }
                            else{
                                [orderDetailMDocsListArray addObject:[tempDictionary objectForKey:@"Action"]];
                            }
                            
                            [orderMDocsListArray addObject:orderDetailMDocsListArray];
                        }
                        
                        [[orderDetailDictionary objectForKey:[orderMeasurementDocumentsArray objectAtIndex:i]] replaceObjectAtIndex:11 withObject:orderMDocsListArray];
                    }
                    
                    [orderMeasurementDocumentsArray removeAllObjects];
                    
                    ///
                    
                    NSArray *objectIds = [orderDetailDictionary allKeys];
                    
                    if ([[defaults objectForKey:@"ACTIVATELOGS"] isEqualToString:@"X"])
                    {
                        [[DataBase sharedInstance] writToLogFile:[NSString stringWithFormat:@"#INFO#.com.enstrapp.fieldtekpro#No of Due Orders received:%lu",(unsigned long)[objectIds count]]];
                    }
                    
                    for (int i=0; i<[objectIds count]; i++) {
                        
                        if (i ==1) {
                            
                            [orderWcmOperationWCDTaggingConditionsArray removeAllObjects];
                            [orderWcmPermitsStandardCheckPoints removeAllObjects];
                        }
                        
                        [[DataBase sharedInstance] insertDataIntoOrderHeader:[[orderDetailDictionary objectForKey:[objectIds objectAtIndex:i]] firstObject] withAttachments:[[orderDetailDictionary objectForKey:[objectIds objectAtIndex:i]] objectAtIndex:2] withPermitWorkApprovalsDetails:[[orderDetailDictionary objectForKey:[objectIds objectAtIndex:i]] objectAtIndex:1] withOperation:[[orderDetailDictionary objectForKey:[objectIds objectAtIndex:i]] objectAtIndex:3] withParts:[[orderDetailDictionary objectForKey:[objectIds objectAtIndex:i]] objectAtIndex:4] withWSM:[[orderDetailDictionary objectForKey:[objectIds objectAtIndex:i]] objectAtIndex:5] withObjects:[[orderDetailDictionary objectForKey:[objectIds objectAtIndex:i]] objectAtIndex:7] withSystemStatus:[[orderDetailDictionary objectForKey:[objectIds objectAtIndex:i]] objectAtIndex:6] withPermitsWorkApplications:[[orderDetailDictionary objectForKey:[objectIds objectAtIndex:i]] objectAtIndex:8] withIssuePermits:[[orderDetailDictionary objectForKey:[objectIds objectAtIndex:i]] objectAtIndex:9] withPermitsOperationWCD:[[orderDetailDictionary objectForKey:[objectIds objectAtIndex:i]] objectAtIndex:10] withPermitsOperationWCDTagiingConditions:orderWcmOperationWCDTaggingConditionsArray withPermitsStandardCheckPoints:orderWcmPermitsStandardCheckPoints withMeasurementDocs:[[orderDetailDictionary objectForKey:[objectIds objectAtIndex:i]] objectAtIndex:11]];
                    }
                }
                
                if (!isRefresh) {
                    
                    //                    [DMPasscode removePasscode];
                    //
                    //                    [DMPasscode setupPasscodeInViewController:self.parentViewController completion:^(BOOL success, NSError *error) {
                    //
                    //                        if (success) {
                    //                            [defaults removeObjectForKey:@"BIOMETRIC"];
                    //                        }
                    //                        else{
                    //
                    //                            [defaults removeObjectForKey:@"password"];
                    //                            [defaults removeObjectForKey:@"userName"];
                    //                            [defaults removeObjectForKey:@"INITIAL"];
                    //
                    //                            [self.navigationController popToRootViewControllerAnimated:YES];
                    //                        }
                    //
                    //                        [defaults synchronize];
                    //
                    //                    }];
                }
                
 
 
                if ([defaults objectForKey:@"DORD_REFRESH"]) {
                    
                    [MBProgressHUD hideHUDForView:self.view animated:YES];

                }
               
            }
 
            
            break;
            
        case GET_STOCK_DATA:
            
            if (!errorDescription.length) {
                
                NSMutableDictionary *parsedDictionary = [[Response sharedInstance] parseForStockOverView:resultData];
                
                NSLog(@"Stock data  called");

                
                if ([parsedDictionary objectForKey:@"ERROR"]) {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"ERROR" message:[parsedDictionary objectForKey:@"ERROR"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    [alert show];
                }
                else if ([parsedDictionary objectForKey:@"result"]) {
                    
                    if ([[defaults objectForKey:@"ACTIVATELOGS"] isEqualToString:@"X"])
                    {
                        [[DataBase sharedInstance] writToLogFile:[NSString stringWithFormat:@"#INFO#.com.enstrapp.fieldtekpro#Stock Data received"]];
                    }
                    
                    NSMutableArray *stockMasterDataArray = [NSMutableArray new];
                    
                    if ([[parsedDictionary objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
                        [stockMasterDataArray addObject:[NSMutableArray arrayWithObject:[parsedDictionary objectForKey:@"result"]]];
                    }
                    else if ([[parsedDictionary objectForKey:@"result"] isKindOfClass:[NSArray class]]){
                        
                        [stockMasterDataArray addObjectsFromArray:[parsedDictionary objectForKey:@"result"]];
                    }
                    
                    if (!stockDeleted) {
                        
                        AppDelegate *tempDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                        [tempDelegate.coreDataControlObject removeContextForStockOverView:@""];
                    }
                    
                    [[DataBase sharedInstance] insertStockOverViewToCoreDataFromArray:stockMasterDataArray];
                }
            }
            
            [self performSelectorOnMainThread:@selector(dispatchQueuesForMeasurementDocuments) withObject:nil waitUntilDone:YES];
            
            
            break;
            
        case GET_CUSTOM_FIELDS:
            
            if (!errorDescription.length) {
                NSMutableDictionary *parsedDictionary = [[Response sharedInstance] parseForCustomFields:resultData];
                if ([parsedDictionary objectForKey:@"Message"]) {
                    id customFields = [parsedDictionary objectForKey:@"Message"];
                    NSMutableArray *customFieldsArray = [NSMutableArray new];
                    for (int i =0; i<[customFields count]; i++) {
                        NSString *str_Zdoctype = [NSString stringWithFormat:@"%@",[[customFields objectAtIndex:i] objectForKey:@"Zdoctype"]];
                        NSString *str_ZdoctypeItem = [NSString stringWithFormat:@"%@",[[customFields objectAtIndex:i] objectForKey:@"ZdoctypeItem"]];
                        NSString *str_Tabname = [NSString stringWithFormat:@"%@",[[customFields objectAtIndex:i] objectForKey:@"Tabname"]];
                        NSString *str_Fieldname = [NSString stringWithFormat:@"%@",[[customFields objectAtIndex:i] objectForKey:@"Fieldname"]];
                        NSString *str_Flabel = [NSString stringWithFormat:@"%@",[[customFields objectAtIndex:i] objectForKey:@"Flabel"]];
                        NSString *str_Datatype = [NSString stringWithFormat:@"%@",[[customFields objectAtIndex:i] objectForKey:@"Datatype"]];
                        NSString *str_Sequence = [NSString stringWithFormat:@"%@",[[customFields objectAtIndex:i] objectForKey:@"Sequence"]];
                        NSString *str_Length = [NSString stringWithFormat:@"%@",[[customFields objectAtIndex:i] objectForKey:@"Length"]];
                        if ([NullChecker isNull:str_Zdoctype]) {
                            str_Zdoctype = @"";
                        }
                        if ([NullChecker isNull:str_ZdoctypeItem]) {
                            str_ZdoctypeItem = @"";
                        }
                        if ([NullChecker isNull:str_Tabname]) {
                            str_Tabname = @"";
                        }
                        if ([NullChecker isNull:str_Fieldname]) {
                            str_Fieldname = @"";
                        }
                        if ([NullChecker isNull:str_Flabel]) {
                            str_Flabel = @"";
                        }
                        if ([NullChecker isNull:str_Datatype]) {
                            str_Datatype = @"";
                        }
                        if ([NullChecker isNull:str_Sequence]) {
                            str_Sequence = @"";
                        }
                        if ([NullChecker isNull:str_Length]) {
                            str_Length = @"";
                        }
                        // Here @"" empty string is value.
                        [customFieldsArray addObject:[NSMutableArray arrayWithObjects:str_Zdoctype,str_ZdoctypeItem,str_Tabname,str_Fieldname,@"",str_Flabel,str_Datatype,str_Sequence,str_Length, nil]];
                    }
                    
                    [[DataBase sharedInstance] deleteCustomFields];
                    
                    [[DataBase sharedInstance] insertCustomFields:customFieldsArray];
                }
            }
            
            break;
            
        case GET_WSM_MASTERDATA:
            
            if (!errorDescription.length) {
                
                NSMutableDictionary *parsedDictionary = [[Response sharedInstance] parseForWSMMasterData:resultData];
                
                //WSM
                [DashBoardViewController functionForWsmRisks:parsedDictionary];
                [DashBoardViewController functionForWsmResponses:parsedDictionary];
                [DashBoardViewController functionForWsmObjAvail:parsedDictionary];
                [DashBoardViewController functionForWsmMaterial:parsedDictionary];
                [DashBoardViewController functionForWsmDocument:parsedDictionary];
                [DashBoardViewController functionForWsmEqui:parsedDictionary];
                [DashBoardViewController functionForWsmEqui:parsedDictionary];
                [DashBoardViewController functionForWsmPermit:parsedDictionary];
                [DashBoardViewController functionForWsmWcmr:parsedDictionary];
                //[DashBoardViewController functionForWsmPlants:parsedDictionary];  //newlyadded
            }
            
            break;
            
        case ORDER_MDOCS:
            
            if (!errorDescription.length) {
                
                NSMutableDictionary *parsedDictionary = [[Response sharedInstance] parseForMeasurementDocs:resultData];
                
                 NSLog(@"MDocs called");

                [DashBoardViewController functionForMDocs:[parsedDictionary objectForKey:@"resultMDocs"]];
                
             }
            
            break;
            
        default: break;
    }
}


+(void)functionForAppSettingsData :(id)resultAppData
{
    NSMutableArray *resultAppDataArray = [NSMutableArray new];
    
    if ([resultAppData isKindOfClass:[NSDictionary class]]) {
        [resultAppDataArray addObject:[NSMutableArray arrayWithObject:resultAppData]];
    }
    else if ([resultAppData isKindOfClass:[NSArray class]]){
        
        [resultAppDataArray addObjectsFromArray:resultAppData];
    }
    
    [[DataBase sharedInstance] insertintoAppSettingsMaster:resultAppDataArray];
}

+(void)functionForNFCSettingsData :(id)resultNFC{
    
    NSMutableArray *mutarr_NFCSettingsData = [[NSMutableArray alloc]init];
    
    if ([resultNFC isKindOfClass:[NSDictionary class]]) {
        [mutarr_NFCSettingsData addObject:[NSMutableArray arrayWithObject:resultNFC]];
    }
    else if ([resultNFC isKindOfClass:[NSArray class]]) {
        [mutarr_NFCSettingsData addObjectsFromArray:resultNFC];
    }
    
    [[DataBase sharedInstance] insertintoNFCSettingsMaster:mutarr_NFCSettingsData];
}

+(void)functionForActivityTypeData :(id)resultLstar{
    
    NSMutableArray *activityDataArray = [[NSMutableArray alloc]init];
    
    if ([resultLstar isKindOfClass:[NSDictionary class]]) {
        [activityDataArray addObject:[NSMutableArray arrayWithObject:resultLstar]];
    }
    else if ([resultLstar isKindOfClass:[NSArray class]]){
        
        [activityDataArray addObjectsFromArray:resultLstar];
    }
    
    [[DataBase sharedInstance] insertintoActivityTypeData:activityDataArray];
}

+(void)functionForNotifEffect :(id)resultNotifEffect{
    
    NSMutableArray *notifEffectArray = [NSMutableArray new];
    
    if ([resultNotifEffect isKindOfClass:[NSDictionary class]]) {
        [notifEffectArray addObject:[NSMutableArray arrayWithObject:resultNotifEffect]];
    }
    else if ([resultNotifEffect isKindOfClass:[NSArray class]]){
        
        [notifEffectArray addObjectsFromArray:resultNotifEffect];
    }
    
    [[DataBase sharedInstance] insertintoNotifEffect:notifEffectArray];
}

+(void)functionForOrderSystemCondition :(id)resultOrderSystemCondition{
    
    NSMutableArray *orderSystemConditionArray = [NSMutableArray new];
    
    if ([resultOrderSystemCondition isKindOfClass:[NSDictionary class]]) {
        [orderSystemConditionArray addObject:[NSMutableArray arrayWithObject:resultOrderSystemCondition]];
    }
    else if ([resultOrderSystemCondition isKindOfClass:[NSArray class]]){
        
        [orderSystemConditionArray addObjectsFromArray:resultOrderSystemCondition];
    }
    
    [[DataBase sharedInstance] insertintoOrderSystemCondition:orderSystemConditionArray];
}

+(void)functionForNotifOrderTypeRelationMaster :(id)resultEtTq80{
    
    NSMutableArray *orderEtTq80Array = [NSMutableArray new];
    
    if ([resultEtTq80 isKindOfClass:[NSDictionary class]]) {
        [orderEtTq80Array addObject:[NSMutableArray arrayWithObject:resultEtTq80]];
    }
    else if ([resultEtTq80 isKindOfClass:[NSArray class]]){
        
        [orderEtTq80Array addObjectsFromArray:resultEtTq80];
    }
    
    [[DataBase sharedInstance] insertintoEtTq80:orderEtTq80Array];
}

 
+(void)functionForPlannerGroupMaster :(id)resultIngrp{
    
    NSMutableArray *vhlpInGrpArray = [NSMutableArray new];
    
    if ([resultIngrp isKindOfClass:[NSDictionary class]]) {
        [vhlpInGrpArray addObject:[NSMutableArray arrayWithObject:resultIngrp]];
    }
    else if ([resultIngrp isKindOfClass:[NSArray class]]){
        
        [vhlpInGrpArray addObjectsFromArray:resultIngrp];
    }
    
    [[DataBase sharedInstance] insertintoInGrp:vhlpInGrpArray];
}

+(void)functionForPersonResponsibleMaster :(id)resultPernr{
    
    NSMutableArray *vhlpPernrArray = [NSMutableArray new];
    
    if ([resultPernr isKindOfClass:[NSDictionary class]]) {
        [vhlpPernrArray addObject:[NSMutableArray arrayWithObject:resultPernr]];
    }
    else if ([resultPernr isKindOfClass:[NSArray class]]){
        
        [vhlpPernrArray addObjectsFromArray:resultPernr];
    }
    
    [[DataBase sharedInstance] insertintoPernr:vhlpPernrArray];
}



+(void)functionForAuthorizationGroupMaster :(id)resultAuthorizationGroup{
    
    NSMutableArray *vhlpAuthorizationArray = [NSMutableArray new];
    
    if ([resultAuthorizationGroup isKindOfClass:[NSDictionary class]]) {
        [vhlpAuthorizationArray addObject:[NSMutableArray arrayWithObject:resultAuthorizationGroup]];
    }
    else if ([resultAuthorizationGroup isKindOfClass:[NSArray class]]){
        
        [vhlpAuthorizationArray addObjectsFromArray:resultAuthorizationGroup];
    }
    
    [[DataBase sharedInstance] insertintoAuthorizationGroup:vhlpAuthorizationArray];
}


+(void)functionForUsagesMaster :(id)resultUsages{
    
    NSMutableArray *vhlpUsagesArray = [NSMutableArray new];
    
    if ([resultUsages isKindOfClass:[NSDictionary class]]) {
        [vhlpUsagesArray addObject:[NSMutableArray arrayWithObject:resultUsages]];
    }
    else if ([resultUsages isKindOfClass:[NSArray class]]){
        
        [vhlpUsagesArray addObjectsFromArray:resultUsages];
    }
    
    [[DataBase sharedInstance] insertintoUsages:resultUsages];
}

+(void)functionForNotifType :(id)resultNotifTypes{
    
    NSMutableArray *notificationTypeArray = [NSMutableArray new];
    
    if ([resultNotifTypes isKindOfClass:[NSDictionary class]]) {
        [notificationTypeArray addObject:[NSMutableArray arrayWithObject:resultNotifTypes]];
    }
    else if ([resultNotifTypes isKindOfClass:[NSArray class]]){
        
        [notificationTypeArray addObjectsFromArray:resultNotifTypes];
    }
    
    [[DataBase sharedInstance] insertintoNotificationType:notificationTypeArray];
}

+(void)functionForNotifPriority :(id)resultNotifPriority{
    
    NSMutableArray *notificationProiority = [NSMutableArray new];
    
    if ([resultNotifPriority isKindOfClass:[NSDictionary class]]) {
        
        [notificationProiority addObject:[NSMutableArray arrayWithObject:resultNotifPriority]];
    }
    else if ([resultNotifPriority isKindOfClass:[NSArray class]]){
        
        [notificationProiority addObjectsFromArray:resultNotifPriority];
    }
    
    [[DataBase sharedInstance] insertintoNotifPriority:notificationProiority];
}

+(void)functionForOrderPriority :(id)resultOrderPriority{
    
    NSMutableArray *orderPriority = [NSMutableArray new];
    
    if ([resultOrderPriority isKindOfClass:[NSDictionary class]]) {
        [orderPriority addObject:[NSMutableArray arrayWithObject:resultOrderPriority]];
    }
    else if ([resultOrderPriority isKindOfClass:[NSArray class]]){
        
        [orderPriority addObjectsFromArray:resultOrderPriority];
    }
    
    [[DataBase sharedInstance] insertintoOrderPriority:orderPriority];
}

+(void)functionForCostCenter :(id)resultKostl{
    
    NSMutableArray *costCenterArray = [NSMutableArray new];
    
    if ([resultKostl isKindOfClass:[NSDictionary class]]) {
        
        [costCenterArray addObject:[NSMutableArray arrayWithObject:resultKostl]];
    }
    else if ([resultKostl isKindOfClass:[NSArray class]]){
        
        [costCenterArray addObjectsFromArray:resultKostl];
    }
    
    [[DataBase sharedInstance] insertintoCostCenter:costCenterArray];
}

+(void)functionForConfirmReason :(id)resultConfReason{
    
    NSMutableArray *resultConfReasonArray = [[NSMutableArray alloc]init];
    
    if ([resultConfReason isKindOfClass:[NSDictionary class]]) {
        [resultConfReasonArray addObject:[NSMutableArray arrayWithObject:resultConfReason]];
    }
    else if ([resultConfReason isKindOfClass:[NSArray class]]){
        
        [resultConfReasonArray addObjectsFromArray:resultConfReasonArray];
    }
    
    [[DataBase sharedInstance] insertintoConfirmReason:resultConfReasonArray];
}

+(void)functionForUserData :(id)resultUser{
    
    NSMutableArray *resultUserArray = [NSMutableArray new];
    
    if ([resultUser isKindOfClass:[NSDictionary class]]) {
        [resultUserArray addObject:[NSMutableArray arrayWithObject:resultUser]];
    }
    else if ([resultUser isKindOfClass:[NSArray class]]){
        
        [resultUserArray addObjectsFromArray:resultUser];
    }
    
    [[DataBase sharedInstance] insertintoUserData:resultUserArray];
}

+(void)functionForEtMeasCodes :(id)resultMeasCodes{
    
    NSMutableArray *itemMeasCodesArray = [[NSMutableArray alloc] init];
            
    if ([resultMeasCodes isKindOfClass:[NSDictionary class]])
    {
        [itemMeasCodesArray addObject:[NSMutableArray arrayWithObject:resultMeasCodes]];
    }
    else if ([resultMeasCodes isKindOfClass:[NSArray class]]){
                
        [itemMeasCodesArray addObjectsFromArray:resultMeasCodes];
    }
                        
    [[DataBase sharedInstance] insertMeascodes:itemMeasCodesArray];
 
}

+(void)functionForAllNotifCodes :(id)resultNotifCodes{
    
    [[DataBase sharedInstance] deleteAllNotifCodesMasters];
 
    for (int i=0; i<[resultNotifCodes count]; i++) {
        
        id parsedResultNotifCodes;
        
        parsedResultNotifCodes = [resultNotifCodes objectAtIndex:i];
 
    
     if ([parsedResultNotifCodes objectForKey:@"ItemCodes"]) {
        
        id itemCodesDetails = [[parsedResultNotifCodes objectForKey:@"ItemCodes"] objectForKey:@"results"];
        
        NSMutableArray *itemCodeArray = [[NSMutableArray alloc] init];
        
        if ([itemCodesDetails isKindOfClass:[NSDictionary class]]) {
            [itemCodeArray addObject:[NSMutableArray arrayWithObject:itemCodesDetails]];
        }
        else if ([itemCodesDetails isKindOfClass:[NSArray class]]){
            
            [itemCodeArray addObjectsFromArray:itemCodesDetails];
        }
        
        [[DataBase sharedInstance] insertItemCodeDetails:itemCodeArray];
    }
    
    if ([parsedResultNotifCodes objectForKey:@"ActCodes"]) {
        
        id activityCodesDetails = [[parsedResultNotifCodes objectForKey:@"ActCodes"] objectForKey:@"results"];
        
        NSMutableArray *codeGroupArray = [[NSMutableArray alloc] init];
        
        if ([activityCodesDetails isKindOfClass:[NSDictionary class]]) {
            [codeGroupArray addObject:[NSMutableArray arrayWithObject:activityCodesDetails]];
        }
        else if ([activityCodesDetails isKindOfClass:[NSArray class]]){
            
            [codeGroupArray addObjectsFromArray:activityCodesDetails];
        }
 
        [[DataBase sharedInstance] insertActCodeDetails:codeGroupArray];
        
     }
    
    if ([parsedResultNotifCodes objectForKey:@"CauseCodes"]) {
        
        id causeCodeDetails = [[parsedResultNotifCodes objectForKey:@"CauseCodes"] objectForKey:@"results"];
        
        NSMutableArray *causeCodeArray = [[NSMutableArray alloc] init];
        
        if ([causeCodeDetails isKindOfClass:[NSDictionary class]]) {
            [causeCodeArray addObject:[NSMutableArray arrayWithObject:causeCodeDetails]];
        }
        else if ([causeCodeDetails isKindOfClass:[NSArray class]]){
            
            [causeCodeArray addObjectsFromArray:causeCodeDetails];
        }
        
        [[DataBase sharedInstance] insertCuaseCodeDetails:causeCodeArray];
    }
    
//    if ([resultNotifCodes objectForKey:@"TaskCodes"]) {
//
//        id taskCodeDetails = [[resultNotifCodes objectForKey:@"TaskCodes"] objectForKey:@"results"];
//
//        NSMutableArray *taskCodeArray = [[NSMutableArray alloc] init];
//
//        if ([taskCodeDetails isKindOfClass:[NSDictionary class]]) {
//
//            [taskCodeArray addObject:[NSMutableArray arrayWithObject:taskCodeDetails]];
//        }
//        else if ([taskCodeDetails isKindOfClass:[NSArray class]]){
//
//            [taskCodeArray addObjectsFromArray:taskCodeDetails];
//        }
//
//        [[DataBase sharedInstance] insertTaskCodeDetails:taskCodeArray];
//    }
    
    if ([parsedResultNotifCodes objectForKey:@"ObjectCodes"]) {
        
        id objectCodeDetails = [[parsedResultNotifCodes objectForKey:@"ObjectCodes"] objectForKey:@"results"];
        
        NSMutableArray *objectCodeArray = [[NSMutableArray alloc] init];
        
        if ([objectCodeDetails isKindOfClass:[NSDictionary class]]) {
            
            [objectCodeArray addObject:[NSMutableArray arrayWithObject:objectCodeDetails]];
        }
        else if ([objectCodeDetails isKindOfClass:[NSArray class]]){
            
            [objectCodeArray addObjectsFromArray:objectCodeDetails];
         }
        
         [[DataBase sharedInstance] insertObjectCodeDetails:objectCodeArray];
      }
        
    }
}

+(void)functionForOrderType :(id)resultOrderTypes{
    
    NSMutableArray *orderTypeArray = [NSMutableArray new];
    
    if ([resultOrderTypes isKindOfClass:[NSDictionary class]]) {
        
        [orderTypeArray addObject:[NSMutableArray arrayWithObject:resultOrderTypes]];
    }
    else if ([resultOrderTypes isKindOfClass:[NSArray class]]){
        
        [orderTypeArray addObjectsFromArray:resultOrderTypes];
    }
    
    [[DataBase sharedInstance] insertintoOrderType:orderTypeArray];
}

+(void)functionForAccIndicator :(id)resultBemot{
    
    NSMutableArray *resultBemotArray = [NSMutableArray new];
    
    if ([resultBemot isKindOfClass:[NSDictionary class]]) {
        [resultBemotArray addObject:[NSMutableArray arrayWithObject:resultBemot]];
    }
    else if ([resultBemot isKindOfClass:[NSArray class]]){
        
        [resultBemotArray addObjectsFromArray:resultBemot];
    }
    
    [[DataBase sharedInstance] insertintoAccIndicator:resultBemotArray];
}

+(void)functionForListOfPlants :(id)resultPlants{
    
    NSMutableArray *resultPlantsArray = [NSMutableArray new];
    
    if ([resultPlants isKindOfClass:[NSDictionary class]]) {
        
        [resultPlantsArray addObject:[NSMutableArray arrayWithObject:resultPlants]];
    }
    else if ([resultPlants isKindOfClass:[NSArray class]]){
        
        [resultPlantsArray addObjectsFromArray:resultPlants];
    }
    
    [[DataBase sharedInstance] insertintoPlantsMaster:resultPlantsArray];
}

+(void)functionForListOfStorageLocation :(id)resultStloc{
    
    NSMutableArray *resultStlocArray = [[NSMutableArray alloc]init];
    
    if ([resultStloc isKindOfClass:[NSDictionary class]]) {
        
        [resultStlocArray addObject:[NSMutableArray arrayWithObject:resultStloc]];
    }
    else if ([resultStloc isKindOfClass:[NSArray class]]){
        
        [resultStlocArray addObjectsFromArray:resultStloc];
    }
    
    [[DataBase sharedInstance] insertintoStorageLocationMaster:resultStlocArray];
}

+(void)functionForGetUnits :(id)resultUnits{
    
    NSMutableArray *resultUnitsArray = [NSMutableArray new];
    
    if ([resultUnits isKindOfClass:[NSDictionary class]]) {
        
        [resultUnitsArray addObject:[NSMutableArray arrayWithObject:resultUnits]];
    }
    else if ([resultUnitsArray isKindOfClass:[NSArray class]]){
        
        [resultUnitsArray addObjectsFromArray:resultUnits];
    }
    
    [[DataBase sharedInstance] insertintoGetUnits:resultUnitsArray];
}

+(void)functionForListOfMovementTypes :(id)resultMovementTypes{
    
    NSMutableArray *resultMovementTypesArray = [NSMutableArray new];
    
    if ([resultMovementTypes isKindOfClass:[NSDictionary class]]) {
        [resultMovementTypesArray addObject:[NSMutableArray arrayWithObject:resultMovementTypes]];
    }
    else if ([resultMovementTypes isKindOfClass:[NSArray class]]){
        
        [resultMovementTypesArray addObjectsFromArray:resultMovementTypes];
    }
    
    [[DataBase sharedInstance] insertintoListOfMovementTypes:resultMovementTypesArray];
}

+(void)functionForListOfWorkCenter :(id)resultWkctrPlant{
    
    NSMutableArray *resultWkctrPlantArray = [NSMutableArray new];
    
    if ([resultWkctrPlant isKindOfClass:[NSDictionary class]]) {
        
        [resultWkctrPlantArray addObject:[NSMutableArray arrayWithObject:resultWkctrPlant]];
    }
    else if ([resultWkctrPlant isKindOfClass:[NSArray class]]){
        
        [resultWkctrPlantArray addObjectsFromArray:resultWkctrPlant];
    }
    
    [[DataBase sharedInstance] insertintoListOfWorkCenter:resultWkctrPlantArray];
}


+(void)functionForWCMWork :(id)resultWcmWorks{
    
    NSMutableArray *vhlpWCMWorksArray = [NSMutableArray new];
    
    if ([resultWcmWorks isKindOfClass:[NSDictionary class]]) {
        [vhlpWCMWorksArray addObject:[NSMutableArray arrayWithObject:resultWcmWorks]];
    }
    else if ([resultWcmWorks isKindOfClass:[NSArray class]]){
        
        [vhlpWCMWorksArray addObjectsFromArray:resultWcmWorks];
    }
    
    [[DataBase sharedInstance] insertintoWCMWorks:vhlpWCMWorksArray];
}


+(void)functionForWCMRequirements :(id)resultWcmRequirements{
    
    NSMutableArray *vhlpWCMRequirementsArray = [NSMutableArray new];
    
    if ([resultWcmRequirements isKindOfClass:[NSDictionary class]]) {
        [vhlpWCMRequirementsArray addObject:[NSMutableArray arrayWithObject:resultWcmRequirements]];
    }
    else if ([resultWcmRequirements isKindOfClass:[NSArray class]]){
        
        [vhlpWCMRequirementsArray addObjectsFromArray:resultWcmRequirements];
    }
    
    [[DataBase sharedInstance] insertintoWCMRequirements:vhlpWCMRequirementsArray];
}

+(void)functionForEtwbs :(id)resultWBSData{
    
    NSMutableArray *vhlpWBSArray = [NSMutableArray new];
    
    if ([resultWBSData isKindOfClass:[NSDictionary class]]) {
        [vhlpWBSArray addObject:[NSMutableArray arrayWithObject:resultWBSData]];
    }
    else if ([resultWBSData isKindOfClass:[NSArray class]]){
        
        [vhlpWBSArray addObjectsFromArray:resultWBSData];
    }
    
    [[DataBase sharedInstance] insertintoETWBSData:vhlpWBSArray];
}

+(void)functionForEvRevnr :(id)resultRevenrData{
    
    NSMutableArray *vhlpRevnrArray = [NSMutableArray new];
    
    if ([resultRevenrData isKindOfClass:[NSDictionary class]]) {
        [vhlpRevnrArray addObject:[NSMutableArray arrayWithObject:resultRevenrData]];
    }
    else if ([resultRevenrData isKindOfClass:[NSArray class]]){
        
        [vhlpRevnrArray addObjectsFromArray:resultRevenrData];
    }
    
    [[DataBase sharedInstance] insertintoETREVRData:resultRevenrData];
    
}

+(void)functionForCustomFields :(NSDictionary *)dictData{
    
    if (dictData) {
        
        id customFields = dictData;
        NSMutableArray *customFieldsArray = [NSMutableArray new];
        for (int i =0; i<[customFields count]; i++) {
            NSString *str_Zdoctype = [NSString stringWithFormat:@"%@",[[customFields objectAtIndex:i] objectForKey:@"Zdoctype"]];
            NSString *str_ZdoctypeItem = [NSString stringWithFormat:@"%@",[[customFields objectAtIndex:i] objectForKey:@"ZdoctypeItem"]];
            NSString *str_Tabname = [NSString stringWithFormat:@"%@",[[customFields objectAtIndex:i] objectForKey:@"Tabname"]];
            NSString *str_Fieldname = [NSString stringWithFormat:@"%@",[[customFields objectAtIndex:i] objectForKey:@"Fieldname"]];
            NSString *str_Flabel = [NSString stringWithFormat:@"%@",[[customFields objectAtIndex:i] objectForKey:@"Flabel"]];
            NSString *str_Datatype = [NSString stringWithFormat:@"%@",[[customFields objectAtIndex:i] objectForKey:@"Datatype"]];
            NSString *str_Sequence = [NSString stringWithFormat:@"%@",[[customFields objectAtIndex:i] objectForKey:@"Sequence"]];
            NSString *str_Length = [NSString stringWithFormat:@"%@",[[customFields objectAtIndex:i] objectForKey:@"Length"]];
            if ([NullChecker isNull:str_Zdoctype]) {
                str_Zdoctype = @"";
            }
            if ([NullChecker isNull:str_ZdoctypeItem]) {
                str_ZdoctypeItem = @"";
            }
            if ([NullChecker isNull:str_Tabname]) {
                str_Tabname = @"";
            }
            if ([NullChecker isNull:str_Fieldname]) {
                str_Fieldname = @"";
            }
            if ([NullChecker isNull:str_Flabel]) {
                str_Flabel = @"";
            }
            if ([NullChecker isNull:str_Datatype]) {
                str_Datatype = @"";
            }
            if ([NullChecker isNull:str_Sequence]) {
                str_Sequence = @"";
            }
            if ([NullChecker isNull:str_Length]) {
                str_Length = @"";
            }
            // Here @"" empty string is value.
            [customFieldsArray addObject:[NSMutableArray arrayWithObjects:str_Zdoctype,str_ZdoctypeItem,str_Tabname,str_Fieldname,@"",str_Flabel,str_Datatype,str_Sequence,str_Length, nil]];
        }
        
        [[DataBase sharedInstance] deleteCustomFields];
        
        [[DataBase sharedInstance] insertCustomFields:customFieldsArray];
    }
}

+(void)functionForGetFuncLocFromCostCenter :(NSDictionary *)dictData :(NSString *)str_CostCenter :(NSString *)str_description{
    NSMutableArray *mutarr_Arbpl,*mutarr_Pltxt,*mutarr_Tplnr,*mutarr_Iwerk;
    mutarr_Arbpl = [[NSMutableArray alloc]init];
    mutarr_Pltxt = [[NSMutableArray alloc]init];
    mutarr_Tplnr = [[NSMutableArray alloc]init];
    mutarr_Iwerk = [[NSMutableArray alloc]init];
    
    [[[[dictData objectForKey:@"env:Body"] objectForKey:@"n0:_-ens_-pmSearchFlocResponse"] objectForKey:@"EtFuncloc"] objectForKey:@"item"];
    
    NSArray *arr_Response_FuncLoc = nil;
    
    arr_Response_FuncLoc = [[[[dictData objectForKey:@"env:Body"] objectForKey:@"n0:_-ens_-pmSearchFlocResponse"] objectForKey:@"EtFuncloc"] objectForKey:@"item"];
    
    for (int i =0; i<[arr_Response_FuncLoc count]; i++) {
        NSString *str_Arbpl = [[arr_Response_FuncLoc objectAtIndex:i] objectForKey:@"Arbpl"];
        NSString *str_Pltxt = [[arr_Response_FuncLoc objectAtIndex:i] objectForKey:@"Pltxt"];
        NSString *str_Tplnr = [[arr_Response_FuncLoc objectAtIndex:i] objectForKey:@"Tplnr"];
        NSString *str_Werks = [[arr_Response_FuncLoc objectAtIndex:i] objectForKey:@"Werks"];
        
        if ([NullChecker isNull:str_Arbpl]) {
            str_Arbpl = @"";
            [mutarr_Arbpl addObject:str_Arbpl];
        }
        else
            [mutarr_Arbpl addObject:str_Arbpl];
        
        if ([NullChecker isNull:str_Pltxt]) {
            str_Pltxt = @"";
            [mutarr_Pltxt addObject:str_Pltxt];
        }
        else
            [mutarr_Pltxt addObject:str_Pltxt];
        
        if ([NullChecker isNull:str_Tplnr]) {
            str_Tplnr = @"";
            [mutarr_Tplnr addObject:str_Tplnr];
        }
        else
            [mutarr_Tplnr addObject:str_Tplnr];
        
        if ([NullChecker isNull:str_Werks]) {
            str_Werks = @"";
            [mutarr_Iwerk addObject:str_Werks];
        }
        else
            [mutarr_Iwerk addObject:str_Werks];
    }
    
    [[DataBase sharedInstance] insertintoFuncLocFromCostCenter:mutarr_Tplnr :mutarr_Pltxt :mutarr_Arbpl :mutarr_Iwerk :str_CostCenter];
}

+(void)functionForGetEquipNoFromCostCenter :(NSDictionary *)dictData :(NSString *)str_CostCenter :(NSString *)str_description{
    NSMutableArray *mutarr_Arbpl,*mutarr_Eqktx,*mutarr_Equnr,*mutarr_Spras,*mutarr_Pltxt,*mutarr_Tplnr,*mutarr_Iwerk;
    
    NSDictionary *dicResponse = [[[[dictData objectForKey:@"env:Body"] objectForKey:@"n0:_-ens_-pmSearchEquipResponse"] objectForKey:@"EtEquip"] objectForKey:@"item"];
    if (dicResponse.count == 0) {
        //        UIAlertView *alertEmptyRepsonse =[[UIAlertView alloc]initWithTitle:@"Info" message:@"No suitable data found for the selected criteria!!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        //        [alertEmptyRepsonse show];
        //
    }
    else{
        mutarr_Arbpl = [[NSMutableArray alloc]init];
        mutarr_Eqktx = [[NSMutableArray alloc]init];
        mutarr_Equnr = [[NSMutableArray alloc]init];
        mutarr_Spras = [[NSMutableArray alloc]init];
        mutarr_Pltxt = [[NSMutableArray alloc]init];
        mutarr_Tplnr = [[NSMutableArray alloc]init];
        mutarr_Iwerk = [[NSMutableArray alloc]init];
        
        if ([dicResponse isKindOfClass:[NSDictionary class]]) {
            NSString *str_Arbpl = [dicResponse objectForKey:@"Arbpl"];
            NSString *str_Eqktx = [dicResponse objectForKey:@"Eqktx"];
            NSString *str_Equnr = [dicResponse objectForKey:@"Equnr"];
            NSString *str_Iwerk = [dicResponse objectForKey:@"Iwerk"];
            NSString *str_Pltxt = [dicResponse objectForKey:@"Pltxt"];
            NSString *str_Spras = [dicResponse objectForKey:@"Spras"];
            NSString *str_Tplnr = [dicResponse objectForKey:@"Tplnr"];
            
            if ([NullChecker isNull:str_Arbpl]) {
                str_Arbpl = @"";
                [mutarr_Arbpl addObject:str_Arbpl];
            }
            else
                [mutarr_Arbpl addObject:str_Arbpl];
            
            if ([NullChecker isNull:str_Eqktx]) {
                str_Eqktx = @"";
                [mutarr_Eqktx addObject:str_Eqktx];
            }
            else
                [mutarr_Eqktx addObject:str_Eqktx];
            
            if ([NullChecker isNull:str_Equnr]) {
                str_Equnr = @"";
                [mutarr_Equnr addObject:str_Equnr];
            }
            else
                [mutarr_Equnr addObject:str_Equnr];
            
            if ([NullChecker isNull:str_Iwerk]) {
                str_Iwerk = @"";
                [mutarr_Iwerk addObject:str_Iwerk];
            }
            else
                [mutarr_Iwerk addObject:str_Iwerk];
            
            if ([NullChecker isNull:str_Pltxt]) {
                str_Pltxt = @"";
                [mutarr_Pltxt addObject:str_Pltxt];
            }
            else
                [mutarr_Pltxt addObject:str_Pltxt];
            
            if ([NullChecker isNull:str_Spras]) {
                str_Spras = @"";
                [mutarr_Spras addObject:str_Spras];
            }
            else
                [mutarr_Spras addObject:str_Spras];
            
            
            if ([NullChecker isNull:str_Tplnr]) {
                str_Tplnr = @"";
                [mutarr_Tplnr addObject:str_Tplnr];
            }
            else
                [mutarr_Tplnr addObject:str_Tplnr];
        }
        else if ([dicResponse isKindOfClass:[NSArray class]]){
            NSArray *arr_EquipCostCenter = nil;
            arr_EquipCostCenter = [[[[dictData objectForKey:@"env:Body"] objectForKey:@"n0:_-ens_-pmSearchEquipResponse"] objectForKey:@"EtEquip"] objectForKey:@"item"];
            
            for (int i =0; i< [arr_EquipCostCenter count]; i++) {
                NSString *str_Arbpl = [[arr_EquipCostCenter objectAtIndex:i] objectForKey:@"Arbpl"];
                NSString *str_Eqktx = [[arr_EquipCostCenter objectAtIndex:i] objectForKey:@"Eqktx"];
                NSString *str_Equnr = [[arr_EquipCostCenter objectAtIndex:i] objectForKey:@"Equnr"];
                NSString *str_Iwerk = [[arr_EquipCostCenter objectAtIndex:i] objectForKey:@"Iwerk"];
                NSString *str_Pltxt = [[arr_EquipCostCenter objectAtIndex:i] objectForKey:@"Pltxt"];
                NSString *str_Spras = [[arr_EquipCostCenter objectAtIndex:i] objectForKey:@"Spras"];
                NSString *str_Tplnr = [[arr_EquipCostCenter objectAtIndex:i] objectForKey:@"Tplnr"];
                
                if ([NullChecker isNull:str_Arbpl]) {
                    str_Arbpl = @"";
                    [mutarr_Arbpl addObject:str_Arbpl];
                }
                else
                    [mutarr_Arbpl addObject:str_Arbpl];
                
                if ([NullChecker isNull:str_Eqktx]) {
                    str_Eqktx = @"";
                    [mutarr_Eqktx addObject:str_Eqktx];
                }
                else
                    [mutarr_Eqktx addObject:str_Eqktx];
                
                if ([NullChecker isNull:str_Equnr]) {
                    str_Equnr = @"";
                    [mutarr_Equnr addObject:str_Equnr];
                }
                else
                    [mutarr_Equnr addObject:str_Equnr];
                
                if ([NullChecker isNull:str_Iwerk]) {
                    str_Iwerk = @"";
                    [mutarr_Iwerk addObject:str_Iwerk];
                }
                else [mutarr_Iwerk addObject:str_Iwerk];
                
                if ([NullChecker isNull:str_Spras]) {
                    str_Spras = @"";
                    [mutarr_Spras addObject:str_Spras];
                }
                else
                    [mutarr_Spras addObject:str_Spras];
                
                if ([NullChecker isNull:str_Pltxt]) {
                    str_Pltxt = @"";
                    [mutarr_Pltxt addObject:str_Pltxt];
                }
                else
                    [mutarr_Pltxt addObject:str_Pltxt];
                
                if ([NullChecker isNull:str_Tplnr]) {
                    str_Tplnr = @"";
                    [mutarr_Tplnr addObject:str_Tplnr];
                }
                else
                    [mutarr_Tplnr addObject:str_Tplnr];
            }
        }
        
        [[DataBase sharedInstance] insertintoEuipNoFromCostCenter:mutarr_Arbpl :mutarr_Eqktx :mutarr_Equnr :mutarr_Iwerk :mutarr_Spras :mutarr_Pltxt :mutarr_Tplnr :str_CostCenter];
    }
}

+(NSDictionary *)dataWithXMLString:(NSDictionary *)dictData :(NSString *)functionCall :(NSString *)str_CostCenter :(NSString *)str_description{
    
    if ([functionCall isEqual:@"FUNCLOC_COSTCENTER"]) {
        [self functionForGetFuncLocFromCostCenter:dictData :str_CostCenter :str_description];
    }
    else if ([functionCall isEqual:@"EQUIPNO_COSTCENTER"]){
        [self functionForGetEquipNoFromCostCenter:dictData :str_CostCenter :str_description];
    }
    return nil;
}

+(void)functionForControlKeys :(id)resultControlKeys
{
    NSMutableArray *resultControlKeysArray = [NSMutableArray new];
    
    if ([resultControlKeys isKindOfClass:[NSDictionary class]]) {
        
        [resultControlKeysArray addObject:[NSMutableArray arrayWithObject:resultControlKeys]];
    }
    else if ([resultControlKeys isKindOfClass:[NSArray class]]){
        
        [resultControlKeysArray addObjectsFromArray:resultControlKeys];
    }
    
    [[DataBase sharedInstance] insertControlKeys:resultControlKeysArray];
}

-(void)functionForAutherization :(id)resultUser
{
    NSMutableArray *resultUserArray = [NSMutableArray new];
    
    if ([[resultUser objectForKey:@"resultUser"] isKindOfClass:[NSDictionary class]]) {
        
        [resultUserArray addObject:[NSMutableArray arrayWithObject:[resultUser objectForKey:@"resultUser"]]];
    }
    else if ([[resultUser objectForKey:@"resultUser"] isKindOfClass:[NSArray class]]){
        
        [resultUserArray addObjectsFromArray:[resultUser objectForKey:@"resultUser"]];
    }
    
    [[DataBase sharedInstance] insertintoUserData:resultUserArray];
    
    if ([[resultUser objectForKey:@"Busfresult"] isKindOfClass:[NSArray class]]) {
        
        id busfResult = [resultUser objectForKey:@"Busfresult"];
        
        if (busfResultArray == nil) {
            
            busfResultArray = [NSMutableArray new];
        }
        else{
            
            [busfResultArray removeAllObjects];
        }
        
      //  busfResult = [[busfResult objectAtIndex:0] objectForKey:@"item"];
        
        if ([busfResult isKindOfClass:[NSDictionary class]]) {
            
            [busfResultArray addObjectsFromArray:[NSMutableArray arrayWithObject:busfResult]];
        }
        else if ([busfResult isKindOfClass:[NSArray class]]){
            
            [busfResultArray addObjectsFromArray:busfResult];
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:busfResultArray forKey:@"BusinessFunctions"];
    }
    
    if ([[resultUser objectForKey:@"MUserresult"] isKindOfClass:[NSArray class]]) {
        
        id mUserResult = [resultUser objectForKey:@"MUserresult"];
        
        if (mUserFResultArray == nil) {
            mUserFResultArray = [NSMutableArray new];
        }
        else{
            [mUserFResultArray removeAllObjects];
        }
        
       // mUserResult = [[mUserResult objectAtIndex:0] objectForKey:@"item"];
        
        if ([mUserResult isKindOfClass:[NSDictionary class]]) {
            
            [mUserFResultArray addObject:[NSMutableArray arrayWithObject:mUserResult]];
        }
        else if ([mUserResult isKindOfClass:[NSArray class]]){
            
            [mUserFResultArray addObjectsFromArray:mUserResult];
        }
        
        [[DataBase sharedInstance] insertintoMUserData:mUserFResultArray];
    }
    
    if ([[resultUser objectForKey:@"Scrfresult"] isKindOfClass:[NSArray class]]) {
        id scrfResult = [resultUser objectForKey:@"Scrfresult"];
        
        if (screenUserresultArray == nil) {
            screenUserresultArray = [NSMutableArray new];
        }
        else{
            [screenUserresultArray removeAllObjects];
        }
        
       // scrfResult = [[scrfResult objectAtIndex:0] objectForKey:@"item"];
        
        if ([scrfResult isKindOfClass:[NSDictionary class]]) {
            [screenUserresultArray addObject:[NSMutableArray arrayWithObject:scrfResult]];
        }
        else if ([scrfResult isKindOfClass:[NSArray class]]){
            
            [screenUserresultArray addObjectsFromArray:scrfResult];
        }
        
        [[DataBase sharedInstance] insertintoScreenUserData:mUserFResultArray];
    }
    
    NSMutableArray *activityDocTypeArray = [NSMutableArray new];
    
    if ([[resultUser objectForKey:@"Usrfresult"] isKindOfClass:[NSArray class]]) {
        
        id usrfResult = [resultUser objectForKey:@"Usrfresult"];
        
      //  usrfResult = [[usrfResult objectAtIndex:0] objectForKey:@"item"];
        
        if ([usrfResult isKindOfClass:[NSDictionary class]]) {
            [activityDocTypeArray addObjectsFromArray:[NSMutableArray arrayWithObject:usrfResult]];
        }
        else if ([usrfResult isKindOfClass:[NSArray class]]){
            
            [activityDocTypeArray addObjectsFromArray:usrfResult];
        }
        
        [[DataBase sharedInstance] insertintoUserFunctionData:activityDocTypeArray];
        
        [[NSUserDefaults standardUserDefaults] setObject:activityDocTypeArray forKey:@"activityDocType"];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self functionCallstobeShown];
}

+(void)functionForSettings :(id)resultAppData
{
    NSMutableArray *resultAppDataArray = [NSMutableArray new];
    
    if ([resultAppData isKindOfClass:[NSDictionary class]]) {
        [resultAppDataArray addObject:[NSMutableArray arrayWithObject:resultAppData]];
    }
    else if ([resultAppData isKindOfClass:[NSArray class]]){
        
        [resultAppDataArray addObjectsFromArray:resultAppData];
    }
    
    [[DataBase sharedInstance] insertintoAppSettingsMaster:resultAppDataArray];
}

+(void)functionForMDocs :(id)resultMDocs{
    
    NSMutableArray *resultMDocsArray = [NSMutableArray new];
    
    if ([resultMDocs isKindOfClass:[NSDictionary class]]) {
        [resultMDocsArray addObject:[NSMutableArray arrayWithObject:resultMDocs]];
    }
    else if ([resultMDocs isKindOfClass:[NSArray class]]){
        
        [resultMDocsArray addObjectsFromArray:[resultMDocs copy]];
    }
    
    [[DataBase sharedInstance] insertEquipMpttToCoreDataFromArray:resultMDocsArray];
}

#pragma mark -
#pragma mark - WSM

+(void)functionForWsmRisks :(id)WSMRisks
{
    NSMutableArray *arr_ResponseGetListOfWsmRisks = [NSMutableArray new];
    
    WSMRisks = [[[WSMRisks objectForKey:@"resultWSMRisks"] objectAtIndex:0] objectForKey:@"item"];
    
    if ([WSMRisks isKindOfClass:[NSDictionary class]]) {
        
        [arr_ResponseGetListOfWsmRisks addObject:[NSMutableArray arrayWithObject:WSMRisks]];
    }
    else if ([WSMRisks isKindOfClass:[NSArray class]]){
        
        [arr_ResponseGetListOfWsmRisks addObjectsFromArray:WSMRisks];
    }
    
    [[DataBase sharedInstance] insertWsmRisks:arr_ResponseGetListOfWsmRisks];
}

+(void)functionForWsmResponses :(id)WSMResponses
{
    NSMutableArray *arr_ResponseGetListOfWsmResponses = [NSMutableArray new];
    
    if ([[WSMResponses objectForKey:@"resultWSMResponses"] isKindOfClass:[NSDictionary class]]) {
        [arr_ResponseGetListOfWsmResponses addObject:[NSMutableArray arrayWithObject:WSMResponses]];
    }
    else if ([[WSMResponses objectForKey:@"resultWSMResponses"] isKindOfClass:[NSArray class]]){
        
        WSMResponses = [[[WSMResponses objectForKey:@"resultWSMResponses"] objectAtIndex:0] objectForKey:@"item"];
        
        [arr_ResponseGetListOfWsmResponses addObjectsFromArray:WSMResponses];
    }
    
    [[DataBase sharedInstance] insertWsmResponses:arr_ResponseGetListOfWsmResponses];
}

+(void)functionForWsmObjAvail :(id)WSMObjAvail
{
    NSMutableArray *mutarr_wsmobjavail = [[NSMutableArray alloc]init];
    
    if ([[WSMObjAvail objectForKey:@"resultWSMObjAvail"] isKindOfClass:[NSArray class]]) {
        
        WSMObjAvail = [[WSMObjAvail objectForKey:@"resultWSMObjAvail"] objectAtIndex:0];
        
        if ([WSMObjAvail objectForKey:@"Document"]) {
            NSString *valueString = [WSMObjAvail objectForKey:@"Document"];
            [mutarr_wsmobjavail addObject:[NSArray arrayWithObjects:@"Document",valueString, nil]];
        }
        
        if ([WSMObjAvail objectForKey:@"Material"]) {
            NSString *valueString = [WSMObjAvail objectForKey:@"Material"];
            [mutarr_wsmobjavail addObject:[NSArray arrayWithObjects:@"Material",valueString, nil]];
        }
        
        if ([WSMObjAvail objectForKey:@"Note"]) {
            NSString *valueString = [WSMObjAvail objectForKey:@"Note"];
            [mutarr_wsmobjavail addObject:[NSArray arrayWithObjects:@"Note",valueString, nil]];
        }
        
        if ([WSMObjAvail objectForKey:@"Permit"]) {
            NSString *valueString = [WSMObjAvail objectForKey:@"Permit"];
            [mutarr_wsmobjavail addObject:[NSArray arrayWithObjects:@"Permit",valueString, nil]];
        }
        
        if ([WSMObjAvail objectForKey:@"Prt"]) {
            NSString *valueString = [WSMObjAvail objectForKey:@"Prt"];
            [mutarr_wsmobjavail addObject:[NSArray arrayWithObjects:@"Equipment",valueString, nil]];
        }
        
        if ([WSMObjAvail objectForKey:@"Wcmr"]) {
            NSString *valueString = [WSMObjAvail objectForKey:@"Wcmr"];
            [mutarr_wsmobjavail addObject:[NSArray arrayWithObjects:@"Wcm Requirement",valueString, nil]];
        }
    }
    
    [[DataBase sharedInstance] insertWsmObjAvail:mutarr_wsmobjavail];
}

+(void)functionForWsmMaterial :(id)WSMMaterial
{
    NSMutableArray *arr_ResponseGetListOfWsmMaterial = [NSMutableArray new];
    
    if ([[WSMMaterial objectForKey:@"resultWSMMaterial"] isKindOfClass:[NSDictionary class]]) {
        
        [arr_ResponseGetListOfWsmMaterial addObject:[NSMutableArray arrayWithObject:[[[WSMMaterial objectForKey:@"resultWSMMaterial"] objectAtIndex:0] objectForKey:@"item"]]];
    }
    else if ([[WSMMaterial objectForKey:@"resultWSMMaterial"] isKindOfClass:[NSArray class]]) {
        
        [arr_ResponseGetListOfWsmMaterial addObjectsFromArray:[[[WSMMaterial objectForKey:@"resultWSMMaterial"] objectAtIndex:0] objectForKey:@"item"]];
    }
    
    [[DataBase sharedInstance] insertWsmMaterial:arr_ResponseGetListOfWsmMaterial];
}

+(void)functionForWsmDocument :(id)WSMDocument
{
    NSMutableArray *mutarr_wsmdocumentdata = [[NSMutableArray alloc]init];
    
    WSMDocument = [[WSMDocument objectAtIndex:0] objectForKey:@"item"];
    
    if ([WSMDocument isKindOfClass:[NSDictionary class]]) {
        
        [mutarr_wsmdocumentdata addObject:[NSMutableArray arrayWithObject:WSMDocument]];
    }
    else if ([WSMDocument isKindOfClass:[NSArray class]]) {
        
        [mutarr_wsmdocumentdata addObjectsFromArray:WSMDocument];
    }
    
    [[DataBase sharedInstance] insertWsmDocument:mutarr_wsmdocumentdata];
}

+(void)functionForWsmEqui :(NSDictionary *)dictData
{
    NSMutableArray *mutarr_wsmequipdata = [[NSMutableArray alloc]init];
    
    NSArray *arr_ResponseGetListOfWsmEquipment;
    
    if ([dictData objectForKey:@"resultWSMEqui"]) {
        
        if ([[dictData objectForKey:@"resultWSMEqui"] isKindOfClass:[NSArray class]]) {
            
            arr_ResponseGetListOfWsmEquipment = [[[dictData objectForKey:@"resultWSMEqui"] objectAtIndex:0] objectForKey:@"item"];
        }
    }
    
    for (int i =0; i<[arr_ResponseGetListOfWsmEquipment count]; i++) {
        
        NSString *equnr = [[arr_ResponseGetListOfWsmEquipment objectAtIndex:i] objectForKey:@"EamsEqunr"];
        NSString *descript = [[arr_ResponseGetListOfWsmEquipment objectAtIndex:i] objectForKey:@"Descript"];
        NSString *safetycharectertext = [[arr_ResponseGetListOfWsmEquipment objectAtIndex:i] objectForKey:@"SafetyCharTxt"];
        
        if ([NullChecker isNull:equnr]) {
            equnr = @"";
        }
        
        if ([NullChecker isNull:descript]) {
            descript = @"";
        }
        
        if ([NullChecker isNull:safetycharectertext]) {
            safetycharectertext = @"";
        }
        
        [mutarr_wsmequipdata addObject:[NSMutableArray arrayWithObjects:equnr,descript,safetycharectertext,nil]];
    }
    
    [[DataBase sharedInstance] insertWsmEqui:mutarr_wsmequipdata];
}

+(void)functionForWsmPermit :(NSDictionary *)dictData
{
    NSMutableArray *mutarr_wsmpermitdata = [[NSMutableArray alloc]init];
    
    NSArray *arr_ResponseGetListOfWsmPermit;
    
    if ([dictData objectForKey:@"resultWSMPermit"]) {
        
        if ([[dictData objectForKey:@"resultWSMPermit"] isKindOfClass:[NSArray class]]) {
            
            if ([[[[dictData objectForKey:@"resultWSMPermit"] objectAtIndex:0] objectForKey:@"item"] isKindOfClass:[NSArray class]]) {
                arr_ResponseGetListOfWsmPermit = [[[dictData objectForKey:@"resultWSMPermit"] objectAtIndex:0] objectForKey:@"item"];
            }
            else if ([[[[dictData objectForKey:@"resultWSMPermit"] objectAtIndex:0] objectForKey:@"item"] isKindOfClass:[NSDictionary class]]){
                
                arr_ResponseGetListOfWsmPermit = [NSArray arrayWithObject:[[[dictData objectForKey:@"resultWSMPermit"] objectAtIndex:0] objectForKey:@"item"]];
            }
            
        }
    }
    
    for (int i =0; i<[arr_ResponseGetListOfWsmPermit count]; i++) {
        
        NSString *permitid = [[arr_ResponseGetListOfWsmPermit objectAtIndex:i] objectForKey:@"Pmsog"];
        NSString *permittext = [[arr_ResponseGetListOfWsmPermit objectAtIndex:i] objectForKey:@"Gntxt"];
        NSString *safetycharectertext = [[arr_ResponseGetListOfWsmPermit objectAtIndex:i] objectForKey:@"CharTxt"];
        // NSString *CharTxt = [[arr_ResponseGetListOfWsmPermit objectAtIndex:i] objectForKey:@"CharTxt"];
        
        if ([NullChecker isNull:permitid]) {
            permitid = @"";
        }
        
        if ([NullChecker isNull:permittext]) {
            permittext = @"";
        }
        
        if ([NullChecker isNull:safetycharectertext]) {
            safetycharectertext = @"";
        }
        
        [mutarr_wsmpermitdata addObject:[NSMutableArray arrayWithObjects:permitid,permittext,safetycharectertext,nil]];
    }
    
    [[DataBase sharedInstance] insertWsmPermit:mutarr_wsmpermitdata];
}

+(void)functionForWsmWcmr :(NSDictionary *)dictData
{
    NSMutableArray *mutarr_wsmwcmrdata = [[NSMutableArray alloc]init];
    
    NSArray *arr_ResponseGetListOfWsmWcmr;
    
    if ([dictData objectForKey:@"resultWSMWcmr"]) {
        
        if ([[dictData objectForKey:@"resultWSMWcmr"] isKindOfClass:[NSArray class]]) {
            
            arr_ResponseGetListOfWsmWcmr = [[[dictData objectForKey:@"resultWSMWcmr"] objectAtIndex:0] objectForKey:@"item"];
        }
    }
    
    for (int i =0; i<[arr_ResponseGetListOfWsmWcmr count]; i++) {
        
        NSString *needid = [[arr_ResponseGetListOfWsmWcmr objectAtIndex:i] objectForKey:@"Needid"];
        NSString *scrttext = [[arr_ResponseGetListOfWsmWcmr objectAtIndex:i] objectForKey:@"ScrtextL"];
        
        if ([NullChecker isNull:needid]) {
            needid = @"";
        }
        
        if ([NullChecker isNull:scrttext]) {
            scrttext = @"";
        }
        
        [mutarr_wsmwcmrdata addObject:[NSMutableArray arrayWithObjects:needid,scrttext,nil]];
    }
    
    [[DataBase sharedInstance] insertWsmWcmr:mutarr_wsmwcmrdata];
}

+(void)functionForWsmPlants :(NSDictionary *)dictData
{
    NSMutableArray *mutarr_wsmPlantsdata = [[NSMutableArray alloc]init];
    
    NSArray *arr_ResponseGetListOfWsmPlants;
    
    if ([dictData objectForKey:@"resultWSMPlants"]) {
        
        if ([[dictData objectForKey:@"resultWSMPlants"] isKindOfClass:[NSArray class]]) {
            
            arr_ResponseGetListOfWsmPlants = [[[dictData objectForKey:@"resultWSMPlants"] objectAtIndex:0] objectForKey:@"item"];
        }
    }
    
    for (int i =0; i<[arr_ResponseGetListOfWsmPlants count]; i++) {
        
        NSString *Werks = [[arr_ResponseGetListOfWsmPlants objectAtIndex:i] objectForKey:@"Werks"];
        NSString *Asgmt = [[arr_ResponseGetListOfWsmPlants objectAtIndex:i] objectForKey:@"Asgmt"];
        NSString *Asrsp = [[arr_ResponseGetListOfWsmPlants objectAtIndex:i] objectForKey:@"Asrsp"];
        NSString *Slwid = [[arr_ResponseGetListOfWsmPlants objectAtIndex:i] objectForKey:@"Slwid"];
        
        if ([NullChecker isNull:Werks]) {
            Werks = @"";
        }
        
        if ([NullChecker isNull:Asgmt]) {
            Asgmt = @"";
        }
        
        if ([NullChecker isNull:Asrsp]) {
            Asrsp = @"";
        }
        
        if ([NullChecker isNull:Slwid]) {
            Slwid = @"";
        }
        
        [mutarr_wsmPlantsdata addObject:[NSMutableArray arrayWithObjects:Werks,Asgmt,Asrsp,Slwid,nil]];
    }
    
    [[DataBase sharedInstance] insertWsmplants:mutarr_wsmPlantsdata];
    
}

+(void)functionForWsmSafetyMeasures :(NSDictionary *)dictData
{
    NSMutableArray *mutarr_wsmSafetyMeasuresdata = [[NSMutableArray alloc]init];
    
    NSArray *arr_ResponseGetListOfWsmSafetyMeas;
    
    if ([dictData objectForKey:@"resultWSMSafetymeas"]) {
        
        if ([[dictData objectForKey:@"resultWSMSafetymeas"] isKindOfClass:[NSArray class]]) {
            
            arr_ResponseGetListOfWsmSafetyMeas = [[[dictData objectForKey:@"resultWSMSafetymeas"] objectAtIndex:0] objectForKey:@"item"];
        }
    }
    
    for (int i =0; i<[arr_ResponseGetListOfWsmSafetyMeas count]; i++) {
        
        NSString *Werks = [[arr_ResponseGetListOfWsmSafetyMeas objectAtIndex:i] objectForKey:@"Werks"];
        NSString *Asgmt = [[arr_ResponseGetListOfWsmSafetyMeas objectAtIndex:i] objectForKey:@"Asgmt"];
        NSString *Asrsp = [[arr_ResponseGetListOfWsmSafetyMeas objectAtIndex:i] objectForKey:@"Asrsp"];
        NSString *Slwid = [[arr_ResponseGetListOfWsmSafetyMeas objectAtIndex:i] objectForKey:@"Slwid"];
        
        if ([NullChecker isNull:Werks]) {
            Werks = @"";
        }
        
        if ([NullChecker isNull:Asgmt]) {
            Asgmt = @"";
        }
        
        if ([NullChecker isNull:Asrsp]) {
            Asrsp = @"";
        }
        
        if ([NullChecker isNull:Slwid]) {
            Slwid = @"";
        }
        
        [mutarr_wsmSafetyMeasuresdata addObject:[NSMutableArray arrayWithObjects:Werks,Asgmt,Asrsp,Slwid,nil]];
    }
    
    [[DataBase sharedInstance] insertWsmplants:mutarr_wsmSafetyMeasuresdata];
}

#pragma mark-
#pragma mark- WCM


+(void)functionForETUsers :(id)resultChkRequests{
    
    NSMutableArray *mutarr_etUsersData = [[NSMutableArray alloc]init];
    
    if ([resultChkRequests isKindOfClass:[NSDictionary class]]) {
        
        [mutarr_etUsersData addObject:[NSMutableArray arrayWithObject:resultChkRequests]];
    }
    else if ([resultChkRequests isKindOfClass:[NSArray class]]) {
        
        [mutarr_etUsersData addObjectsFromArray:resultChkRequests];
    }
    
    [[DataBase sharedInstance] insertetUsersTokenId :mutarr_etUsersData];
}

+(void)functionForWcmChkReq :(id)resultChkRequests{
    
    NSMutableArray *mutarr_ChkRequestsData = [[NSMutableArray alloc]init];
    
    if ([resultChkRequests isKindOfClass:[NSDictionary class]]) {
        
        [mutarr_ChkRequestsData addObject:[NSMutableArray arrayWithObject:resultChkRequests]];
    }
    else if ([resultChkRequests isKindOfClass:[NSArray class]]) {
        
        [mutarr_ChkRequestsData addObjectsFromArray:resultChkRequests];
    }
    
    [[DataBase sharedInstance] insertWCMCheckRequest :mutarr_ChkRequestsData];
}

+(void)functionForWcmTypes :(id)resultWcmTypes{
    
    NSMutableArray *mutarr_WcmTypesData = [[NSMutableArray alloc]init];
    
    if ([resultWcmTypes isKindOfClass:[NSDictionary class]]) {
        [mutarr_WcmTypesData addObject:[NSMutableArray arrayWithObject:resultWcmTypes]];
    }
    else if ([resultWcmTypes isKindOfClass:[NSArray class]]) {
        
        [mutarr_WcmTypesData addObjectsFromArray:resultWcmTypes];
    }
    
    [[DataBase sharedInstance] insertWCMTypes:mutarr_WcmTypesData];
}

+(void)functionForWcmWcvp6 :(id)resultWcmWcvp6{
    
    NSMutableArray *mutarr_arr_WcmWcvp6Data = [[NSMutableArray alloc]init];
    
    if ([resultWcmWcvp6 isKindOfClass:[NSArray class]]) {
        [mutarr_arr_WcmWcvp6Data addObject:[NSMutableArray arrayWithObject:resultWcmWcvp6]];
    }
    else if ([resultWcmWcvp6 isKindOfClass:[NSDictionary class]]){
        
        [mutarr_arr_WcmWcvp6Data addObjectsFromArray:resultWcmWcvp6];
    }
    //
    //        for (int i =0; i<[arr_WcmWcvp6 count]; i++) {
    //
    //            NSString *Werks = [[arr_WcmWcvp6 objectAtIndex:i] objectForKey:@"Iwerk"];
    //            NSString *Mandt = [[arr_WcmWcvp6 objectAtIndex:i] objectForKey:@"Mandt"];
    //            NSString *Objart = [[arr_WcmWcvp6 objectAtIndex:i] objectForKey:@"Objart"];
    //            NSString *Objtyp = [[arr_WcmWcvp6 objectAtIndex:i] objectForKey:@"Objtyp"];
    //            NSString *Pmsog = [[arr_WcmWcvp6 objectAtIndex:i] objectForKey:@"Pmsog"];
    //
    //            if ([NullChecker isNull:Werks]) {
    //                Werks = @"";
    //            }
    //
    //            if ([NullChecker isNull:Mandt]) {
    //                Mandt = @"";
    //            }
    //
    //            if ([NullChecker isNull:Objart]) {
    //                Objart = @"";
    //            }
    //
    //            if ([NullChecker isNull:Objtyp]) {
    //                Objtyp = @"";
    //            }
    //
    //            if ([NullChecker isNull:Pmsog]) {
    //                Pmsog = @"";
    //            }
    //
    //            [mutarr_arr_WcmWcvp6Data addObject:[NSMutableArray arrayWithObjects:Werks,Mandt,Objart,Objtyp,Pmsog,nil]];
    //        }
    
    // [[DataBase sharedInstance] insertWsmplants:mutarr_arr_WcmWcvp6Data];
}

+(void)functionForWcmTgtyp :(id)resultWcmTgTypes{
    
    NSMutableArray *mutarr_WcmTgTypesData = [[NSMutableArray alloc]init];
    
    if ([resultWcmTgTypes isKindOfClass:[NSDictionary class]]) {
        
        [mutarr_WcmTgTypesData addObject:[NSMutableArray arrayWithObject:resultWcmTgTypes]];
    }
    else if ([resultWcmTgTypes isKindOfClass:[NSArray class]]){
        
        [mutarr_WcmTgTypesData addObjectsFromArray:resultWcmTgTypes];
    }
    
    [[DataBase sharedInstance] insertWCMIsolation:mutarr_WcmTgTypesData];
    
}

+(void)functionForJSAEHSOpstat :(id)resultEHSOpstat{
    
    NSMutableArray *mutarr_EHSOpstat = [[NSMutableArray alloc]init];
    
    if ([resultEHSOpstat isKindOfClass:[NSDictionary class]]) {
        
        [mutarr_EHSOpstat addObject:[NSMutableArray arrayWithObject:[resultEHSOpstat objectForKey:@"results"]]];
    }
    else if ([resultEHSOpstat isKindOfClass:[NSArray class]]) {
        
        [mutarr_EHSOpstat addObjectsFromArray:[[resultEHSOpstat objectAtIndex:0]objectForKey:@"results"]];
    }
    
    [[DataBase sharedInstance] insertJSA :mutarr_EHSOpstat];
    
}

+(void)functionForJSAEHSLocrev :(id)resultEHSLocrev{
 
    NSMutableArray *mutarr_EHLocrev = [[NSMutableArray alloc]init];
    
    if ([resultEHSLocrev isKindOfClass:[NSDictionary class]]) {
        
        [mutarr_EHLocrev addObject:[NSMutableArray arrayWithObject:[resultEHSLocrev objectForKey:@"results"]]];
    }
    else if ([resultEHSLocrev isKindOfClass:[NSArray class]]) {
        
        [mutarr_EHLocrev addObjectsFromArray:[[resultEHSLocrev objectAtIndex:0]objectForKey:@"results"]];
    }
    
    [[DataBase sharedInstance] insertJSASSLocRev :mutarr_EHLocrev];
    
}

+(void)functionForJSAEHSLoctyp :(id)resultEHSLoctyp{
    
    NSMutableArray *mutarr_EHLoctyp = [[NSMutableArray alloc]init];
    
    if ([resultEHSLoctyp isKindOfClass:[NSDictionary class]]) {
        
        [mutarr_EHLoctyp addObject:[NSMutableArray arrayWithObject:[resultEHSLoctyp objectForKey:@"results"]]];
    }
    else if ([resultEHSLoctyp isKindOfClass:[NSArray class]]) {
        
        [mutarr_EHLoctyp addObjectsFromArray:[[resultEHSLoctyp objectAtIndex:0]objectForKey:@"results"]];
    }
    
    [[DataBase sharedInstance] insertJSASSLocRev :mutarr_EHLoctyp];
 }

+(void)functionForJSRasRole :(id)resultEHSasRole{
    
    NSMutableArray *mutarr_EHSasRole = [[NSMutableArray alloc]init];
    
    if ([resultEHSasRole isKindOfClass:[NSDictionary class]]) {
        
        [mutarr_EHSasRole addObject:[NSMutableArray arrayWithObject:[resultEHSasRole objectForKey:@"results"]]];
    }
    else if ([resultEHSasRole isKindOfClass:[NSArray class]]) {
        
        [mutarr_EHSasRole addObjectsFromArray:[[resultEHSasRole objectAtIndex:0]objectForKey:@"results"]];
    }
    
    [[DataBase sharedInstance] insertJSASRasrole :mutarr_EHSasRole];
    
}

+(void)functionForJSAEHSrastep :(id)resultEHSSrastep{
    
    NSMutableArray *mutarr_EHSSrastep = [[NSMutableArray alloc]init];
    
    if ([resultEHSSrastep isKindOfClass:[NSDictionary class]]) {
        
        [mutarr_EHSSrastep addObject:[NSMutableArray arrayWithObject:[resultEHSSrastep objectForKey:@"results"]]];
    }
    else if ([resultEHSSrastep isKindOfClass:[NSArray class]]) {
        
        [mutarr_EHSSrastep addObjectsFromArray:[[resultEHSSrastep objectAtIndex:0]objectForKey:@"results"]];
    }
    
    [[DataBase sharedInstance] insertJSASRastep :mutarr_EHSSrastep];
    
}

+(void)functionForJSAEHSReason :(id)resultEHSSReason{
    
    NSMutableArray *mutarr_EHSSReason = [[NSMutableArray alloc]init];
    
    if ([resultEHSSReason isKindOfClass:[NSDictionary class]]) {
        
        [mutarr_EHSSReason addObject:[NSMutableArray arrayWithObject:[resultEHSSReason objectForKey:@"results"]]];
    }
    else if ([resultEHSSReason isKindOfClass:[NSArray class]]) {
        
        [mutarr_EHSSReason addObjectsFromArray:[[resultEHSSReason objectAtIndex:0]objectForKey:@"results"]];
    }
    
    [[DataBase sharedInstance] insertJSASReason :mutarr_EHSSReason];
 }

+(void)functionForJSAShazaimp :(id)resultEHSShazaimp{
    
    NSMutableArray *mutarr_EHShazaimp = [[NSMutableArray alloc]init];
    
    if ([resultEHSShazaimp isKindOfClass:[NSDictionary class]]) {
        
        [mutarr_EHShazaimp addObject:[NSMutableArray arrayWithObject:[resultEHSShazaimp objectForKey:@"results"]]];
    }
    else if ([resultEHSShazaimp isKindOfClass:[NSArray class]]) {
        
        [mutarr_EHShazaimp addObjectsFromArray:[[resultEHSShazaimp objectAtIndex:0]objectForKey:@"results"]];
    }
    
    [[DataBase sharedInstance] insertJSASHazimp :mutarr_EHShazaimp];
}


+(void)functionForJSAShazard :(id)resultEHSShazarad{
    
    NSMutableArray *mutarr_EHShazarad = [[NSMutableArray alloc]init];
    
    if ([resultEHSShazarad isKindOfClass:[NSDictionary class]]) {
        
        [mutarr_EHShazarad addObject:[NSMutableArray arrayWithObject:[resultEHSShazarad objectForKey:@"results"]]];
    }
    else if ([resultEHSShazarad isKindOfClass:[NSArray class]]) {
        
        [mutarr_EHShazarad addObjectsFromArray:[[resultEHSShazarad objectAtIndex:0]objectForKey:@"results"]];
    }
    
    [[DataBase sharedInstance] insertJSASHazard :mutarr_EHShazarad];
}

+(void)functionForJSAShazcat :(id)resultEHSShazcat{
    
    NSMutableArray *mutarr_EHShazcat = [[NSMutableArray alloc]init];
    
    if ([resultEHSShazcat isKindOfClass:[NSDictionary class]]) {
        
        [mutarr_EHShazcat addObject:[NSMutableArray arrayWithObject:[resultEHSShazcat objectForKey:@"results"]]];
    }
    else if ([resultEHSShazcat isKindOfClass:[NSArray class]]) {
        
        [mutarr_EHShazcat addObjectsFromArray:[[resultEHSShazcat objectAtIndex:0]objectForKey:@"results"]];
    }
    
    [[DataBase sharedInstance] insertJSAShacat :mutarr_EHShazcat];
}

+(void)functionForJSAShazctrl :(id)resultEHSShazctrl{
    
    NSMutableArray *mutarr_EHShazctrl = [[NSMutableArray alloc]init];
    
    if ([resultEHSShazctrl isKindOfClass:[NSDictionary class]]) {
        
        [mutarr_EHShazctrl addObject:[NSMutableArray arrayWithObject:[resultEHSShazctrl objectForKey:@"results"]]];
    }
    else if ([resultEHSShazctrl isKindOfClass:[NSArray class]]) {
        
        [mutarr_EHShazctrl addObjectsFromArray:[[resultEHSShazctrl objectAtIndex:0]objectForKey:@"results"]];
    }
    
    [[DataBase sharedInstance] insertJSAShacat :mutarr_EHShazctrl];
}

+(void)functionForJSAShaJobtyp :(id)resultEHShaJobtyp{
    
    NSMutableArray *mutarr_EHhaJobtyp = [[NSMutableArray alloc]init];
    
    if ([resultEHShaJobtyp isKindOfClass:[NSDictionary class]]) {
        
        [mutarr_EHhaJobtyp addObject:[NSMutableArray arrayWithObject:[resultEHShaJobtyp objectForKey:@"results"]]];
    }
    else if ([resultEHShaJobtyp isKindOfClass:[NSArray class]]) {
        
        [mutarr_EHhaJobtyp addObjectsFromArray:[[resultEHShaJobtyp objectAtIndex:0]objectForKey:@"results"]];
    }
    
    [[DataBase sharedInstance] insertJSASJobTyp :mutarr_EHhaJobtyp];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
