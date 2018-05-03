//
//  ConnectionManager.h
//  ConnectionManager
//
//  Created by Harish Kishenchand on 12/05/13.
//  Copyright (c) 2013 Harish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Request.h"
#import "Response.h"

typedef enum connectionPriority
{
    HIGH = 0,
    MEDIUM = 1,
    LOW = 2
}connectionPriority;

@protocol connectionManagerHandler <NSObject>



@optional
- (void)currentNetworkStatus:(BOOL)reachable;
- (void)taskCompletedwithStatus:(BOOL)Success;
@end

@interface ConnectionManager : NSObject<requestDelegate>

@property (nonatomic, weak)id<connectionManagerHandler> currentHandler;
//+ (id)defaultManager;
//- (void)addConnection:(Connection *)connection;
//- (void)addDownloads:(NSString *)contentUrl BOOKID:(NSString *)bookId epubTimeStamp:(NSString *)epubTimeStamp;
//- (void)didFailConnection:(Connection *)connection withError:(NSError *)error;
- (BOOL)isReachable;
- (void)addConnectionwithDetail:(NSMutableArray *)detailArray prioriy:(connectionPriority)priorityValue delegate:(id)parentDelegate;
//- (NSString *)downloadStatusOfBook:(NSString *)bookId;
//- (void)cancelDownloadForBook:(NSString *)bookId;
//- (void)cancelAllDownloads;
- (void)stopCurrentConnetion;
- (void)startNextConnection;
- (void)startConnection;
- (void)refreshSyncLog;
- (BOOL)canStartNextConnection;
- (BOOL)isConnectionQueueIsActive;
+ (id)defaultManager;
@end
