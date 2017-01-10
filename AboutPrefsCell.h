//
//  MovieCell.h
//
//  Created by Justin on 2007-10-16.
//  Copyright (c) 2007 Active Reload, LLC.. All rights reserved.
//

#import <UIKit/UIPreferencesTableCell.h>

@class UIImageView;
@class UITextLabel;

@interface AboutPrefsCell : UIPreferencesTableCell
{
    UIImageView *_movieImage;
    UITextLabel *_movieTitle;
    UITextLabel *_movieDesc;
}

//- (id)initWithTitle:(NSString *)title description:(NSString *)description image:(NSString *)image guid:(NSString *)guid;
- (id)initWithTitle:(NSString *)title description:(NSString *)description;
@end
