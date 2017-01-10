//
//  RSSView.m
//  ibbo
//
//  Created by Jerry Jones on 12/1/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//
#import "ibboApp.h"
#import "RSSView.h"


@implementation RSSView
- (id) initWithFrame: (struct CGRect)frame withApp: (id)_app;
{
    app = _app;
	
	NSLog(@"Initialized RSS View: %@", app);
    self = [super initWithFrame: frame];
	
	CGRect rect = [UIHardware fullScreenApplicationContentRect];
	rect.origin.x = rect.origin.y = 0.0f;
	
	navBar = [[UINavigationBar alloc] init];
	[navBar setFrame:CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, 45.0f)];
	[navBar setBarStyle:1];
	[navBar showButtonsWithLeftTitle:@"Back" rightTitle:nil leftBack:YES];
	[navBar setDelegate:self];
	[navBar enableAnimation];
	UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@"RSS FEEDS"];
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
		NSLog(@"WTF BUTTON");
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

// Delegate Methods
- (void)tableRowSelected:(NSNotification *)notification
{
	if([prefsTable selectedRow] == 1){
		//Do something when row is selected
	}else if([prefsTable selectedRow] == 3){
		//[app showView:@"shippedView" withTransition:1];
	}
}

- (int)numberOfGroupsInPreferencesTable:(UIPreferencesTable *)table
{
    //number of group in table
	return 1;
}

- (int)preferencesTable:(UIPreferencesTable *)table numberOfRowsInGroup:(int)group
{
	switch (group){
		case 0: {
			return 1;
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
	//Group Titles
	if(group == 0){
		UIPreferencesTableCell *cell = [[UIPreferencesTableCell alloc] init];
		[cell setTitle:@"RSS Feeds..."];
		return [cell autorelease];		
	}if(group == 1){
		UIPreferencesTableCell *cell = [[UIPreferencesTableCell alloc] init];
		[cell setTitle:@"Your Movies..."];
		return [cell autorelease];
	}else{
		return FALSE;
	}
}

- (UIPreferencesTableCell*) preferencesTable: (UIPreferencesTable*)table cellForRow: (int)row inGroup: (int)group 
{	
	NSLog(@"Initialized Cell View");
	if(group == 0) {
        switch  (row) {
            case 0: {
				UIPreferencesTableCell *cell = [[UIPreferencesTableCell alloc] init];
				[cell setShowDisclosure: NO];
				[cell setTitle:@"Coming Soon"];
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
		default: return proposed;
	}
}


@end