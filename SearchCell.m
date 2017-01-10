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
#import "SearchCell.h"


@implementation SearchCell
//- (id)initWithTitle:(NSString *)title description:(NSString *)description image:(NSString *)imageURL guid:(NSString *)guid
- (id)initWithTitle:(NSString *)title description:(NSString *)description movieId:(NSString *)aId imgUrl:(NSString *)imgUrl inQueue:(BOOL)inQueue withDownloader:(id)aDownloader
{
   // NSLog(@"init CustomTableCell");
	
    if(self = [super init]) {
        _movieTitle = [[UITextLabel alloc] init];
        _movieDesc  = [[UITextLabel alloc] init];
		movieId = [aId retain];
		myImgURL = [imgUrl retain];
        //NSLog(@"My URL: %@", imgUrl);
		
        [_movieTitle setText:title];
        [_movieDesc setText:description];
        
        [self addSubview:_movieTitle];
        [self addSubview:_movieDesc];
		


		
		
		background = [[UIImageView alloc] init];
		NSString *writeToPath = [[[[NSString alloc] initWithString:@"/var/root/Library/Dashbuster/"] stringByAppendingString:movieId] stringByAppendingString:@".jpg"];
		NSData  *imageData = [NSData dataWithContentsOfFile:writeToPath];
		if(imageData != nil) {
		//	NSLog(@"loading from file");
			[background setImage:[[UIImage alloc] initWithData:imageData cache:true] ];		
		}else {
		//	NSLog(@"loading from url");
			[background setImage:[UIImage imageAtPath:[[NSBundle mainBundle] pathForResource:@"loading" ofType:@"jpg" inDirectory:@"/"]]];	
			[aDownloader addToQueue:self withURL:imgUrl forFileName:writeToPath];
		}
		
		
        [self addSubview:background];
        
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    	float grayComponents[4] = { 0.6, 0.6, 0.6, 1. };
		float darkGray[4] = { 0.1, 0.1, 0.1, 1. };
		float lightGray[4] = { 0.1, 0.1, 0.1, 1. };
		float whiteShadow[4] = { 1., 1., 1.1, .5 };
    	float whiteComponents[4] = { 1., 1., 1., 1. };
    	float transparentWhiteComponents[4] = { 1., 1., 1., 0. };
		
        [_movieTitle setFont:[NSClassFromString(@"WebFontCache") createFontWithFamily:@"Helvetica" traits:2 size:16.]];
        [_movieTitle setHighlightedColor:CGColorCreate(colorSpace, whiteComponents)];
    	[_movieTitle setBackgroundColor:CGColorCreate(colorSpace, transparentWhiteComponents)];
    	
        [_movieDesc setFont:[NSClassFromString(@"WebFontCache") createFontWithFamily:@"Helvetica" traits:0 size:12.]];
        [_movieDesc setHighlightedColor:CGColorCreate(colorSpace, whiteComponents)];
    	[_movieDesc setBackgroundColor:CGColorCreate(colorSpace, transparentWhiteComponents)];
    	[_movieDesc setColor:CGColorCreate(colorSpace, grayComponents)];
        [_movieDesc setWrapsText:YES];
		if(inQueue){
			UIView *inQueueOverlay;
			UITextLabel *alreadyInQueueLabel = [[UITextLabel alloc] init];
			[alreadyInQueueLabel setText:@"Already In Your Queue"];
			[alreadyInQueueLabel setFont:[NSClassFromString(@"WebFontCache") createFontWithFamily:@"Helvetica" traits:2 size:28.]];
			[alreadyInQueueLabel setColor:CGColorCreate(colorSpace, darkGray)];
			[alreadyInQueueLabel setShadowColor:CGColorCreate(colorSpace, whiteShadow)];
			CGSize mySize;
			mySize.height = 1.0f;
			mySize.width = 0.0f;
			[alreadyInQueueLabel setShadowOffset:mySize];
			[alreadyInQueueLabel setBackgroundColor:CGColorCreate(colorSpace, transparentWhiteComponents)];
			[alreadyInQueueLabel setFrame:CGRectMake(5.0,0,320.0,85.0)];
			
			CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
			float gray[4] = { .5, 0.5, 0.5, .7 };
			inQueueOverlay = [[[ UIView alloc ] initWithFrame:CGRectMake(0,0,320.0,85.0)] autorelease];
			[inQueueOverlay setBackgroundColor: CGColorCreate(CGColorSpaceCreateDeviceRGB(), gray)];
			[self addSubview:inQueueOverlay];
			[self addSubview:alreadyInQueueLabel];
		}
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
	CGRect contentBounds = [self contentBounds]; // using contentBounds instead of frame because it gets updated for remove and reording controls being visible
	CGRect frame = contentBounds;
	
    frame.origin.y      = contentBounds.origin.y + 5.;
	frame.origin.x      = contentBounds.origin.x + 70;
    frame.size.height   = 20.;
	frame.size.width    = contentBounds.size.width - 65.;
    [_movieTitle setFrame:frame];
    
    frame.size.height = 50.;
	frame.origin.y = contentBounds.origin.y + 20;
	[_movieDesc setFrame:frame];
	
	frame.size.height = 75.;
	frame.size.width = 55.;
    frame.origin.y = contentBounds.origin.y + 5.;
	frame.origin.x = contentBounds.origin.x + 10;

	[background setFrame:frame];
	
}

- (void)setCoverArt:(UIImage *)aImage
{
	[background setImage:aImage];
}

- (NSString *)movieId
{
	//NSLog(@"My Movie Id: %@", myImgURL);
	//return @"test";
	return movieId;
}

- (NSString *)myImgURL
{
	//NSLog(@"%@", myImgURL);
	return @"test";
	//return movieId;
	
}

- (void)setInQueue{
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	float grayComponents[4] = { 0.6, 0.6, 0.6, 1. };
	float darkGray[4] = { 0.1, 0.1, 0.1, 1. };
	float lightGray[4] = { 0.1, 0.1, 0.1, 1. };
	float whiteShadow[4] = { 1., 1., 1.1, .5 };
	float whiteComponents[4] = { 1., 1., 1., 1. };
	float transparentWhiteComponents[4] = { 1., 1., 1., 0. };
	
	
	UIView *inQueueOverlay;
	UITextLabel *alreadyInQueueLabel = [[UITextLabel alloc] init];
	[alreadyInQueueLabel setText:@"Already In Your Queue"];
	[alreadyInQueueLabel setFont:[NSClassFromString(@"WebFontCache") createFontWithFamily:@"Helvetica" traits:2 size:28.]];
	[alreadyInQueueLabel setColor:CGColorCreate(colorSpace, darkGray)];
	[alreadyInQueueLabel setShadowColor:CGColorCreate(colorSpace, whiteShadow)];
	CGSize mySize;
	mySize.height = 1.0f;
	mySize.width = 0.0f;
	[alreadyInQueueLabel setShadowOffset:mySize];
	[alreadyInQueueLabel setBackgroundColor:CGColorCreate(colorSpace, transparentWhiteComponents)];
	[alreadyInQueueLabel setFrame:CGRectMake(5.0,0,320.0,85.0)];

	float gray[4] = { .5, 0.5, 0.5, .7 };
	inQueueOverlay = [[[ UIView alloc ] initWithFrame:CGRectMake(0,0,320.0,85.0)] autorelease];
	[inQueueOverlay setBackgroundColor: CGColorCreate(CGColorSpaceCreateDeviceRGB(), gray)];
	[self addSubview:inQueueOverlay];
	[self addSubview:alreadyInQueueLabel];
	[self layoutSubviews];
}

- (void)dealloc
{
	//NSLog(@"DEALLOC SEARCH CELL: %@", self);
	//NSLog(@"movie title retain: %d",[_movieTitle retainCount]);
	//NSLog(@"background retain: %d",[background retainCount]);
	[_movieImage release];
	[_movieTitle release];
	[_movieDesc release];
	[movieId release];
	[myImgURL release];
	[background release];
	[super dealloc];
	
	
}

@end
