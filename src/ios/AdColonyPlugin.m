//Copyright (c) 2015 Luditeam
//Email: dev@Luditeam.com
#import "AdColonyPlugin.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import <CommonCrypto/CommonDigest.h> //md5

@implementation AdColonyPlugin

@synthesize callbackIdKeepCallback;
//
@synthesize email;
@synthesize licenseKey_;
@synthesize validLicenseKey;

//
@synthesize appId;
@synthesize fullScreenAdZoneId;
@synthesize rewardedVideoAdZoneId;

- (void) pluginInitialize {
    [super pluginInitialize];
    //
}


- (void) setUp: (CDVInvokedUrlCommand*)command {
    //self.viewController
    //self.webView
    //NSString *adUnitBanner = [command.arguments objectAtIndex: 0];
    //NSString *adUnitFullScreen = [command.arguments objectAtIndex: 1];
    //BOOL isOverlap = [[command.arguments objectAtIndex: 2] boolValue];
    //BOOL isTest = [[command.arguments objectAtIndex: 3] boolValue];
	//NSArray *zoneIds = [command.arguments objectAtIndex:4];
    //NSLog(@"%@", adUnitBanner);
    //NSLog(@"%@", adUnitFullScreen);
    //NSLog(@"%d", isOverlap);
    //NSLog(@"%d", isTest);
	NSString* appId = [command.arguments objectAtIndex:0];
	NSString* fullScreenAdZoneId = [command.arguments objectAtIndex:1];
	NSString* rewardedVideoAdZoneId = [command.arguments objectAtIndex:2];
	NSLog(@"%@", appId);
	NSLog(@"%@", fullScreenAdZoneId);
	NSLog(@"%@", rewardedVideoAdZoneId);

    self.callbackIdKeepCallback = command.callbackId;

    //[self.commandDelegate runInBackground:^{
		[self _setUp:appId aFullScreenAdZoneId:fullScreenAdZoneId aRewardedVideoAdZoneId:rewardedVideoAdZoneId];
    //}];
}

- (void) showFullScreenAd: (CDVInvokedUrlCommand*)command {

    [self.commandDelegate runInBackground:^{
		[self _showFullScreenAd];
    }];
}

- (void) showRewardedVideoAd: (CDVInvokedUrlCommand*)command {

    [self.commandDelegate runInBackground:^{
		[self _showRewardedVideoAd];
    }];
}

- (NSString*) md5:(NSString*) input {
    const char *cStr = [input UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call

    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];

    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];

    return  output;
}

- (void) _setUp:(NSString *)appId aFullScreenAdZoneId:(NSString *)fullScreenAdZoneId aRewardedVideoAdZoneId:(NSString *)rewardedVideoAdZoneId {
	self.appId = appId;
	self.fullScreenAdZoneId = fullScreenAdZoneId;
	self.rewardedVideoAdZoneId = rewardedVideoAdZoneId;

	//
    BOOL debug = NO;
/*
	NSDictionary *options = [command.arguments objectAtIndex:2];
	if (options && [options isKindOfClass:[NSDictionary class]]) {
		[AdColony setCustomID:[options objectForKey:@"customId"]];
		debug = [self toBool:[options objectForKey:@"debug"]];
	}
*/

	NSArray* zoneIds = [NSArray arrayWithObjects: self.fullScreenAdZoneId, self.rewardedVideoAdZoneId, nil];

	//+ ( void ) configureWithAppID:( NSString * )appID zoneIDs:( NSArray * )zoneIDs delegate:( id<AdColonyDelegate> )del logging:( BOOL )log;
	[AdColony configureWithAppID:self.appId
		zoneIDs:zoneIds
		delegate:[[MyAdColonyDelegate alloc] initWithAdColonyPlugin:self]
		logging:debug
	];
}

-(void) _showFullScreenAd {

    if (![AdColony videoAdCurrentlyRunning]) {
		//+ ( void ) playVideoAdForZone:( NSString * )zoneID withDelegate:( id<AdColonyAdDelegate> )del;
        [AdColony playVideoAdForZone:fullScreenAdZoneId
			withDelegate:[[AdColonyAdDelegateFullScreenAd alloc] initWithAdColonyPlugin:self]
		];
    }
}

-(void) _showRewardedVideoAd {

    if (![AdColony videoAdCurrentlyRunning]) {
		//+ ( void ) playVideoAdForZone:( NSString * )zoneID withDelegate:( id<AdColonyAdDelegate> )del withV4VCPrePopup:( BOOL )showPrePopup andV4VCPostPopup:( BOOL )showPostPopup;
        [AdColony playVideoAdForZone:rewardedVideoAdZoneId
			withDelegate:[[AdColonyAdDelegateRewardedVideoAd alloc] initWithAdColonyPlugin:self]
			//withV4VCPrePopup:YES
			//andV4VCPostPopup:YES
		];
    }
}

@end

@implementation MyAdColonyDelegate

@synthesize adColonyPlugin;

- (id) initWithAdColonyPlugin:(AdColonyPlugin *)adColonyPlugin_ {
    self = [super init];
    if (self) {
        self.adColonyPlugin = adColonyPlugin_;
    }
    return self;
}

