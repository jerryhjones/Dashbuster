#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UIKit/UIApplication.h>
#import <UIKit/UIPushButton.h>
#import <UIKit/UITableCell.h>
#import <UIKit/UIImageAndTextTableCell.h>
#import "QueueItem.h"


@interface RSS : NSObject {
	NSMutableData *rssData;
	NSMutableURLRequest *rssRequest;

	NSMutableArray *rssTitleArray;
	
	//Parsing Flags
	BOOL isParsingItem;
    BOOL isParsingTitle;
	BOOL isParsingMovieClassDiv;
	BOOL isParsingLink;
	BOOL isParsingDescription;
	NSMutableString *currentParsingMovieTitleId;
	
	//tmp String
	NSMutableString	*tmpString;
	QueueItem	*tmpItem;
}

- (NSMutableArray *)getRSSTitleArray;
- (id)initWithFeed: (NSString *)aString;
- (NSString *)titles;
- (void)dealloc;
@end
