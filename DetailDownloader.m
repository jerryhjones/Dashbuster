//
//  CoverArtDownloader.m
//  ibbo
//
//  Created by Jerry Jones on 12/8/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "DetailDownloader.h"
#import "MovieCell.h"

@implementation DetailDownloader

- (id)init
{
	NSLog(@"detail dl");
	downloadQueue = [[NSMutableArray alloc] init];
	pendingRequests = [[NSMutableArray alloc] init];
	pendingRequestsMoreData = [[NSMutableArray alloc] init];
	openRequests = 0;
	
	return self;
}

-(void)addToQueue:(id)cell withURL:(NSString *)aURL forType:(NSString *)aType forFileName:(NSString *)movieId
{
	NSLog(@"QUEUE DETAILS: %@\n%@\n%@\n%@", cell, aURL, aType, movieId);
	NSArray *keys = [NSArray arrayWithObjects:@"cell", @"url", @"fileName", @"downloadType", nil];
	NSArray *objects = [NSArray arrayWithObjects:cell, aURL, movieId, aType, nil];
	NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
	//NSLog(@"filename: %@", movieId);
	
	[downloadQueue addObject:dictionary];
	//NSLog(@"Add To Queue: %d", [downloadQueue count]);
	[self tryDownload];
}

-(void)connectionFinished
{
	openRequests--;
	[self tryDownload];
}

