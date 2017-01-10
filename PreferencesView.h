#import <Foundation/Foundation.h>
#import <UIKit/CDStructures.h>
#import <UIKit/UINavigationItem.h>
#import <UIKit/UIKit.h>

#import <UIKit/UITableColumn.h>
#import <UIKit/UIPreferencesTable.h>
#import <UIKit/UIPreferencesTableCell.h>
#import <UIKit/UIPreferencesTextTableCell.h>
#import <UIKit/UIKeyboard.h>
#import "Search.h"

/* 
 * Define Keys for the dictionary for app's preferences 
 */
#define PREFS_USERNAME	@"username"
#define PREFS_PASSWORD	@"password"

@interface PreferencesView : UIView {
	UIPreferencesTable          *prefsTable;
	UIPreferencesTextTableCell  *email;	
	UIPreferencesTextTableCell  *password;
	UIPreferencesTextTableCell  *rssID;
	UIPreferencesTableCell		*loginGroup;
	UIPreferencesTableCell		*shippedMoviesCell;
	UIPreferencesTableCell		*queuedCell;
	UISearchField				*searchBox;
	
    id                          app;
    UINavigationBar             *navBar;
	Search *search;
	UIKeyboard *keyboard;
	
	//Color Spaces
	CGColorRef					*blueColor;
	CGColorRef					*blackColor;
	CGColorRef					*goldColor;
}

- (id) initWithFrame: (struct CGRect)frame withApp: (id)_app;
- (void) errorWithTitle: (NSString*)title message: (NSString*) message;
- (Search *)getSearch;
- (void)clearSelection;
- (void)myReturn;
- (void)enableQueueButtons;
- (void)disableQueueButtons;
@end
