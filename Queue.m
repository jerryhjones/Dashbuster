//
//  Queue.m
//  NSUrl
//
//  Created by Jerry Jones on 11/25/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "Queue.h"
#import "QueueItem.h"


@implementation Queue

- (id)init
{
	titleArray = [[NSMutableArray alloc] init];
	shippedTitleArray = [[NSMutableArray alloc] init];
	queuedTitleArray = [[NSMutableArray alloc] init];
	
	return self;
}



- (void)loadRemoteQueue
{
	//	theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.0.129/idashbuster/bug-queue-1.htm"]	
	//	theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://www.blockbuster.com/queuemgmt/fullQueue"]
	theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://www.blockbuster.com/queuemgmt/fullQueue"]
									   cachePolicy:NSURLRequestUseProtocolCachePolicy
								   timeoutInterval:60.0];
	
	[theRequest setHTTPMethod:@"GET"];
	[theRequest setHTTPShouldHandleCookies:TRUE];
	
	NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	if (theConnection) {
		receivedData=[[NSMutableData data] retain];
	} else {
		// inform the user that the download could not be made
	}	
}

-(void)saveDataToDisk
{
//	NSLog(@"save to disk");
	NSString * path = @"/Applications/Dashbuster.app/testSave.stuff";
	
	NSMutableDictionary * rootObject;
	rootObject = [NSMutableDictionary dictionary];
	
	[rootObject setObject: shippedTitleArray forKey:@"shippedArray"];
	[NSKeyedArchiver archiveRootObject: rootObject toFile: path];
	[self loadDataFromDisk];
}

- (void)loadDataFromDisk 
{ 
	//NSLog(@"Load Data From Disk");
	NSString * path = @"/Applications/Dashbuster.app/testSave.stuff";
	NSDictionary * rootObject; 
	
	rootObject = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
	NSMutableArray *tmpShippedArray = [rootObject valueForKey:@"shippedArray"];
	[self setShippedTitleArray:tmpShippedArray];
	//NSLog(@"new shipped title pointer: %p", shippedTitleArray);
	//NSLog(@"new shipped title: %@", shippedTitleArray);
	//NSLog(@"Done loading");
//	NSLog(@"old shipped title: %@", shippedTitleArray);
//	NSLog(@"new shipped title: %@", tmpShippedArray);
}

-(void)setLastRefresh{
	lastRefresh = [NSDate date];
	NSLog(@"Date: %@", lastRefresh);
}

-(BOOL)shouldUpdate{
	if(lastRefresh < lastAdd){
		return YES;
	}else{
		return NO;
	}
}

- (NSMutableArray *)getMovieTitleArray
{
	//NSLog(@"title array count: %i", [titleArray count]);
	return titleArray;
}

- (NSMutableArray *)getShippedTitleArray
{

	//NSLog(@"title array count: %i", [shippedTitleArray count]);
	return shippedTitleArray;
}

- (void)setShippedTitleArray:(NSMutableArray *)aArray
{
//	NSLog(@"SET SHIPPED: %@", aArray);
	shippedTitleArray = aArray;
}

- (NSMutableArray *)getQueuedTitleArray
{
	//NSLog(@"title array count: %i", [shippedTitleArray count]);
	return queuedTitleArray;
}

- (void)setQueuedTitleArray:(NSMutableArray *)aArray
{
	queuedTitleArray = aArray;
}

- (BOOL)checkForId:(NSString *)aId
{
	return [queueSystemIdArray containsObject:aId];
}

- (void)addToQueueWithItemId:(NSString *)aString
{
	fromAddRequest = YES;
	lastAdd = [NSDate date];
	//NSLog(@"Add item id of: %@", aString);
	NSString* moveURL = [[NSString alloc] initWithFormat:@"http://www.blockbuster.com/queuemgmt/addTitleToQueue?titleId=%@",aString];	
	addRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:moveURL]
										 cachePolicy:NSURLRequestUseProtocolCachePolicy
									 timeoutInterval:60.0];
	
	[addRequest setHTTPMethod:@"GET"];
	[addRequest setHTTPShouldHandleCookies:TRUE];
	
	addConnection=[[NSURLConnection alloc] initWithRequest:addRequest delegate:self];
	if (addConnection) {
		[queueSystemIdArray addObject:aString];
		receivedData=[[NSMutableData data] retain];

		NSNotificationCenter *nc;
		nc = [NSNotificationCenter defaultCenter];
		[nc postNotificationName:@"AddDidFinishLoading" object:self];
//		[nc release];
	} else {
		// inform the user that the download could not be made
	}	
}

