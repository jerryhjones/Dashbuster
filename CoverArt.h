#import <CoreFoundation/CoreFoundation.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UIKit/UIApplication.h>
#import <UIKit/UIPushButton.h>
#import <UIKit/UITableCell.h>
#import <UIKit/UIImageAndTextTableCell.h>
#import <Foundation/Foundation.h>
#import <UIKit/CDStructures.h>
#import <UIKit/UINavigationItem.h>
#import <UIKit/UIKit.h>
#import "CoverArtDownloader.h"

@class UIImageView;

@interface CoverArt : UIImageView {
	NSMutableData *receivedData;
	NSMutableURLRequest *theRequest;
	NSURLConnection *theConnection;
	NSString *writeToPath;
	NSString *myId;
	NSString *myURL;
	id *myDownloader;
	
}

- (NSString *)myURL;
- (void)setMyData:(NSMutableData *)someData;

@end
