/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Implementation of the cross-platform view controller
*/

#import "AAPLViewController.h"
#if TARGET_IOS || TARGET_TVOS
#import "AAPLUIView.h"
#else
#import "AAPLNSView.h"
#endif
#import "AAPLRenderer.h"

#import <QuartzCore/CAMetalLayer.h>

@implementation AAPLViewController
{
    AAPLRenderer *_renderer;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    AAPLView *view = (AAPLView *)self.view;

    // Set this class as the delegate to receive resize and render callbacks.
    view.delegate = self;

    _renderer = [[AAPLRenderer alloc] initWithMetalLayer:view.metalLayer];
}

- (void)drawableResize:(CGSize)size
{
    [_renderer drawableResize:size];
}

- (void)renderToMetalLayer:(nonnull CAMetalLayer *)layer
{
    [_renderer renderToMetalLayer:layer];
}

@end
