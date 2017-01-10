//
//  ShippedView.m
//  ibbo
//
//  Created by Jerry Jones on 11/26/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//
#import "ibboApp.h"
#import "ShippedView.h"


@implementation ShippedView
- (id) initWithFrame: (struct CGRect)frame withApp: (id)_app;
{
    app = _app;
	shippedArray = [[NSMutableArray alloc] init];
	
	//NSLog(@"Initialized Shipped View");
    self = [super initWithFrame: frame];
	
    
	CGRect rect = [UIHardware fullScreenApplicationContentRect];
	rect.origin.x = rect.origin.y = 0.0f;
	
	navBar = [[UINavigationBar alloc] init];
	[navBar setFrame:CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, 45.0f)];
	[navBar setBarStyle:1];
	[navBar showButtonsWithLeftTitle:@"Back" rightTitle:nil leftBack:YES];
	[navBar setDelegate:self];
	[navBar enableAnimation];
	
	
    table = [[UITable alloc] initWithFrame:CGRectMake(0.0f, 44.0f, 320.0f, 415.0f)];
	[table setDelegate:self];
	[table setDataSource:self];
	[table setSeparatorStyle:2];
	[table setRowHeight:50.];
	[table setShowScrollerIndicators:YES];
	[table setAllowsReordering:NO]; // set to no if reordering isn't wanted
	
	UITableColumn * myColumn = [[UITableColumn alloc] initWithTitle:@"Column1" identifier:@"column1" width:rect.size.width];
	[table addTableColumn: myColumn];
	
	[table reloadData];
	
    [self addSubview: table];
	[self addSubview: navBar];
	UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@"Shipped Movies"];
	[navBar pushNavigationItem:navItem];
	
	return self;
}

- (void)reloadData
{
	[table reloadData];
}

-(void)setDataSource:(NSMutableArray *)aMutableArray
{
//	NSLog(@"array: %@", aMutableArray);
	NSLog(@"set data source shipped view");
	NSLog(@"shippedArray pointer: %p", shippedArray);
	shippedArray = aMutableArray;
	NSLog(@"shippedArray pointer2: %p", shippedArray);
//	NSLog(@"array2: %@", shippedArray);
}

- (void)navigationBar:(UINavigationBar*) navbar buttonClicked:(int)button 
{
	if(button == 1){
		//NSLog(@"Done");
		[app showView:@"prefsView" withTransition:2];
	}
}

//---------------------------------------------------------------------

//datasource methods
-(int)numberOfRowsInTable:(UITable*)table{
	return [[[app queue] getShippedTitleArray] count];
}

-(UITableCell*)table:(UITable*)table cellForRow:(int)row column:(int)column{


	NSLog(@"CELL FOR ROW");
	pbCell = [[UIImageAndTextTableCell alloc] init];
	NSLog(@"1");
  //  NSString *helloString = [[NSString alloc] initWithFormat:@"asdf %i", row];
	NSLog(@"2 row: %d", row);
	NSString *tmpForTable = [shippedArray objectAtIndex:row];
	NSLog(@"3");
//	NSLog(@"tmpForTable: %@", tmpForTable);
	NSLog(@"4");
	[pbCell setTitle:tmpForTable]; 	

	return pbCell;

	
}

- (BOOL)respondsToSelector:(SEL)aSelector {
	//NSLog(@"respondsToSelector: selector = %@", NSStringFromSelector(aSelector));
	return [super respondsToSelector:aSelector];
}

- (BOOL)table:(UITable*)table2 canSelectRow:(int)row
{
	return NO;
}


@end
