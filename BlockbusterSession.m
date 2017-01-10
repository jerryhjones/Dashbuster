//
//  BlockbusterSession.m
//  NSUrl
//
//  Created by Jerry Jones on 11/25/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "BlockbusterSession.h"


@implementation BlockbusterSession

- (id)initWithUser:(NSString *)userString password:(NSString *)passwordString
{
	[super init];
	[self initiateConnectionWithUser:userString password:passwordString];
	return self;
}

- (void)initiateConnectionWithUser:(NSString *)userString password:(NSString *)passwordString
{
	theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.blockbuster.com/auth/processLogin"]
									   cachePolicy:NSURLRequestUseProtocolCachePolicy
								   timeoutInterval:60.0];
	
	//Encode data.
	NSString* content = [[NSString alloc] initWithFormat:@"loginEmail=%@&loginPassword=%@",userString,passwordString];
	
	[theRequest setHTTPMethod:@"POST"];
	[theRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
	[theRequest setHTTPBody:[content dataUsingEncoding:NSASCIIStringEncoding]];
	[theRequest addValue:[NSString stringWithFormat:@"%d", [content lengthOfBytesUsingEncoding:NSUTF8StringEncoding]] forHTTPHeaderField:@"Content-Length"];
	[theRequest setHTTPShouldHandleCookies:TRUE];
	
	NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	if (theConnection) {
		receivedData=[[NSMutableData data] retain];
	} else {
		// inform the user that the download could not be made
	}
	
}

- (void)refreshConnection
{
	[self initiateConnectionWithUser:[[NSUserDefaults standardUserDefaults] objectForKey: PREFS_USERNAME]
							password:[[NSUserDefaults standardUserDefaults] objectForKey: PREFS_PASSWORD]];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response

{
	//NSLog(@"Session Response: %@",[response URL]);
    [receivedData setLength:0];
	
}

-(NSURLRequest *)connection:(NSURLConnection *)connection
            willSendRequest:(NSURLRequest *)request
		   redirectResponse:(NSURLResponse *)redirectResponse
{
    NSURLRequest *newRequest=request;	
    if (redirectResponse) {
        newRequest=nil;
    }
    return newRequest;
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
	//NSLog(@"Data: %@", [[NSString alloc] initWithData:receivedData encoding:NSASCIIStringEncoding]);

	
	NSNotificationCenter *nc;
	nc = [NSNotificationCenter defaultCenter];
	//NSLog(@"Sending notification of connectionDidFinishLoading");
	if([receivedData length] == 103){
		[nc postNotificationName:@"BBSDidFinishLoadingSuccess" object:self];		
	}else{
		[nc postNotificationName:@"BBSDidFinishLoadingFailure" object:self];		
	}

	
	
    // release the connection, and the data object
    [connection release];
    //[receivedData release];
	
}



@end
