

#import <UIKit/UIImageAndTextTableCell.h>

@class UIImageView;
@class UITextLabel;

@interface TapableTextLabel : UITextLabel 
@end



@interface MovieCell : UITableCell
{
    UIImageView *_movieImage;
    //UITextLabel *_movieTitle;
	UITextLabel *_movieTitle;
    UITextLabel *_movieDesc;
	
	UITextLabel *_movieMPAA;
	UITextLabel *_movieYear;	
	
	UIImageView *background;
	
	UIView			*backBackground;
    UIView			*testview1;
    UIView			*testview2;
    UIView			*delayView;
	NSString *myTitle;
	NSString *myDescription;
	NSString *myYear;
	NSString *myMPAA;
	NSString *myBackside;
	NSString *myImageURL;
	
	BOOL showingBackside;
}

//- (id)initWithTitle:(NSString *)title description:(NSString *)description image:(NSString *)image guid:(NSString *)guid;
- (id)initWithTitle:(NSString *)title itemId:(NSString *)aItemId description:(NSString *)description year:(NSString *)year mpaa:(NSString *)mpaa image:(NSString*)imageURL withDownloader:(id)aDownloader;
- (NSString *)getTitle;
- (BOOL)showingBackside;
- (void)setShowingBackside:(BOOL)aBool;
- (void)setCoverArt:(UIImage *)aImage;
- (void)setImageURL:(NSString *)aString;
- (NSString*)imageURL;
@end
