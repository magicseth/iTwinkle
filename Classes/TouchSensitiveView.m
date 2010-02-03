//
//  TouchSensitiveView.m
//  iTwinkle
//
//  Created by Seth Raphael on 2/1/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "TouchSensitiveView.h"
#import "iTwinkleAppDelegate.h"

@implementation TouchSensitiveView


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	NSLog(@"yowser");	
	[[(iTwinkleAppDelegate *)[[UIApplication sharedApplication] delegate] viewController] touchesBegan:touches withEvent:event];
	
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	NSLog(@"yowser");	
	[[(iTwinkleAppDelegate *)[[UIApplication sharedApplication] delegate] viewController] touchesMoved:touches withEvent:event];
	
}
- (void)dealloc {
    [super dealloc];
}


@end
