//
//  SearchBoxView.m
//  ibbo
//
//  Created by Jerry Jones on 1/7/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "SearchBoxView.h"
#import <UIKit/UIGradient.h>

@implementation SearchBoxView
- (id) initWithFrame: (struct CGRect)frame withApp: (id)_app;
{
    app = _app;
    self = [super initWithFrame: CGRectMake(0.0f, 44.0f, 320.0f, 40.0f)];
	
	CGRect rect = [UIHardware fullScreenApplicationContentRect];
	rect.origin.x = rect.origin.y = 0.0f;
	float gray[4] = {.0, .0, .0, 1.0};
	[self setBackgroundColor: CGColorCreate(CGColorSpaceCreateDeviceRGB(), gray)];			
	
	return self;
}


@end
