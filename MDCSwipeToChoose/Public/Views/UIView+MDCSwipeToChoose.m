//
// UIView+MDCSwipeToChoose.m
//
// Copyright (c) 2014 to present, Brian Gesiak @modocache
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "UIView+MDCSwipeToChoose.h"
#import "MDCSwipeToChoose.h"
#import "MDCViewState.h"
#import "MDCGeometry.h"
#import <objc/runtime.h>

const void * const MDCSwipeOptionsKey = &MDCSwipeOptionsKey;
const void * const MDCViewStateKey = &MDCViewStateKey;

@implementation UIView (MDCSwipeToChoose)

#pragma mark - Public Interface

- (void)mdc_swipeToChooseSetup:(MDCSwipeOptions *)options {
    self.mdc_options = options ? options : [MDCSwipeOptions new];
    self.mdc_viewState = [MDCViewState new];
    self.mdc_viewState.originalTransform = self.layer.transform;
    self.mdc_viewState.translation = CGPointZero;

    if (options.swipeEnabled) {
        [self mdc_setupPanGestureRecognizer];
    }
}

- (void)mdc_swipe:(MDCSwipeDirection)direction {
    [self mdc_swipeToChooseSetupIfNecessary];

    // A swipe in no particular direction "finalizes" the swipe.
    if (direction == MDCSwipeDirectionNone) {
        [self mdc_finalizePosition];
        return;
    }

    // Moves the view to the minimum point exceeding the threshold.
    // Transforms and executes pan callbacks as well.
    void (^animations)(void) = ^{
        CGPoint translation = [self mdc_translationExceedingThreshold:self.mdc_options.threshold
                                                            direction:direction];
        
        self.mdc_viewState.translation = translation;
        self.mdc_viewState.rotationDirection = MDCRotationAwayFromCenter;
        [self mdc_applyLayerTransform];
        [self mdc_executeOnPanBlockForTranslation:translation];
    };

    // Finalize upon completion of the animations.
    void (^completion)(BOOL) = ^(BOOL finished) {
        if (finished) { [self mdc_finalizePositionForDirection:direction]; }
    };

    [UIView animateWithDuration:self.mdc_options.swipeAnimationDuration
                          delay:0.0
                        options:self.mdc_options.swipeAnimationOptions
                     animations:animations
                     completion:completion];
}

- (void)mdc_exitSuperviewFromCurrentTranslationWithDuration:(NSTimeInterval)duration
                                                    options:(UIViewAnimationOptions)options
                                                 completion:(void(^)(void))completion
{
    CGPoint translation = self.mdc_viewState.translation;
    if (translation.x == 0) {
        return;
    }
    
    CGRect currentRect = self.frame;
    currentRect.origin = MDCCGPointAdd(currentRect.origin, translation);
    
    CGRect destination = MDCCGRectExtendedOutOfBounds(currentRect,
                                                      self.superview.bounds,
                                                      translation);
    self.mdc_viewState.translation = MDCCGPointSubtract(destination.origin, self.frame.origin);
    
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:options
                     animations:^{
                         [self mdc_applyLayerTransform];
                     } completion:^(BOOL finished) {
                         if (finished) {
                             [self removeFromSuperview];
                             completion();
                         }
                     }];
}

#pragma mark - Internal Methods

