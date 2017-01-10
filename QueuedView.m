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

@implementation QueuedView
- (id) initWithFrame: (struct CGRect)frame withApp: (id)_app;
{
    app = _app;
	
	//NSLog(@"Initialized Search Results View");
    self = [super initWithFrame: frame];
	queueArray = [[NSMutableArray alloc] init];

	coverArtDownloader = [[DetailDownloader alloc] init];
	
	
	CGRect rect = [UIHardware fullScreenApplicationContentRect];
	rect.origin.x = rect.origin.y = 0.0f;
	
	UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0., 0., rect.size.width, [UINavigationBar defaultSize].height)];
	[navBar setDelegate:self];
	[navBar setBarStyle:1];
	[navBar showButtonsWithLeftTitle:@"Back" rightTitle:@"Edit" leftBack:YES];
	UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@""];
	[navBar pushNavigationItem:navItem];

	float black[4] = {0, 0, 0, 1};
	
	sectionList = [[UISectionList alloc] initWithFrame:CGRectMake(rect.origin.x, [UINavigationBar defaultSize].height, rect.size.width, rect.size.height) showSectionIndex:YES	];
	[sectionList setDataSource:self];
	[sectionList reloadData];
	[self addSubview:sectionList];

    queueTable = [sectionList table];
	[queueTable setShouldHideHeaderInShortLists:NO];
	//queueTable = [[CustomTable alloc] initWithFrame:CGRectMake(20.0f, 64.0f, 280.0f, 375.0f)];
	[queueTable setDelegate:self];
//	[queueTable setDataSource:self];
	[queueTable setSeparatorStyle:2];
	[queueTable setShowScrollerIndicators:YES];
	[queueTable setAllowsReordering:YES]; // set to no if reordering isn't wanted
	//[queueTable setBackgroundColor: CGColorCreate(CGColorSpaceCreateDeviceRGB(), black)];
	
	UITableColumn * myColumn = [[UITableColumn alloc] initWithTitle:@"Column1" identifier:@"column1" width:rect.size.width];
	[queueTable addTableColumn: myColumn];
	
	[sectionList reloadData];
	
//    [self addSubview: queueTable];
	[self addSubview: navBar];
	
	return self;
}

- (void)reloadData
{
	[queueTable reloadData];
}

- (void)setDataArray:(NSMutableArray *)aMutableArray
{
	[queueArray release];
	queueArray = aMutableArray;
}


-(void)setDataSource
{
	//NSLog(@"Setting Queue Data Source");
	[dataArray removeAllObjects];
	[coverArtDownloader emptyQueue];
	[dataArray release];
	dataArray = [[NSMutableArray alloc] init];
	NSEnumerator *arrayEnumerator = nil;
	id temporaryObject = nil;
	arrayEnumerator = [queueArray objectEnumerator];
	
	while ( temporaryObject = [arrayEnumerator nextObject] )
	{
		//NSLog(@"deal with cell %d", [temporaryObject systemId]);

		UITableCell *tmpCell = [[[MovieCell alloc] initWithTitle:[temporaryObject queueItemTitle]
										  itemId:[temporaryObject systemId]
									 description:[temporaryObject queueAvailability]
											year:[temporaryObject queueItemYear]
											mpaa:[temporaryObject MPAA]
										   image:[temporaryObject queueItemImageURL]
								  withDownloader:coverArtDownloader] autorelease];
		[dataArray addObject:tmpCell];
		
	}
	[queueTable reloadData];
}

// navigationbar is needed so that we can have a button to set
// [table enableRowDeletion:YES animated:YES]; this must be done outside the 
// initialization of the table for the reorder column to be displayed correctly
- (void)navigationBar:(UINavigationBar*)navBar2 buttonClicked:(int)button {
	if (button == 1) {
		[dataArray removeAllObjects];
		[queueTable reloadData];
		[app showView:@"prefsView" withTransition:2];
		//[transitionView transition:2 toView:prefsView];
	} else if (button == 0) {
		if(queueEditMode){
			[queueTable enableRowDeletion:NO animated:YES];
			[navBar2 showButtonsWithLeftTitle:@"Back" rightTitle:@"Edit" leftBack:YES];
			queueEditMode = NO;
			//[transitionView transition:1 toView:table];			
		}else{
			[queueTable enableRowDeletion:YES animated:YES];  // this must be done outside the initialization of the table for the reorder column to be displayed correctly
			[navBar2 showLeftButton:nil withStyle:0 rightButton:@"Done" withStyle:3];
			queueEditMode = YES;
		}
	}
}

