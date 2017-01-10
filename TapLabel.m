//
//  tapLabel.m
//  ibbo
//
//  Created by Jerry Jones on 12/7/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "TapLabel.h"

@implementation TapLabel 
- (BOOL) ignoresMouseEvents {
	return NO;
}
#if 1
- (void) handleSingleTapEvent: (struct __GSEvent *)fp8 {
	//NSLog(@"handleSingleTap");
	
	//[textGrid tapTarget: self];
}
#endif

- (void)view:(UIView *)view handleTapWithCount:(int)count event:(GSEvent *)event {
	//NSLog(@"handleTapWithCount");
	

}


- (void) disable {
	//[self setEnabled: FALSE];
}

// Use a label mouseup to get fast reponse to touch events.
// Tap handling seems to have a visible delay before doing hilights
- (void) mouseUp: (GSEvent *) event {
	//NSLog(@"mouseUp label");
	
	[self doHilite];
}

- (void) doHilite {
	float hili1[4] =  {0.,1.,0.,0.3};
	[self setBackgroundColor: CGColorCreate(CGColorSpaceCreateDeviceRGB(), hili1)];
}

- (void) removeHilite {
	float trans1[4] =  {0.,0.,0.,0.};
	[self setBackgroundColor: CGColorCreate(CGColorSpaceCreateDeviceRGB(), trans1)];
	
}

@end