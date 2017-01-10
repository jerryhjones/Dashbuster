#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UIKit/UIApplication.h>
#import <UIKit/UIPushButton.h>
#import <UIKit/UITableCell.h>
#import <UIKit/UIImageAndTextTableCell.h>
#import "CoverArt.h"


@interface DetailDownloader : NSObject {
	NSMutableArray		*downloadQueue;
	NSMutableArray		*pendingRequests;
	NSMutableArray		*pendingRequestsMoreData;
	int					openRequests;
}

-(void)addToQueue:(id)cell withURL:(NSString *)aURL forType:(NSString *)aType forFileName:(NSString *)movieId;
-(void)connectionFinished;
-(void)tryDownload;
-(void)emptyQueue;

@end
