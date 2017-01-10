//
//  MovieCell.h
//
//  Created by Justin on 2007-10-16.
//  Copyright (c) 2007 Active Reload, LLC.. All rights reserved.
//

#import <UIKit/UIImageAndTextTableCell.h>

@class UIImageView;
@class UITextLabel;

@interface SearchCell : UITableCell
{
    UIImageView *_movieImage;
    UITextLabel *_movieTitle;
    UITextLabel *_movieDesc;
	UIImageView *background;

	
	NSString *movieId;
	NSString *myImgURL;
}

//- (id)initWithTitle:(NSString *)title description:(NSString *)description image:(NSString *)image guid:(NSString *)guid;
- (id)initWithTitle:(NSString *)title description:(NSString *)description movieId:(NSString *)aId imgUrl:(NSString *)imgUrl inQueue:(BOOL)inQueue withDownloader:(id)aDownloader;
- (NSString *)movieId;
- (void)setCoverArt:(UIImage *)aImage;
- (NSString *)myImgURL;
- (void)setInQueue;

@end
