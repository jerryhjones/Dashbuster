#import <Foundation/Foundation.h>
#import <UIKit/CDStructures.h>
#import <UIKit/UINavigationItem.h>
#import <UIKit/UIKit.h>

#import <UIKit/UITableColumn.h>
#import <UIKit/UIPreferencesTable.h>
#import <UIKit/UIPreferencesTableCell.h>
#import <UIKit/UIPreferencesTextTableCell.h>
#import "CoverArtDownloader.h"

@interface SearchResultsView : UIView {
    UIImageAndTextTableCell *pbCell;
	UIPreferencesTable          *prefsTable;
	UIPreferencesTextTableCell  *email;	
	UIPreferencesTextTableCell  *password;
	UIPreferencesTextTableCell  *rssID;
	UIPreferencesTableCell*		loginGroup;
    id                          app;
    UINavigationBar             *navBar;
	UITable   		*table;
	NSMutableArray 	*searchArray;
	
	CoverArtDownloader *coverArtDownloader;
}

- (id) initWithFrame: (struct CGRect)frame withApp: (id)_app;
- (void)setDataSource:(NSMutableArray *)aMutableArray;
- (void)reloadData;
- (void)startDownload;
- (void)clearSelection;
@end
