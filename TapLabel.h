#import <CoreFoundation/CoreFoundation.h>

#import <GraphicsServices/GraphicsServices.h>

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>
#import <UIKit/UIApplication.h>
#import <UIKit/UIPushButton.h>
#import <UIKit/UIImage.h>
#import <UIKit/UITransitionView.h>
#import <UIKit/UIImageView.h>
#import <UIKit/CDStructures.h>
#import <UIKit/UIPushButton.h>
#import <UIKit/UIThreePartButton.h>
#import <UIKit/UINavigationBar.h>
#import <UIKit/UIWindow.h>
#import <UIKit/UIView-Hierarchy.h>
#import <UIKit/UIHardware.h>
#import <UIKit/UITextView.h>
#import <UIKit/UIImageView.h>
#import <UIKit/UITouchDiagnosticsLayer.h>
#import <UIKit/UITransitionView.h>


@interface TapLabel : UITextLabel {
}
- (BOOL) ignoresMouseEvents;
#if 1
- (void) handleSingleTapEvent: (struct __GSEvent *)fp8;
#endif
- (void) mouseUp: (GSEvent *) event;
- (void)view:(UIView *)view handleTapWithCount:(int)count event:(GSEvent *)event;
- (void) disable;
- (void) doHilite;
- (void) removeHilite;
@end