#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UIKit/UIApplication.h>
#import <UIKit/UIPushButton.h>
#import <UIKit/UITableCell.h>
#import <UIKit/UIImageAndTextTableCell.h>
#import <UIKit/UIProgressHUD.h>
#import "Queue.h"
#import "PreferencesView.h"
#import "QueueItem.h"
#import "Search.h"
#import "SearchResultsView.h"
#import "AccountDetailsView.h"
//#import "UIView-Color.h"
#import "BlockbusterSession.h"
#import "MovieCell.h"
#import "SearchCell.h"
#import "QueuedView.h"
#import "RSSListView.h"
#import "RSSDetailView.h"
#import "AboutView.h"
#import "ShippedView.h"
#import "CoverArtDownloader.h"
#import "SearchBoxView.h"
//#import "RSSDetailView.h"
#import <math.h>


#define PREFS_HAS_RUN	@"has_run"
#define PREFS_USERNAME	@"username"
#define PREFS_PASSWORD	@"password"


@interface ibboApp : UIApplication {
	CGRect rect;
	
	UIWindow *window;
    UIImageAndTextTableCell *pbCell;
    UITableCell *buttonCell;
	UIView       	*mainView;
	UITable   		*queueTable;
	UIProgressHUD	*progress;
	NSNotificationCenter *nc;
	Search *mySearch;
	NSMutableArray *mySearchResults;
	NSMutableArray *queuedMovieIds;
	Queue *queue;
	Queue *queue2;
	QueueItem *testItem;
	BlockbusterSession *session;
	
	CoverArtDownloader *coverArtDownloader;

	UITextLabel *_movieTitle;

	//Refresh Bools
	BOOL waitingToTransition;
	
	//Check to see if first run
	BOOL isFirstRun;
	BOOL needCreds;
	BOOL sessionCreatedSinceLaunch;
	
	//Views
	UITransitionView      *transitionView;
	UIView                *prefsView;
	ShippedView	*shippedView;
	UIView	*queuedView;
	UIView	*searchResultsView;
	UIView	*accountDetailsView;
	UIView	*rssListView;
	UIView	*rssDetailView;
	UIView	*aboutView;
	//UIView	*rssDetailView;
	UIView *testview1;
	UIView *testview2;
	UIView *testview3;
	UIView *modalView;
	
	UIView *searchBoxView;
	
}

-(void) showView:(NSString *)view withTransition:(int)trans;
-(Queue *)queue;
-(void)setQueue:(Queue *)aQueue;
-(void)showHUDwithTitle:(NSString*)aString;
-(void)hideHUD;
-(void)hideProgressHUD;
-(void)refreshQueue;
-(void)newRSSDetail;

-(void)moviesAdded;
-(void)queueUpdated;

-(UIView *)mainview;



@end
