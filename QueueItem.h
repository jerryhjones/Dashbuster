//
//  QueueItem.h
//  ibbo
//
//  Created by Jerry Jones on 11/26/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UIKit/UIApplication.h>
#import <UIKit/UIPushButton.h>
#import <UIKit/UITableCell.h>
#import <UIKit/UIImageAndTextTableCell.h>


@interface QueueItem : NSObject <NSCoding> {
	
	NSMutableData *deleteData;
	NSMutableData *moveData;
	NSMutableURLRequest *deleteRequest;
	NSMutableURLRequest *moveRequest;
	NSString *queueItemTitle;
	NSString *queueItemId;
	NSString *queueAvailability;
	NSString *queueItemMPAA;
	NSString *queueItemYear;
	NSString *queueItemImageURL;
	NSString *queueItemDescription;
	NSString *systemId;
	BOOL	 *isSet;
	
	NSURLConnection *moveConnection;
}

- (void)deleteFromQueue;
- (void)moveToQueueIndex:(int)aIndex fromIndex:(int)fromIndex;

- (void)setQueueItemTitle:(NSString *)aTitle;
- (NSString *)queueItemTitle;

- (void)setQueueItemId:(NSString *)aId;
- (NSString *)queueItemId;

- (void)setQueueAvailability:(NSString *)aString;
- (NSString *)queueAvailability;

- (void)setMPAA:(NSString *)aString;
- (NSString *)MPAA;

- (void)setQueueItemYear:(NSString *)aString;
- (NSString *)queueItemYear;

- (void)setQueueItemImageURL:(NSString *)aString;
- (NSString *)queueItemImageURL;

- (void)setQueueItemDescription:(NSString *)aString;
- (NSString *)queueItemDescription;

- (void)setSystemId:(NSString *)aString;
- (NSString *)systemId;

- (void)setIsSet:(BOOL)shouldBeSet;
- (BOOL)isSet;



@end
