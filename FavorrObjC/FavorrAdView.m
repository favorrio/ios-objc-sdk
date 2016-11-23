//
//  FavorrAdView.m
//  FavorrObjC
//
//  Created by 大橋 功 on 11/22/16.
//  Copyright © 2016 Favorr, Inc. All rights reserved.
//

#import "FavorrAdView.h"
#import "Favorr.h"
#import <QuartzCore/QuartzCore.h>

@interface FavorrAdView()<SKStoreProductViewControllerDelegate>{
    
}
@end

@implementation FavorrAdView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

// init with frame
- (id)initWithFrame:(CGRect)aRect
{
    self = [super initWithFrame:aRect];
    
    if (self)
    {
        [self initFavorrAdView:aRect];
    }
    
    return self;
}

// Init Favorr AdView
-(void)initFavorrAdView:(CGRect) frame{
    
    // Set Default Parameters
    self.defaultFavorrBackgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    self.defaultFavorrTextColor = [UIColor blackColor];
    self.defaultInstallButtonColorType = @"green";
    self.defaultStarColorType = @"black";
    self.trackId = 0;
    self.storeReadyFlg = NO;
    self.isNetworking = NO;
    
    
    // ContentView
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.contentView.backgroundColor = self.defaultFavorrBackgroundColor;
    self.contentView.hidden = YES;
    [self addSubview:self.contentView];
    
    // App Icon
    self.app_icon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 38, 38)];
    self.app_icon.layer.cornerRadius = 8.0;
    self.app_icon.clipsToBounds = YES;
    [self.contentView addSubview:self.app_icon];
    
    // Install Button
    CGFloat install_icon_x = frame.size.width - 10 - 76;
    self.install_icon = [[UIImageView alloc] initWithFrame:CGRectMake(install_icon_x, 12, 76, 34)];
    [self.contentView addSubview:_install_icon];
    
    // Ad Title Label
    CGFloat title_label_w = self.frame.size.width - 154;
    CGFloat title_label_x = 10 + self.app_icon.frame.size.width + 10;
    self.title_label = [[UILabel alloc] initWithFrame:CGRectMake(title_label_x, 12, title_label_w, 16)];
    self.title_label.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:12];
    [self.contentView addSubview:self.title_label];
    
    // Price Label
    CGFloat price_label_y = self.title_label.frame.origin.y + self.title_label.frame.size.height + 2;
    CGFloat price_label_x = self.title_label.frame.origin.x;
    self.price_label = [[UILabel alloc] initWithFrame:CGRectMake(price_label_x, price_label_y, 32, 16)];
    self.price_label.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:12];
    [self.contentView addSubview:self.price_label];
    
    // Start #1
    CGFloat star_icon_1_x = self.price_label.frame.origin.x + self.price_label.frame.size.width;
    CGFloat star_icon_1_y = self.price_label.frame.origin.y + 2;
    self.star_icon_1 = [[UIImageView alloc] initWithFrame:CGRectMake(star_icon_1_x, star_icon_1_y, 11, 10.47)];
    [self.contentView addSubview:self.star_icon_1];
    
    // Start #2
    CGFloat star_icon_2_x = self.star_icon_1.frame.origin.x + self.star_icon_1.frame.size.width;
    CGFloat star_icon_2_y = self.star_icon_1.frame.origin.y;
    self.star_icon_2 = [[UIImageView alloc] initWithFrame:CGRectMake(star_icon_2_x, star_icon_2_y, 11, 10.47)];
    [self.contentView addSubview:self.star_icon_2];
    
    // Start #3
    CGFloat star_icon_3_x = self.star_icon_2.frame.origin.x + self.star_icon_2.frame.size.width;
    CGFloat star_icon_3_y = self.star_icon_2.frame.origin.y;
    self.star_icon_3 = [[UIImageView alloc] initWithFrame:CGRectMake(star_icon_3_x, star_icon_3_y, 11, 10.47)];
    [self.contentView addSubview:self.star_icon_3];
    
    // Start #4
    CGFloat star_icon_4_x = self.star_icon_3.frame.origin.x + self.star_icon_3.frame.size.width;
    CGFloat star_icon_4_y = self.star_icon_3.frame.origin.y;
    self.star_icon_4 = [[UIImageView alloc] initWithFrame:CGRectMake(star_icon_4_x, star_icon_4_y, 11, 10.47)];
    [self.contentView addSubview:self.star_icon_4];
    
    // Start #5
    CGFloat star_icon_5_x = self.star_icon_4.frame.origin.x + self.star_icon_4.frame.size.width;
    CGFloat star_icon_5_y = self.star_icon_4.frame.origin.y;
    self.star_icon_5 = [[UIImageView alloc] initWithFrame:CGRectMake(star_icon_5_x, star_icon_5_y, 11, 10.47)];
    [self.contentView addSubview:self.star_icon_5];
    
    // Review Count Label
    CGFloat review_count_label_x = self.star_icon_5.frame.origin.x + self.star_icon_5.frame.size.width;
    CGFloat review_count_label_y = self.price_label.frame.origin.y;
    self.review_count_label = [[UILabel alloc] initWithFrame:CGRectMake(review_count_label_x, review_count_label_y, 32, 16)];
    self.review_count_label.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:11];
    [self.contentView addSubview:self.review_count_label];
    
    // Activity Indicator
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    CGRect activityRect = CGRectMake( (self.frame.size.width - self.activityIndicator.frame.size.width)/2 ,
                                     (self.frame.size.height - self.activityIndicator.frame.size.height)/2,
                                     self.activityIndicator.frame.size.width,
                                     self.activityIndicator.frame.size.height);
    self.activityIndicator.frame = activityRect;
    self.activityIndicator.hidden = YES;
    [self.contentView addSubview:self.activityIndicator];
    
    // Make it Touchable
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBanner:)];
    [self addGestureRecognizer:tapGesture];

}