- (void)onAdColonyAdAvailabilityChange:(BOOL)available inZone:(NSString *)zoneId {
	NSLog(@"%@: %d", @"onAdColonyAdAvailabilityChange", available);

	if (available) {
        if ([zoneId isEqualToString:self.adColonyPlugin.fullScreenAdZoneId]) {
			CDVPluginResult* pr = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"onFullScreenAdLoaded"];
			[pr setKeepCallbackAsBool:YES];
			[adColonyPlugin.commandDelegate sendPluginResult:pr callbackId:adColonyPlugin.callbackIdKeepCallback];
			//CDVPluginResult* pr = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
			//[pr setKeepCallbackAsBool:YES];
			//[self.commandDelegate sendPluginResult:pr callbackId:callbackIdKeepCallback];
		}
        else if ([zoneId isEqualToString:self.adColonyPlugin.rewardedVideoAdZoneId]) {
			CDVPluginResult* pr = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"onRewardedVideoAdLoaded"];
			[pr setKeepCallbackAsBool:YES];
			[adColonyPlugin.commandDelegate sendPluginResult:pr callbackId:adColonyPlugin.callbackIdKeepCallback];
			//CDVPluginResult* pr = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
			//[pr setKeepCallbackAsBool:YES];
			//[self.commandDelegate sendPluginResult:pr callbackId:callbackIdKeepCallback];
		}
	}
}

- (void)onAdColonyV4VCReward:(BOOL)success currencyName:(NSString *)currencyName currencyAmount:(int)amount inZone:(NSString *)zoneId {
	NSLog(@"%@ %d", @"onAdColonyV4VCReward", success);

    if (success) {
    	CDVPluginResult* pr = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[NSMutableString stringWithFormat:@"onRewardedVideoAdCompleted:%@:%d", currencyName, amount]];
		[pr setKeepCallbackAsBool:YES];
		[adColonyPlugin.commandDelegate sendPluginResult:pr callbackId:adColonyPlugin.callbackIdKeepCallback];
		//CDVPluginResult* pr = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
		//[pr setKeepCallbackAsBool:YES];
		//[self.commandDelegate sendPluginResult:pr callbackId:callbackIdKeepCallback];
    }
}

@end

@implementation AdColonyAdDelegateFullScreenAd

@synthesize adColonyPlugin;

- (id) initWithAdColonyPlugin:(AdColonyPlugin *)adColonyPlugin_ {
    self = [super init];
    if (self) {
        self.adColonyPlugin = adColonyPlugin_;
    }
    return self;
}

- (void)onAdColonyAdStartedInZone:(NSString *)zoneId {
	NSLog(@"%@", @"onAdColonyAdStartedInZone");

	CDVPluginResult* pr = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"onFullScreenAdShown"];
	[pr setKeepCallbackAsBool:YES];
	[adColonyPlugin.commandDelegate sendPluginResult:pr callbackId:adColonyPlugin.callbackIdKeepCallback];
	//CDVPluginResult* pr = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
	//[pr setKeepCallbackAsBool:YES];
	//[self.commandDelegate sendPluginResult:pr callbackId:callbackIdKeepCallback];
}

- (void)onAdColonyAdAttemptFinished:(BOOL)shown inZone:(NSString *)zoneId {
	NSLog(@"%@", @"onAdColonyAdAttemptFinished");

    if (shown) {
		NSLog(@"%@", @"onAdColonyAdAttemptFinished: shown");

		CDVPluginResult* pr = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"onFullScreenAdHidden"];
		[pr setKeepCallbackAsBool:YES];
		[adColonyPlugin.commandDelegate sendPluginResult:pr callbackId:adColonyPlugin.callbackIdKeepCallback];
		//CDVPluginResult* pr = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
		//[pr setKeepCallbackAsBool:YES];
		//[self.commandDelegate sendPluginResult:pr callbackId:callbackIdKeepCallback];
    }
	else {
		NSLog(@"%@", @"onAdColonyAdAttemptFinished: else");
    }
}

@end

@implementation AdColonyAdDelegateRewardedVideoAd

@synthesize adColonyPlugin;

- (id) initWithAdColonyPlugin:(AdColonyPlugin *)adColonyPlugin_ {
    self = [super init];
    if (self) {
        self.adColonyPlugin = adColonyPlugin_;
    }
    return self;
}

- (void)onAdColonyAdStartedInZone:(NSString *)zoneId
{
	NSLog(@"%@", @"onAdColonyAdStartedInZone");

	CDVPluginResult* pr = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"onRewardedVideoAdShown"];
	[pr setKeepCallbackAsBool:YES];
	[adColonyPlugin.commandDelegate sendPluginResult:pr callbackId:adColonyPlugin.callbackIdKeepCallback];
	//CDVPluginResult* pr = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
	//[pr setKeepCallbackAsBool:YES];
	//[self.commandDelegate sendPluginResult:pr callbackId:callbackIdKeepCallback];
}

- (void)onAdColonyAdAttemptFinished:(BOOL)shown inZone:(NSString *)zoneId {
	NSLog(@"%@", @"onAdColonyAdAttemptFinished");

    if (shown) {
		NSLog(@"%@", @"onAdColonyAdAttemptFinished: shown");

		CDVPluginResult* pr = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"onRewardedVideoAdHidden"];
		[pr setKeepCallbackAsBool:YES];
		[adColonyPlugin.commandDelegate sendPluginResult:pr callbackId:adColonyPlugin.callbackIdKeepCallback];
		//CDVPluginResult* pr = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
		//[pr setKeepCallbackAsBool:YES];
		//[self.commandDelegate sendPluginResult:pr callbackId:callbackIdKeepCallback];
    }
	else {
		NSLog(@"%@", @"onAdColonyAdAttemptFinished: else");
    }
}

@end
