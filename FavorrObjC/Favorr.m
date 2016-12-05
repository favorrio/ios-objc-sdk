//
//  Favorr.m
//  FavorrObjC
//
//  Created by 大橋 功 on 11/18/16.
//  Copyright © 2016 Favorr, Inc. All rights reserved.
//

#import "Favorr.h"
#import <sys/utsname.h>
#import "FavorrAdView.h"

@implementation Favorr

// init
-(Favorr*)init{
    
    if (self = [super init]) {
    }
    
    return self;
}

+ (Favorr*)sharedInstance {
    static dispatch_once_t once;
    static Favorr *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

//-(void) myMethod:(myCompletion) compblock{
//    //do stuff
//    compblock(YES);
//}

// Favorr as a session tracker
// init with apiKey
-(void)initWithApiKey:(NSString*)apiKey block:(favorrCompletion) compblock{
    
    // NSLog(@"apiKey:%@", [apiKey description]);
    
    self.ad_available = NO;

    if (apiKey == nil) {
        NSDictionary *userInfo = @{@"code" : @"101", @"detail":@"API Key is not set"};
        NSError *error = [NSError errorWithDomain:@"favorr" code:101 userInfo:userInfo];
        compblock(error, nil);
        return;
    }
    
    self.apiKey = apiKey;
    
    self.uuid_string = [UIDevice currentDevice].identifierForVendor.UUIDString;
    self.adid_string = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    self.systemVersion = [UIDevice currentDevice].systemVersion;
    
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *modelId = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    self.modelId = modelId;
    
    self.deviceName = [UIDevice currentDevice].name;
    self.systemName = [UIDevice currentDevice].systemName;
    
    // updateSessionWithCompletion
    [self updateSessionWithCompletion:^(NSError *error, NSDictionary *dict) {
        if (error){
            
            self.ad_available = NO;
            
            compblock(error, nil);
            return;
        }
        
//        NSString *result_code = dict[@"result_code"];
//        BOOL ad_available = dict[@"ad_available"];
//        // NSLog(@"result_code:%@, ad_available:%d",result_code, ad_available);
//        
//        if ([result_code isEqualToString:@"success"]) {
//            if (ad_available == YES) {
//                self.ad_available = YES;
//            }
//        }
        
        compblock(nil, dict);
        
        // NSLog(@"dict:%@", [dict description]);
    }];
    
    
    // Observers
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActive)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillResignActive)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
}

// update session with callback
-(void)updateSessionWithCompletion:(favorrCompletion) compblock{
    
    // prepare parameters
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    if (self.apiKey == nil) {
        NSDictionary *userInfo = @{@"code" : @"101", @"detail":@"API Key is not set"};
        NSError *error = [NSError errorWithDomain:@"favorr" code:101 userInfo:userInfo];
        compblock(error, nil);
        return;
    } else {
        // [dict setObject:@"apiKey" forKey:self.apiKey];
        [dict setObject:self.apiKey forKey:@"apiKey"];
    }
    
    if (self.uuid_string != nil) {
        // [dict setObject:@"uuid_string" forKey:self.uuid_string];
        [dict setObject:self.uuid_string forKey:@"uuid_string"];
    }
    if (self.adid_string != nil) {
        // [dict setObject:@"adid_string" forKey:self.adid_string];
        [dict setObject:self.adid_string forKey:@"adid_string"];
    }
    
    if (self.systemVersion != nil) {
        // [dict setObject:@"systemVersion" forKey:self.systemVersion];
        [dict setObject:self.systemVersion forKey:@"systemVersion"];
    }
    if (self.modelId != nil) {
        // [dict setObject:@"modelId" forKey:self.modelId];
        [dict setObject:self.modelId forKey:@"modelId"];
    }
    if (self.deviceName != nil) {
        // [dict setObject:@"deviceName" forKey:self.deviceName];
        [dict setObject:self.deviceName forKey:@"deviceName"];
    }
    if (self.systemName != nil) {
        // [dict setObject:@"systemName" forKey:self.systemName];
        [dict setObject:self.systemName forKey:@"systemName"];
    }
    if (self.sessionId != nil) {
        // [dict setObject:@"sessionId" forKey:self.sessionId];
        [dict setObject:self.sessionId forKey:@"sessionId"];
    }
    
    // post request
    NSError *error;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
                             
                             
    NSURL *url = [NSURL URLWithString:@"https://cp1.favorr.io/update_session"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPMethod:@"POST"];
    NSData *postData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    [request setHTTPBody:postData];
    
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil){
            compblock(error, nil);
            return;
        }

        NSError *parseError = nil;
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
        if (parseError != nil){
            compblock(parseError, nil);
        } else {
            
            NSString *result_code = responseDictionary[@"result_code"];
            BOOL ad_available = responseDictionary[@"ad_available"];
            if ([result_code isEqualToString:@"success"]) {
                if (ad_available == YES) {
                    self.ad_available = YES;
                }
            }
            
            compblock(nil, responseDictionary);
        }
        
    }];
    
    [postDataTask resume];

}

