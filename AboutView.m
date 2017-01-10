//
//  AboutView.m
//  ibbo
//
//  Created by Jerry Jones on 12/3/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//
#import "AboutView.h"
#import "AboutPrefsCell.h"
#import <UIKit/UIPreferencesTableCell.h>
#import <UIKit/UIPreferencesDeleteTableCell.h>
#import <WebCore/WebFontCache.h>


@implementation AboutView
- (id) initWithFrame: (struct CGRect)frame withApp: (id)_app;
{
    app = _app;
    self = [super initWithFrame: frame];
	
	CGRect rect = [UIHardware fullScreenApplicationContentRect];
	rect.origin.x = rect.origin.y = 0.0f;
	
	navBar = [[UINavigationBar alloc] init];
	[navBar setFrame:CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, 45.0f)];
	[navBar setBarStyle:1];
	[navBar showButtonsWithLeftTitle:@"Back" rightTitle:nil leftBack:YES];
	[navBar setDelegate:self];
	[navBar enableAnimation];
	UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@"ABOUT"];
	[navBar pushNavigationItem:navItem];
	
	prefsTable = [[UIPreferencesTable alloc] initWithFrame:CGRectMake(0.0f, 45.0f, 320.0f, 415.0f)];
	[prefsTable setDataSource:self];
	[prefsTable setDelegate:self];
	[prefsTable reloadData];
	
	
	
    [self addSubview: prefsTable];
	[self addSubview: navBar];
	
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

// Delegate Methods
- (void)tableRowSelected:(NSNotification *)notification
{
	if([prefsTable selectedRow] == 1){
		//Do something when row is selected
	}else if([prefsTable selectedRow] == 3){
		[app openURL:[NSURL URLWithString:@"mailto:dashbuster@gmail.com?subject=Dashbuster(comment)"]];
	}else if([prefsTable selectedRow] == 4){
		[app openURL:[NSURL URLWithString:@"http://iphone.dashbuster.com"]];
	}else if([prefsTable selectedRow] == 5){
		[app openURL:[NSURL URLWithString:@"https://www.paypal.com/cgi-bin/webscr?cmd=_xclick&business=jerry%40jetskier79%2ecom&item_name=iPhone%20Dashbuster%20Donation&no_shipping=1&no_note=1&tax=0&currency_code=USD&lc=US&bn=PP%2dDonationsBF&charset=UTF%2d8"]];
	}
}

- (int)numberOfGroupsInPreferencesTable:(UIPreferencesTable *)table
{
    //number of group in table
	return 3;
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
		case 2: {
			return 0;
			break;
		}
	}
}

- (UIPreferencesTableCell *)preferencesTable:(UIPreferencesTable *)table cellForGroup:(int)group
{
	//Group Titles
	if(group == 0){
		UIPreferencesTableCell *cell = [[UIPreferencesTableCell alloc] init];
		[cell setTitle:@"Not ALL the cool kids use Netflix."];
		[cell setAlignment:2];
		[[cell titleTextLabel] setFont:[NSClassFromString(@"WebFontCache") createFontWithFamily:@"Helvetica" traits:2 size:18.]];
		[[cell titleTextLabel] setWrapsText:YES];
		return [cell autorelease];		
	}else if(group == 2){
		UIPreferencesTableCell *cell = [[UIPreferencesTableCell alloc] init];
		[cell setTitle:@"Version 0.5.2"];
		[cell setAlignment:2];
		[[cell titleTextLabel] setFont:[NSClassFromString(@"WebFontCache") createFontWithFamily:@"Helvetica" traits:1 size:15.]];
		[[cell titleTextLabel] setWrapsText:YES];
		return [cell autorelease];		
	}
	else{
		return FALSE;
	}
}

- (UIPreferencesTableCell*) preferencesTable: (UIPreferencesTable*)table cellForRow: (int)row inGroup: (int)group 
{	
	if(group == 0) {
        switch  (row) {
            case 0: {
				UITableCell *xCell = [[AboutPrefsCell alloc] initWithTitle:@"Dashbuster is ported from my dashboard widget of the same name.\n\nIf you've got any feature requests or bug finds I'd love to hear them.\n\n-Jerry Jones"
														 description:@""];
				[xCell setEnabled: NO];
				return [xCell autorelease];
			}
				
		}
    }else {
		switch  (row) {
            case 0: {
				UIPreferencesTableCell *cell = [[UIPreferencesTableCell alloc] init];
				[cell setTitle:@"Contact The Developer"];
				[cell setShowDisclosure: YES];
				[cell setAlignment:2];
				return [cell autorelease];
			}
            case 1: {
				UIPreferencesTableCell *cell = [[UIPreferencesTableCell alloc] init];
				[cell setTitle:@"Visit Dashbuster Webpage"];
				[cell setShowDisclosure: YES];
				[cell setAlignment:2];
				return [cell autorelease];
			}
            case 2: {
				UIPreferencesTableCell *cell = [[UIPreferencesTableCell alloc] init];
				[cell setTitle:@"Donate"];
				[cell setShowDisclosure: YES];
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

		case 0: {
			switch (row) {
				case -1: return 65.0f;	
				case 0: return 150.0f;
			}
		}
		case 1: {
			return proposed;
		}

		default: return proposed;
	}
}


@end