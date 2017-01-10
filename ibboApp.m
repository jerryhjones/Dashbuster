#import <CoreFoundation/CoreFoundation.h>
#import <Foundation/Foundation.h>
#import <UIKit/CDStructures.h>
#import <UIKit/UIPushButton.h>
#import <UIKit/UIThreePartButton.h>
#import <UIKit/UINavigationBar.h>
#import <UIKit/UIWindow.h>
#import <UIKit/UIView-Hierarchy.h>
#import <UIKit/UIHardware.h>
#import <UIKit/UITable.h>
#import <UIKit/UITableCell.h>
#import <UIKit/UITableColumn.h>
#import <UIKit/UIProgressHUD.h>
#import "ibboApp.h"
#import "BlockbusterSession.h"
#import "Queue.h"
#import "PreferencesView.h"
#import "ShippedView.h"
#import "SearchResultsView.h"
#import "AccountDetailsView.h"
#import "AboutView.h"
#import <math.h>
#include <CoreFoundation/CoreFoundation.h>
#include <IOKit/IOKitLib.h>

@implementation ibboApp
- (id)init
{
	
	[super init];
	
		NSNotificationCenter *nc1;
		nc1 = [NSNotificationCenter defaultCenter];
		[nc1 addObserver:self
			   selector:@selector(handleSessionLoadingFinish:)
				   name:@"BBSDidFinishLoadingSuccess"
				 object:nil];

		[nc1 addObserver:self
			selector:@selector(handleSessionLoadingFailed:)
				name:@"BBSDidFinishLoadingFailure"
			  object:nil];
		
		[nc1 addObserver:self
		   selector:@selector(handleQueueLoadingFinish:)
			   name:@"BBQDidFinishLoading"
			 object:nil];
	
		[nc1 addObserver:self
			selector:@selector(handleSearchFinish:)
				name:@"SearchDidFinishLoading"
			  object:nil];
		
		[nc1 addObserver:self
			selector:@selector(handleAddFinish:)
				name:@"AddDidFinishLoading"
			  object:nil];
	
		[nc1 addObserver:self
			selector:@selector(handleRSSFinish:)
				name:@"RSSDidFinishLoading"
			  object:nil];

	NSFileManager *fileMan = [NSFileManager defaultManager];
	[fileMan createDirectoryAtPath:@"/var/root/Library/Dashbuster" attributes:nil];
	[fileMan release];
	
	
	queuedMovieIds = [[NSMutableArray alloc] init];
	return self;
}

- (void)dealloc
{
	NSNotificationCenter *nc1;
	nc1 = [NSNotificationCenter defaultCenter];
	[nc1 removeObserver:self];
	NSLog(@"Unregistered with notification center.");
	[super dealloc];
}

- (void)handleSessionLoadingFinish:(NSNotification *)note
{
	NSLog(@"Received notification from Session: %@", note);
	[self hideProgressHUD];
	[self showProgressHUD:@"Loading Queue..." withWindow:window withView:mainView withRect:CGRectMake(0.0f, 100.0f, 320.0f, 50.0f)];
	queue = [[Queue alloc] init];
	[queue loadRemoteQueue];
	
}

- (void)handleSessionLoadingFailed:(NSNotification *)note
{
	NSLog(@"Received notification that session failed: %@", note);
	[self hideProgressHUD];
	
	//Login failed....disable the queue buttons so we don't show empty queues.
	// *disable queues
	// *better check for cause of error
	
	NSArray *buttons = [NSArray arrayWithObjects:@"Dismiss", @"Check Login Info",nil];
	UIAlertSheet *alertSheet = [[UIAlertSheet alloc] initWithTitle:@"Login Error" 
														   buttons:buttons 
												defaultButtonIndex:1 
														  delegate:self 
														   context:@"login_error"];
	[alertSheet setBodyText:@"There was a problem logging you into your account!\n\nMaybe your login information wasn't correct, maybe Blockbusters site is down (it's been known to happen)."];
	[alertSheet popupAlertAnimated:YES];
}


