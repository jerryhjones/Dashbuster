#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UIKit/UIApplication.h>
#import <UIKit/UIPushButton.h>
#import <UIKit/UITableCell.h>
#import <UIKit/UIImageAndTextTableCell.h>


@interface Search : NSObject {
	NSMutableData *searchData;
	NSMutableURLRequest *searchRequest;
	NSXMLDocument *searchResults;
	NSMutableArray *searchTitleArray;
	
	//Parsing Flags
    BOOL isParsingTitle;
	BOOL isParsingTitleInfo;
	BOOL isParsingMovieClassDiv;
	BOOL isParsingSummary;
	NSMutableString *currentParsingMovieTitleId;
	int divTreeLevel;
	
	int lastAddedItem;
	
	NSString *tmpString;
}

- (id)initWithKeyword: (NSString *)aString;
- (NSMutableArray *)getSearchTitleArray;

@end
