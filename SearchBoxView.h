//
//  SearchBoxView.h
//  ibbo
//
//  Created by Jerry Jones on 1/7/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <UIKit/UIPreferencesTable.h>
#import <UIKit/UIPreferencesTableCell.h>
#import <UIKit/UIPreferencesTextTableCell.h>
#import <UIKit/UIPreferencesDeleteTableCell.h>
#import <UIKit/UIPreferencesControlTableCell.h>
#import <WebCore/WebFontCache.h>

@interface SearchBoxView : UIView {

    id							app;

}
- (id) initWithFrame: (struct CGRect)frame withApp: (id)_app;


@end
