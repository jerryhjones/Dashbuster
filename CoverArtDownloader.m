//
//  CoverArtDownloader.m
//  ibbo
//
//  Created by Jerry Jones on 12/8/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "CoverArtDownloader.h"
#import "SearchCell.h"

@implementation CoverArtDownloader

- (id)init
{
	NSLog(@"WTF");
	downloadQueue = [[NSMutableArray alloc] init];
	pendingRequests = [[NSMutableArray alloc] init];
	pendingRequestsMoreData = [[NSMutableArray alloc] init];
	openRequests = 0;
	
	return self;
}

-(void)addToQueue:(id)coverArtObject withURL:(NSString *)aURL forFileName:(NSString *)movieId
{
	NSArray *keys = [NSArray arrayWithObjects:@"cell", @"url", @"fileName", nil];
	NSArray *objects = [NSArray arrayWithObjects:coverArtObject, aURL, movieId, nil];
	NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
	
	
	[downloadQueue addObject:dictionary];
	//NSLog(@"Add To Queue: %d", [downloadQueue count]);
	[self tryDownload];
	//NSLog(@"Add Object to downloder queue with URL: %@", [coverArtObject myURL]);
}

-(void)connectionFinished
{
	openRequests--;
	//NSLog(@"Connection finished - do more");
	[self tryDownload];
}

-(void)tryDownload
{
	while((openRequests < 6) && [downloadQueue count]){
		openRequests++;		
		
		
		//[[[[downloadQueue objectAtIndex:0] objectForKey:@"url"] componentsSeparatedByString:@"?"] objectAtIndex:0];
		NSLog(@"attempting URL: %@", [[[[[downloadQueue objectAtIndex:0] objectForKey:@"url"] componentsSeparatedByString:@"?"] objectAtIndex:0] stringByAppendingString:@"?wid=65&hei=91&cvt=jpeg"]);
		NSURLRequest *theRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[[[[[downloadQueue objectAtIndex:0] objectForKey:@"url"] componentsSeparatedByString:@"?"] objectAtIndex:0] stringByAppendingString:@"?wid=65&hei=91&cvt=jpeg"]]
		//NSURLRequest *theRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[[downloadQueue objectAtIndex:0] objectForKey:@"url"]]
														   cachePolicy:NSURLRequestUseProtocolCachePolicy
													   timeoutInterval:60.0];
		[theRequest setHTTPMethod:@"GET"];
		[theRequest setHTTPShouldHandleCookies:TRUE];
		
		
		NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
		if (theConnection) {
			
			NSArray *keys = [NSArray arrayWithObjects:@"connection", @"cell", @"data", @"fileName", nil];
			NSArray *objects = [NSArray arrayWithObjects:theConnection, [[downloadQueue objectAtIndex:0] objectForKey:@"cell"], [NSMutableData data], [[downloadQueue objectAtIndex:0] objectForKey:@"fileName"], nil];
			NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
			
			[downloadQueue removeObjectAtIndex:0];
			[pendingRequests addObject:dictionary];
			
			//[keys release];
			//[objects release];
			//[dictionary release];
			
			
		} else {
			// inform the user that the download could not be made
			
		}
	
	}

}

-(void)emptyQueue
{
	[downloadQueue removeAllObjects];
}






//---------------------------------------------------------------------
//connection delegates

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response

{
	
	int arrayCount = [pendingRequests count];
	NSAutoreleasePool *pool =  [[NSAutoreleasePool alloc] init];
	int i;

	for (i = 0; i < arrayCount; i++) {
		if([[pendingRequests objectAtIndex:i] objectForKey:@"connection"] == connection){
			//NSLog(@"Matched at index: %d - Pending Request: %@", i, connection);
			[[[pendingRequests objectAtIndex:i] objectForKey:@"data"] setLength:0];
		}
	}
	[pool release];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data

{
	int arrayCount = [pendingRequests count];
	NSAutoreleasePool *pool =  [[NSAutoreleasePool alloc] init];
	int i;

	for (i = 0; i < arrayCount; i++) {
		if([[pendingRequests objectAtIndex:i] objectForKey:@"connection"] == connection){
			//NSLog(@"Matched at index: %d - Pending Request: %@", i, connection);
			[[[pendingRequests objectAtIndex:i] objectForKey:@"data"] appendData:data];
		}
	}
	[pool release];
	
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection

{			
	int arrayCount = [pendingRequests count];
	//NSLog(@"Count: %d", [pendingRequests count]);
	
	int i;
	int x;
	for (i = 0; i < arrayCount; i++) {
		if([[pendingRequests objectAtIndex:i] objectForKey:@"connection"] == connection){
			//NSLog(@"Matched at index: %d - Pending Request: %@", i, connection);
			//NSLog(@"Succeeded! Received %d bytes of data",[[[pendingRequests objectAtIndex:i] objectForKey:@"data"] length]);
			x = i;
			
			if([pendingRequests count] > i){
				//NSLog(@"REMOVE OBJECT AT: %d", i);
				//NSLog(@"OBJECT AT %d: %@", i, [pendingRequests objectAtIndex:i]);
				
			}
			//[self connectionFinished];
		}
	}
	//NSLog(@"MATCHED HERE: %d", x);
	
	SearchCell *tmpCell = [[pendingRequests objectAtIndex:x] objectForKey:@"cell"];
	NSData *tmpData = [[pendingRequests objectAtIndex:x] objectForKey:@"data"];
	UIImage *image = [[UIImage alloc] initWithData:tmpData cache:true];
	[tmpCell setCoverArt:image];
	
	//NSString *writeToPath = [[[[NSString alloc] initWithString:@"/var/root/Library/Dashbuster/"] stringByAppendingString:[[pendingRequests objectAtIndex:x] objectForKey:@"fileName"]] stringByAppendingString:@".jpg"];
	[tmpData writeToFile:[[pendingRequests objectAtIndex:x] objectForKey:@"fileName"] atomically:YES];
	
	//[writeToPath release];
	//[tmpData release];
	//[image release];
	
	[pendingRequests removeObjectAtIndex:x];
	//[[[pendingRequests objectAtIndex:x] objectForKey:@"data"] release];
	[self connectionFinished];
	
	
	
	
	
	//NSLog(@"Succeeded! Received %d bytes of data",[[[pendingRequestsMoreData objectAtIndex:[pendingRequests indexOfObject:connection]] objectForKey:@"data"] length]);
	//[receivedData writeToFile:writeToPath atomically:YES];
	//UIImage *image = [[[UIImage alloc] initWithData:receivedData cache:true] autorelease];
	//[self setImage:[[UIImage alloc] initWithData:receivedData cache:true]];	
	//
	//[self connectionFinished];
	//[connection release];
	//[receivedData release];
}




@end
