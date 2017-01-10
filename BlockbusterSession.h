//
//  BlockbusterSession.h
//  NSUrl
//
//  Created by Jerry Jones on 11/25/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UIKit/UIApplication.h>
#import <UIKit/UIPushButton.h>
#import <UIKit/UITableCell.h>
#import <UIKit/UIImageAndTextTableCell.h>

#define PREFS_HAS_RUN	@"has_run"
#define PREFS_USERNAME	@"username"
#define PREFS_PASSWORD	@"password"

@interface BlockbusterSession : NSObject {
	NSString *myString;
	NSMutableData *receivedData;
	NSMutableURLRequest *theRequest;
	NSURLRequest *staticRequest;
}

- (id)initWithUser:(NSString *)userString password:(NSString *)passwordString;
- (void)refreshConnection;
- (void)initiateConnectionWithUser:(NSString *)userString password:(NSString *)passwordString;

@end
