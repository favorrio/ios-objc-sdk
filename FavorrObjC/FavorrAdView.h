//
//  FavorrAdView.h
//  FavorrObjC
//
//  Created by 大橋 功 on 11/22/16.
//  Copyright © 2016 Favorr, Inc. All rights reserved.
//

@import Foundation;
@import UIKit;
@import AdSupport;
@import StoreKit;






// Define Delegate methods
@protocol FavorrAdViewDelegate <NSObject>
- (void)FavorrAdViewDelegateDidReceiveAd:(NSDictionary*) parameters;
- (void)FavorrAdViewDelegateDidReceiveError:(NSError*) error;
@end



@interface FavorrAdView : UIView

@property (nonatomic, weak) id <FavorrAdViewDelegate> delegate;

// properties
@property (nonatomic, strong) NSString *unitId;
@property (nonatomic, strong) UIViewController *rootViewController;
@property (nonatomic, strong) UIImageView *app_icon;
@property (nonatomic, strong) UIImageView *install_icon;
@property (nonatomic, strong) UILabel *title_label;
@property (nonatomic, strong) UILabel *price_label;
@property (nonatomic, strong) UIImageView *star_icon_1;
@property (nonatomic, strong) UIImageView *star_icon_2;
@property (nonatomic, strong) UIImageView *star_icon_3;
@property (nonatomic, strong) UIImageView *star_icon_4;
@property (nonatomic, strong) UIImageView *star_icon_5;
@property (nonatomic, strong) UILabel *review_count_label;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property int trackId;
@property (nonatomic, strong) NSString *banner_log_id;
@property (nonatomic, strong) SKStoreProductViewController *storeViewController;
@property BOOL storeReadyFlg;

// Settings
@property (nonatomic, strong) UIColor *defaultFavorrBackgroundColor;
@property (nonatomic, strong) UIColor *defaultFavorrTextColor;
@property (nonatomic, strong) NSString *defaultInstallButtonColorType;
@property (nonatomic, strong) NSString *defaultStarColorType;
@property (nonatomic, strong) UIColor *favorrBackgroundColor;
@property (nonatomic, strong) UIColor *favorrTextColor;
@property (nonatomic, strong) NSString *installButtonColorType;
@property (nonatomic, strong) NSString *starColorType;

@property (nonatomic, strong) NSDictionary *banner_params;
@property (nonatomic, strong) UIView *contentView;
@property BOOL isNetworking;

// methods

// Request Ads
-(void)requestAd;

@end
