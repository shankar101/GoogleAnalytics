//
//  ViewController.m
//  GoogleAnalytics
//
//  Created by Shankar on 14/04/16.
//  Copyright © 2016 Shankar. All rights reserved.
//

#import "ViewController.h"
#import "INTGoogleAnalyticsHandler.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[INTGoogleAnalyticsHandler sharedInstance]trackScreen:@"BaseClass"];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pressok:(id)sender {
    
    [[INTGoogleAnalyticsHandler sharedInstance]trackClickEvent:@"Name_tracking" Action:@"Ok tap" Label:@"Ok call " Value:1];
}
@end
