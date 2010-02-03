//
//  iTwinkleAppDelegate.h
//  iTwinkle
//
//  Created by Seth Raphael on 1/31/10.
//  Copyright Apple Inc 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class iTwinkleViewController;

@interface iTwinkleAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    iTwinkleViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet iTwinkleViewController *viewController;

@end