- (void)handleQueueLoadingFinish:(NSNotification *)note
{
	NSLog(@"Received notification from Queue: %@", note);
	NSMutableArray *tmpArray = [queue getQueuedTitleArray];
	NSMutableArray *tmpShippedArray = [queue getShippedTitleArray];

	[shippedView setDataSource:tmpShippedArray];
	[shippedView reloadData];
	[queuedView setDataArray:tmpArray];
	[queuedView reloadData];
	
	
	
	[prefsView enableQueueButtons];
	[self hideProgressHUD];
	[queue setLastRefresh];
	if(waitingToTransition){
		waitingToTransition = NO;
		[queuedView setDataSource];
	}
}

- (void)handleSearchFinish:(NSNotification *)note
{
	mySearch = [prefsView getSearch];
	mySearchResults = [mySearch getSearchTitleArray];
	[searchResultsView setDataSource:mySearchResults];
	[searchResultsView reloadData];
	//NSLog(@"SEARCH FINSHED");
	[self hideProgressHUD];
	[transitionView transition:3 fromView:shippedView toView:searchResultsView];
}

- (void)handleAddFinish:(NSNotification *)note
{
	
	//NSMutableArray *tmpArray = [queue getQueuedTitleArray];
	//NSMutableArray *tmpShippedArray = [queue getShippedTitleArray];
	//[shippedView setDataSource:tmpShippedArray];
	//[queuedView setDataSource];
	//[shippedView reloadData];
	//[queuedView reloadData];
	//[self hideProgressHUD];
	[progress done];
	[rssDetailView drawRect:CGRectMake(0.0f, 0.0f, 320.0f, 50.0f)];
	NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval: 0.5
											 target: self
										   selector: @selector(handleFinishedHUDTimer:)
										   userInfo: nil
											repeats: NO];
	[rssDetailView clearSelection];
	[searchResultsView clearSelection];
	//[transitionView transition:7 toView:prefsView];
	
}

- (void)handleRSSFinish:(NSNotification *)note
{
	NSMutableArray *tmp = [[rssListView tmpRSS] getRSSTitleArray];
	//NSLog(@"RSS ARRAY: %@ - COUNT: %d", tmp, [tmp count]);
	//[[rssListView tmpRSS] dealloc];
	//rssDetailView = [[RSSDetailView alloc] initWithFrame: rect withApp: self];
	[rssDetailView setDataSource:tmp];
	[rssDetailView reloadData];

	[transitionView transition:1 toView:rssDetailView];
	
}

- (void)handleFinishedHUDTimer:(NSTimer *)timer{
	[self hideHUD];
}

- (Queue *)queue
{
	return queue;
}

-(void)setQueue:(Queue *)aQueue
{
	
	queue2 = aQueue;
}


-(void)showHUDwithTitle:(NSString*)aString
{
	
	[self showProgressHUD:aString withWindow:window withView:mainView withRect:CGRectMake(0.0f, 100.0f, 320.0f, 50.0f)];
}

-(void)hideHUD
{
	
	[self hideProgressHUD];
	//NSLog(@"APP SHOULD HIDE HUD");
}



-(void)doCredPrefsExist;
{
	if([[NSUserDefaults standardUserDefaults] objectForKey: PREFS_USERNAME] == nil
	   || [[NSUserDefaults standardUserDefaults] objectForKey: PREFS_PASSWORD] == nil
	   || [[[NSUserDefaults standardUserDefaults] objectForKey: PREFS_USERNAME] isEqualToString:@""]
	   || [[[NSUserDefaults standardUserDefaults] objectForKey: PREFS_PASSWORD] isEqualToString:@""])
	{
		needCreds = YES;
	}
}