// Request Ads
-(void)requestAd {
    // Get data from Favorr Rest API
    
    if ([Favorr sharedInstance].apiKey == nil){
        NSDictionary *userInfo = @{@"code" : @"101", @"detail":@"API Key is not set"};
        NSError *error = [NSError errorWithDomain:@"favorr" code:101 userInfo:userInfo];
        [self.delegate FavorrAdViewDelegateDidReceiveError:error];
        return;
    }
    
    // hide everything...
    self.contentView.hidden = YES;
    
    // show indicator
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.activityIndicator startAnimating];
        self.activityIndicator.hidden = NO;
    });
    
    // Prepare Parameters
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    if ([Favorr sharedInstance].apiKey != nil) {
        [dict setObject:[Favorr sharedInstance].apiKey forKey:@"apiKey"];
    }
    if (self.unitId != nil) {
        [dict setObject:self.unitId forKey:@"unitId"];
    }
    if ([Favorr sharedInstance].uuid_string != nil) {
        [dict setObject:[Favorr sharedInstance].uuid_string forKey:@"uuid_string"];
    }
    if ([Favorr sharedInstance].adid_string != nil) {
        [dict setObject:[Favorr sharedInstance].adid_string forKey:@"adid_string"];
    }
    
    if ([Favorr sharedInstance].systemVersion != nil) {
        [dict setObject:[Favorr sharedInstance].systemVersion forKey:@"systemVersion"];
    }
    if ([Favorr sharedInstance].modelId != nil) {
        [dict setObject:[Favorr sharedInstance].modelId forKey:@"modelId"];
    }
    if ([Favorr sharedInstance].deviceName != nil) {
        [dict setObject:[Favorr sharedInstance].deviceName forKey:@"deviceName"];
    }
    if ([Favorr sharedInstance].systemName != nil) {
        [dict setObject:[Favorr sharedInstance].systemName forKey:@"systemName"];
    }
    if ([Favorr sharedInstance].sessionId != nil) {
        [dict setObject:[Favorr sharedInstance].sessionId forKey:@"sessionId"];
    }
    
    // post request
    NSError *error;
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
    NSURL *url = [NSURL URLWithString:@"https://cp1.favorr.io/request_ad"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPMethod:@"POST"];
    NSData *postData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    [request setHTTPBody:postData];
    
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        // Stop Indicator
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.activityIndicator stopAnimating];
            self.activityIndicator.hidden = YES;
        });
        
        if (error != nil){
            // sNSLog(@"error:%@",[error description]);
            
            NSDictionary *userInfo = @{@"code" : @"101", @"detail":error.description};
            NSError *error = [NSError errorWithDomain:@"favorr" code:101 userInfo:userInfo];
            [self.delegate FavorrAdViewDelegateDidReceiveError:error];
            
            [[Favorr sharedInstance] slowSession];
            
            return;
        }
        
        NSError *parseError = nil;
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
        
        // NSLog(@"responseDictionary:%@", [responseDictionary description]);
        
        NSString *result_code = responseDictionary[@"result_code"];
        if (![result_code  isEqual: @"success"]) {
            NSDictionary *userInfo = @{@"code" : @"101", @"detail":@"Server Error"};
            NSError *error = [NSError errorWithDomain:@"favorr" code:101 userInfo:userInfo];
            [self.delegate FavorrAdViewDelegateDidReceiveError:error];
            
            [[Favorr sharedInstance] slowSession];
            return;
        }
        
        // Success
        
        // Setting Info
        NSDictionary *setting_info = responseDictionary[@"setting_info"];
        
        if (setting_info != nil){
            
            // favorrTextColor
            NSString *favorrTextColor = setting_info[@"favorrTextColor"];
            if (favorrTextColor != nil){
                NSArray *arr = [favorrTextColor componentsSeparatedByString:@"::"];
                CGFloat red = [arr[0] floatValue];
                CGFloat green = [arr[1] floatValue];
                CGFloat blue = [arr[2] floatValue];
                CGFloat alpha = [arr[3] floatValue];
                self.defaultFavorrTextColor = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
            }
            
            // favorrBackgroundColor
            NSString *favorrBackgroundColor = setting_info[@"favorrBackgroundColor"];
            if (favorrBackgroundColor != nil){
                NSArray *arr = [favorrBackgroundColor componentsSeparatedByString:@"::"];
                CGFloat red = [arr[0] floatValue];
                CGFloat green = [arr[1] floatValue];
                CGFloat blue = [arr[2] floatValue];
                CGFloat alpha = [arr[3] floatValue];
                self.defaultFavorrBackgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
            }
            
            
            // installButtonColorType
            NSString *installButtonColorType = setting_info[@"installButtonColorType"];
            if (installButtonColorType != nil){
                self.defaultInstallButtonColorType = installButtonColorType;
            }
            
            // starColorType
            NSString *starColorType = setting_info[@"starColorType"];
            if (starColorType != nil){
                self.defaultStarColorType = starColorType;
            }
            
        }
        
        // Ad Info
        NSDictionary *ad_info = responseDictionary[@"ad_info"];
        if ( ad_info != nil ) {
            
            // Draw Banner
            self.banner_params = ad_info;
            [self drawAd];
            
            [self.delegate FavorrAdViewDelegateDidReceiveAd:ad_info];
        } else {
            
            NSDictionary *userInfo = @{@"code" : @"101", @"detail":@"No Ad is Available Now"};
            NSError *error = [NSError errorWithDomain:@"favorr" code:101 userInfo:userInfo];
            [self.delegate FavorrAdViewDelegateDidReceiveError:error];
            
            [[Favorr sharedInstance] slowSession];
            return;
        }
        
        
    }];
    
    [postDataTask resume];
}


