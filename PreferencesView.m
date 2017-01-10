#import "ibboApp.h"
#import "PreferencesView.h"
#import "Search.h"
#import <WebCore/WebFontCache.h>
#import <UIKit/UINavigationItem.h>

#import <UIKit/UISearchField.h>
#import <WebCore/WebFontCache.h>
#import <GraphicsServices/GraphicsServices.h>

#define font [NSClassFromString(@"WebFontCache") createFontWithFamily:@"Helvetica" traits:0 size:16]

@implementation PreferencesView
- (id) initWithFrame: (struct CGRect)frame withApp: (id)_app;
{
    app = _app;
	//NSLog(@"Initialized Preferences View");
    self = [super initWithFrame: frame];
    
	//setup some colors
	float blueColorComponents[4] = {0.0, 0.0, 0.4, 1.0};
	float bcolorComponents[4] = {0.0, 0.0, 0.0, 1.0};
	float goldComponents[4] = { 0.831, 0.706, .07, 1. };
	CGColorSpaceRef rgbSpace = CGColorSpaceCreateDeviceRGB();
	blueColor = CGColorCreate(rgbSpace, blueColorComponents);
	blackColor = CGColorCreate(rgbSpace, bcolorComponents);
	goldColor = CGColorCreate(rgbSpace, goldComponents);
	CGColorSpaceRelease(rgbSpace);
	
	
	CGRect rect = [UIHardware fullScreenApplicationContentRect];
	rect.origin.x = rect.origin.y = 0.0f;
	
	navBar = [[UINavigationBar alloc] init];
	[navBar setFrame:CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, 45.0f)];
	[navBar setBarStyle:1];
	[navBar showButtonsWithLeftTitle:@"Refresh" rightTitle:@"About" leftBack:NO];
	[navBar setDelegate:self];
	[navBar enableAnimation];
	UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@"DASHBUSTER"];

	//searchBox = [[UISearchField alloc] initWithFrame:CGRectMake(30.0f, ([UINavigationBar defaultSize].height - [UISearchField defaultHeight]) / 2., rect.size.width - 60., [UISearchField defaultHeight])];
	//[searchBox setDisplayEnabled:YES];
	[navBar addSubview:searchBox];
	
	//[searchBox setFont:font];
	//[searchBox setPaddingTop:4];
	//[[searchBox textTraits] setEditingDelegate:self];
	//[[searchBox textTraits] setReturnKeyType:6];
	//[searchBox becomeFirstResponder];
	//[searchBox setTapDelegate: self];
	//UIKeyboard *keyboard = [[UIKeyboard alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - [UIKeyboard defaultSize].height - 48, frame.size.width, [UIKeyboard defaultSize].height)];
	
	
	[navBar pushNavigationItem:navItem];
	
    
//	float black[4] = {0, 0, 0, 1};
	prefsTable = [[UIPreferencesTable alloc] initWithFrame:CGRectMake(0.0f, 45.0f, 320.0f, 415.0f)];
	//[prefsTable setBackgroundColor: CGColorCreate(CGColorSpaceCreateDeviceRGB(), black)];
	[prefsTable setDataSource:self];
	[prefsTable setDelegate:self];
	[prefsTable reloadData];
	
	

    [self addSubview: prefsTable];
	[self addSubview: navBar];
	//[self addSubview: searchBox];
	//[self addSubview:keyboard];
    [prefsTable reloadData];
	
	
	
	
	return self;
}

- (void)view:(UIView *)view handleTapWithCount:(int)count event:(GSEvent *)event {
	//	CGRect rect = GSEventGetLocationInWindow(event);
	//	CGPoint point = rect.origin;
	//YYNSLog(@"view:%@ handleTapWithCount:%i event:(point.x=%f, point.y=%f)",view, count, point.x, point.y);
	NSLog(@"tapped");
	//YYNSLog(@"selected row %i , frame.width= %f", [table selectedRow],[table frame].size.width);
}

-(void)textFieldDidBecomeFirstResponder:(id)cell{
	[prefsTable setKeyboardVisible:YES];	
}


- (void)navigationBar:(UINavigationBar*) navbar buttonClicked:(int)button 
{
	if(button == 1){
		//NSLog(@"refresh queue");
		[app refreshQueue];
		//NSLog(@"88? %d",);
	}else
	{
		[app showView:@"aboutView" withTransition:1];
	}
}

- (void) errorWithTitle: (NSString*)title message: (NSString*) message 
{
    NSArray* buttons = [NSArray arrayWithObjects: @"Try Again",nil];
    UIAlertSheet* sheet = [[UIAlertSheet alloc] 
						   initWithTitle: title
						   buttons: buttons
						   defaultButtonIndex: 1 
						   delegate: self
						   context: @"error_window"];
    [sheet setBodyText: message];
    [sheet popupAlertAnimated:YES];
}