- (void) applicationDidFinishLaunching: (id) unused
{
	//check for creds
	[self doCredPrefsExist];
	//check for first launch
	
	if([[NSUserDefaults standardUserDefaults] objectForKey: PREFS_HAS_RUN] == nil){
		[[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey: PREFS_HAS_RUN];
		isFirstRun = YES;
		NSArray *buttons = [NSArray arrayWithObjects:@"OK", nil];
		UIAlertSheet *alertSheet = [[UIAlertSheet alloc] initWithTitle:@"First Time?" 
															   buttons:buttons 
													defaultButtonIndex:1 
															  delegate:self 
															   context:@"need_creds"];
		[alertSheet setBodyText:@"It seems to be your first time using Dashbuster.  You need to fill in your blockbuster user information to continue."];
		[alertSheet popupAlertAnimated:YES];
		
	}else if(needCreds)
	{
		NSArray *buttons = [NSArray arrayWithObjects:@"OK", nil];
		UIAlertSheet *alertSheet = [[UIAlertSheet alloc] initWithTitle:@"Need User Info" 
															   buttons:buttons 
													defaultButtonIndex:1 
															  delegate:self 
															   context:@"need_creds"];
		[alertSheet setBodyText:@"Ya know, it's kinda tough to get to your Blockbuster account without your user info.\n\nGo ahead, put it in....it's ok."];
		[alertSheet popupAlertAnimated:YES];
	}

	
	rect = [UIHardware fullScreenApplicationContentRect];
    rect.origin.x = rect.origin.y = 0.0f;
	
  	window = [[UIWindow alloc] initWithContentRect: rect];
	
	transitionView = [[UITransitionView alloc] initWithFrame:CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height)];
	[transitionView setDelegate:self]; 
	mainView = [[UIView alloc] initWithFrame: rect];
	

	[mainView addSubview:transitionView];	

	
	[window setContentView: mainView];
	[window orderFront: self];
	[window makeKey: self];
	[window _setHidden: NO];
	[window setNeedsDisplay];
	
	
	nc = [NSNotificationCenter defaultCenter];
	[nc addObserver:self
		   selector:@selector(tellMeAboutNotification:)
			   name:nil
			 object:queueTable];
	

	prefsView = [[PreferencesView alloc] initWithFrame: CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height) withApp: self];
	float gray[4] = {.2, .2, .2, .7};
	modalView = [[UIView alloc] initWithFrame: rect];
	[modalView setBackgroundColor: CGColorCreate(CGColorSpaceCreateDeviceRGB(), gray)];			
	queuedView = [[QueuedView alloc] initWithFrame: CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height) withApp: self];
	shippedView = [[ShippedView alloc] initWithFrame: rect withApp: self];
	searchResultsView = [[SearchResultsView alloc] initWithFrame: rect withApp: self];
	accountDetailsView = [[AccountDetailsView alloc] initWithFrame: rect withApp: self];
	rssListView = [[RSSListView alloc] initWithFrame: rect withApp: self];
	rssDetailView = [[RSSDetailView alloc] initWithFrame: rect withApp: self];
	aboutView = [[AboutView alloc] initWithFrame: rect withApp: self];
	
	searchBoxView = [[SearchBoxView alloc] initWithFrame:rect withApp:self];
//	[mainView addSubview:searchBoxView];
	
	//rssDetailView = [[RSSDetailView alloc] initWithFrame: rect withApp: self];
	[transitionView transition:1 toView:prefsView];
	
	
	
	
	// If this is first run, don't try logging in.
	if(!isFirstRun && !needCreds){
		[self showProgressHUD:@"Logging In..." withWindow:window withView:mainView withRect:CGRectMake(0.0f, 100.0f, 320.0f, 50.0f)];
		session = [[BlockbusterSession alloc] initWithUser:[[NSUserDefaults standardUserDefaults] objectForKey: PREFS_USERNAME]
																	  password:[[NSUserDefaults standardUserDefaults] objectForKey: PREFS_PASSWORD]];
		
		

		sessionCreatedSinceLaunch = YES;
//		NSHost *testHost = [NSHost currentHost];
		//NSLog(@"Session Object: %@", session);
//		NSLog(@"NSHOST: %@", [testHost names]);
	}
}


/*- (void)drawRect:(CGRect)rect
{
	NSLog(@"asdf");
    UIBezierPath *path;
    UIBezierPath *bgpath;
    CGRect bounds;
    float sliceWidth;
    CGRect colorRect;
    const float backgroundComponents[4] = {0, 0, 0, 0.3};
    const float progressColor[4] = {0,1,0,0.5};
    colorRect = rect;
    
    bgpath = [UIBezierPath bezierPath];
    [bgpath appendBezierPathWithRect:rect];
    CGContextSetFillColor(UICurrentContext(), backgroundComponents);
    [bgpath fill];
    sliceWidth = rect.size.width/ 100;
    colorRect.size.width = sliceWidth * 5 * 100;
    path = [UIBezierPath bezierPath];
    [path appendBezierPathWithRect:colorRect];
    CGContextSetFillColor(UICurrentContext(), progressColor);
    [path fill];
}*/


