#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UIKit/UIApplication.h>
#import <UIKit/UIPushButton.h>
#import <UIKit/UITableCell.h>
#import <UIKit/UIImageAndTextTableCell.h>


@interface CoverArtDownloader : NSObject {
	NSMutableArray		*downloadQueue;
	NSMutableArray		*pendingRequests;
	NSMutableArray		*pendingRequestsMoreData;
	int					openRequests;
}

-(void)addToQueue:(id *)coverArtObject withURL:(NSString *)aURL forFileName:(NSString *)movieId;
-(void)connectionFinished;
-(void)tryDownload;
-(void)emptyQueue;

@end
