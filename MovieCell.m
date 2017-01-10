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
#import <UIKit/UIView.h>

#import <UIKit/UIImageAndTextTableCell.h>
#import <UIKit/UIApplication.h>
#import <UIKit/UIWindow.h>
#import <UIKit/UIView.h>
#import <UIKit/UITableColumn.h>
#import <UIKit/UITransitionView.h>
#import "WebCore/WebFontCache.h"
#import "MovieCell.h"
#import "TapLabel.h"

@implementation TapableTextLabel
- (BOOL)ignoresMouseEvents{
	return YES;
}

- (void) mouseUp: (GSEvent *) event {
	//NSLog(@"mouseUp label: %@", [self text]);
	
	//[self doHilite];
}
@end



@implementation MovieCell
//- (id)initWithTitle:(NSString *)title description:(NSString *)description image:(NSString *)imageURL guid:(NSString *)guid
- (id)initWithTitle:(NSString *)title itemId:(NSString *)aItemId description:(NSString *)description year:(NSString *)year mpaa:(NSString *)mpaa image:(NSString*)imageURL withDownloader:(id)aDownloader
{
   // NSLog(@"init CustomTableCell");
	
    if(self = [super init]) {
		
		myTitle = title;
		myDescription = description;
		myYear = year;
		myMPAA = mpaa;
		myImageURL = imageURL;
		showingBackside = NO;
		myBackside = [[NSString alloc] initWithFormat:@"%@ - Year:%@ - Rating:%@", description, year, mpaa];

		background = [[UIImageView alloc] init];
		NSString *writeToPath = [[[[NSString alloc] initWithString:@"/var/root/Library/Dashbuster/"] stringByAppendingString:aItemId] stringByAppendingString:@".jpg"];
		//NSString *writeToPath = [[NSString alloc] initWithString:@"/var/root/Library/Dashbuster/000000.jpg"];
		//http://www.blockbuster.com/esi/catalog/movieRollover/306051/true 
		NSString *someURL = [[[[NSString alloc] initWithString:@"http://www.blockbuster.com/esi/catalog/movieRollover/"] stringByAppendingString:aItemId] stringByAppendingString: @"/true"];
		
		NSData  *imageData = [NSData dataWithContentsOfFile:writeToPath];
		if(imageData != nil) {
			//NSLog(@"loading from file");
			[background setImage:[[UIImage alloc] initWithData:imageData cache:true] ];		
		}else {
			//NSLog(@"loading from url");
			[background setImage:[UIImage imageAtPath:[[NSBundle mainBundle] pathForResource:@"loading" ofType:@"jpg" inDirectory:@"/"]]];	
			if ([aItemId length]){
				[aDownloader addToQueue:self withURL:someURL forType:@"detail" forFileName:writeToPath];
				//[aDownloader addToQueue:self withURL:@"http://images.blockbuster.com/is/amg/dvd/cov150/drt600/t669/t66985ijyma.jpg?wid=62&&hei=88&cvt=jpeg" forType:@"cover" forFileName:writeToPath];
				
			}

		}
		
		
		
		//NSLog(@"itemId: %@", aItemId);
		
		
	
		
		

	
		
		float cyan[4] = {0, 0.6823, 0.9372, 1};
		float gray[4] = {0.3, 0.3, 0.3, 1};
		float yellowHalf[4] = {1, 1, 0, .2};		
		float yellowFull[4] = {1, .5, 0, .3};		
		float red[4] = {1, 0, 0, .2};		
		float blue[4] = {0, 0, .75, .2};		
		float white[4] = {1, 1, 1, 1};
		float black[4] = {0, 0, 0, 1};
		
		backBackground = [ [ UIView alloc ] initWithFrame:CGRectMake(0,0,0,0)];
		[backBackground setBackgroundColor: CGColorCreate(CGColorSpaceCreateDeviceRGB(), gray)];
		
		
		testview1 = [ [ UIView alloc ] initWithFrame:CGRectMake(0,0,100,10)];
		[testview1 setBackgroundColor: CGColorCreate(CGColorSpaceCreateDeviceRGB(), white)];
		
		if([myDescription isEqualToString:@"Short Wait"]){
			[testview1 setBackgroundColor: CGColorCreate(CGColorSpaceCreateDeviceRGB(), yellowHalf)];			
		}else if([myDescription isEqualToString:@"Long Wait"]){
			[testview1 setBackgroundColor: CGColorCreate(CGColorSpaceCreateDeviceRGB(), yellowFull)];			
		}else if([myDescription isEqualToString:@"Very Long Wait"]){
			[testview1 setBackgroundColor: CGColorCreate(CGColorSpaceCreateDeviceRGB(), red)];			
		}else if([myDescription isEqualToString:@"Coming Soon"]){
			[testview1 setBackgroundColor: CGColorCreate(CGColorSpaceCreateDeviceRGB(), blue)];			
		}else{
			[testview1 setBackgroundColor: CGColorCreate(CGColorSpaceCreateDeviceRGB(), white)];			
		}
			
		


		testview2 = [ [ UIView alloc ] initWithFrame:CGRectMake(0,0,100,10)];
		//[testview2 setBackgroundColor: CGColorCreate(CGColorSpaceCreateDeviceRGB(), cyan)];
		
		_movieTitle = [[UITextLabel alloc] init];
        [_movieTitle setTapDelegate:self]; 
        [_movieTitle setText:title];

		_movieYear = [[UITextLabel alloc] init];
        [_movieYear setTapDelegate:self]; 
        [_movieYear setText:year];
        [_movieYear setFont:[NSClassFromString(@"WebFontCache") createFontWithFamily:@"Helvetica" traits:2 size:17.]];
		
        [self setBackgroundColor: CGColorCreate(CGColorSpaceCreateDeviceRGB(), cyan)];
        [testview2 addSubview:backBackground];		
		[self addSubview: testview1 ];
		[self addSubview: testview2 ];
		[self addSubview: delayView];

        [self addSubview:background];
		[self addSubview: _movieTitle];

		
        
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
    	float transparentWhiteComponents[4] = { 1., 1., 1., 0.0 };
    	        
        [_movieTitle setFont:[NSClassFromString(@"WebFontCache") createFontWithFamily:@"Helvetica" traits:2 size:19.]];
		//[_movieTitle setColor:CGColorCreate(colorSpace, goldComponents)];
        [_movieTitle setHighlightedColor:CGColorCreate(colorSpace, whiteComponents)];
    	[_movieTitle setBackgroundColor:CGColorCreate(colorSpace, transparentWhiteComponents)];
        [_movieTitle setWrapsText:YES];
		CGSize mySize = [_movieTitle textSize];    	
    }
    
    return self;
}

