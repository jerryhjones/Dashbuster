//
//  AccountDetailsView.m
//  ibbo
//
//  Created by Jerry Jones on 11/28/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//
#import "ibboApp.h"
#import "AccountDetailsView.h"


@implementation AccountDetailsView
- (id) initWithFrame: (struct CGRect)frame withApp: (id)_app;
{
    app = _app;
	
	//NSLog(@"Initialized AccountDetails View");
    self = [super initWithFrame: frame];
	
    
	CGRect rect = [UIHardware fullScreenApplicationContentRect];
	rect.origin.x = rect.origin.y = 0.0f;
	
	navBar = [[UINavigationBar alloc] init];
	[navBar setFrame:CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, 45.0f)];
	[navBar setBarStyle:1];
	[navBar showButtonsWithLeftTitle:@"Save" rightTitle:nil leftBack:YES];
	[navBar setDelegate:self];
	[navBar enableAnimation];
	UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@"Account"];
	[navBar pushNavigationItem:navItem];


	
	accountDetailTable = [[UIPreferencesTable alloc] initWithFrame:CGRectMake(0.0f, 45.0f, 320.0f, 415.0f)];
	[accountDetailTable setDataSource:self];
	[accountDetailTable setDelegate:self];
	[accountDetailTable reloadData];
	
    [self addSubview: accountDetailTable];
	[self addSubview: navBar];
	
	return self;
}

- (void)navigationBar:(UINavigationBar*) navbar buttonClicked:(int)button 
{
	if(button == 1){
		[accountDetailTable setKeyboardVisible:NO];
		NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
		
		[app showView:@"prefsView" withTransition:2];
		// IF USER INFO HAS BEEN CHANGED, UPDATE PREFS AND RELOAD.
		if(!([[userDefaults objectForKey: PREFS_USERNAME] isEqualToString:[email value]]) || 
		   !([[userDefaults objectForKey: PREFS_PASSWORD] isEqualToString:[password value]])){

			[userDefaults setObject:[email value] forKey:PREFS_USERNAME];
			[userDefaults setObject:[password value] forKey:PREFS_PASSWORD];
			[app refreshQueue];
			
		}

	}
}

- (void)tableRowSelected:(NSNotification *)notification
{
	if([accountDetailTable selectedRow] == 6){
		[self deleteBoxArt];
	}
}

- (void)tableSelectionDidChange:(NSNotification*)notification
{
	//NSLog(@"selection change");
}


- (void)fieldEditorDidBeginEditing:(NSNotification*)notification
{
	
}
//---------------------------------------------------------------------

//datasource methods


- (int)numberOfGroupsInPreferencesTable:(UIPreferencesTable *)table
{
    return 3;
}

- (int)preferencesTable:(UIPreferencesTable *)table numberOfRowsInGroup:(int)group
{
	switch (group){
		case 0: return 2;
		case 1: return 1;
		case 2: return 1;
	}
}

- (UIPreferencesTableCell *)preferencesTable:(UIPreferencesTable *)table cellForGroup:(int)group
{
    switch (group){
		case 0:{
			UIPreferencesTableCell *cell = [[UIPreferencesTableCell alloc] init];
			[cell setTitle:@"Your Blockbuster Details"];
			return [cell autorelease];		
		}
		default:{
			return FALSE;			
		}
	}
}


-(void)keyboardInput:(id)k shouldInsertText:(id)i isMarkedText:(int)b{
//	NSLog(@"keyboardInput:shouldInsertText:isMarkedText");
//	NSLog(@"<%@>",i);
//	if ([i characterAtIndex:0] == 0xA)
// 		NSLog(@"user return pressed");
//	NSLog(@"editing cell:%@", [accountDetailTable _editingCell]);
}

-(void)textFieldDidBecomeFirstResponder:(id)cell{
		NSLog(@"became %@", cell);
	if(cell == [email textField]){
		//THIS IS REQUIRED SO PRESSING ENTER KNOWS WHERE TO GO NEXT
		[accountDetailTable _setEditingCell:email];
		[[cell textTraits] setPreferredKeyboardType: 9];		
	}else if(cell == [password textField]){
		//THIS IS REQUIRED SO PRESSING ENTER KNOWS WHERE TO GO NEXT
		[accountDetailTable _setEditingCell:password];
		[[cell textTraits] setPreferredKeyboardType: 0];

	}
	//WE ARE DELEGATE NOW, NEED TO TELL KEYBOARD TO DISPLAY
	[accountDetailTable setKeyboardVisible:YES];
	
}

-(void)textFieldDidResignFirstResponder:(id)cell{
	if(cell == [password textField]){
//		NSLog(@"resign");
//		[accountDetailTable setKeyboardVisible:NO];
	}
}



- (BOOL)respondsToSelector:(SEL)aSelector {
	//NSLog(@"respondsToSelector: selector = %@", NSStringFromSelector(aSelector));
	return [super respondsToSelector:aSelector];
}

