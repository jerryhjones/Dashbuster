//
//  QueueItem.m
//  ibbo
//
//  Created by Jerry Jones on 11/26/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "QueueItem.h"


@implementation QueueItem
- (void) encodeWithCoder: (NSCoder *)coder
{ 
	//NSLog(@"encode QueueItem");
	[coder encodeObject:queueItemTitle forKey:@"queueItemTitle"];
	[coder encodeObject:queueItemId forKey:@"queueItemId"];
	[coder encodeObject:queueAvailability forKey:@"queueAvailability"];
	[coder encodeObject:queueItemMPAA forKey:@"queueItemMPAA"];
	[coder encodeObject:queueItemYear forKey:@"queueItemYear"];
	[coder encodeObject:queueItemImageURL forKey:@"queueItemImageURL"];
	[coder encodeObject:queueItemDescription forKey:@"queueItemDescription"];	
	[coder encodeObject:systemId forKey:@"systemId"];	
	[coder encodeBool:isSet forKey:@"isSet"];
	//NSLog(@"end encode");
	
}

- (id) initWithCoder: (NSCoder *)coder 
{ 
	if (self = [super init]) 
	{ 
		//NSLog(@"decode QueueItem");
		[self setQueueItemTitle: [coder decodeObjectForKey:@"queueItemTitle"]];
		//NSLog(@"title: %@", [self queueItemTitle]);
		[self setQueueItemId: [coder decodeObjectForKey:@"queueItemId"]];
		[self setQueueAvailability: [coder decodeObjectForKey:@"queueAvailability"]];
		[self setMPAA: [coder decodeObjectForKey:@"queueItemMPAA"]];
		[self setQueueItemYear: [coder decodeObjectForKey:@"queueItemYear"]];
		[self setQueueItemImageURL: [coder decodeObjectForKey:@"queueItemImageURL"]];
		[self setQueueItemDescription: [coder decodeObjectForKey:@"queueItemDescription"]];
		[self setSystemId: [coder decodeObjectForKey:@"systemId"]];
		[self setIsSet: [coder decodeBoolForKey:@"isSet"]];
		//NSLog(@"end decode");
	} 
	return self;
}


- (void)setQueueItemTitle:(NSString *)aTitle{
	queueItemTitle = aTitle;
}

- (NSString *)queueItemTitle{
	return queueItemTitle;
}

- (void)setQueueItemId:(NSString *)aId{
	queueItemId = aId;
}

- (NSString *)queueItemId{
	return queueItemId;
}

- (void)setQueueAvailability:(NSString *)aString{
	queueAvailability = aString;
}
- (NSString *)queueAvailability{
	return queueAvailability;
}

- (void)setMPAA:(NSString *)aString{
	queueItemMPAA = aString;
}
- (NSString *)MPAA{
	return queueItemMPAA;
}

- (void)setQueueItemYear:(NSString *)aString{
	queueItemYear = aString;
}

- (NSString *)queueItemYear{
	return queueItemYear;
}

- (void)setQueueItemImageURL:(NSString *)aString{
	queueItemImageURL = aString;
}

- (NSString *)queueItemImageURL{
	return queueItemImageURL;
}

- (void)setQueueItemDescription:(NSString *)aString
{
	queueItemDescription = aString;	
}

- (NSString *)queueItemDescription
{
	return queueItemDescription;
}

- (void)setSystemId:(NSString *)aString
{
	systemId = aString;
}
- (NSString *)systemId
{
	return systemId;
}

- (void)setIsSet:(BOOL)shouldBeSet
{
	isSet = shouldBeSet;
}

- (BOOL)isSet
{
	return isSet;
}


- (void)deleteFromQueue{
	NSLog(@"Delete item id of: %@", [self queueItemId]);
	deleteRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://www.blockbuster.com/queuemgmt/updateQueue"]
									   cachePolicy:NSURLRequestUseProtocolCachePolicy
								   timeoutInterval:60.0];
	
	//Encode data.
	NSLog(@"my stuff: %@", [self queueItemId]);
	NSString* deleteContent;
	if(isSet){
		deleteContent = [[NSString alloc] initWithFormat:@"deleteSetNumber=%@",[self queueItemId]];		
	}else{
		deleteContent = [[NSString alloc] initWithFormat:@"deleteItemId=%@",[self queueItemId]];		
	}

	//NSLog(@"Delete with string: %@", deleteContent);
	
	[deleteRequest setHTTPMethod:@"POST"];
	[deleteRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
	[deleteRequest setHTTPBody:[deleteContent dataUsingEncoding:NSASCIIStringEncoding]];
	[deleteRequest addValue:[NSString stringWithFormat:@"%d", [deleteContent lengthOfBytesUsingEncoding:NSUTF8StringEncoding]] forHTTPHeaderField:@"Content-Length"];
	[deleteRequest setHTTPShouldHandleCookies:TRUE];
	
	NSURLConnection *deleteConnection=[[NSURLConnection alloc] initWithRequest:deleteRequest delegate:self];
	if (deleteConnection) {
		//deleteData=[[NSMutableData data] retain];
	} else {
		// inform the user that the download could not be made
	}
}

- (void)moveToQueueIndex:(int)aIndex fromIndex:(int)oldIndex{
	//NSLog(@"WTF?");
	NSLog(@"Move item id of: %@ - to index: %d", [self queueItemId], aIndex);
	//Moving around the queue is screwing.  If the movie is moving downward it needs to move two indexes not one.
	if(aIndex > oldIndex){
		aIndex++;
	}
	NSString *moveURL;
	if(isSet){
		moveURL = [[NSString alloc] initWithFormat:@"http://www.blockbuster.com/queuemgmt/fullQueue/moveSet?setId=%@&position=%d",[self queueItemId],aIndex];
	}else{
		moveURL = [[NSString alloc] initWithFormat:@"http://www.blockbuster.com/queuemgmt/fullQueue/moveItem?itemId=%@&position=%d",[self queueItemId],aIndex];
	}
		
	moveRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:moveURL]
											cachePolicy:NSURLRequestUseProtocolCachePolicy
										timeoutInterval:60.0];
	//[moveURL release];
	//NSLog(@"Move with string: %@", moveURL);
	
	[moveRequest setHTTPMethod:@"GET"];
	[moveRequest setHTTPShouldHandleCookies:TRUE];
	
	moveConnection=[[NSURLConnection alloc] initWithRequest:moveRequest delegate:self];
	if (moveConnection) {
		//moveData=[[NSMutableData data] retain];
	} else {
		// inform the user that the download could not be made
	}
}

//---------------------------------------------------------------------
//connection delegates

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response

{
	//NSLog(@"Response URL: %@", [response URL]);
    //[moveData setLength:0];
	
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data

{
    // append the new data to the receivedData	
    // receivedData is declared as a method instance elsewhere
	
    //[moveData appendData:data];
	
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection

{			
	// do something with the data	
    // receivedData is declared as a method instance elsewhere
    //NSLog(@"Succeeded! Received %d bytes of data",[moveData length]);
	//NSString *tmp = [[NSString alloc] initWithData:moveData encoding:NSASCIIStringEncoding];
	//NSLog(@"Data: %@", tmp);

	
	
    [connection release];
    //[moveData release];
	
}


@end
