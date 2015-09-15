//Copyright (c) 2014 Sang Ki Kwon (Cranberrygame)
//Email: cranberrygame@yahoo.com
//Homepage: http://cranberrygame.github.io
//License: MIT (http://opensource.org/licenses/MIT)
#import <Cordova/CDV.h>
#import <AdColony/AdColony.h>

@interface AdColonyPlugin : CDVPlugin

@property NSString *callbackIdKeepCallback;

@property NSString *appId;
@property NSString *fullScreenAdZoneId;
@property NSString *rewardedVideoAdZoneId;

- (void) setUp:(CDVInvokedUrlCommand*)command;
- (void) showFullScreenAd:(CDVInvokedUrlCommand*)command;
- (void) showRewardedVideoAd:(CDVInvokedUrlCommand*)command;

@end

@interface LtAdColonyDelegate : NSObject <AdColonyDelegate>

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