// Re Draw Ad
-(void)drawAd {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.favorrBackgroundColor != nil) {
            self.contentView.backgroundColor = self.favorrBackgroundColor;
        } else {
            self.contentView.backgroundColor = self.defaultFavorrBackgroundColor;
        }
    });
    
    if ( self.banner_params == nil ) {
        return;
    }
    
    self.banner_log_id = self.banner_params[@"banner_log_id"];
    
    NSBundle *frameWorkBundle = [NSBundle bundleForClass:[Favorr class]];
    
    // Install Incon
    
    NSString *install_icon_image = @"install_icon";
    if ( [self.installButtonColorType  isEqual: @"white"] ) {
        install_icon_image = @"install_icon_white";
    } else if ( [self.installButtonColorType  isEqual: @"black"] ) {
        install_icon_image = @"install_icon_black";
    } else if ( [self.installButtonColorType  isEqual: @"green"] ) {
        install_icon_image = @"install_icon";
    } else if ( [self.installButtonColorType  isEqual: @"orange"] ) {
        install_icon_image = @"install_icon_orange";
    } else {
        install_icon_image = @"install_icon";
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        self.install_icon.image = [UIImage imageNamed:install_icon_image inBundle:frameWorkBundle compatibleWithTraitCollection:nil];
    });
    
    // Title Label
    if ( self.banner_params[@"title"] != nil ) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.title_label.text = self.banner_params[@"title"];
            if ( self.favorrTextColor != nil ) {
                self.title_label.textColor = self.favorrTextColor;
            } else {
                self.title_label.textColor = self.defaultFavorrTextColor;
            }
        });
    }
    
    // Price Label
    if ( self.banner_params[@"price"] != nil ) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.price_label.text = self.banner_params[@"price"];
            if ( self.favorrTextColor != nil ) {
                self.price_label.textColor = self.favorrTextColor;
            } else {
                self.price_label.textColor = self.defaultFavorrTextColor;
            }
        });
    }
    
    // Stars
    
    NSString *star_empty_icon = @"star_empty_icon";
    NSString *star_half_icon = @"star_half_icon";
    NSString *star_full_icon = @"star_full_icon";
    if ( [self.starColorType  isEqual: @"white"] ) {
        star_empty_icon = @"star_empty_icon_white";
        star_half_icon = @"star_half_icon_white";
        star_full_icon = @"star_full_icon_white";
    } else if ( [self.starColorType  isEqual: @"black"] ) {
        star_empty_icon = @"star_empty_icon";
        star_half_icon = @"star_half_icon";
        star_full_icon = @"star_full_icon";
    } else if ( [self.starColorType  isEqual: @"orange"] ) {
        star_empty_icon = @"star_empty_icon_orange";
        star_half_icon = @"star_half_icon_orange";
        star_full_icon = @"star_full_icon_orange";
    } else if ( [self.starColorType  isEqual: @"green"] ) {
        star_empty_icon = @"star_empty_icon_green";
        star_half_icon = @"star_half_icon_green";
        star_full_icon = @"star_full_icon_green";
    }
    
    // Star #1
    if ( self.banner_params[@"averageUserRatingForCurrentVersion"] != nil ) {
        float averageUserRatingForCurrentVersion = [self.banner_params[@"averageUserRatingForCurrentVersion"] floatValue];
        if ( averageUserRatingForCurrentVersion < 0.5 ) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.star_icon_1.image = [UIImage imageNamed:star_empty_icon inBundle:frameWorkBundle compatibleWithTraitCollection:nil];
            });
        } else if (averageUserRatingForCurrentVersion < 1.0 ) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.star_icon_1.image = [UIImage imageNamed:star_half_icon inBundle:frameWorkBundle compatibleWithTraitCollection:nil];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.star_icon_1.image = [UIImage imageNamed:star_full_icon inBundle:frameWorkBundle compatibleWithTraitCollection:nil];
            });
        }
    }
    
    // Star #2
    if ( self.banner_params[@"averageUserRatingForCurrentVersion"] != nil ) {
        float averageUserRatingForCurrentVersion = [self.banner_params[@"averageUserRatingForCurrentVersion"] floatValue];
        if ( averageUserRatingForCurrentVersion < 1.5 ) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.star_icon_2.image = [UIImage imageNamed:star_empty_icon inBundle:frameWorkBundle compatibleWithTraitCollection:nil];
            });
        } else if (averageUserRatingForCurrentVersion < 2.0 ) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.star_icon_2.image = [UIImage imageNamed:star_half_icon inBundle:frameWorkBundle compatibleWithTraitCollection:nil];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.star_icon_2.image = [UIImage imageNamed:star_full_icon inBundle:frameWorkBundle compatibleWithTraitCollection:nil];
            });
        }
    }
    
    // Star #3
    if ( self.banner_params[@"averageUserRatingForCurrentVersion"] != nil ) {
        float averageUserRatingForCurrentVersion = [self.banner_params[@"averageUserRatingForCurrentVersion"] floatValue];
        if ( averageUserRatingForCurrentVersion < 2.5 ) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.star_icon_3.image = [UIImage imageNamed:star_empty_icon inBundle:frameWorkBundle compatibleWithTraitCollection:nil];
            });
        } else if (averageUserRatingForCurrentVersion < 3.0 ) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.star_icon_3.image = [UIImage imageNamed:star_half_icon inBundle:frameWorkBundle compatibleWithTraitCollection:nil];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.star_icon_3.image = [UIImage imageNamed:star_full_icon inBundle:frameWorkBundle compatibleWithTraitCollection:nil];
            });
        }
    }
    
    
    // Star #4
    if ( self.banner_params[@"averageUserRatingForCurrentVersion"] != nil ) {
        float averageUserRatingForCurrentVersion = [self.banner_params[@"averageUserRatingForCurrentVersion"] floatValue];
        if ( averageUserRatingForCurrentVersion < 3.5 ) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.star_icon_4.image = [UIImage imageNamed:star_empty_icon inBundle:frameWorkBundle compatibleWithTraitCollection:nil];
            });
        } else if (averageUserRatingForCurrentVersion < 4.0 ) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.star_icon_4.image = [UIImage imageNamed:star_half_icon inBundle:frameWorkBundle compatibleWithTraitCollection:nil];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.star_icon_4.image = [UIImage imageNamed:star_full_icon inBundle:frameWorkBundle compatibleWithTraitCollection:nil];
            });
        }
    }
    
    // Star #5
    if ( self.banner_params[@"averageUserRatingForCurrentVersion"] != nil ) {
        float averageUserRatingForCurrentVersion = [self.banner_params[@"averageUserRatingForCurrentVersion"] floatValue];
        if ( averageUserRatingForCurrentVersion < 4.5 ) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.star_icon_5.image = [UIImage imageNamed:star_empty_icon inBundle:frameWorkBundle compatibleWithTraitCollection:nil];
            });
        } else if (averageUserRatingForCurrentVersion < 5.0 ) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.star_icon_5.image = [UIImage imageNamed:star_half_icon inBundle:frameWorkBundle compatibleWithTraitCollection:nil];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.star_icon_5.image = [UIImage imageNamed:star_full_icon inBundle:frameWorkBundle compatibleWithTraitCollection:nil];
            });
        }
    }
    
    
    // Review Count Label
    if ( self.banner_params[@"userRatingCountForCurrentVersion"] != nil ) {

        NSString *str = [NSString stringWithFormat: @"%@%@%@", @"(", self.banner_params[@"userRatingCountForCurrentVersion"], @")"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.review_count_label.text = str;
            self.review_count_label.hidden = NO;
            if ( self.favorrTextColor != nil ) {
                self.review_count_label.textColor = self.favorrTextColor;
            } else {
                self.review_count_label.textColor = self.defaultFavorrTextColor;
            }
            
        });
    }
    
    // Start Downloading Icon
    if ( self.banner_params[@"icon"] != nil ) {
        [self download_icon:self.banner_params[@"icon"]];
    }
    
    // Send Log
    if ( self.banner_params[@"trackId"] != nil ) {
        self.trackId = [self.banner_params[@"trackId"] intValue];
        [[Favorr sharedInstance] send_log:self.trackId unitId:self.unitId banner_log_id:self.banner_log_id action:@"show"];
        
        // Prepare Store
        self.storeViewController = [[SKStoreProductViewController alloc] init];
        self.storeViewController.delegate = self;
        
        // Load Product Here
        NSDictionary *dict = @{SKStoreProductParameterITunesItemIdentifier : [NSNumber numberWithInt:self.trackId]};
        [self.storeViewController loadProductWithParameters:dict completionBlock:^(BOOL result, NSError * _Nullable error) {
            if (result == true){
                self.storeReadyFlg = true;
            }
        }];
    }
    
    
    
}




