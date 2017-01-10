#import <Foundation/Foundation.h>
#import <UIKit/CDStructures.h>
#import <UIKit/UINavigationItem.h>
#import <UIKit/UIKit.h>

#import <UIKit/UITableColumn.h>
#import <UIKit/UIPreferencesTable.h>
#import <UIKit/UIPreferencesTableCell.h>
#import <UIKit/UIPreferencesTextTableCell.h>
#import <UIKit/UIPreferencesDeleteTableCell.h>
#import <WebCore/WebFontCache.h>

#define PREFS_USERNAME	@"username"
#define PREFS_PASSWORD	@"password"

@interface AccountDetailsView : UIView {
	UIPreferencesTable          *accountDetailTable;
	UIPreferencesTextTableCell  *email;	
	UIPreferencesTextTableCell  *password;
	UIPreferencesTableCell  *diskUse;
	UIKeyboard					*kb;
    id                          app;
    UINavigationBar             *navBar;
}

- (id) initWithFrame: (struct CGRect)frame withApp: (id)_app;
- (NSString *)boxArtSize;
- (void)updateBoxArtSize;
- (NSString *)stringFromFileSize:(int)theSize;
@end