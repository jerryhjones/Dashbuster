//
//  SearchResultsView.m
//  ibbo
//
//  Created by Jerry Jones on 11/28/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//
#import "ibboApp.h"
#import "SearchResultsView.h"


@implementation SearchResultsView
- (id) initWithFrame: (struct CGRect)frame withApp: (id)_app;
{
    app = _app;
	
	//NSLog(@"Initialized Search Results View");
    self = [super initWithFrame: frame];
	coverArtDownloader = [[CoverArtDownloader alloc] init];
    
	CGRect rect = [UIHardware fullScreenApplicationContentRect];
	rect.origin.x = rect.origin.y = 0.0f;
	
	navBar = [[UINavigationBar alloc] init];
	[navBar setFrame:CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, 45.0f)];
	[navBar setBarStyle:1];
	[navBar showButtonsWithLeftTitle:@"Done" rightTitle:nil leftBack:YES];
	[navBar setDelegate:self];
	[navBar enableAnimation];
	
    table = [[UITable alloc] initWithFrame:CGRectMake(0.0f, 44.0f, 320.0f, 415.0f)];
	[table setDelegate:self];
	[table setDataSource:self];
	[table setSeparatorStyle:2];
	[table setRowHeight:50.];
	[table setShowScrollerIndicators:YES];
	[table setAllowsReordering:NO]; // set to no if reordering isn't wanted
	
	UITableColumn * myColumn = [[UITableColumn alloc] initWithTitle:@"Column1" identifier:@"column1" width:rect.size.width-40.0];
	UITableColumn * myColumn2 = [[UITableColumn alloc] initWithTitle:@"Column2" identifier:@"column2" width:40.0];
	[table addTableColumn: myColumn];
	[table addTableColumn: myColumn2];
	
	[table reloadData];
	
    [self addSubview: table];
	[self addSubview: navBar];
	
	return self;
}

- (void)reloadData
{
	[table reloadData];
}

-(void)setDataSource:(NSMutableArray *)aMutableArray
{
	//searchArray = aMutableArray;
	searchArray = [[NSMutableArray alloc] init];
	NSEnumerator *arrayEnumerator = nil;
	id temporaryObject = nil;
	arrayEnumerator = [aMutableArray objectEnumerator];
	
	while ( temporaryObject = [arrayEnumerator nextObject] )
	{
		//NSLog([temporaryObject queueItemImageURL]);
		BOOL inQueue;
		if([[app queue] checkForId:[temporaryObject objectForKey:@"titleId"]]){
			inQueue = YES;			
		}else{
			inQueue = NO;
		}
			
		UITableCell *tmpCell = [[[SearchCell alloc] initWithTitle:[temporaryObject objectForKey:@"title"]
													 description:[temporaryObject objectForKey:@"description"]
														 movieId:[temporaryObject objectForKey:@"titleId"]
														  imgUrl:[temporaryObject objectForKey:@"imagePath"]
														  inQueue:inQueue
												  withDownloader:coverArtDownloader] autorelease];
				
		[searchArray addObject:tmpCell];

		//NSLog(@"Count dataArray: %d", [searchArray count]);
	}
	//[coverArtDownloader tryDownload];
}

- (void)navigationBar:(UINavigationBar*) navbar buttonClicked:(int)button 
{
	if(button == 1){
		NSLog(@"Done");
		[app showView:@"prefsView" withTransition:7];
	}
}

//---------------------------------------------------------------------

//datasource methods
-(int)numberOfRowsInTable:(UITable*)table{
	return [searchArray count];
}

-(UITableCell*)table:(UITable*)table cellForRow:(int)row column:(id)column{
	if([[column identifier] isEqualToString:@"column1"]){
		return [searchArray objectAtIndex:row];
	}else{
		pbCell = [[UIImageAndTextTableCell alloc] init];
		[pbCell setImage: [UIImage applicationImageNamed: @"blue_plus.png"]];
		[pbCell setTitle:@""];
		[pbCell setShowDisclosure: NO];
		return pbCell;		
	}
}

- (BOOL)respondsToSelector:(SEL)aSelector {
	////NSLog(@"respondsToSelector: selector = %@", NSStringFromSelector(aSelector));
	return [super respondsToSelector:aSelector];
}

- (float)table: (UITable *)table heightForRow: (int)row
{
	return (85.0f);
}


// Selection Notifications
-(void)tableRowSelected:(NSNotification*)note{
	int actRowId = [[note object] selectedRow];
	//NSLog(@"Add Id: %@", [[searchArray objectAtIndex:actRowId] movieId]);
	[app showHUDwithTitle:@"Adding Movie"];
	[[app queue] addToQueueWithItemId:[[searchArray objectAtIndex:actRowId] movieId]];
	[[searchArray objectAtIndex:actRowId] setInQueue];
}

- (void)startDownload
{
	[coverArtDownloader tryDownload];
}

- (void)clearSelection
{
	
	[table clearSelectionHighlite];
	[table reloadData];
}
- (BOOL)table:(UITable*)table2 canSelectRow:(int)row
{
	if([[app queue] checkForId:[[table2 cellAtRow:row column:0] movieId]])
	{
		//NSLog(@"%@ is already in your queue", [[table2 cellAtRow:row column:0] movieId]);
		return NO;
	}
	
}


@end