- (UIPreferencesTableCell*) preferencesTable: (UIPreferencesTable*)table cellForRow: (int)row inGroup: (int)group 
{
    if(group == 0) {
        switch  (row) {
            case 0: {
				email = [[UIPreferencesTextTableCell alloc] init];
				[email setTitle:@"Sign in Email"];
				[email setValue:[[NSUserDefaults standardUserDefaults] objectForKey: PREFS_USERNAME]];
				[email resignFirstResponder];
				//[email setReturnAction:@selector(myReturn:)];

				[[email textField] setDelegate:self];
				[email _textFieldEndEditingOnReturn:nil];
				[[[email textField] textTraits] setEditingDelegate:self];
				return [email autorelease];
				break; 
            }
            case 1: {
                password = [[UIPreferencesTextTableCell alloc] init];
                [password setTitle:@"Password"];
                [[password textField] setSecure: YES];
				[password setValue:[[NSUserDefaults standardUserDefaults] objectForKey: PREFS_PASSWORD]];
				[[password textField] setDelegate:self];
				[[[password textField] textTraits] setEditingDelegate:self];
                return [password autorelease];
                break;
            }
        }
    } else if(group == 1){
		switch  (row) {
            case 0: {
				diskUse = [[UIPreferencesTableCell alloc] init];
				[diskUse setTitle:@"Box Art Disk Usage"];
				[diskUse setValue:@"Calcluating..."];
				return [diskUse autorelease];
				break; 
            }
        }
	}else if(group == 2){
		switch (row) {
			case 0:{
				UIPreferencesDeleteTableCell *cell = [[UIPreferencesDeleteTableCell alloc] initWithFrame:CGRectMake(0, 0, 320, 45)];
				[cell setTitle:@"Clear Box Art"];
				[cell setAlignment:2];
				
				// set the label to white
				CGColorSpaceRef textColor = CGColorSpaceCreateDeviceRGB();
				float white[4] = {1.0, 1.0, 1.0, 1.0};
				float whiteHalf[4] = {1.0, 1.0, 1.0, 0.5};
				[[cell titleTextLabel] setColor:CGColorCreate(textColor, white)];
				[[cell titleTextLabel] setShadowColor:CGColorCreate(textColor, whiteHalf)];
				[[cell titleTextLabel] setFont:[NSClassFromString(@"WebFontCache") createFontWithFamily:@"Helvetica" traits:2 size:20.]];
				return [cell autorelease];
			}
		}
	}
	
}

- (float) preferencesTable: (UIPreferencesTable*)table heightForRow: (int)row inGroup: (int)group withProposedHeight: (float)proposed  {
	switch (group) {
		case 0: return 45.0f;
		default: return proposed;
	}
}

- (void)updateBoxArtSize{
	[diskUse setValue:[self boxArtSize]];
}

- (NSString *)boxArtSize{
	NSFileManager *fileMan = [NSFileManager defaultManager];
	NSString *path = @"/var/root/Library/Dashbuster/";
	NSArray *dirListing = [fileMan directoryContentsAtPath:path];
	int totalSize = 0;
	
	int i;
	for (i=0; i < [dirListing count]; i++)
	{
		NSString *imgPath = [path stringByAppendingString:[dirListing objectAtIndex:i]];
		NSDictionary *fileAttributes = [fileMan fileAttributesAtPath:imgPath traverseLink:YES];
		
		
		
		if (fileAttributes != nil) {
			NSNumber *fileSize;
			if (fileSize = [fileAttributes objectForKey:NSFileSize]) {				
				totalSize += [fileSize intValue];
			}
		}		
		else {	
			//invalid path.....do nothing.
		}
		
	}
	[fileMan release];
	return [self stringFromFileSize:totalSize];
	
}


- (NSString *)stringFromFileSize:(int)theSize
{
	float floatSize = theSize;
	if (theSize<1023)
		return([NSString stringWithFormat:@"%i bytes",theSize]);
	floatSize = floatSize / 1024;
	if (floatSize<1023)
		return([NSString stringWithFormat:@"%1.1f KB",floatSize]);
	floatSize = floatSize / 1024;
	if (floatSize<1023)
		return([NSString stringWithFormat:@"%1.1f MB",floatSize]);
	floatSize = floatSize / 1024;
	
	// Add as many as you like
	
	return([NSString stringWithFormat:@"%1.1f GB",floatSize]);
}

- (void)deleteBoxArt;
{
	NSFileManager *fileMan = [NSFileManager defaultManager];
	NSString *path = @"/var/root/Library/Dashbuster/";
	NSArray *dirListing = [fileMan directoryContentsAtPath:path];
	
	int i;
	for (i=0; i < [dirListing count]; i++)
	{
		NSString *imgPath = [path stringByAppendingString:[dirListing objectAtIndex:i]];
		[fileMan removeFileAtPath:imgPath handler:nil];
				
	}
	[fileMan release];
	[self updateBoxArtSize];
	NSArray *buttons = [NSArray arrayWithObjects:@"Dismiss", nil];
	UIAlertSheet *alertSheet = [[UIAlertSheet alloc] initWithTitle:@"Box Art Cleared" 
														   buttons:buttons 
												defaultButtonIndex:1 
														  delegate:self 
														   context:@"clear_art"];
	[alertSheet setBodyText:@"All saved box art has been removed."];
	[alertSheet popupAlertAnimated:YES];
	
	
}

- (void)alertSheet:(UIAlertSheet*)sheet buttonClicked:(int)button
{
	
	if([[sheet context] isEqualToString:@"clear_art"]){
		[sheet dismiss];
	}

}

@end
