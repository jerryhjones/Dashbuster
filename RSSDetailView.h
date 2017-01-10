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

@interface RSSDetailView : UIView {
    id                          app;
	
    UINavigationBar             *navBar;
	UITable   		*queueTable;
    UIImageAndTextTableCell *pbCell;
	NSMutableArray 	*dataArray;
	
	
	
	//Check to see if in delete mode for nav
	BOOL queueEditMode;
	BOOL changeHeight;
	BOOL scrollerIsMoving;
	BOOL waitingToClearCells;
	
	CoverArtDownloader *coverArtDownloader;

	
}

- (id) initWithFrame: (struct CGRect)frame withApp: (id)_app;
- (void)setDataSource:(NSMutableArray *)aMutableArray;
- (void)reloadData;
- (void)clearSelection;
- (void)startDownload;
- (void)clearDataArray;

@end