- (void) mouseUp: (GSEvent *) event {
	//NSLog(@"mouseUp label: %@", self);
	[self testAnimation];
}

- (void)layoutSubviews
{
	
	
    [super layoutSubviews];
    
     CGRect contentBounds = [self contentBounds]; // using contentBounds instead of frame because it gets updated for remove and reording controls being visible
     CGRect frame = contentBounds;

	frame.origin.y      = contentBounds.origin.y + 10;
 	frame.origin.x      = contentBounds.origin.x + 75.;
    frame.size.height   = contentBounds.size.height-20;
    frame.size.width    = contentBounds.size.width - 80;
    [_movieTitle setFrame:frame];
	
	frame.origin.y      = contentBounds.origin.y + 10;
 	frame.origin.x      = contentBounds.origin.x + 10.;
    frame.size.height   = contentBounds.size.height-20;
    frame.size.width    = contentBounds.size.width - 20.;
    [_movieYear setFrame:frame];
	
	frame.origin.y      = contentBounds.origin.y;
 	frame.origin.x      = contentBounds.origin.x;
    frame.size.height   = contentBounds.size.height-2;
    frame.size.width    = contentBounds.size.width;
    [testview1 setFrame:frame];	
	
		
	frame.origin.y      = contentBounds.origin.y;
 	frame.origin.x      = contentBounds.origin.x;
    frame.size.height   = contentBounds.size.height-2;
    frame.size.width    = contentBounds.size.width;
    [testview2 setFrame:frame];	
    
    frame.size.height = contentBounds.size.height;
	frame.origin.y = contentBounds.origin.y + 0;
	[_movieDesc setFrame:frame];
	
	frame.size.height = 75.;
	frame.size.width = 55.;
    frame.origin.y = contentBounds.origin.y + 5.;
	frame.origin.x = contentBounds.origin.x + 10;
	
	[background setFrame:frame];
	
	
}

