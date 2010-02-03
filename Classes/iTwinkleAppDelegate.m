//
//  iTwinkleAppDelegate.m
//  iTwinkle
//
//  Created by Seth Raphael on 1/31/10.
//  Copyright Apple Inc 2010. All rights reserved.
//

#import "iTwinkleAppDelegate.h"
#import "iTwinkleViewController.h"

@implementation iTwinkleAppDelegate

@synthesize window;
@synthesize viewController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after app launch    
	[application setStatusBarHidden:YES];
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
	
	return YES;
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