// Download Icon
-(void)download_icon:(NSString*) icon_url{
    
    NSURL *url = [NSURL URLWithString:icon_url];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // post request
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            // NSLog(@"error:%@",[error description]);
            return;
        }
        
        UIImage *bach = [UIImage imageWithData:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // Set Image
            self.app_icon.image = bach;
            
            // Seems Ready
            self.hidden = NO;
            self.contentView.alpha = 0;
            self.contentView.hidden = NO;
            [UIView animateWithDuration:0.5 animations:^{
                self.contentView.alpha = 1.0;
            }];
        });
    }];
    
    [postDataTask resume];
}

// TAPPED
-(void)tapBanner:(UITapGestureRecognizer*)sender{
    
    if (self.trackId == 0) {
        return;
    }
    
    if ( self.banner_log_id != nil ) {
        if ( self.storeReadyFlg == YES ) {
            [self.rootViewController presentViewController:self.storeViewController animated:YES completion:^{
                
                // SEND CLICK LOG
                [[Favorr sharedInstance] send_log:self.trackId unitId:self.unitId banner_log_id:self.banner_log_id action:@"show"];
            }];
        }
    }
}

//MARK: SKStoreProductViewController Delegate
-(void) productViewControllerDidFinish:(SKStoreProductViewController *)viewController{
    [viewController dismissViewControllerAnimated:YES completion:^{
        self.storeReadyFlg = false;
        if (self.trackId == 0) {
            [self requestAd];
            return;
        }
        
        // Prepare Store
        self.storeViewController = [[SKStoreProductViewController alloc] init];
        self.storeViewController.delegate = self;
        
        // Load Product Here
        NSDictionary *dict = @{SKStoreProductParameterITunesItemIdentifier : [NSNumber numberWithInt:self.trackId]};
        [self.storeViewController loadProductWithParameters:dict completionBlock:^(BOOL result, NSError * _Nullable error) {
            if (result == true){
                self.storeReadyFlg = true;
            }
        }];
    }];
}


