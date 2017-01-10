#import <Foundation/Foundation.h>
#import <GraphicsServices/GraphicsServices.h>

#import <UIKit/UIKit.h>
#import <UIKit/UIImage.h>
#import <UIKit/UIView-Geometry.h>
#import <UIKit/UIView.h>
#import <WebCore/WebFontCache.h>
#import "SmallAdView.h"

@implementation SmallAdView
- (id) initWithFrame: (struct CGRect)frame withApp: (id)_app;
{
    app = _app;
	
    self = [super initWithFrame: frame];

	CGRect rect = [UIHardware fullScreenApplicationContentRect];
	rect.origin.x = rect.origin.y = 0.0f;

	float black[4] = {0, 0, 0, 1};
	
	
	return self;
}

@end
