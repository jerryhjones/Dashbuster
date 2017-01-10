#import <Foundation/Foundation.h>
#import <UIKit/CDStructures.h>
#import <UIKit/UINavigationItem.h>
#import <UIKit/UIKit.h>


#import <UIKit/UITableColumn.h>
#import <UIKit/UIPreferencesTable.h>
#import <UIKit/UIPreferencesTableCell.h>
#import <UIKit/UIPreferencesTextTableCell.h>
#import "CustomTable.h"
#import <math.h>
#import "DetailDownloader.h"

@class UISectionTable;
@class UISectionList;

@interface QueuedView : UIView {
    id                          app;

    UINavigationBar             *navBar;
	UISectionTable	*queueTable;
	UISectionList	*sectionList;
    UIImageAndTextTableCell *pbCell;
	NSMutableArray 	*dataArray;
	NSMutableArray *queueArray;
	UITableCell *cell;
	UITableCell *animateCell;

	//Check to see if in delete mode for nav
	BOOL queueEditMode;
	BOOL changeHeight;
	
	DetailDownloader *coverArtDownloader;
	
}

- (id) initWithFrame: (struct CGRect)frame withApp: (id)_app;
- (void)setDataSource;
- (void)setDataArray:(NSMutableArray *)aMutableArray;
- (void)reloadData;

@end
