//
//  MDCSwipeOptions.m
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

#import "MDCSwipeOptions.h"
#import "MDCSwipeToChoose.h"
#import "MDCGeometry.h"

@implementation MDCSwipeOptions

#pragma mark - Object Lifecycle

- (instancetype)init {
    self = [super init];
    if (self) {
        _swipeCancelledAnimationDuration = 0.2;
        _swipeCancelledAnimationOptions = UIViewAnimationOptionCurveEaseOut;
        _swipeAnimationDuration = 0.1;
        _swipeAnimationOptions = UIViewAnimationOptionCurveEaseIn;
        _rotationFactor = 3.f;

        _onChosen = [[self class] exitScreenOnChosenWithDuration:0.1
                                                         options:UIViewAnimationOptionCurveLinear];
    }
    return self;
}

#pragma mark - Public Interface

+ (MDCSwipeToChooseOnChosenBlock)exitScreenOnChosenWithDuration:(NSTimeInterval)duration
                                                        options:(UIViewAnimationOptions)options {
    return ^(MDCSwipeResult *state) {
        CGRect destination = MDCCGRectExtendedOutOfBounds(state.view.frame,
                                                          state.view.superview.bounds,
                                                          state.translation);
        [UIView animateWithDuration:duration
                              delay:0.0
                            options:options
                         animations:^{
                             state.view.frame = destination;
                         } completion:^(BOOL finished) {
                             if (finished) {
                                 [state.view removeFromSuperview];
                                 state.onCompletion();
                             }
                         }];
    };
}

@end