- (void)deleteItemAtIndex:(int)queueLocation
{

	[[queuedTitleArray objectAtIndex:queueLocation] deleteFromQueue];
}

- (void) encodeWithCoder: (NSCoder *)coder
{ 
	//NSLog(@"encode bitch");
//	[coder encodeObject:queuedTitleArray forKey:@"queuedTitleArray"];
//	[coder encodeObject:shippedTitleArray forKey:@"shippedTitleArray"];
}

- (id) initWithCoder: (NSCoder *)coder 
{ 
//	NSLog(@"init before super init");
//		NSLog(@"init after super init");
//		NSLog(@"%@", [coder decodeObjectForKey:@"queuedTitleArray"]);
	return self;
}

-(int)savedStartsAtIndex{
	NSLog(@"saved started at: %d", savedStartsAt);
	return savedStartsAt;
}

-(void)savedStartsLessOne{
	savedStartsAt--;
}

-(void)rebuildSystemIdArray{
	[queueSystemIdArray removeAllObjects];
	int i;
	for(i = 0; i < [queuedTitleArray count]; i++){
		[queueSystemIdArray addObject:[[queuedTitleArray objectAtIndex:i] systemId]];
	}
}

//---------------------------------------------------------------------
//connection delegates

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response

{
	if(fromAddRequest){
		//NSLog(@"from add - didReceiveResponse");
		[receivedData setLength:0];		
	}else{
		[receivedData setLength:0];		
	}

	
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data

{
    // append the new data to the receivedData	
    // receivedData is declared as a method instance elsewhere
	if(fromAddRequest){
		[receivedData appendData:data];		
	}else{
		[receivedData appendData:data];		
	}

	
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection

{			


		// do something with the data	
		// receivedData is declared as a method instance elsewhere
		//NSLog(@"Succeeded! Received %d bytes of data",[receivedData length]);
		
		//NSLog(@"Length: %d", [queuedTitleArray count]);

		if(fromAddRequest){
			fromAddRequest = NO;
		//	NSLog(@"Sending notification of connectionDidFinishLoading for Add");
		//	[nc postNotificationName:@"AddDidFinishLoading" object:self];			
		}else{
			//NSLog(@"Sending notification of connectionDidFinishLoading for Queue");
			//Reset Arrays
			NSNotificationCenter *nc;
			nc = [NSNotificationCenter defaultCenter];
			[titleArray removeAllObjects];
			[shippedTitleArray removeAllObjects];
			[queuedTitleArray removeAllObjects];
			
			
			// release the connection, and the data object
			[connection release];
			
			Class NSXMLParserClass = NSClassFromString(@"NSXMLParser");
			NSXMLParser *pownceAuthParser = [[[NSXMLParserClass alloc] initWithData: receivedData] autorelease];
			[pownceAuthParser setDelegate:self];
			[pownceAuthParser parse];
			[receivedData release];
			
			[nc postNotificationName:@"BBQDidFinishLoading" object:self];
			//[nc release];
		}

}

//---------------------------------------------------------------------

//parser delegates


- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
    
	if([[attributeDict objectForKey:@"class"] isEqualToString:@"moviesSaved"]){
		isParsingQueuedUL = NO;
		//NSLog(@"SAVED LIST TIME");
	}
	
	if([elementName isEqualToString:@"li"]){
		isParsingWholeSet = NO;
	}
	
	//DELETE ME
	//LETS CHECK FOR rolloverDetailsDiv
	//rolloverDetails doesn't always come up???  Sometimes href is blank. Fuck Blockbuster
	if(divTreeLevel == 0 && isParsingTitle && isParsingQueuedUL && [elementName isEqualToString:@"a"]){
		NSString *systemId;
		if([[attributeDict objectForKey:@"href"] length] > 0){
			 systemId= [[[attributeDict objectForKey:@"href"] componentsSeparatedByString:@"/"] objectAtIndex:3];
//			NSLog(@"systemId: %@", [attributeDict objectForKey:@"href"]);			
		}else {
			systemId = @"";
		}
		[[queuedTitleArray objectAtIndex:(lastId-1)] setSystemId:[[NSString alloc] initWithString:systemId]];

	}
	
	if([[attributeDict objectForKey:@"class"] isEqualToString:@"end"] && !isParsingQueueItem){
		isParsingSavedUL = NO;
		isParsingQueuedUL = NO;
		isParsingShippedUL = NO;
		isParsingTitle = NO;
		isParsingAvailability = NO;
	}
	
	if([[attributeDict objectForKey:@"class"] isEqualToString:@"mpaa"]){
		isParsingMPAA = YES;
		tmpString = [[NSMutableString alloc] init];
		[tmpString retain];
	}
	
	if([[attributeDict objectForKey:@"class"] isEqualToString:@"release"]){
		isParsingYear = YES;
		tmpString = [[NSMutableString alloc] init];
		[tmpString retain];
	}
	
	
	
	if([[attributeDict objectForKey:@"class"] isEqualToString:@"format"]){
	
	}
	
	if([[attributeDict objectForKey:@"id"] isEqualToString:@"queueShippedList"]){
		isParsingShippedUL = YES;
		//NSLog(@"start parsing shipped list");
	}else if([[attributeDict objectForKey:@"id"] isEqualToString:@"queueCurrentList"]) {
		isParsingQueuedUL = YES;
		//q		NSLog(@"start parsing queued list");
	}else if([[attributeDict objectForKey:@"id"] isEqualToString:@"queueSavedList"]) {
		savedStartsAt = [queuedTitleArray count];
		//isParsingSavedUL = YES;
		isParsingQueuedUL = YES;
	}
	
	if(isParsingQueuedUL && [elementName isEqualToString:@"li"]){
		//NSLog(@"queued li");
		isParsingQueueItem = YES;
		QueueItem *tmp = [[QueueItem alloc] init];
				//NSLog(@"addobject 3");
		[queuedTitleArray addObject:tmp];
		lastId = [queuedTitleArray count];
	}
	
	if(isParsingSavedUL && [elementName isEqualToString:@"li"]){
		//NSLog(@"saved li");
		isParsingSavedItem = YES;
		QueueItem *tmp = [[QueueItem alloc] init];
				//NSLog(@"addobject 4");
		[queuedTitleArray addObject:tmp];
		lastId = [queuedTitleArray count];
	}
	
	if(isParsingQueuedUL && [[attributeDict objectForKey:@"class"] isEqualToString:@"setHeader setIcon"]){
		//isParsingSetHeader = YES;
		//NSLog(@"Start Header");
	}
	
	if(isParsingQueuedUL && [[attributeDict objectForKey:@"class"] isEqualToString:@"setHeader setIcon"]){
		isParsingSetItem = YES;
		isParsingWholeSet = YES;
	}
	
	//Apparently Blockbuster has removed the qi tag from some people's queues?  Strange.
	/*if([elementName isEqualToString:@"qi"] && isParsingQueuedUL){
		NSString *queueId = [attributeDict objectForKey:@"itemId"];
		[[queuedTitleArray objectAtIndex:(lastId-1)] setQueueItemId:[[NSString alloc] initWithString:queueId]];
		//NSLog(@"Last Index: %d", [queuedTitleArray count]);
		
	}*/
	
	//Get id from delete box instead.  This is more accurate anyhow because it gives us the set id if need be.
	if(isParsingQueuedUL && [elementName isEqualToString:@"input"] && ([[attributeDict objectForKey:@"name"] isEqualToString:@"deleteSetNumber"] || [[attributeDict objectForKey:@"name"] isEqualToString:@"deleteItemId"]))
	{
		if([[attributeDict objectForKey:@"name"] isEqualToString:@"deleteSetNumber"]){
			[[queuedTitleArray objectAtIndex:(lastId-1)] setIsSet:YES];
			isParsingSetItem = NO;
			
		}else {
			[[queuedTitleArray objectAtIndex:(lastId-1)] setIsSet:NO];
		}
		//NSLog(@"Item Id for %i via delete input box: %@", (lastId-1), [attributeDict objectForKey:@"value"]);
		[[queuedTitleArray objectAtIndex:(lastId-1)] setQueueItemId:[[NSString alloc] initWithString:[attributeDict objectForKey:@"value"]]];
	}
	
	if([[attributeDict objectForKey:@"class"] isEqualToString:@"availability"] && [elementName isEqualToString:@"a"] ){
		isParsingAvailability = YES;
	}
	
	
	if([[attributeDict objectForKey:@"class"] isEqualToString:@"title"]){
		tmpString = [[NSMutableString alloc] init];
		[tmpString retain];
		isParsingTitle = YES;
		divTreeLevel = 0;
	}else {
		if([elementName isEqualToString:@"div"]){
			divTreeLevel += 1;
		}
	}
	
	
	
	
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{

	
	
	if(isParsingShippedUL){
		if([elementName isEqualToString:@"ul"]){
			isParsingShippedUL = NO;
			//NSLog(@"stop parsing shipped list");
		}
	}else if(isParsingQueuedUL){
		if([elementName isEqualToString:@"ul"]){
			isParsingQueuedUL = NO;
			//NSLog(@"stop parsing queued list");
		}
	}else if(isParsingSavedUL){
		if([elementName isEqualToString:@"ul"]){
			isParsingSavedUL = NO;
			//NSLog(@"stop parsing saved list");
		}
	}
	
	if(isParsingMPAA && [elementName isEqualToString:@"div"]){
		isParsingMPAA = NO;
		if(lastId && isParsingQueuedUL){
			[[queuedTitleArray objectAtIndex:(lastId-1)] setMPAA:[[NSString alloc] initWithString:tmpString]];
			[tmpString release];
		}
	}
	
	if(isParsingYear && [elementName isEqualToString:@"div"]){
		isParsingYear = NO;
		if(lastId && isParsingQueuedUL){
			[[queuedTitleArray objectAtIndex:(lastId-1)] setQueueItemYear:[[NSString alloc] initWithString:tmpString]];
			[tmpString release];
		}
	}
	
	if(isParsingAvailability){
		isParsingAvailability = NO;
	}
	
	if([elementName isEqualToString:@"div"]){		
		if(divTreeLevel == 0 && isParsingTitle && isParsingQueuedUL){
			isParsingTitle = NO;

			if(lastId && !(isParsingWholeSet && !isParsingSetItem)){
				[[queuedTitleArray objectAtIndex:(lastId-1)] setQueueItemTitle:[[NSString alloc] initWithString:tmpString]];
				[tmpString release];				
			}
		}else if(divTreeLevel == 0 && isParsingTitle && isParsingShippedUL){
			isParsingTitle = NO;
			if([tmpString length]){
				//NSLog(@"addobject 1");
				[shippedTitleArray addObject:tmpString];	
			}
			[tmpString release];
		}else{
			divTreeLevel -= 1;
		}
	}
	//NSLog(@"Div Tree Level %i", divTreeLevel);

}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{

	if(isParsingShippedUL){
		if (isParsingTitle){
			[tmpString appendString:string];
		}
	}else if(isParsingQueuedUL){
		if (isParsingTitle){
			[tmpString appendString:string];
		}
	}
	if (isParsingTitle && isParsingShippedUL){
		//NSLog(@"Found chars: %@", string);
//		[shippedTitleArray addObject:string];
//		isParsingTitle = NO;	
	}else if(isParsingAvailability && isParsingQueuedUL){
		[[queuedTitleArray objectAtIndex:(lastId-1)] setQueueAvailability:[[NSString alloc] initWithString:string]];
		
	}
	
	if ((isParsingMPAA || isParsingYear) && isParsingQueuedUL){
		[tmpString appendString:string];
	}
	
    //[_tempElemChars appendString:string];
}

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    // Clear parsing state
    //isParsingUserTitle = isParsingUserURI = isParsingUserImageURI = NO;
   // NSLog(@"Started parsing queue document");
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{  
    // Notify the delegate that we're done
    //[delegate performSelector:@selector(loginComplete:) withObject:self];
	int i;
	queueSystemIdArray = [[NSMutableArray alloc] init];
	for(i = 0; i < [queuedTitleArray count]; i++){
		[queueSystemIdArray addObject:[[queuedTitleArray objectAtIndex:i] systemId]];
	}
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{

}


@end