-(void)tryDownload
{
	Class NSXMLParserClass = NSClassFromString(@"NSXMLParser");
	if((openRequests < 6) && [downloadQueue count]){
		openRequests++;		

		
		if([[[downloadQueue objectAtIndex:0] objectForKey:@"downloadType"] isEqualToString:@"cover"]){
			NSLog(@"Download Cover");
			NSURLRequest *theRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[[[[[downloadQueue objectAtIndex:0] objectForKey:@"url"] componentsSeparatedByString:@"?"] objectAtIndex:0] stringByAppendingString:@"?wid=65&hei=91&cvt=jpeg"]]
										//NSURLRequest *theRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[[downloadQueue objectAtIndex:0] objectForKey:@"url"]]
															   cachePolicy:NSURLRequestUseProtocolCachePolicy
														   timeoutInterval:60.0];
			[theRequest setHTTPMethod:@"GET"];
			[theRequest setHTTPShouldHandleCookies:TRUE];
			NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
			if (theConnection) {
				
				NSArray *keys = [NSArray arrayWithObjects:@"connection", @"cell", @"data", @"fileName", @"downloadType", nil];
				NSArray *objects = [NSArray arrayWithObjects:theConnection, [[downloadQueue objectAtIndex:0] objectForKey:@"cell"], [NSMutableData data], [[downloadQueue objectAtIndex:0] objectForKey:@"fileName"], [[downloadQueue objectAtIndex:0] objectForKey:@"downloadType"], nil];
				NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
				[downloadQueue removeObjectAtIndex:0];
				[pendingRequests addObject:dictionary];
			} else {
				// inform the user that the download could not be made				
			}
			
		}else if([[[downloadQueue objectAtIndex:0] objectForKey:@"downloadType"] isEqualToString:@"detail"]){
			//NSLog(@"TRY GETTING DETAILS");
			//NSString* content = [[NSString alloc] initWithFormat:@"loginEmail=%@&loginPassword=%@",userString,passwordString];
			
			NSURLRequest *theRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[[downloadQueue objectAtIndex:0] objectForKey:@"url"]]
															   cachePolicy:NSURLRequestUseProtocolCachePolicy
														   timeoutInterval:60.0];
			[theRequest setHTTPMethod:@"POST"];
			[theRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
			[theRequest setValue:@"www.blockbuster.com" forHTTPHeaderField:@"Host"];
			[theRequest setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
			[theRequest setValue:@"http://www.blockbuster.com/queuemgmt/fullQueue" forHTTPHeaderField:@"Referer"];
			[theRequest setHTTPShouldHandleCookies:TRUE];
			NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
			if (theConnection) {
				
				NSArray *keys = [NSArray arrayWithObjects:@"connection", @"cell", @"data", @"fileName", @"downloadType", @"parser", nil];
				NSArray *objects = [NSArray arrayWithObjects:theConnection, [[downloadQueue objectAtIndex:0] objectForKey:@"cell"], [NSMutableData data], [[downloadQueue objectAtIndex:0] objectForKey:@"fileName"], [[downloadQueue objectAtIndex:0] objectForKey:@"downloadType"], [NSXMLParserClass alloc], nil];
				NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
				//NSLog(@"WTF!!!!: %@", [[downloadQueue objectAtIndex:0] objectForKey:@"fileName"]);
				[downloadQueue removeObjectAtIndex:0];
				//NSLog(@"After remove Object");
				[pendingRequests addObject:dictionary];
				//NSLog(@"After add to pending ");				
				//[keys release];
				//[objects release];
				//[dictionary release];
				
				
			} else {
				// inform the user that the download could not be made
				//NSLog(@"Connection broke");
			}
			
			
		}else{
			//NSLog(@"BAD DOWNLOADER REQUESTS");
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
	//NSLog(@"Connection response");
	int arrayCount = [pendingRequests count];
	NSAutoreleasePool *pool =  [[NSAutoreleasePool alloc] init];
	int i;
	
	for (i = 0; i < arrayCount; i++) {
		if([[pendingRequests objectAtIndex:i] objectForKey:@"connection"] == connection){
			//NSLog(@"Matched at index: %d - Pending Request: %@", i, connection);
			[[[pendingRequests objectAtIndex:i] objectForKey:@"data"] setLength:0];
			break;
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
	//NSLog(@"did recieve data");
	
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection

{			
	int arrayCount = [pendingRequests count];
	//NSLog(@"loading finished");
	
	int i;
	int x;
	for (i = 0; i < arrayCount; i++) {
		if([[pendingRequests objectAtIndex:i] objectForKey:@"connection"] == connection){
			//NSLog(@"Matched at index: %d - Pending Request: %@", i, connection);
			//NSLog(@"Succeeded! Received %d bytes of data",[[[pendingRequests objectAtIndex:i] objectForKey:@"data"] length]);
			x = i;
			break;
		}
	}
	
	
	if([[[pendingRequests objectAtIndex:x] objectForKey:@"downloadType"] isEqualToString:@"cover"]){
		MovieCell *tmpCell = [[pendingRequests objectAtIndex:x] objectForKey:@"cell"];
		NSData *tmpData = [[pendingRequests objectAtIndex:x] objectForKey:@"data"];
		UIImage *image = [[UIImage alloc] initWithData:tmpData cache:true];
		[tmpCell setCoverArt:image];
		
		[tmpData writeToFile:[[pendingRequests objectAtIndex:x] objectForKey:@"fileName"] atomically:YES];
		//NSLog(@"RMOVEING FROM PENDING");
		[pendingRequests removeObjectAtIndex:x];
		[self connectionFinished];

	}else{
		//MovieCell *tmpCell = [[pendingRequests objectAtIndex:x] objectForKey:@"cell"];
		NSMutableString *tmpString;
		
//		NSLog(@"FUUUUCKK: %d", [pendingRequests count]);
		//Data needs to contain something to make a string out of it
		if([[[pendingRequests objectAtIndex:x] objectForKey:@"data"] length]){
			//Fixes tags so we can parse.
			tmpString = [[NSMutableString alloc] initWithData: [[pendingRequests objectAtIndex:x] objectForKey:@"data"] encoding:NSASCIIStringEncoding];
			[tmpString deleteCharactersInRange:NSMakeRange(0,38)];
			NSMutableData *tmpData;
			tmpData = [tmpString dataUsingEncoding: NSASCIIStringEncoding];
			
			[[[pendingRequests objectAtIndex:x] objectForKey:@"data"] release];
			[[[pendingRequests objectAtIndex:x] objectForKey:@"parser"] initWithData: tmpData];
			[[[pendingRequests objectAtIndex:x] objectForKey:@"parser"] setDelegate: self];
			[[[pendingRequests objectAtIndex:x] objectForKey:@"parser"] parse];

			//[tmpString release];
			//NSLog(@"Detail Remove");
			[pendingRequests removeObjectAtIndex:x];
			[self connectionFinished];

		}else
		{
			[[[pendingRequests objectAtIndex:x] objectForKey:@"cell"] setCoverArt:[UIImage imageAtPath:[[NSBundle mainBundle] pathForResource:@"tmp" ofType:@"jpg" inDirectory:@"/"]]];
			[pendingRequests removeObjectAtIndex:x];
			[self connectionFinished];

			//[[[pendingRequests objectAtIndex:x] objectForKey:@"parser"] initWithData: [[pendingRequests objectAtIndex:x] objectForKey:@"data"]];
		}
		
		
		
		
		//[[[pendingRequests objectAtIndex:x] objectForKey:@"parser"] setDelegate: self];
		//[[[pendingRequests objectAtIndex:x] objectForKey:@"parser"] parse];		
	}
	
	
	
	//[writeToPath release];
	//[tmpData release];
	//[image release];
	
	
	
	//[connection release];
	//[pendingRequests removeObjectAtIndex:x];
	//[self connectionFinished];
	
	//NSLog(@"Connection finished");
}



//---------------------------------------------------------------------

//parser delegates


- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
	int i;
	int x;
	for (i = 0; i < [pendingRequests count]; i++) {
		if([[pendingRequests objectAtIndex:i] objectForKey:@"parser"] == parser){
			x = i;
			break;
		}
	}
	if([[attributeDict objectForKey:@"class"] isEqualToString:@"boxart"]){

		if([[attributeDict objectForKey:@"src"] length]){
			//NSLog(@"IMG URL: %@", [attributeDict objectForKey:@"src"]);			
			//[[[pendingRequests objectAtIndex:x] objectForKey:@"cell"] setImageURL:[attributeDict objectForKey:@"src"]];
			//Why wait for the end.....lets add a queue item right now.
			[self addToQueue:[[pendingRequests objectAtIndex:x] objectForKey:@"cell"] withURL:[[[attributeDict objectForKey:@"src"] componentsSeparatedByString:@"?"] objectAtIndex:0] forType:@"cover" forFileName:[[pendingRequests objectAtIndex:x] objectForKey:@"fileName"]];
			//NSLog(@"%d fuck: %@", x, [pendingRequests objectAtIndex:x]);
			//NSLog(@"pending count: %d", [pendingRequests count]);
			//[pendingRequests removeObjectAtIndex:0];
			//[self connectionFinished];
		}

	}
	
	//[pendingRequests removeObjectAtIndex:x];
	//[self connectionFinished];
		 
		 
	
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	
	
	
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	

}

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
	//NSLog(@"Parser started");
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{

	//int i;
	//int x;
	//for (i = 0; i < [pendingRequests count]; i++) {
	//	if([[pendingRequests objectAtIndex:i] objectForKey:@"parser"] == parser){
	//		x = i;
	//		NSLog(@"pos: %d - Length: %d", x, [pendingRequests count]);
				//break;
		//}
//	}
	//NSLog(@"end doc for movie: %@", [[pendingRequests objectAtIndex:x] objectForKey:@"fileName"]);
	//NSLog(@"Cell: %@", [[pendingRequests objectAtIndex:x] objectForKey:@"cell"]);
	//NSLog(@"URL: %@", [[[pendingRequests objectAtIndex:x] objectForKey:@"cell"] imageURL]);
	//NSLog(@"filename: %@", [[pendingRequests objectAtIndex:x] objectForKey:@"fileName"]);
	
	//we can't make reqeust with blank values......need better error checking up top.
	//right now just check for blank URL, becuase blockbuster is a fucker and doesn't always
	//return an detail page.
	//if([[[pendingRequests objectAtIndex:x] objectForKey:@"cell"] imageURL]){

		//	[self addToQueue:[[pendingRequests objectAtIndex:x] objectForKey:@"cell"] withURL:[[[pendingRequests objectAtIndex:x] objectForKey:@"cell"] imageURL] forType:@"cover" forFileName:[[pendingRequests objectAtIndex:x] objectForKey:@"fileName"]];		
//	}
	//NSLog(@"Pending coung: %d:", [pendingRequests count]);

}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{

}



@end