- (Search *)getSearch
{
	return search;
}


- (void)alertSheet:(UIAlertSheet*) sheet buttonClicked:(int)button 
{
    if([[sheet context] isEqualToString: @"search_window"]) {
		if(button==1){
			//Initiate Search
		//	NSLog(@"text field contents: %@",[[sheet textField] text]);
			[app showHUDwithTitle:@"Searching..."];
			search = [[Search alloc] initWithKeyword:[[sheet textField] text]];
		}else if(button==2){
			//Cancel
			[self clearSelection];
		}

		[sheet dismissAnimated:NO];
    }
}

- (BOOL)respondsToSelector:(SEL)aSelector {
	NSLog(@"respondsToSelector: selector = %@", NSStringFromSelector(aSelector));
	return [super respondsToSelector:aSelector];
}

- (void)scrollerDidEndDragging:(UIScroller*)scroller willSmoothScroll:(BOOL)flag
{
	
}

- (void)reloadData
{
	[prefsTable reloadData];
}

- (void)clearSelection
{
	[prefsTable selectRow:-1 byExtendingSelection:NO withFade:NO];
}

- (void)enableQueueButtons
{
	[shippedMoviesCell setEnabled:YES];
	[queuedCell setEnabled:YES];
	[prefsTable reloadData];
}
- (void)disableQueueButtons
{
	[shippedMoviesCell setEnabled:NO];
	[queuedCell setEnabled:NO];	
	[prefsTable reloadData];
}

// Delegate Methods
- (void)tableRowSelected:(NSNotification *)notification
{
	if([prefsTable selectedRow] == 8){
		//NSLog(@"Account details");
		[app showView:@"accountDetailsView" withTransition:1];
	}else if([prefsTable selectedRow] == 1){
		[app showView:@"shippedView" withTransition:1];
	}else if([prefsTable selectedRow] == 2){
		[app showView:@"queueView" withTransition:1];
	}else if([prefsTable selectedRow] == 4){
		NSArray* buttons = [NSArray arrayWithObjects: @"Search", @"Cancel",nil];
		UIAlertSheet* sheet = [[[UIAlertSheet alloc] 
							   initWithTitle: @"SEARCH FOR MOVIES..."
							   buttons: buttons
							   defaultButtonIndex: 1 
							   delegate: self
							   context: @"search_window"] autorelease];
		[sheet setRunsModal:NO];
		[sheet setDimsBackground:NO];
		[sheet setNumberOfRows: 1];
//		[sheet setAlertSheetStyle:1]; 
		[sheet addTextFieldWithValue:@"" label:@"Movies, Actors"];
	//	[sheet presentSheetFromAboveView: self];
		[sheet popupAlertAnimated:NO];
		
	}else if([prefsTable selectedRow] == 6){
		[app showView:@"rssListView" withTransition:1];
	}else if([prefsTable selectedRow] == 5){
	}
}

/*- (void)drawRect:(CGRect)rect
{
	NSLog(@"Drawing! %@", NSStringFromRect(*(NSRect *)&rect));
	
	CGRect testPathRect = {{50,50},{100,100}};
	UIBezierPath *testPath = [UIBezierPath roundedRectBezierPath:testPathRect
											  withRoundedCorners:kUIBezierPathTopLeftCorner|kUIBezierPathBottomRightCorner
													visibleEdges:4
													cornerRadius:10];
	CGContextSetFillColorWithColor(UICurrentContext(), GSColorCreateColorWithDeviceRGBA(1.0, 1.0, 1.0, 1.0));
	[testPath fill];
	[testPath stroke];
}*/


- (int)numberOfGroupsInPreferencesTable:(UIPreferencesTable *)table
{
    return 3;
}

- (int)preferencesTable:(UIPreferencesTable *)table numberOfRowsInGroup:(int)group
{
	switch (group){
		case 2: {
			return 1;
			break;
		}
		case 0: {
			return 2;
			break;
		}
		case 1: {
			return 3;
			break;
		}
	}
}

- (UIPreferencesTableCell *)preferencesTable:(UIPreferencesTable *)table cellForGroup:(int)group
{
    if(group == 2){
		UIPreferencesTableCell *cell = [[UIPreferencesTableCell alloc] init];
		[cell setTitle:@""];
		return [cell autorelease];		
	}if(group == 0){
		UIPreferencesTableCell *cell = [[UIPreferencesTableCell alloc] init];
		[cell setTitle:@"Your Movies..."];
		return [cell autorelease];
	}if(group == 1){
		UIPreferencesTableCell *cell = [[UIPreferencesTableCell alloc] init];
		[cell setTitle:@"Find Movies..."];
		return [cell autorelease];
	}else{
		return FALSE;
	}
}

