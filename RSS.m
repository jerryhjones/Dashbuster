//
//  RSS.m
//  ibbo
//
//  Created by Jerry Jones on 12/1/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "RSS.h"
#import "QueueItem.h"


@implementation RSS

- (id)initWithFeed: (NSString *)aString
{
	rssTitleArray = [[NSMutableArray alloc] init];
	//NSString *tmp = [self urlencode:moveURL];
	rssRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:aString]
										  cachePolicy:NSURLRequestUseProtocolCachePolicy
									  timeoutInterval:60.0];
	
	
	[rssRequest setHTTPMethod:@"GET"];
	[rssRequest setHTTPShouldHandleCookies:TRUE];
	
	
	NSURLConnection *rssConnection=[[NSURLConnection alloc] initWithRequest:rssRequest delegate:self];
	if (rssConnection) {
		rssData=[[NSMutableData data] retain];
	} else {
		// inform the user that the download could not be made
	}
	
	return self;
	
}

- (NSMutableArray *)getRSSTitleArray
{
	return rssTitleArray;
}

- (NSString *)titles
{
	//return [rssTitleArray count];
	//	(@"Titles count: %@", rssTitleArray);
	//return @"WTF";
}

//---------------------------------------------------------------------
//connection delegates

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response

{
	
    [rssData setLength:0];
	
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data

{
    // append the new data to the searchData	
    // searchData is declared as a method instance elsewhere
	
    [rssData appendData:data];
	
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection

{			

	
	Class NSXMLParserClass = NSClassFromString(@"NSXMLParser");
	NSXMLParser *searchResultParser = [[[NSXMLParserClass alloc] initWithData: rssData] autorelease];
    [searchResultParser setDelegate:self];
    [searchResultParser parse];
	[connection release];
    [rssData release];
	
}

//---------------------------------------------------------------------

//parser delegates


- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
	if([elementName isEqualToString:@"item"]){
		isParsingItem = YES;
		tmpItem = [[[QueueItem alloc] init] autorelease];
		[rssTitleArray addObject:tmpItem];
		
	}else if([elementName isEqualToString:@"title"]){
		isParsingTitle = YES;
		tmpString = [[[NSMutableString alloc] init] autorelease];
		[tmpString retain];
	}
	else if([elementName isEqualToString:@"link"]){
		isParsingLink = YES;
		tmpString = [[[NSMutableString alloc] init] autorelease];
		[tmpString retain];
	}else if([elementName isEqualToString:@"enclosure"]){
		//NSLog(@"IMAGE URL: %@", [attributeDict objectForKey:@"url"]);
		[tmpItem setQueueItemImageURL:[[[NSString alloc] initWithString:[attributeDict objectForKey:@"url"]] autorelease] ];
	}else if([elementName isEqualToString:@"description"]){
		isParsingDescription = YES;
		tmpString = [[[NSMutableString alloc] init] autorelease];
		[tmpString retain];
	}

	

}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	if([elementName isEqualToString:@"item"]){
		isParsingItem = NO;
		[tmpItem release];
	}else if([elementName isEqualToString:@"title"] && isParsingItem){
		isParsingTitle = NO;
		[tmpItem setQueueItemTitle:[[[NSString alloc] initWithString:tmpString] autorelease] ];
		[tmpString release];
	}else if([elementName isEqualToString:@"link"] && isParsingItem){
		isParsingLink = NO;
		[tmpItem setQueueItemId:[[[NSString alloc] initWithString:[tmpString substringFromIndex:51]] autorelease]];
		[tmpString release];
	}else if([elementName isEqualToString:@"description"] && isParsingItem){
		[tmpItem setQueueItemDescription:[[[NSString alloc] initWithString:tmpString] autorelease]];
		[tmpString release];
		
	}

}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	if(isParsingItem && (isParsingItem || isParsingLink || isParsingDescription)){
		[tmpString appendString:string];
	}
}

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    // Clear parsing state
    //NSLog(@"Started parsing rss document");
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    // Release our char buffer
    /*
	 _tempElemChars = nil;
	 isParsingUserTitle = isParsingUserURI = isParsingUserImageURI = NO;*/
    //NSLog(@"Ended parsing document");
    
	// Notify the delegate that we're done
	NSNotificationCenter *nc;
	nc = [NSNotificationCenter defaultCenter];
	//NSLog(@"Sending notification of RSSDidFinish");
	[nc postNotificationName:@"RSSDidFinishLoading" object:self];
	
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
	
}

- (void)dealloc
{

	[super dealloc];
	//NSLog(@"DEALLOC RSS");
	
}


@end