- (void)refreshQueue
{
	//NSLog(@"Refreshing Queue");
	needCreds = NO;
	[self doCredPrefsExist];
	if(needCreds)
	{
		//NSLog(@"Refreshing Queue - need creds");
		NSArray *buttons = [NSArray arrayWithObjects:@"OK", nil];
		UIAlertSheet *alertSheet = [[UIAlertSheet alloc] initWithTitle:@"Need User Info" 
															   buttons:buttons 
													defaultButtonIndex:1 
															  delegate:self 
															   context:@"need_creds"];
		[alertSheet setBodyText:@"Ya know, it's kinda tough to get to your Blockbuster account without your user info.\n\nGo ahead, put it in....it's ok."];
		[alertSheet popupAlertAnimated:YES];
	}else{
		//[session refreshConnection];
		//[self showProgressHUD:@"Loading Queue..." withWindow:window withView:mainView withRect:CGRectMake(0.0f, 100.0f, 320.0f, 50.0f)];
		if(sessionCreatedSinceLaunch){
			[session refreshConnection];			
		}else{
			session = [[BlockbusterSession alloc] initWithUser:[[NSUserDefaults standardUserDefaults] objectForKey: PREFS_USERNAME]
													  password:[[NSUserDefaults standardUserDefaults] objectForKey: PREFS_PASSWORD]];
			sessionCreatedSinceLaunch = YES;
		}

	}
	
}

-(void)newRSSDetail{
	[rssDetailView dealloc];
//	rssDetailView = [[RSSDetailView alloc] initWithFrame: rect withApp: self];
}

-(void)applicationSuspend:(struct __GSEvent *)event{
	//NSLog(@"applicationSuspend");
	[self terminate];
}

-(UIView *)mainview
{
	return mainView;
}

// --------------------------------
// UITransitionView Delegate Tests
// Don't leave these here
// --------------------------------
- (void)transitionViewDidStart:(UITransitionView*)view
{
	//NSLog(@"Transition started");
}

- (void)transitionViewDidComplete:(UITransitionView*)view fromView:(UIView*)from toView:(UIView*)to
{
	[prefsView clearSelection];
	if(to == accountDetailsView){
		sleep(.5);
		[accountDetailsView updateBoxArtSize];
	}
	if(to == rssDetailView){
		[rssListView clearSelection];
		sleep(.5);
		[self hideProgressHUD];
		//[rssDetailView startDownload];
		
	}
}

//-------------------------------------------------


// Change views via the transition view.
- (void) showView:(NSString *)view withTransition:(int)trans{
	if([view isEqualToString:@"queueView"]){
		
		[transitionView transition:trans toView:queuedView];
		if([[self queue] shouldUpdate]){
			[self refreshQueue];
			waitingToTransition = YES;
		}else{
			[queuedView setDataSource];			
		}

	}else if([view isEqualToString:@"shippedView"]){
		NSLog(@"array2: %p", 	[[[self queue] getShippedTitleArray] objectAtIndex:1]);
		[transitionView transition:trans toView:shippedView];	
	}else if([view isEqualToString:@"accountDetailsView"]){
		[transitionView transition:trans toView:accountDetailsView];
	}else if([view isEqualToString:@"prefsView"]){
		[transitionView transition:trans toView:prefsView];
	}else if([view isEqualToString:@"rssListView"]){
		[transitionView transition:trans toView:rssListView];
	}else if([view isEqualToString:@"rssDetailView"]){
		[transitionView transition:trans toView:rssDetailView];
	}else if([view isEqualToString:@"aboutView"]){
		[transitionView transition:trans toView:aboutView];
	}else{
		[transitionView transition:1 toView:rssListView];
		
	}
	
}

/*- (void)drawRect:(CGRect)rect2;
{
    //CGContextSetFillColorWithColor(UICurrentContext(), [UIView colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0]);
    [[UIBezierPath roundedRectBezierPath:rect2 withRoundedCorners:kUIBezierPathAllCorners withCornerRadius:10.0] fill];
}*/


