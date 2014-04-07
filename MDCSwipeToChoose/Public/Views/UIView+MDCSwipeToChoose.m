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

    [self mdc_setupPanGestureRecognizer];
}

#pragma mark - Internal Methods

- (void)mdc_setupPanGestureRecognizer {
    SEL action = @selector(mdc_onSwipeToChoosePanGestureRecognizer:);
    UIPanGestureRecognizer *panGestureRecognizer =
        [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                action:action];
    [self addGestureRecognizer:panGestureRecognizer];
}

#pragma mark Internal Properties

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

#pragma mark Gesture Recognizer Events

- (void)mdc_onSwipeToChoosePanGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer {
    UIView *view = panGestureRecognizer.view;

    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        self.mdc_viewState.originalCenter = view.center;

        // If the pan gesture originated at the top half of the view, rotate the view
        // counter-clockwise, i.e.: away from the origin.
        CGPoint panOrigin = [panGestureRecognizer locationInView:view];
        self.mdc_viewState.rotationDirection = panOrigin.y > view.center.y ? -1 : 1;
    } else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        // Either move the view back to its original position or move it off screen.
        [self mdc_finalizePositionAgainstThreshold:self.mdc_options.threshold];
    } else {
        // Update the position and transform. Then, notify any listeners of
        // the updates via the pan block.
        CGPoint translation = [panGestureRecognizer translationInView:view];
        view.center = MDCCGPointAdd(self.mdc_viewState.originalCenter, translation);
        view.transform = CGAffineTransformRotate(CGAffineTransformIdentity,
                                                 [self mdc_rotationForTranslation:translation]);
        [self mdc_executeOnPanBlockForTranslation:translation];
    }
}

#pragma mark Other

- (void)mdc_finalizePositionAgainstThreshold:(CGFloat)threshold {
    CGPoint translation = MDCCGPointSubtract(self.center, self.mdc_viewState.originalCenter);

    MDCSwipeDirection direction = [self mdc_exceededThresholdDirection:threshold];
    switch (direction) {
        case MDCSwipeDirectionRight:
        case MDCSwipeDirectionLeft:
            [self mdc_exitSuperviewWithTranslation:translation direction:direction];
            break;
        case MDCSwipeDirectionNone:
            [self mdc_returnToCenter:self.mdc_viewState.originalCenter
                            duration:self.mdc_options.swipeCancelledAnimationDuration
                             options:self.mdc_options.swipeCancelledAnimationOptions];
            [self mdc_executeOnPanBlockForTranslation:CGPointZero];
            break;
    }
}

- (void)mdc_returnToCenter:(CGPoint)center
                  duration:(NSTimeInterval)duration
                   options:(UIViewAnimationOptions)options {
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:options
                     animations:^{
                         self.transform = CGAffineTransformIdentity;
                         self.center = center;
                     } completion:^(BOOL finished) {
                         id<MDCSwipeToChooseDelegate> delegate = self.mdc_options.delegate;
                         if ([delegate respondsToSelector:@selector(viewDidCancelSwipe:)]) {
                             [delegate viewDidCancelSwipe:self];
                         }
                     }];
}

- (void)mdc_exitSuperviewWithTranslation:(CGPoint)translation
                               direction:(MDCSwipeDirection)direction {
    id<MDCSwipeToChooseDelegate> delegate = self.mdc_options.delegate;
    if ([delegate respondsToSelector:@selector(view:shouldBeChosenWithDirection:)]) {
        BOOL should = [delegate view:self shouldBeChosenWithDirection:direction];
        if (!should) {
            return;
        }
    }

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
}

- (MDCSwipeDirection)mdc_exceededThresholdDirection:(CGFloat)threshold {
    if (self.center.x > self.mdc_viewState.originalCenter.x + threshold) {
        return MDCSwipeDirectionRight;
    } else if (self.center.x < self.mdc_viewState.originalCenter.x - threshold) {
        return MDCSwipeDirectionLeft;
    } else {
        return MDCSwipeDirectionNone;
    }
}

- (CGFloat)mdc_rotationForTranslation:(CGPoint)translation {
    CGFloat rotation = MDCDegreesToRadians(translation.x/100 * self.mdc_options.rotationFactor);
    return self.mdc_viewState.rotationDirection * rotation;
}

- (void)mdc_executeOnPanBlockForTranslation:(CGPoint)translation {
    if (self.mdc_options.onPan) {
        CGFloat thresholdRatio = MIN(1.f, fabsf(translation.x)/self.mdc_options.threshold);

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

@end