// Set Timer
-(void)startSession:(BOOL) fromInit{
    if (self.pingTimer == nil) {
        
        // Create Timer
        [self createTimer:10];
        
        if (fromInit != true) {
            // Send 1st Log
            [self.pingTimer fire];
        }
        
    } else {
       
        if ( self.pingTimer.timeInterval == 10.0 ) {
            [self.pingTimer invalidate];
        }
        
        if ( self.pingTimer.isValid == NO ) {
            // Create Timer
            [self createTimer:10];
            
            if (fromInit != YES) {
                // Send 1st Log
                [self.pingTimer fire];
            }
        }
        
    }
}

// Create Timer
-(void)createTimer:(NSTimeInterval) interval{
    if (self.pingTimer == nil) {
        
        // Create Timer
        self.pingTimer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(updateSession) userInfo:nil repeats:YES];
        
    }
}

// Stop Timer
-(void)stopSession {
    if (self.pingTimer == nil) {
        
        // Create Timer
        [self.pingTimer invalidate];
        
    }
}

// Network is not accessible -> Make it slow
-(void)slowSession {
    if (self.pingTimer == nil) {
        
        if ( self.pingTimer.timeInterval == 10.0 ) {
            // Invalidate Timer
            [self.pingTimer invalidate];
            // Create New One
            [self createTimer:60];
        }
    }
}


// update session status
-(void)updateSession {
    
    // prepare parameters
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    if (self.apiKey == nil) {
//        NSLog(@"No API Key found");
        return;
    } else {
        [dict setObject:self.apiKey forKey:@"apiKey"];
    }
    
    if (self.uuid_string != nil) {
        [dict setObject:self.uuid_string forKey:@"uuid_string"];
    }
    if (self.adid_string != nil) {
        [dict setObject:self.adid_string forKey:@"adid_string"];
    }
    
    if (self.systemVersion != nil) {
        [dict setObject:self.systemVersion forKey:@"systemVersion"];
    }
    if (self.modelId != nil) {
        [dict setObject:self.modelId forKey:@"modelId"];
    }
    if (self.deviceName != nil) {
        [dict setObject:self.deviceName forKey:@"deviceName"];
    }
    if (self.systemName != nil) {
        [dict setObject:self.systemName forKey:@"systemName"];
    }
    if (self.sessionId != nil) {
        [dict setObject:self.sessionId forKey:@"sessionId"];
    }
    
    // post request
    NSError *error;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
    
    
    NSURL *url = [NSURL URLWithString:@"https://cp1.favorr.io/update_session"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPMethod:@"POST"];
    NSData *postData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    [request setHTTPBody:postData];
    
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil){
            self.ad_available = NO;
            // NSLog(@"error:%@",[error description]);
            return;
        }

        
        NSError *parseError = nil;
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
        if (parseError != nil){
            // compblock(parseError, nil);
            self.ad_available = NO;
        } else {
            
            NSString *result_code = responseDictionary[@"result_code"];
            BOOL ad_available = responseDictionary[@"ad_available"];
            if ([result_code isEqualToString:@"success"]) {
                if (ad_available == YES) {
                    self.ad_available = YES;
                } else {
                    self.ad_available = NO;
                }
            } else {
                self.ad_available = NO;
            }
            
            // compblock(nil, responseDictionary);
        }
        
    }];
    
    [postDataTask resume];
}


// Notifications

// applicationDidBecomeActive
-(void)applicationDidBecomeActive {
    [self startSession:NO];
}


