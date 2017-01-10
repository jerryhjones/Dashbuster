#import <Foundation/Foundation.h>
#import <GraphicsServices/GraphicsServices.h>

#import <UIKit/UIKit.h>
#import <UIKit/UIImage.h>
#import <UIKit/UIView-Geometry.h>
#import <UIKit/UIView.h>
#import <WebCore/WebFontCache.h>
#import "ibboApp.h"
#import "SearchResultsView.h"
#import <math.h>

@implementation RSSDetailView
- (id) initWithFrame: (struct CGRect)frame withApp: (id)_app;
{
    app = _app;
	
	//NSLog(@"Initialized Search Results View");
    self = [super initWithFrame: frame];
	coverArtDownloader = [[CoverArtDownloader alloc] init];
    
	CGRect rect = [UIHardware fullScreenApplicationContentRect];
	rect.origin.x = rect.origin.y = 0.0f;
	
	UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0., 0., rect.size.width, [UINavigationBar defaultSize].height)];
	[navBar setDelegate:self];
	[navBar setBarStyle:1];
	[navBar showButtonsWithLeftTitle:@"Back" rightTitle:nil leftBack:YES];
	UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@"RSS Feed"];
	[navBar pushNavigationItem:navItem];
	
	
    queueTable = [[UITable alloc] initWithFrame:CGRectMake(0.0f, 44.0f, 320.0f, 415.0f)];
	//queueTable = [[CustomTable alloc] initWithFrame:CGRectMake(20.0f, 64.0f, 280.0f, 375.0f)];
	[queueTable setDelegate:self];
	[queueTable setDataSource:self];
	[queueTable setSeparatorStyle:2];
	[queueTable setShowScrollerIndicators:YES];
	[queueTable setAllowsReordering:YES]; // set to no if reordering isn't wanted
	
	UITableColumn * myColumn = [[UITableColumn alloc] initWithTitle:@"Column1" identifier:@"column1" width:rect.size.width-40.0];
	UITableColumn * myColumn2 = [[UITableColumn alloc] initWithTitle:@"Column2" identifier:@"column2" width:40.0];
	[queueTable addTableColumn: myColumn];
	[queueTable addTableColumn: myColumn2];
	
	[queueTable reloadData];
	
	
    [self addSubview: queueTable];
	[self addSubview: navBar];
	
	//pbCell = [[UIImageAndTextTableCell alloc] init];
	//[pbCell setImage: [UIImage applicationImageNamed: @"blue_plus.png"]];
	//[pbCell setTitle:@""];
	//[pbCell setShowDisclosure: NO];
	
	return self;
}

- (void)reloadData
{
	[queueTable reloadData];
}

- (void)clearSelection
{

	[queueTable clearSelectionHighlite];
	[queueTable reloadData];
}




-(void)setDataSource:(NSMutableArray *)aMutableArray
{
	[dataArray removeAllObjects];
	[coverArtDownloader emptyQueue];
	[dataArray release];
	dataArray = [[NSMutableArray alloc] init];
	NSEnumerator *arrayEnumerator = nil;
	id temporaryObject = nil;
	arrayEnumerator = [aMutableArray objectEnumerator];
	
	
	while ( temporaryObject = [arrayEnumerator nextObject] )
	{
		
		BOOL inQueue;
		if([[app queue] checkForId:[temporaryObject queueItemId]]){
			inQueue = YES;			
		}else{
			inQueue = NO;
		}
		
		UITableCell *tmpCell = [[[SearchCell alloc] initWithTitle:[temporaryObject queueItemTitle]
												  description:[temporaryObject queueItemDescription]
													  movieId:[temporaryObject queueItemId]
													   imgUrl:[temporaryObject queueItemImageURL]
														  inQueue:inQueue
												  withDownloader:coverArtDownloader] autorelease];
		[dataArray addObject:tmpCell];
	}
	
}

- (void)navigationBar:(UINavigationBar*)navBar2 buttonClicked:(int)button {
	if (button == 1) {
		[dataArray removeAllObjects];
		[queueTable reloadData];

		[app showView:@"rssListView" withTransition:2];
		//[transitionView transition:2 toView:prefsView];
	}
}

//datasource methods
-(int)numberOfRowsInTable:(UITable*)table{
	return [dataArray count];
}

-(UITableCell*)table:(UITable*)table cellForRow:(int)row column:(int)column{
	if([[column identifier] isEqualToString:@"column1"]){
		return [dataArray objectAtIndex:row];
	}else {
		UIImageAndTextTableCell *plusCell = [[UIImageAndTextTableCell alloc] init];
		[plusCell setImage: [UIImage applicationImageNamed: @"blue_plus.png"]];
		[plusCell setTitle:@""];
		[plusCell setShowDisclosure: NO];
		return [plusCell autorelease];
	}
	
}



- (BOOL)respondsToSelector:(SEL)aSelector {
	//NSLog(@"respondsToSelector: selector = %@", NSStringFromSelector(aSelector));
	return [super respondsToSelector:aSelector];
}

// Selection Notifications
-(void)tableRowSelected:(NSNotification*)note{
	int actRowId = [[note object] selectedRow];
	//[[dataArray objectAtIndex:actRowId] movieId];
	//NSLog(@"Add Id: %@", [dataArray objectAtIndex:actRowId]);
	[app showHUDwithTitle:@"Adding Movie"];
	[[app queue] addToQueueWithItemId:[[dataArray objectAtIndex:actRowId] movieId]];
	[[dataArray objectAtIndex:actRowId] setInQueue];
}

- (void)table:(UITable*)table scrollerWillStartSmoothScrolling:(BOOL)didStart
{
	NSLog(@"Does this work");
}


- (BOOL)table:(UITable*)table canSelectRow:(int)row
{
	if([[app queue] checkForId:[[table cellAtRow:row column:0] movieId]])
	{
		//NSLog(@"%@ is already in your queue", [[table2 cellAtRow:row column:0] movieId]);
		return NO;
	}else{
		return YES;		
	}
	

}

- (float)table: (UITable *)table heightForRow: (int)row
{
	return (85.0f);
}

- (void)startDownload
{
	[coverArtDownloader tryDownload];
}

- (void)clearDataArray
{
	[dataArray removeAllObjects];
}

@end
