//
//  CoverArt.m
//  ibbo
//
//  Created by Jerry Jones on 12/7/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "CoverArt.h"


@implementation CoverArt

- (id)init{
	
	self = [super initWithFrame: CGRectMake(0.0f, 0.0f, 30.0f, 30.0f)];	
	[self setImage:[[UIImage imageAtPath:[[NSBundle mainBundle] pathForResource:@"tmp" ofType:@"jpg" inDirectory:@"/"]] retain]]; 
	return self;
}

- (void)getArtWithUrl:(NSString *)aURL forFile:(NSString *)aFileName withDownloader:(id)aDownloader
{
	//NSLog(@"Looking for art at: %@", aURL);
	myId = aFileName;
	myDownloader = aDownloader;
	NSString *newUrl = [[aURL componentsSeparatedByString:@"?"] objectAtIndex:0];
	writeToPath = [[NSString alloc] initWithFormat:@"%@/%@.jpg", @"/var/root/Library/Dashbuster", aFileName];
	
	NSData   *imageData = [NSData dataWithContentsOfFile:writeToPath];
	if(imageData == nil) {
		//NSLog(@"Image Data doesn't exist");
		myURL = aURL;
		if(aURL != nil){
			[aDownloader addToQueue: self];			
		}

	}else {
		//NSLog(@"load an image");
		[self setImage:[[UIImage alloc] initWithData:imageData cache:true]];		
	}

	
}

- (NSString *)myURL
{
	
	return myURL;
	
}

- (void)setMyData:(NSMutableData *)someData
{
	receivedData = someData;
}

//---------------------------------------------------------------------
//connection delegates

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response

{
		[receivedData setLength:0];		
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data

{
    // append the new data to the receivedData	
    // receivedData is declared as a method instance elsewhere
		[receivedData appendData:data];		
	
	
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection

{			
	
	
	// do something with the data	
	// receivedData is declared as a method instance elsewhere
	//NSLog(@"Succeeded! Received %d bytes of data",[receivedData length]);
	[receivedData writeToFile:writeToPath atomically:YES];
	//UIImage *image = [[[UIImage alloc] initWithData:receivedData cache:true] autorelease];
	[self setImage:[[UIImage alloc] initWithData:receivedData cache:true]];	
	[myDownloader connectionFinished];
	[connection release];
	[receivedData release];
}

- (void)dealloc
{
	//NSLog(@"DEALLOC COVER ART");
	[super dealloc];
}


@end