// Customize Design

// change textcolor
-(void)updateTextColor:(UIColor*)color{
    self.favorrTextColor = color;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if ( self.favorrTextColor != nil ) {
            self.title_label.textColor = self.favorrTextColor;
        } else {
            self.title_label.textColor = self.defaultFavorrTextColor;
        }
    });
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if ( self.favorrTextColor != nil ) {
            self.price_label.textColor = self.favorrTextColor;
        } else {
            self.price_label.textColor = self.defaultFavorrTextColor;
        }
    });
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.review_count_label.hidden = NO;
        if ( self.favorrTextColor != nil ) {
            self.review_count_label.textColor = self.favorrTextColor;
        } else {
            self.review_count_label.textColor = self.defaultFavorrTextColor;
        }
        
    });
}

// change star color
-(void)updateStarColor:(NSString*)type{
    self.starColorType = type;
    
    NSBundle *frameWorkBundle = [NSBundle bundleForClass:[Favorr class]];
    // Stars
    
    NSString *star_empty_icon = @"star_empty_icon";
    NSString *star_half_icon = @"star_half_icon";
    NSString *star_full_icon = @"star_full_icon";
    if ( [self.starColorType  isEqual: @"white"] ) {
        star_empty_icon = @"star_empty_icon_white";
        star_half_icon = @"star_half_icon_white";
        star_full_icon = @"star_full_icon_white";
    } else if ( [self.starColorType  isEqual: @"black"] ) {
        star_empty_icon = @"star_empty_icon";
        star_half_icon = @"star_half_icon";
        star_full_icon = @"star_full_icon";
    } else if ( [self.starColorType  isEqual: @"orange"] ) {
        star_empty_icon = @"star_empty_icon_orange";
        star_half_icon = @"star_half_icon_orange";
        star_full_icon = @"star_full_icon_orange";
    } else if ( [self.starColorType  isEqual: @"green"] ) {
        star_empty_icon = @"star_empty_icon_green";
        star_half_icon = @"star_half_icon_green";
        star_full_icon = @"star_full_icon_green";
    }
    
    // Star #1
    if ( self.banner_params[@"averageUserRatingForCurrentVersion"] != nil ) {
        float averageUserRatingForCurrentVersion = [self.banner_params[@"averageUserRatingForCurrentVersion"] floatValue];
        if ( averageUserRatingForCurrentVersion < 0.5 ) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.star_icon_1.image = [UIImage imageNamed:star_empty_icon inBundle:frameWorkBundle compatibleWithTraitCollection:nil];
            });
        } else if (averageUserRatingForCurrentVersion < 1.0 ) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.star_icon_1.image = [UIImage imageNamed:star_half_icon inBundle:frameWorkBundle compatibleWithTraitCollection:nil];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.star_icon_1.image = [UIImage imageNamed:star_full_icon inBundle:frameWorkBundle compatibleWithTraitCollection:nil];
            });
        }
    }
    
    // Star #2
    if ( self.banner_params[@"averageUserRatingForCurrentVersion"] != nil ) {
        float averageUserRatingForCurrentVersion = [self.banner_params[@"averageUserRatingForCurrentVersion"] floatValue];
        if ( averageUserRatingForCurrentVersion < 1.5 ) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.star_icon_2.image = [UIImage imageNamed:star_empty_icon inBundle:frameWorkBundle compatibleWithTraitCollection:nil];
            });
        } else if (averageUserRatingForCurrentVersion < 2.0 ) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.star_icon_2.image = [UIImage imageNamed:star_half_icon inBundle:frameWorkBundle compatibleWithTraitCollection:nil];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.star_icon_2.image = [UIImage imageNamed:star_full_icon inBundle:frameWorkBundle compatibleWithTraitCollection:nil];
            });
        }
    }
    
    // Star #3
    if ( self.banner_params[@"averageUserRatingForCurrentVersion"] != nil ) {
        float averageUserRatingForCurrentVersion = [self.banner_params[@"averageUserRatingForCurrentVersion"] floatValue];
        if ( averageUserRatingForCurrentVersion < 2.5 ) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.star_icon_3.image = [UIImage imageNamed:star_empty_icon inBundle:frameWorkBundle compatibleWithTraitCollection:nil];
            });
        } else if (averageUserRatingForCurrentVersion < 3.0 ) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.star_icon_3.image = [UIImage imageNamed:star_half_icon inBundle:frameWorkBundle compatibleWithTraitCollection:nil];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.star_icon_3.image = [UIImage imageNamed:star_full_icon inBundle:frameWorkBundle compatibleWithTraitCollection:nil];
            });
        }
    }
    
    
    // Star #4
    if ( self.banner_params[@"averageUserRatingForCurrentVersion"] != nil ) {
        float averageUserRatingForCurrentVersion = [self.banner_params[@"averageUserRatingForCurrentVersion"] floatValue];
        if ( averageUserRatingForCurrentVersion < 3.5 ) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.star_icon_4.image = [UIImage imageNamed:star_empty_icon inBundle:frameWorkBundle compatibleWithTraitCollection:nil];
            });
        } else if (averageUserRatingForCurrentVersion < 4.0 ) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.star_icon_4.image = [UIImage imageNamed:star_half_icon inBundle:frameWorkBundle compatibleWithTraitCollection:nil];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.star_icon_4.image = [UIImage imageNamed:star_full_icon inBundle:frameWorkBundle compatibleWithTraitCollection:nil];
            });
        }
    }
    
    // Star #5
    if ( self.banner_params[@"averageUserRatingForCurrentVersion"] != nil ) {
        float averageUserRatingForCurrentVersion = [self.banner_params[@"averageUserRatingForCurrentVersion"] floatValue];
        if ( averageUserRatingForCurrentVersion < 4.5 ) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.star_icon_5.image = [UIImage imageNamed:star_empty_icon inBundle:frameWorkBundle compatibleWithTraitCollection:nil];
            });
        } else if (averageUserRatingForCurrentVersion < 5.0 ) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.star_icon_5.image = [UIImage imageNamed:star_half_icon inBundle:frameWorkBundle compatibleWithTraitCollection:nil];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.star_icon_5.image = [UIImage imageNamed:star_full_icon inBundle:frameWorkBundle compatibleWithTraitCollection:nil];
            });
        }
    }

}

