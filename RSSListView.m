//
//  RSSListView.m
//  ibbo
//
//  Created by Jerry Jones on 12/1/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//
#import "ibboApp.h"
#import "RSS.h"
#import "RSSListView.h"


@implementation RSSListView
- (id) initWithFrame: (struct CGRect)frame withApp: (id)_app;
{
    app = _app;
	//NSLog(@"Initialized RSS View: %@", app);
    self = [super initWithFrame: frame];
	
	
	
	CGRect rect = [UIHardware fullScreenApplicationContentRect];
	rect.origin.x = rect.origin.y = 0.0f;
	
	navBar = [[UINavigationBar alloc] init];
	[navBar setFrame:CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, 45.0f)];
	[navBar setBarStyle:1];
	[navBar showButtonsWithLeftTitle:@"Back" rightTitle:nil leftBack:YES];
	[navBar setDelegate:self];
	[navBar enableAnimation];
	UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@"RSS Feeds"];
	[navBar pushNavigationItem:navItem];
	
	prefsTable = [[UIPreferencesTable alloc] initWithFrame:CGRectMake(0.0f, 45.0f, 320.0f, 415.0f)];
	[prefsTable setDataSource:self];
	[prefsTable setDelegate:self];
	[prefsTable reloadData];
	
	
	
    [self addSubview: prefsTable];
	[self addSubview: navBar];
	[prefsTable reloadData];	
	return self;
}



- (void)navigationBar:(UINavigationBar*) navbar buttonClicked:(int)button 
{
	if(button == 1){
		[app showView:@"prefsView" withTransition:2];
	}else if(button == 1){
		//Do something for 2nd button
	}
}

- (BOOL)respondsToSelector:(SEL)aSelector {
	////NSLog(@"respondsToSelector: selector = %@", NSStringFromSelector(aSelector));
	return [super respondsToSelector:aSelector];
}


- (void)reloadData
{
	[prefsTable reloadData];
}

- (void)clearSelection
{
	[prefsTable selectRow:-1 byExtendingSelection:NO withFade:NO];
}


- (RSS *)tmpRSS
{
	return tmpRSS;
}

// Delegate Methods
- (void)tableRowSelected:(NSNotification *)notification
{
	if([prefsTable selectedRow] == 1){
		[app showHUDwithTitle:@"Loading RSS Feed"];
		tmpRSS = [[[RSS alloc] initWithFeed:@"http://www.blockbuster.com/rss/queueAdds"] autorelease];
		//NSLog(@"RSS Object: %@", tmpRSS);
	}else if([prefsTable selectedRow] == 2){
		[app showHUDwithTitle:@"Loading RSS Feed"];
		tmpRSS = [[[RSS alloc] initWithFeed:@"http://www.blockbuster.com/rss/newRelease"] autorelease];
	}else if([prefsTable selectedRow] == 3){
		[app showHUDwithTitle:@"Loading RSS Feed"];
		tmpRSS = [[[RSS alloc] initWithFeed:@"http://www.blockbuster.com/rss/top100"] autorelease];
	}else if([prefsTable selectedRow] == 5){
		[app showHUDwithTitle:@"Loading RSS Feed"];
		tmpRSS = [[[RSS alloc] initWithFeed:@"http://www.blockbuster.com/rss/top25/actionAdventure"] autorelease];
	}else if([prefsTable selectedRow] == 6){
		[app showHUDwithTitle:@"Loading RSS Feed"];
		tmpRSS = [[[RSS alloc] initWithFeed:@"http://www.blockbuster.com/rss/top25/classics"] autorelease];
	}else if([prefsTable selectedRow] == 7){
		[app showHUDwithTitle:@"Loading RSS Feed"];
		tmpRSS = [[[RSS alloc] initWithFeed:@"http://www.blockbuster.com/rss/top25/comedy"] autorelease];
	}else if([prefsTable selectedRow] == 8){
		[app showHUDwithTitle:@"Loading RSS Feed"];
		tmpRSS = [[[RSS alloc] initWithFeed:@"http://www.blockbuster.com/rss/top25/documentary"] autorelease];
	}else if([prefsTable selectedRow] == 9){
		[app showHUDwithTitle:@"Loading RSS Feed"];
		tmpRSS = [[[RSS alloc] initWithFeed:@"http://www.blockbuster.com/rss/top25/drama"] autorelease];
	}else if([prefsTable selectedRow] == 10){
		[app showHUDwithTitle:@"Loading RSS Feed"];
		tmpRSS = [[[RSS alloc] initWithFeed:@"http://www.blockbuster.com/rss/top25/familyKids"] autorelease];
	}else if([prefsTable selectedRow] == 11){
		[app showHUDwithTitle:@"Loading RSS Feed"];
		tmpRSS = [[[RSS alloc] initWithFeed:@"http://www.blockbuster.com/rss/top25/horror"] autorelease];
	}else if([prefsTable selectedRow] == 12){
		[app showHUDwithTitle:@"Loading RSS Feed"];
		tmpRSS = [[[RSS alloc] initWithFeed:@"http://www.blockbuster.com/rss/top25/independent"] autorelease];
	}else if([prefsTable selectedRow] == 13){
		[app showHUDwithTitle:@"Loading RSS Feed"];
		tmpRSS = [[[RSS alloc] initWithFeed:@"http://www.blockbuster.com/rss/top25/mysterySuspence"] autorelease];
	}else if([prefsTable selectedRow] == 14){
		[app showHUDwithTitle:@"Loading RSS Feed"];
		tmpRSS = [[[RSS alloc] initWithFeed:@"http://www.blockbuster.com/rss/top25/television"] autorelease];
	}
}

