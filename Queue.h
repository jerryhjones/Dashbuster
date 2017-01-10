//
//  Queue.h
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
#import "QueueItem.h"


@interface Queue : NSObject{
	NSString *myString;
	NSMutableData *receivedData;
	NSMutableURLRequest *theRequest;
	NSURLRequest *staticRequest;

	NSMutableArray *shippedTitleArray;
	NSMutableArray *queuedTitleArray;
	NSMutableArray *titleArray;
	NSMutableArray *queueSystemIdArray;

	NSMutableData *addData;
	NSMutableURLRequest *addRequest;
	NSURLConnection *addConnection;
	BOOL fromAddRequest;
	
	//Timestamps
	NSDate *lastAdd;
	NSDate *lastRefresh;
	
	// Parsing flags
    BOOL isParsingTitle;
	BOOL isParsingShippedUL;
	BOOL isParsingQueuedUL;
	BOOL isParsingSavedUL;
	BOOL isParsingMPAA;
	BOOL isParsingAvailability;
	BOOL isParsingYear;
	BOOL isParsingQueueItem;
	BOOL isParsingSetItem;
	BOOL isParsingWholeSet;
	BOOL isParsingSavedItem;
	int divTreeLevel;
	
	int savedStartsAt;
	int lastId;
	int lastShippedId;
	
	//tmp String
	NSMutableString	*tmpString;
	NSString	*eTest;
}

- (void) loadRemoteQueue;
- (void) saveDataToDisk;
- (void) loadDataFromDisk;

-(void)setLastRefresh;
-(BOOL)shouldUpdate;

- (NSMutableArray *)getMovieTitleArray;
- (NSMutableArray *)getShippedTitleArray;
- (NSMutableArray *)getQueuedTitleArray;
- (void)setShippedTitleArray:(NSMutableArray *)aArray;
- (void)setQueuedTitleArray:(NSMutableArray *)aArray;

- (BOOL)checkForId:(NSString *)aId;
- (void)addToQueueWithItemId:(NSString *)aString;
- (void)deleteItemAtIndex:(int)queueLocation;
-(int)savedStartsAtIndex;
-(void)savedStartsLessOne;
-(void)rebuildSystemIdArray;



@end