// change install button color
-(void) updateInstallButtonColor:(NSString*)type{
    
    self.installButtonColorType = type;
    NSBundle *frameWorkBundle = [NSBundle bundleForClass:[Favorr class]];
    
    NSString *install_icon_image = @"install_icon";
    if ( [self.installButtonColorType  isEqual: @"white"] ) {
        install_icon_image = @"install_icon_white";
    } else if ( [self.installButtonColorType  isEqual: @"black"] ) {
        install_icon_image = @"install_icon_black";
    } else if ( [self.installButtonColorType  isEqual: @"green"] ) {
        install_icon_image = @"install_icon";
    } else if ( [self.installButtonColorType  isEqual: @"orange"] ) {
        install_icon_image = @"install_icon_orange";
    } else {
        install_icon_image = @"install_icon";
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        self.install_icon.image = [UIImage imageNamed:install_icon_image inBundle:frameWorkBundle compatibleWithTraitCollection:nil];
    });
}

// change background color
-(void)updateBackgroundColor:(UIColor*)color{
    self.favorrBackgroundColor = color;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.favorrBackgroundColor != nil) {
            self.contentView.backgroundColor = self.favorrBackgroundColor;
        } else {
            self.contentView.backgroundColor = self.defaultFavorrBackgroundColor;
        }
    });
    
}

@end















