//
//  RSSListView.h
//  ibbo
//
//  Created by Jerry Jones on 12/1/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/CDStructures.h>
#import <UIKit/UINavigationItem.h>
#import <UIKit/UIKit.h>

#import <UIKit/UITableColumn.h>
#import <UIKit/UIPreferencesTable.h>
#import <UIKit/UIPreferencesTableCell.h>
#import <UIKit/UIPreferencesTextTableCell.h>
#import "RSS.h"

@interface RSSListView	: UIView {
	id                          app;
	
	UIPreferencesTable          *prefsTable;
	UIPreferencesTextTableCell  *prefsTextCell;	
	UIPreferencesTableCell		*prefsTableCell;
    
    UINavigationBar             *navBar;
	
	RSS							*tmpRSS;
}

- (id) initWithFrame: (struct CGRect)frame withApp: (id)_app;
- (void)clearSelection;
- (void)myReturn;
- (RSS *)tmpRSS;
@end
