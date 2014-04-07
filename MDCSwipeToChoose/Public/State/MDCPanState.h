//
// MDCPanState.h
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

#import <UIKit/UIKit.h>
#import "MDCSwipeDirection.h"

/*!
 * An object representing the state of the current pan gesture.
 * This is provided as an argument to `MDCSwipeToChooseOnPanBlock` callbacks.
 */
@interface MDCPanState : NSObject

/*!
 * The view being panned.
 */
@property (nonatomic, strong) UIView *view;

/*!
 * The direction of the current pan. Note that a direction of `MDCSwipeDirectionRight`
 * does not imply that the threshold has been reached.
 */
@property (nonatomic, assign) MDCSwipeDirection direction;

/*!
 * The ratio of the threshold that has been reached. This can take on any value
 * between `0.0f` and `1.0f`, with `1.0f` meaning the threshold has been reached.
 * A `thresholdRatio` of `1.0f` implies that were the user to end the pan gesture,
 * the current direction would be chosen.
 */
@property (nonatomic, assign) CGFloat thresholdRatio;

@end