// applicationDidBecomeActive
-(void)applicationWillResignActive {
    [self stopSession];
}


// Favorr as a Ad Network

// Init Ad View
-(FavorrAdView*)createAdView:(NSString*) unitId frame:(CGRect) frame {
    FavorrAdView *adView = [[FavorrAdView alloc] initWithFrame:frame];
    adView.unitId = unitId;
    return adView;
}


// Send Log
-(void)send_log:(int)trackId unitId:(NSString*)unitId banner_log_id:(NSString*)banner_log_id action:(NSString*)action {
    
    // prepare parameters
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    if (self.apiKey != nil) {
        [dict setObject:self.apiKey forKey:@"apiKey"];
    }
    
    if (unitId != nil) {
        [dict setObject:unitId forKey:@"unitId"];
    }
    
    if (banner_log_id != nil) {
        [dict setObject:banner_log_id forKey:@"banner_log_id"];
    }
    
    if (self.uuid_string != nil) {
        [dict setObject:self.uuid_string forKey:@"uuid_string"];
    }
    if (self.adid_string != nil) {
        [dict setObject:self.adid_string forKey:@"adid_string"];
    }
    
    if (self.systemVersion != nil) {
        [dict setObject:self.systemVersion forKey:@"systemVersion"];
    }
    if (self.modelId != nil) {
        [dict setObject:self.modelId forKey:@"modelId"];
    }
    if (self.deviceName != nil) {
        [dict setObject:self.deviceName forKey:@"deviceName"];
    }
    if (self.systemName != nil) {
        [dict setObject:self.systemName forKey:@"systemName"];
    }
    if (self.sessionId != nil) {
        [dict setObject:self.sessionId forKey:@"sessionId"];
    }
    
    if (trackId != 0) {
        [dict setObject:[NSNumber numberWithInt:trackId] forKey:@"trackId"];
    }
    if (action != nil) {
        [dict setObject:action forKey:@"action"];
    }
    
    // post request
    NSError *error;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
    
    
    NSURL *url = [NSURL URLWithString:@"https://cp1.favorr.io/banner_log"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPMethod:@"POST"];
    NSData *postData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    [request setHTTPBody:postData];
    
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil){
            // NSLog(@"error:%@",[error description]);
            return;
        }
        
//         NSError *parseError = nil;
//         NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
//        
         // NSLog(@"responseDictionary:%@", [responseDictionary description]);

    }];
    
    [postDataTask resume];
}




//
// Convenient Methods
//

// Check Ad Availability
-(void)checkAdAvailable:(NSString*)unitId block:(favorrCompletion) compblock{
    
    // prepare parameters
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    if (self.apiKey != nil) {
        [dict setObject:self.apiKey forKey:@"apiKey"];
    }
    if (unitId != nil) {
        [dict setObject:unitId forKey:@"unitId"];
    }
    
    // post request
    NSError *error;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
    
    
    NSURL *url = [NSURL URLWithString:@"https://cp1.favorr.io/check_ad_available_with_unitid"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPMethod:@"POST"];
    NSData *postData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    [request setHTTPBody:postData];
    
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil){
            // NSLog(@"error:%@",[error description]);
            return;
        }
        
        NSError *parseError = nil;
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
        // NSLog(@"responseDictionary:%@", [responseDictionary description]);
        
        NSString *result_code = responseDictionary[@"result_code"];
        if (![result_code  isEqual: @"success"]){
            
            NSDictionary *userInfo = @{@"code" : @"101", @"detail":@"Server Error"};
            NSError *error = [NSError errorWithDomain:@"favorr" code:101 userInfo:userInfo];
            
            NSDictionary *resultInfo = @{@"ad_availability" : @"0"};
            
            compblock(error, resultInfo);
            return;
        }
        
        BOOL ad_availability = [responseDictionary[@"ad_availability"] boolValue];
        if (ad_availability == true) {
            NSDictionary *resultInfo = @{@"ad_availability" : @"1"};
            compblock(nil, resultInfo);
        } else {
            NSDictionary *resultInfo = @{@"ad_availability" : @"0"};
            compblock(nil, resultInfo);
        }
        
    }];
    
    [postDataTask resume];
}







// dealloc
- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



@end