- (void)showProgressHUD:(NSString *)label withWindow:(UIWindow *)w withView:(UIView *)v withRect:(struct CGRect)rect
{
	[mainView addSubview:modalView];
	progress = [[UIProgressHUD alloc] initWithWindow: w];
	[progress setText: label];
	[progress drawRect: rect];
	[progress show: YES];
	
	[v addSubview:progress];
}

- (void)hideProgressHUD
{
	[modalView removeFromSuperview];
	[progress show: NO];
	[progress removeFromSuperview];
}


//---------------------------------------------------------------------
// Notification Tests
//---------------------------------------------------------------------

- (void)tellMeAboutNotification:(NSNotification *)note
{
	//NSLog(@"notification sent, Name: %@ / Dict: %@", [note name], [note object]);
}

-(void)tableRowSelected:(NSNotification*)note{
	int actRowId = [[note object] selectedRow];
	//NSLog(@"Table Row Selected - Object: %d", actRowId);
}


//---------------------------------------------------------------------

//alert sheet methods
- (void)alertSheet:(UIAlertSheet*)sheet buttonClicked:(int)button
{
	
	if([[sheet context] isEqualToString:@"need_creds"]){
		[transitionView transition:1 toView:accountDetailsView];
	}else if([[sheet context] isEqualToString:@"login_error"]){
		if(button == 2){
			[transitionView transition:1 toView:accountDetailsView];	
		}
	}else{
		if ( button == 1 )
			NSLog(@"Yes");
		else if ( button == 2 )
			NSLog(@"No");
	}
	[sheet dismiss];
}



@end

@implementation UIView (Color)

- (CGColorRef)colorWithRed:(float)red green:(float)green blue:(float)blue alpha:(float)alpha;
{
    float rgba[4] = {red, green, blue, alpha};
    CGColorSpaceRef rgbColorSpace = (CGColorSpaceRef)[(id)CGColorSpaceCreateDeviceRGB() autorelease];
    CGColorRef color = (CGColorRef)[(id)CGColorCreate(rgbColorSpace, rgba) autorelease];
    return color;
}

@end


@implementation UITable (SELECTION_CLEAR)

- (void)clearSelectionHighlite
{
	_selectedRow = -1;
	[self _sendSelectionDidChange];
}


@end

@implementation NSString (MY_RFC2396Support) 

- (NSString *)stringByAddingPercentEscapes 
/*" Returns an autoreleased NSString composed of the characters in the 
 receiver modified (escaped) as necessary to conform with RFC 2396 for 
 use in URLs "*/ 
{ 
	return [(NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, 
																(CFStringRef)self, NULL, NULL, 
																CFStringConvertNSStringEncodingToEncoding(NSASCIIStringEncoding)) 
			autorelease]; 
} 

- (NSString *)stringByReplacingPercentEscapes 
/*" Returns an autoreleased NSString composed of the characters in the receiver 
 represented directly as Unicode characters rather than RFC 2396 escaped 
 characters. "*/ 
{ 
	return [(NSString *)CFURLCreateStringByReplacingPercentEscapes( 
																   kCFAllocatorDefault,(CFStringRef)self, CFSTR("")) autorelease]; 
} 

-(NSString *)urlEncode
{
    NSArray *escapeChars = [NSArray arrayWithObjects:@";" , @"/" , @"?" , @":" ,
							@"@" , @"&" , @"=" , @"+" ,
							@"$" , @"," , @"[" , @"]",
							@"#", @"!", @"'", @"(", 
							@")", @"*", nil];
	
    NSArray *replaceChars = [NSArray arrayWithObjects:@"%3B" , @"%2F" , @"%3F" ,
							 @"%3A" , @"%40" , @"%26" ,
							 @"%3D" , @"%2B" , @"%24" ,
							 @"%2C" , @"%5B" , @"%5D", 
							 @"%23", @"%21", @"%27",
							 @"%28", @"%29", @"%2A", nil];
	
    int len = [escapeChars count];
	
    NSMutableString *temp = [self mutableCopy];
	
    int i;
    for(i = 0; i < len; i++)
    {
		
        [temp replaceOccurrencesOfString: [escapeChars objectAtIndex:i]
							  withString:[replaceChars objectAtIndex:i]
								 options:NSLiteralSearch
								   range:NSMakeRange(0, [temp length])];
    }
	
    NSString *out = [NSString stringWithString: temp];
	
    return out;
}

@end 