- (void)myReturn
{
	//NSLog(@"text field did return");
}

- (UIPreferencesTableCell*) preferencesTable: (UIPreferencesTable*)table cellForRow: (int)row inGroup: (int)group 
{	
	if(group == 2) {
        switch  (row) {
            case 0: {
				UIPreferencesTableCell *cell = [[UIPreferencesTableCell alloc] init];
				[cell setShowDisclosure: YES];
				[cell setTitle:@"Preferences"];
				[cell setAlignment:2];
				
				return [cell autorelease];
				
				/*email = [[UIPreferencesTextTableCell alloc] init];
                [email setTitle:@"Sign in Email"];
                [email setValue:[[NSUserDefaults standardUserDefaults] objectForKey: PREFS_USERNAME]];
				[email _textFieldEndEditingOnReturn:YES];
				[email setReturnAction:@selector(myReturn:)];
				[email resignFirstResponder];
				//[email setValue:[account objectForKey:@"email"]];
                return [email autorelease];
                break;
				*/
            }
				
            case 1: {
                password = [[UIPreferencesTextTableCell alloc] init];
                [password setTitle:@"Password"];
                [[password textField] setSecure: YES];
				[password setValue:[[NSUserDefaults standardUserDefaults] objectForKey: PREFS_PASSWORD]];
				[password _textFieldEndEditingOnReturn:YES];
                //[password setValue:[account valueForKey:@"password"]];
                return [password autorelease];
                break;
            }
				
            case 2: {
                rssID = [[UIPreferencesTextTableCell alloc] init];
                [rssID setTitle:@"RSS ID"];
                //[rssID setValue:[account valueForKey:@"rssID"]];
                return [rssID autorelease];
                break;
            }
        }
    }else if(group == 0) {
		switch (row) {
			case 0: {
				
				CGRect rect = [UIHardware fullScreenApplicationContentRect];
				rect.origin.x = rect.origin.y = 0.0f;
				
				shippedMoviesCell = [[UIPreferencesTableCell alloc] init];
				[shippedMoviesCell setShowDisclosure: YES];
			
				//[shippedMoviesCell setTitle:@"View Your Shipped Movies"];
				[shippedMoviesCell setFrame:CGRectMake(rect.origin.x, rect.origin.y, 20.0f, 10.0f) ];
				[shippedMoviesCell setTitle:@"View Your Shipped Movies"];
				//[[shippedMoviesCell titleTextLabel] setWrapsText:YES];
				//[[shippedMoviesCell titleTextLabel] setFont:[NSClassFromString(@"WebFontCache") createFontWithFamily:@"Helvetica" traits:2 size:10.]];
				[shippedMoviesCell setAlignment:2];
				[[shippedMoviesCell titleTextLabel] setColor: blueColor];

				return shippedMoviesCell;

				
			}
			case 1: {
				queuedCell = [[UIPreferencesTableCell alloc] init];
				[queuedCell setShowDisclosure: YES];
				[queuedCell setTitle:@"View Your Queued Movies"];
				[queuedCell setAlignment:2];
				[[queuedCell titleTextLabel] setColor: blueColor];
				return [queuedCell autorelease];
			}
				
		}
	}else if(group == 1){
		switch (row){
			case 0: {
				UIPreferencesTableCell *cell = [[UIPreferencesTableCell alloc] init];
				//[cell setIcon: [UIImage applicationImageNamed: @"Search.png"]];
				[cell setTitle:@"Search..."];
				[cell setAlignment:2];
				[[cell titleTextLabel] setColor: blueColor];
				return [cell autorelease];
			}
			case 1: {
				UIPreferencesTableCell *cell = [[UIPreferencesTableCell alloc] init];
				[cell setShowDisclosure: YES];
				[cell setTitle:@"Friends and Family"];
				[cell setAlignment:2];
				[[cell titleTextLabel] setColor: blueColor];
				return [cell autorelease];
			}
			case 2: {
				UIPreferencesTableCell *cell = [[UIPreferencesTableCell alloc] init];
				[cell setShowDisclosure: YES];
				[cell setTitle:@"RSS Feeds"];
				[cell setAlignment:2];
				[[cell titleTextLabel] setColor: blueColor];
				return [cell autorelease];				
			}
		}
	}
	
}

- (BOOL)table:(UITable*)table canSelectRow:(int)row
{
}

- (float) preferencesTable: (UIPreferencesTable*)table heightForRow: (int)row inGroup: (int)group withProposedHeight: (float)proposed  {
	switch (group) {
		case 2: return proposed;
		case 0: return 45.0f;
		case 1: return 45.0f;
		default: return proposed;
	}
}


@end