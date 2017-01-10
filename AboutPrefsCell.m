//
//  MovieCell.m
//
//  Created by Justin on 2007-10-16.
//  Copyright (c) 2007 Active Reload, LLC.. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GraphicsServices/GraphicsServices.h>

#import <UIKit/UIKit.h>
#import <UIKit/UIImage.h>
#import <UIKit/UIView-Geometry.h>
#import <UIKit/UIView.h>

#import <WebCore/WebFontCache.h>
#import "AboutPrefsCell.h"


@implementation AboutPrefsCell
//- (id)initWithTitle:(NSString *)title description:(NSString *)description image:(NSString *)imageURL guid:(NSString *)guid
- (id)initWithTitle:(NSString *)title description:(NSString *)description
{
    //NSLog(@"init CustomTableCell");
	
    if(self = [super init]) {
        _movieTitle = [[UITextLabel alloc] init];
        //_movieDesc  = [[UITextLabel alloc] init];
        //_movieImage = [[UIImageView alloc] init];
        
        [_movieTitle setText:title];
        //[_movieDesc setText:description];
        
        [self addSubview:_movieTitle];
        //[self addSubview:_movieDesc];
        //[self addSubview:_movieImage];
        
        //NSString *tmpFile = [NSString stringWithFormat:@"/var/root/Library/Myflix/%@", guid];
        //NSData   *imageData = [NSData dataWithContentsOfFile:tmpFile];
        
        /*if(imageData == nil) {
		 imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]];
		 [imageData writeToFile:tmpFile atomically:YES];
		 }
		 
		 UIImage *image = [[[UIImage alloc] initWithData:imageData cache:true] autorelease];
		 UIImage *image = [UIImage applicationImageNamed:imageURL];
		 [_movieImage setImage:image];*/
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    	float grayComponents[4] = { 0.6, 0.6, 0.6, 1. };
    	float whiteComponents[4] = { 1., 1., 1., 1. };
    	float blueComponents[4] = { 0., 0., .5, 1. };
    	float goldComponents[4] = { 0.831, 0.706, .07, 1. };
    	float transparentWhiteComponents[4] = { 1., 1., 1., 0. };
		
        [_movieTitle setFont:[NSClassFromString(@"WebFontCache") createFontWithFamily:@"Helvetica" traits:2 size:16.]];
		//[_movieTitle setColor:CGColorCreate(colorSpace, goldComponents)];
        [_movieTitle setHighlightedColor:CGColorCreate(colorSpace, whiteComponents)];
    	[_movieTitle setBackgroundColor:CGColorCreate(colorSpace, transparentWhiteComponents)];
        [_movieTitle setWrapsText:YES];
		CGSize mySize = [_movieTitle textSize];
		//NSLog(@"Width: %f - Height: %f", mySize.width, mySize.height);
		//NSLog(@"object: %@", );
    	
        /*[_movieDesc setFont:[NSClassFromString(@"WebFontCache") createFontWithFamily:@"Verdana" traits:0 size:12.]];
		 [_movieDesc setHighlightedColor:CGColorCreate(colorSpace, whiteComponents)];
		 [_movieDesc setBackgroundColor:CGColorCreate(colorSpace, transparentWhiteComponents)];
		 [_movieDesc setColor:CGColorCreate(colorSpace, grayComponents)];
		 [_movieDesc setWrapsText:YES];*/
    	
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
	CGRect contentBounds = [self contentBounds]; // using contentBounds instead of frame because it gets updated for remove and reording controls being visible
	CGRect frame = contentBounds;
	//NSLog(@"Frame - height: %f / width: %f", frame.size.width, frame.size.height);
	
	/*frame.origin.y      = contentBounds.origin.y + 5.;
     frame.origin.x      = contentBounds.origin.x + 2.;
     frame.size.width    = 65.;
     frame.size.height   = 90.;
     [_movieImage setFrame:frame];*/
	
    //frame.origin.y      = contentBounds.origin.y - 30.;
	frame.origin.y      = contentBounds.origin.y + 10;
    //-----
	//We don't want title's right now, move back to the left
	//frame.origin.x      = contentBounds.origin.x + 75.;
	frame.origin.x      = contentBounds.origin.x + 10.;
	//-----
    frame.size.height   = contentBounds.size.height-20;
    frame.size.width    = contentBounds.size.width - 20.;
    [_movieTitle setFrame:frame];
    
    frame.size.height = contentBounds.size.height;
	frame.origin.y = contentBounds.origin.y + 0;
	[_movieDesc setFrame:frame];
	
}

- (void)dealloc
{
    [_movieTitle release];
    [_movieDesc release];
    //[_movieImage release];
    [super dealloc];
}

@end