- (int)numberOfGroupsInPreferencesTable:(UIPreferencesTable *)table
{
    //number of group in table
	return 2;
}

- (int)preferencesTable:(UIPreferencesTable *)table numberOfRowsInGroup:(int)group
{
	switch (group){
		case 0: {
			return 3;
			break;
		}
		case 1: {
			return 10;
			break;
		}
	}
}

- (UIPreferencesTableCell *)preferencesTable:(UIPreferencesTable *)table cellForGroup:(int)group
{
	//Group Titles
	if(group == 0){
		UIPreferencesTableCell *cell = [[UIPreferencesTableCell alloc] init];
		[cell setTitle:@"Popular Feeds"];
		return [cell autorelease];		
	}if(group == 1){
		UIPreferencesTableCell *cell = [[UIPreferencesTableCell alloc] init];
		[cell setTitle:@"BBO Top 25 by Category"];
		return [cell autorelease];
	}else{
		return FALSE;	
	}
}

- (UIPreferencesTableCell*) preferencesTable: (UIPreferencesTable*)table cellForRow: (int)row inGroup: (int)group 
{	
	if(group == 0) {
        switch  (row) {
            case 0: {
				UIPreferencesTableCell *cell = [[UIPreferencesTableCell alloc] init];
				[cell setShowDisclosure: YES];
				[cell setTitle:@"Daily Top 25 Q Adds"];
				[cell setAlignment:2];
				
				return [cell autorelease];
			}
			case 1: {
				UIPreferencesTableCell *cell = [[UIPreferencesTableCell alloc] init];
				[cell setShowDisclosure: YES];
				[cell setTitle:@"New Releases"];
				[cell setAlignment:2];
				
				return [cell autorelease];
			}
			case 2: {
				UIPreferencesTableCell *cell = [[UIPreferencesTableCell alloc] init];
				[cell setShowDisclosure: YES];
				[cell setTitle:@"Blockbuster Online Top 100"];
				[cell setAlignment:2];
				
				return [cell autorelease];
			}
		}
    }
	if(group == 1) {
		switch (row) {
			case 0: {
				UIPreferencesTableCell *cell = [[UIPreferencesTableCell alloc] init];
				[cell setShowDisclosure: YES];
				[cell setTitle:@"Action & Adventure"];
				[cell setAlignment:2];
				
				return [cell autorelease];				
			}
			case 1: {
				UIPreferencesTableCell *cell = [[UIPreferencesTableCell alloc] init];
				[cell setShowDisclosure: YES];
				[cell setTitle:@"Classics"];
				[cell setAlignment:2];
				
				return [cell autorelease];				
			}
			case 2: {
				UIPreferencesTableCell *cell = [[UIPreferencesTableCell alloc] init];
				[cell setShowDisclosure: YES];
				[cell setTitle:@"Comedy"];
				[cell setAlignment:2];
				
				return [cell autorelease];				
			}
			case 3: {
				UIPreferencesTableCell *cell = [[UIPreferencesTableCell alloc] init];
				[cell setShowDisclosure: YES];
				[cell setTitle:@"Documentary"];
				[cell setAlignment:2];
				
				return [cell autorelease];				
			}
			case 4: {
				UIPreferencesTableCell *cell = [[UIPreferencesTableCell alloc] init];
				[cell setShowDisclosure: YES];
				[cell setTitle:@"Drama"];
				[cell setAlignment:2];
				
				return [cell autorelease];				
			}
			case 5: {
				UIPreferencesTableCell *cell = [[UIPreferencesTableCell alloc] init];
				[cell setShowDisclosure: YES];
				[cell setTitle:@"Family & Kids"];
				[cell setAlignment:2];
				
				return [cell autorelease];				
			}
			case 6: {
				UIPreferencesTableCell *cell = [[UIPreferencesTableCell alloc] init];
				[cell setShowDisclosure: YES];
				[cell setTitle:@"Horror"];
				[cell setAlignment:2];
				
				return [cell autorelease];				
			}
			case 7: {
				UIPreferencesTableCell *cell = [[UIPreferencesTableCell alloc] init];
				[cell setShowDisclosure: YES];
				[cell setTitle:@"Independent"];
				[cell setAlignment:2];
				
				return [cell autorelease];				
			}
			case 8: {
				UIPreferencesTableCell *cell = [[UIPreferencesTableCell alloc] init];
				[cell setShowDisclosure: YES];
				[cell setTitle:@"Mystery & Suspense"];
				[cell setAlignment:2];
				
				return [cell autorelease];				
			}
			case 9: {
				UIPreferencesTableCell *cell = [[UIPreferencesTableCell alloc] init];
				[cell setShowDisclosure: YES];
				[cell setTitle:@"Television"];
				[cell setAlignment:2];
				
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
		case 0: return 45.0f;
		case 1: return 45.0f;
		default: return proposed;
	}
}


@end