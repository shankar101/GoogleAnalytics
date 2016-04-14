//
//  INTGoogleAnalyticsHandler.m
//  MyAppAnalytics
//
//  Created by Shankar Mallick on 21/11/14.
//  Copyright (c) 2014 Shankar_ios. All rights reserved.
//
//https://developers.google.com/analytics/devguides/collection/ios/v3/sdk-download#add_sdk_to_xcode_pj

#import "INTGoogleAnalyticsHandler.h"

static NSString *const kAllowTracking = @"allowTracking";
@implementation INTGoogleAnalyticsHandler
@synthesize trackingID=_trackingID,tracker=_tracker,userId=_userId;

+ (INTGoogleAnalyticsHandler *)sharedInstance
{
    static INTGoogleAnalyticsHandler *sharedInstance_ = nil;
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^{
        sharedInstance_ = [[INTGoogleAnalyticsHandler alloc] init];
    });
    return sharedInstance_;
    
}

/**
 *  This method Sets the tracking to the Shared instance of the Google analytics tracker. This method should be called only once form the Application didifinish with launching mehtod. this method also sets the dispatch interval and tracks the uncaught exceptions and the Logging level is set to VERBOSE.
 
 *
 *  @param trackingID The tracking Id that is provided while creating the App in the google analytics console.
 */
-(void)setTrackingID:(NSString *)trackingID {
    
    // Optional: automatically send uncaught exceptions to Google Analytics.
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 20;
    
    // Optional: set Logger to VERBOSE for debug information.
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
    
    // Initialize tracker. Replace with your tracking ID.

    self.tracker=[[GAI sharedInstance] trackerWithTrackingId:trackingID];
    _trackingID=trackingID;
    
    // Enable IDFA collection.
    //IDFA Enables to tarck the demographics for a particular user. Eg. Age , Gender , Interest.
    self.tracker.allowIDFACollection = YES;

    [self SetOptOut:NO];
}

/**
 *  This method sets Opt out Options for Google Analytics Features. Google recommends to add a feature to all apps recommending to ask the user consent before sending the data to google servers. This method is set private for testing if required this should be made public and used where ever required.
 *
 *  @param shouldOptOut Bool Variable. if yes is sent then Google analytics stops collecting data in the App. Defaults to No.
 */
-(void)SetOptOut:(BOOL)shouldOptOut {
    
    NSDictionary *appDefaults = @{kAllowTracking: @(shouldOptOut)};
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
    // User must be able to opt out of tracking
    [GAI sharedInstance].optOut =[[NSUserDefaults standardUserDefaults] boolForKey:kAllowTracking];

}

-(void)trackClickEvent:(NSString *)eventCategory_ Action:(NSString *)actionName_ Label:(NSString *)lblName_ Value:(int)value_{
    
    NSNumber *xValue=[NSNumber numberWithInt:value_];
    [self.tracker send:[[GAIDictionaryBuilder createEventWithCategory:eventCategory_  // Event category (required)
                                                              action:actionName_  // Event action (required)
                                                               label:lblName_     // Event label
                                                               value:xValue] build]];
    
}

-(void)trackScreen:(NSString *)screenName_{
    [self.tracker set:kGAIScreenName value:screenName_];
    [self.tracker send:[[GAIDictionaryBuilder createAppView]build]];
}

-(void)setUserId:(NSString *)userId {

    _userId=userId;
    
    // You only need to set User ID on a tracker once. By setting it on the tracker, the ID will be
    // sent with all subsequent hits.
    [self.tracker set:@"&uid" value:userId];
    
    //Uncomment the below line to create an event with Category Login
    /*
    // This hit will be sent with the User ID value and be visible in User-ID-enabled views (profiles).
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"UX"            // Event category (required)
                                                          action:@"User Sign In"  // Event action (required)
                                                           label:nil              // Event label
                                                           value:nil] build]];    // Event value
     */

}

@end
