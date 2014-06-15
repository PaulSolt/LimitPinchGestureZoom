//
//  ViewController.m
//  GestureStackOverflow
//
//  Created by Paul on 6/14/14.
//  Copyright (c) 2014 Paul Solt. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIGestureRecognizerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIView *blueView = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 150, 150)];
    blueView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:blueView];
    [self addMovementGesturesToView:blueView];
    
    // UIImageView's and UILabel's don't have userInteractionEnabled by default!
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BombDodge.png"]]; // Any image in Xcode project
    imageView.center = CGPointMake(160, 250);
    [imageView sizeToFit];
    [self.view addSubview:imageView];
    [self addMovementGesturesToView:imageView];
    
    // Note: Changing the font size would be crisper than zooming a font!
    UILabel *label = [[UILabel alloc] init];
    label.text = @"Hello Gestures!";
    label.font = [UIFont systemFontOfSize:30];
    label.textColor = [UIColor blackColor];
    [label sizeToFit];
    label.center = CGPointMake(160, 400);
    [self.view addSubview:label];
    [self addMovementGesturesToView:label];
}

- (void)addMovementGesturesToView:(UIView *)view {
    view.userInteractionEnabled = YES;  // Enable user interaction
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    panGesture.delegate = self;
    [view addGestureRecognizer:panGesture];
    
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
    pinchGesture.delegate = self;
    [view addGestureRecognizer:pinchGesture];
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)panGesture {
    CGPoint translation = [panGesture translationInView:panGesture.view.superview];
    
    if (UIGestureRecognizerStateBegan == panGesture.state ||UIGestureRecognizerStateChanged == panGesture.state) {
        panGesture.view.center = CGPointMake(panGesture.view.center.x + translation.x,
                                             panGesture.view.center.y + translation.y);
        // Reset translation, so we can get translation delta's (i.e. change in translation)
        [panGesture setTranslation:CGPointZero inView:self.view];
    }
    // Don't need any logic for ended/failed/canceled states
}

- (void)handlePinchGesture:(UIPinchGestureRecognizer *)pinchGesture {
    
    if (UIGestureRecognizerStateBegan == pinchGesture.state ||
        UIGestureRecognizerStateChanged == pinchGesture.state) {
        
        // Use the x or y scale, they should be the same for typical zooming (non-skewing)
        float currentScale = [[pinchGesture.view.layer valueForKeyPath:@"transform.scale.x"] floatValue];
        
        // Variables to adjust the max/min values of zoom
        float minScale = 1.0;
        float maxScale = 2.0;
        float zoomSpeed = .5;
        
        float deltaScale = pinchGesture.scale;
        
        // We need to translate the zoom to a value that we can multiple
        //  a speed factor and then translate back to "zoomSpace"
        if(pinchGesture.scale > 1) {
            deltaScale = (deltaScale - 1) * zoomSpeed + 1;
        } else if(pinchGesture.scale < 1) {
            deltaScale = 1 - ((1 - deltaScale) * zoomSpeed);
        }
        // Limit to min/max size (i.e maxScale = 2, current scale = 2, 2/2 = 1.0)
        //  A deltaScale is ~0.99 for decreasing or ~1.01 for increasing
        //  A deltaScale of 1.0 will maintain the zoom size
        deltaScale = MIN(deltaScale, maxScale / currentScale);
        deltaScale = MAX(deltaScale, minScale / currentScale);
        
        CGAffineTransform zoomTransform = CGAffineTransformScale(pinchGesture.view.transform, deltaScale, deltaScale);
        pinchGesture.view.transform = zoomTransform;
        
        // Reset to 1 for scale delta's
        //  Note: not 0, or we won't see a size: 0 * width = 0
        pinchGesture.scale = 1;
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES; // Works for most use cases of pinch + zoom + pan
}

@end
