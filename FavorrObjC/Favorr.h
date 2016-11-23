//
//  Favorr.h
//  FavorrObjC
//
//  Created by 大橋 功 on 11/18/16.
//  Copyright © 2016 Favorr, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;
@import AdSupport;
#import "FavorrAdView.h"



@interface Favorr : NSObject

// properties
@property (nonatomic, strong) NSString *apiKey;
@property (nonatomic, strong) NSString *uuid_string;
@property (nonatomic, strong) NSString *adid_string;
@property (nonatomic, strong) NSString *systemVersion;
@property (nonatomic, strong) NSString *modelId;
@property (nonatomic, strong) NSString *deviceName;
@property (nonatomic, strong) NSString *systemName;
@property (nonatomic, strong) NSTimer *pingTimer;
@property (nonatomic, strong) NSString *sessionId;
@property _Bool isNetworking;
@property (nonatomic, strong) NSString *ad_available;

// completion block
// typedef void(^myCompletion)(BOOL);

// typedef void (^callbackWithParams) (NSDictionary * _Nonnull params, NSError * _Nullable error);
// typedef void (^callbackWithUrl) (NSString *  url, NSError *  error);

typedef void(^favorrCompletion)(NSError *error, NSDictionary *dict);

// methods
+(Favorr*)sharedInstance;

// -(void) myMethod:(myCompletion) compblock;

// init favorr
-(void)initWithApiKey:(NSString*)apiKey block:(favorrCompletion) compblock;
// update session with callback
-(void)updateSessionWithCompletion:(favorrCompletion) compblock;

// Network is not accessible -> Make it slow
-(void)slowSession;

-(FavorrAdView*)createAdView:(NSString*) unitId frame:(CGRect) frame;

// Send Log
-(void)send_log:(int)trackId unitId:(NSString*)unitId banner_log_id:(NSString*)banner_log_id action:(NSString*)action;

// Check Ad Availability
-(void)checkAdAvailable:(NSString*)unitId block:(favorrCompletion) compblock;

@end