//---------------------------------------------------------------------
// for reordering and deleting
//---------------------------------------------------------------------

// return NO if you only want to move rows
- (BOOL)table:(UITable*)table canDeleteRow:( int)row {
	//ZZNSLog(@"canDeleteRow: %d",row);
	return YES;
}

- (BOOL)table:(UITable*)table willSwipeToDeleteRow:( int)row {
	[table _reloadRowHeights];
	return YES;
}


- (BOOL) table:(UITable*)table beginConfirmationForDeletingRow:(id)row withContinuation:(id)row2
{
	//I don't understand this.....it doesn't seem to respond to anything.
	//NSLog(@"being confirm - first:");
	return NO;
}


// this method must be declared so that rows can be moved
// if you don't want to delete rows, then return NO from table:canDeleteRow:
- (void)table:(UITable*)table deleteRow:(int)row {
	
	//NSLog(@"Delete This Row: %i", row);

	[[queueArray objectAtIndex:row] deleteFromQueue];
	[queueArray removeObjectAtIndex:row];
	[dataArray removeObjectAtIndex:row];
	if(row < [[app queue] savedStartsAtIndex]){
		[[app queue] savedStartsLessOne];
	}
	[[app queue] rebuildSystemIdArray];	
}

// this is required to move rows, otherwise only the delete button object is shown
- (BOOL)table:(UITable*)table canMoveRow:(int)row{
	if (row < [[app queue] savedStartsAtIndex])
		return YES;
	
	else
		return NO;
}



-(int)table:(UITable*)thisTable movedRow:(int)row toRow:(int)dest{
	if(dest > [[app queue] savedStartsAtIndex]-1){
		[thisTable reloadData];
		return NO;
	}
	//NSLog(@"table:movedRow:toRow: %i, %i", row, dest);
	if(row != dest){
		[[queueArray objectAtIndex:row] moveToQueueIndex:dest fromIndex:row];		
	}
	QueueItem *tmpString = [queueArray objectAtIndex:row];
	[queueArray removeObjectAtIndex:row];	
	[queueArray insertObject: tmpString atIndex: dest];
	
	MovieCell *tmpCell = [dataArray objectAtIndex:row];
	[dataArray removeObjectAtIndex:row];	
	[dataArray insertObject: tmpCell atIndex: dest];
	[thisTable reloadData];
	//[tmpCell release];
	//[tmpString release];
	//[thisTable clearAllData];
	//NSLog(@"RELOAD6");	[thisTable reloadData];
	NSLog(@"queue array: %@", queueArray);
	return dest;
}

#pragma mark Section List Data Source

- (int)numberOfSectionsInSectionList:(UISectionList *)aSectionList {
	return 2; // x = number of sections in this table
}

- (NSString *)sectionList:(UISectionList *)aSectionList titleForSection:(int)section {
	if (0 == section)
		return @"Queued Movies";
	else if (1 == section)
		return @"Saved Movies";
}       

//the row that this section begins on
- (int)sectionList:(UISectionList *)aSectionList rowForSection:(int)section {
	if (0 == section)
		return 0;
	else if (1 == section)
		return [[app queue] savedStartsAtIndex];
	
}


//---------------------------------------------------------------------

//datasource methods
-(int)numberOfRowsInTable:(UITable*)table{
	return [dataArray count];
}

-(UITableCell*)table:(UITable*)table cellForRow:(int)row column:(int)column{

		return [dataArray objectAtIndex:row];
	
}

- (BOOL)respondsToSelector:(SEL)aSelector {
//	NSLog(@"respondsToSelector: selector = %@", NSStringFromSelector(aSelector));
	return [super respondsToSelector:aSelector];
}

- (BOOL)table:(UITable*)table canSelectRow:(int)row
{
	//NSLog(@"RELOAD1");
	//[table reloadData];
	//[self testAnimation];
	//	NSLog(@"RELOAD2");[self reloadData];

	return NO;
}



- (float)table: (UITable *)table heightForRow: (int)row
{
	return 85.0f;
}

@end
