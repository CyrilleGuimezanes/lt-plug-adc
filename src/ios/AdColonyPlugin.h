//Copyright (c) 2015 Luditeam
//Email: dev@Luditeam.com
#import <Cordova/CDV.h>
#import "AdColony.framework/Versions/A/Headers/AdColony.h"

@interface AdColonyPlugin : CDVPlugin

@property NSString *callbackIdKeepCallback;
//
@property NSString *email;
@property NSString *licenseKey_;
@property BOOL validLicenseKey;
//
@property NSString *appId;
@property NSString *fullScreenAdZoneId;
@property NSString *rewardedVideoAdZoneId;

- (void) setUp:(CDVInvokedUrlCommand*)command;
- (void) showFullScreenAd:(CDVInvokedUrlCommand*)command;
- (void) showRewardedVideoAd:(CDVInvokedUrlCommand*)command;

@end

@interface MyAdColonyDelegate : NSObject <AdColonyDelegate>

@property AdColonyPlugin *adColonyPlugin;

- (id) initWithAdColonyPlugin:(AdColonyPlugin *)adColonyPlugin_ ;

@end

@interface AdColonyAdDelegateFullScreenAd : NSObject <AdColonyAdDelegate>

@property AdColonyPlugin *adColonyPlugin;

- (id) initWithAdColonyPlugin:(AdColonyPlugin *)adColonyPlugin_ ;

@end

@interface AdColonyAdDelegateRewardedVideoAd : NSObject <AdColonyAdDelegate>

@property AdColonyPlugin *adColonyPlugin;

- (id) initWithAdColonyPlugin:(AdColonyPlugin *)adColonyPlugin_ ;

@end
