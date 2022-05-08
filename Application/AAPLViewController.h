/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Header for the cross-platform view controller
*/

#if defined(TARGET_IOS) || defined(TARGET_TVOS)
#import <UIKit/UIKit.h>
#define PlatformViewController UIViewController
#else
#import <AppKit/AppKit.h>
#define PlatformViewController NSViewController
#endif

#import "AAPLView.h"

@interface AAPLViewController : PlatformViewController <AAPLViewDelegate>

@end