-(void)layoutBackside {
	CGRect contentBounds = [self contentBounds]; // using contentBounds instead of frame because it gets updated for remove and reording controls being visible
	CGRect frame = contentBounds;
	
	frame.origin.y      = contentBounds.origin.y + 10;
 	frame.origin.x      = contentBounds.size.width - 100.;
    frame.size.height   = contentBounds.size.height-20;
    frame.size.width    = contentBounds.size.width - 100.;
    [_movieTitle setFrame:frame];
	
	frame.origin.y      = contentBounds.origin.y;
 	frame.origin.x      = contentBounds.origin.x;
    frame.size.height   = contentBounds.size.height-2;
    frame.size.width    = contentBounds.size.width;
    [backBackground setFrame:frame];	
	
	//[testview2 addSubview: _movieYear];
	//[testview2 addSubview:backBackground];
}

-(void)layoutFrontside {
	
	CGRect contentBounds = [self contentBounds]; // using contentBounds instead of frame because it gets updated for remove and reording controls being visible
	CGRect frame = contentBounds;
	
	frame.origin.y      = contentBounds.origin.y + 10;
 	frame.origin.x      = contentBounds.origin.x + 10.;
    frame.size.height   = contentBounds.size.height-20;
    frame.size.width    = contentBounds.size.width - 100.;
    [_movieTitle setFrame:frame];
	
	frame.origin.y      = 0;
 	frame.origin.x      = 0;
    frame.size.height   = 0;
    frame.size.width    = 0;
    [backBackground setFrame:frame];	
	
	
	[_movieYear removeFromSuperview];
	
}

-(void)testAnimation {
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	float whiteComponents[4] = { 1., 1., 1., 1. };
	float blueComponents[4] = { 0., 0., .5, 1. };
	float darkGrayComponents[4] = { 0.3, 0.3, 0.3, 1. };
	float blackComponents[4] = { 0., 0., 0., 1. };
	
	LKAnimation *animation = [LKTransition animation];
	[animation setType: @"tubey"];
	[animation setTimingFunction: [LKTimingFunction functionWithName: @"easeInEaseOut"]];
	[animation setFillMode: @"extended"];
	[animation setTransitionFlags: 3];
	[animation setDuration: 10];
	[animation setSpeed:.3];
	[animation setSubtype: @"fromLeft"];
	[self addAnimation: animation forKey: 0];
	if([self showingBackside]){
		[self layoutFrontside];
		[_movieTitle setText:myTitle];
        [_movieTitle setFont:[NSClassFromString(@"WebFontCache") createFontWithFamily:@"Helvetica" traits:2 size:20.]];
		[_movieTitle setColor:CGColorCreate(colorSpace, blackComponents)];
    	//[testview1 setBackgroundColor:CGColorCreate(colorSpace, whiteComponents)];
		[self setShowingBackside: NO];
	}else{
		[self layoutBackside];
		[_movieTitle setText:myBackside];
		[_movieTitle setFont:[NSClassFromString(@"WebFontCache") createFontWithFamily:@"Helvetica" traits:2 size:17.]];
		[_movieTitle setColor:CGColorCreate(colorSpace, whiteComponents)];
    	//[testview1 setBackgroundColor:CGColorCreate(colorSpace, darkGrayComponents)];
		[self setShowingBackside: YES];
	}

	
	/*[UIView beginAnimations:nil];
	[UIView setAnimationCurve:kUIAnimationCurveEaseInEaseOut];
	[UIView setAnimationDuration:2.0];
	// animate to the new frame in 2 seconds
	[self setFrame:CGRectMake(0, 0, 100, 100)];
	[UIView endAnimations];*/
	
}

-(NSString *)getTitle {
	return myTitle;
}

- (void)setTitle:(NSString *)aString {
	[_movieTitle setText:aString];
	
}

- (BOOL)showingBackside{
	return showingBackside;
}

- (void)setShowingBackside:(BOOL)aBool{
	showingBackside = aBool;
}

- (void)setCoverArt:(UIImage *)aImage
{
	[background setImage:aImage];
}

- (void)setImageURL:(NSString *)aString
{
	//NSLog(@"Change URL TO: %@", aString);
	myImageURL = aString;
}

- (NSString*)imageURL
{
	return myImageURL;
}


- (void)dealloc
{
	//NSLog(@"DEALLOC MOVIE CELL: %@", self);
    [_movieTitle release];
    [_movieDesc release];
   // [_movieImage release];
	[myBackside release];
	[background release];
	[testview1 release];
    [super dealloc];
}

@end