- (void)setMdc_options:(MDCSwipeOptions *)options {
    objc_setAssociatedObject(self, MDCSwipeOptionsKey, options, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (MDCSwipeOptions *)mdc_options {
    return objc_getAssociatedObject(self, MDCSwipeOptionsKey);
}

- (void)setMdc_viewState:(MDCViewState *)state {
    objc_setAssociatedObject(self, MDCViewStateKey, state, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (MDCViewState *)mdc_viewState {
    return objc_getAssociatedObject(self, MDCViewStateKey);
}

#pragma mark Setup

- (void)mdc_swipeToChooseSetupIfNecessary {
    if (!self.mdc_options || !self.mdc_viewState) {
        [self mdc_swipeToChooseSetup:nil];
    }
}

- (void)mdc_setupPanGestureRecognizer {
    SEL action = @selector(mdc_onSwipeToChoosePanGestureRecognizer:);
    UIPanGestureRecognizer *panGestureRecognizer =
    [[UIPanGestureRecognizer alloc] initWithTarget:self
                                            action:action];
    [self addGestureRecognizer:panGestureRecognizer];
}

#pragma mark Translation

- (void)mdc_finalizePosition {
    MDCSwipeDirection direction = [self mdc_directionOfExceededThreshold];
    [self mdc_finalizePositionForDirection:direction];
}

- (void)mdc_finalizePositionForDirection:(MDCSwipeDirection)direction {
    switch (direction) {
        case MDCSwipeDirectionRight:
        case MDCSwipeDirectionLeft: {
            [self mdc_exitSuperviewFromTranslation:self.mdc_viewState.translation];
            break;
        }
        case MDCSwipeDirectionNone:
            [self mdc_returnToOriginalCenter];
            [self mdc_executeOnPanBlockForTranslation:CGPointZero];
            break;
    }
}

- (void)mdc_returnToOriginalCenter {
    [UIView animateWithDuration:self.mdc_options.swipeCancelledAnimationDuration
                          delay:0.0
                        options:self.mdc_options.swipeCancelledAnimationOptions
                     animations:^{
                         self.layer.transform = self.mdc_viewState.originalTransform;
                     } completion:^(BOOL finished) {
                         id<MDCSwipeToChooseDelegate> delegate = self.mdc_options.delegate;
                         if ([delegate respondsToSelector:@selector(viewDidCancelSwipe:)]) {
                             [delegate viewDidCancelSwipe:self];
                         }
                     }];
}

- (void)mdc_exitSuperviewFromTranslation:(CGPoint)translation {
    MDCSwipeDirection direction = [self mdc_directionOfExceededThreshold];
    id<MDCSwipeToChooseDelegate> delegate = self.mdc_options.delegate;
    void (^onChoose)(void) = ^ {
        MDCSwipeResult *state = [MDCSwipeResult new];
        state.view = self;
        state.translation = translation;
        state.direction = direction;
        state.onCompletion = ^{
            if ([delegate respondsToSelector:@selector(view:wasChosenWithDirection:)]) {
                [delegate view:self wasChosenWithDirection:direction];
            }
        };
        self.mdc_options.onChosen(state);
    };
    if ([delegate respondsToSelector:@selector(view:shouldBeChosenWithDirection:yes:no:)]) {
        [delegate view:self shouldBeChosenWithDirection:direction yes:onChoose no:^{
            [self mdc_returnToOriginalCenter];
            if (self.mdc_options.onCancel != nil){
                self.mdc_options.onCancel(self);
            }
        }];
    } else {
        onChoose();
    }
}

- (void)mdc_executeOnPanBlockForTranslation:(CGPoint)translation {
    if (self.mdc_options.onPan) {
        CGFloat thresholdRatio = MIN(1.f, fabs(translation.x)/self.mdc_options.threshold);

        MDCSwipeDirection direction = MDCSwipeDirectionNone;
        if (translation.x > 0.f) {
            direction = MDCSwipeDirectionRight;
        } else if (translation.x < 0.f) {
            direction = MDCSwipeDirectionLeft;
        }

        MDCPanState *state = [MDCPanState new];
        state.view = self;
        state.direction = direction;
        state.thresholdRatio = thresholdRatio;
        self.mdc_options.onPan(state);
    }
}

- (void)mdc_applyLayerTransform {
    CATransform3D t = self.mdc_viewState.originalTransform;
    
    CGPoint translation = self.mdc_viewState.translation;
    t = CATransform3DTranslate(t, translation.x, translation.y, 0);
    
    CGFloat rotation = MDCDegreesToRadians(translation.x/100 * self.mdc_options.rotationFactor);
    t = CATransform3DRotate(t, self.mdc_viewState.rotationDirection * rotation, 0, 0, 1);
    
    self.layer.transform = t;
}

#pragma mark Threshold

- (CGPoint)mdc_translationExceedingThreshold:(CGFloat)threshold
                                   direction:(MDCSwipeDirection)direction {
    NSParameterAssert(direction != MDCSwipeDirectionNone);

    CGFloat offset = threshold + 1.f;
    switch (direction) {
        case MDCSwipeDirectionLeft:
            return CGPointMake(-offset, 0);
        case MDCSwipeDirectionRight:
            return CGPointMake(offset, 0);
        default:
            [NSException raise:NSInternalInconsistencyException
                        format:@"Invallid direction argument."];
            return CGPointZero;
    }
}

- (MDCSwipeDirection)mdc_directionOfExceededThreshold {
    if (self.mdc_viewState.translation.x > self.mdc_options.threshold) {
        return MDCSwipeDirectionRight;
    } else if (self.mdc_viewState.translation.x < -self.mdc_options.threshold) {
        return MDCSwipeDirectionLeft;
    } else {
        return MDCSwipeDirectionNone;
    }
}

#pragma mark Gesture Recognizer Events

- (void)mdc_onSwipeToChoosePanGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer {
    UIView *view = panGestureRecognizer.view;

    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        self.mdc_viewState.originalTransform = view.layer.transform;
        self.mdc_viewState.translation = CGPointZero;

        // If the pan gesture originated at the top half of the view, rotate the view
        // away from the center. Otherwise, rotate towards the center.
        if ([panGestureRecognizer locationInView:view].y < view.center.y) {
            self.mdc_viewState.rotationDirection = MDCRotationAwayFromCenter;
        } else {
            self.mdc_viewState.rotationDirection = MDCRotationTowardsCenter;
        }
    } else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded ||
               panGestureRecognizer.state == UIGestureRecognizerStateCancelled ||
               panGestureRecognizer.state == UIGestureRecognizerStateFailed) {
        // Either move the view back to its original position or move it off screen.
        [self mdc_finalizePosition];
    } else {
        // Update the position and transform. Then, notify any listeners of
        // the updates via the pan block.
        self.mdc_viewState.translation = [panGestureRecognizer translationInView:view];
        [self mdc_applyLayerTransform];
        [self mdc_executeOnPanBlockForTranslation:self.mdc_viewState.translation];
    }
}

@end
