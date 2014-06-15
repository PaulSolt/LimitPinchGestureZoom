LimitPinchGestureZoom
=====================

Limit UIPinchGestureRecognizer Zoom for any UIView

The code sample shows two things.

1. Use multiple gestures together to create a responsive user experience with media content.
2. How to zoom using the UIPinchGestureRecognizer and limit the zoom extents as well as speed.

I have used this code in my iPhone apps and recently revised it to make it easier to use as discussed on [Stack Overflow](http://stackoverflow.com/a/5449865/276626).

Code
----
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



Resources
----

* [Apple's Multi-touch Gestures](https://developer.apple.com/library/ios/documentation/EventHandling/Conceptual/EventHandlingiPhoneOS/GestureRecognizer_basics/GestureRecognizer_basics.html#//apple_ref/doc/uid/TP40009541-CH2-SW2)
* [StackOverflow Simultaneous Gestures](http://stackoverflow.com/a/5449865/276626)
