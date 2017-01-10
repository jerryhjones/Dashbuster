//
//  Search.m
//  ibbo
//
//  Created by Jerry Jones on 11/28/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "Search.h"


@implementation Search

- (id)initWithKeyword: (NSString *)aString
{
	searchTitleArray = [[NSMutableArray alloc] init];

	NSString* moveURL = [[NSString alloc] initWithFormat:@"http://www.blockbuster.com/search/movie/mostPopular?keyword=%@&y=0&x=0&lc.1.viewType=BoxArt&pg.1.pageSize=20",[aString stringByAddingPercentEscapes]];
	//NSString *tmp = [self urlencode:moveURL];
	//NSLog(@"moveURL: %@", moveURL);
	searchRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:moveURL]
									   cachePolicy:NSURLRequestUseProtocolCachePolicy
								   timeoutInterval:60.0];

	
	[searchRequest setHTTPMethod:@"GET"];
	[searchRequest setHTTPShouldHandleCookies:TRUE];
	
	
	NSURLConnection *searchConnection=[[NSURLConnection alloc] initWithRequest:searchRequest delegate:self];
	if (searchConnection) {
		searchData=[[NSMutableData data] retain];
	} else {
		// inform the user that the download could not be made
	}
	
	//NSLog(@"Search initiated");
	return self;
	
}

- (NSMutableArray *)getSearchTitleArray
{
	return searchTitleArray;
}

//---------------------------------------------------------------------
//connection delegates

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response

{
	
    [searchData setLength:0];
	
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data

{
    // append the new data to the searchData	
    // searchData is declared as a method instance elsewhere
	
    [searchData appendData:data];
	
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection

{			
	// do something with the data	
    // searchData is declared as a method instance elsewhere
    //NSLog(@"Succeeded! Received %d bytes of data",[searchData length]);

	
	// release the connection, and the data object
    [connection release];
	
	Class NSXMLParserClass = NSClassFromString(@"NSXMLParser");
	NSXMLParser *searchResultParser = [[[NSXMLParserClass alloc] initWithData: searchData] autorelease];
    [searchResultParser setDelegate:self];
    [searchResultParser parse];
    [searchData release];
	
}

//---------------------------------------------------------------------

//parser delegates


- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
	
	if([elementName isEqualToString:@"div"]){
		//Here we are checking for a class string that starts with movie
		//this indicates the start of a movie object.
		NSString *classStr = [attributeDict objectForKey:@"class"];
		NSString *firstFiveCharsString;
		if([classStr length] > 5){
			firstFiveCharsString = [classStr substringToIndex:5];
		}else{
			firstFiveCharsString = classStr;
		}
			
		if([firstFiveCharsString isEqualToString:@"movie"]){
			//NSLog(@"div - class: %@", [attributeDict objectForKey:@"class"]);
		//	NSLog(@"start parsing movie div");
			currentParsingMovieTitleId = [attributeDict objectForKey:@"id"];
			isParsingMovieClassDiv = YES;
			divTreeLevel = 0;
		}else if(isParsingMovieClassDiv){
			divTreeLevel += 1;
		}		
		
		
	}
	
	if([[attributeDict objectForKey:@"class"] isEqualToString:@"titleInfo"]){
		isParsingTitleInfo = YES;
		NSLog(@"Is Parsing Title");
		NSArray * keys = [NSArray arrayWithObjects: @"titleId", @"title", @"imagePath", @"description", nil];
		NSArray * values = [NSArray arrayWithObjects: @"", @"", @"", @"", nil];
		[searchTitleArray addObject:[[NSMutableDictionary alloc] initWithObjects: values forKeys: keys]];
		lastAddedItem = [searchTitleArray count]-1;		
	}
	
	if(isParsingTitleInfo && [elementName isEqualToString:@"img"]){
		//NSLog(@"Image: %@", [attributeDict objectForKey:@"src"]);
//		NSArray * keys = [NSArray arrayWithObjects: @"titleId", @"title", @"imagePath", @"description", nil];
//		NSArray * values = [NSArray arrayWithObjects: @"", @"", [attributeDict objectForKey:@"src"], @"", nil];
		[[searchTitleArray objectAtIndex: lastAddedItem] setValue:[attributeDict objectForKey:@"src"] forKey:@"imagePath"];
		//NSLog(@"last add: %d", lastAddedItem);

	}
	
	if(isParsingMovieClassDiv && [[attributeDict objectForKey:@"class"] isEqualToString:@"title"]){
		isParsingTitle = YES;
	}
	
	
	if(isParsingTitle && [elementName isEqualToString:@"a"]){
		//NSArray * keys = [NSArray arrayWithObjects: @"titleId", @"title", @"imagePath", nil];
		//NSArray * values = [NSArray arrayWithObjects: currentParsingMovieTitleId, [attributeDict objectForKey:@"title"], @"", nil];
		//NSLog(@"id: %@", currentParsingMovieTitleId);
		//NSLog(@"title: %@", [attributeDict objectForKey:@"title"]);
		NSLog(@"1");
		NSLog(@"Count: %d", [searchTitleArray count]);
		[[searchTitleArray objectAtIndex: lastAddedItem] setValue:currentParsingMovieTitleId forKey:@"titleId"];
		NSLog(@"2");
		[[searchTitleArray objectAtIndex: lastAddedItem] setValue:[attributeDict objectForKey:@"title"] forKey:@"title"];
		NSLog(@"3");
	}
	
	if([[attributeDict objectForKey:@"class"] isEqualToString:@"summary"]){
		//NSLog(@"START SUMMARY");
		isParsingSummary = YES;
		tmpString = [[[NSMutableString alloc] init] autorelease];
		[tmpString retain];
	}
	
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	if([elementName isEqualToString:@"dt"]){
		isParsingTitleInfo = NO;
	}
	
	if(isParsingSummary && [elementName isEqualToString:@"div"]){
		//NSLog(@"END SUMMARY");
		isParsingSummary = NO;
		//NSLog(tmpString);
		[[searchTitleArray objectAtIndex: lastAddedItem] setValue:tmpString forKey:@"description"];
		[tmpString release];
	}
	
	if([elementName isEqualToString:@"div"] && isParsingMovieClassDiv){
		if(divTreeLevel == 0){
			isParsingMovieClassDiv = NO;
			currentParsingMovieTitleId = nil;
			//NSLog(@"stop parsing movie div");
		}else{
			divTreeLevel -= 1;
		}
	}
	if([elementName isEqualToString:@"span"] && isParsingTitle){
		isParsingTitle = NO;
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	if(isParsingSummary){
		[tmpString appendString:string];
	}
}

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    // Clear parsing state
    //NSLog(@"Started parsing queue document");
	lastAddedItem = 0;
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    // Release our char buffer
    /*
	 _tempElemChars = nil;
	 isParsingUserTitle = isParsingUserURI = isParsingUserImageURI = NO;*/
   // NSLog(@"Ended parsing document");
    
	// Notify the delegate that we're done
	NSNotificationCenter *nc;
	nc = [NSNotificationCenter defaultCenter];
	//NSLog(@"Sending notification of SearchDidFinishLoading for Queue");
	[nc postNotificationName:@"SearchDidFinishLoading" object:self];
	
	
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
  
}



@end
