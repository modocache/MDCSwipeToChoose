//
// UIView+MDCSwipeToChoose.h
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

@class MDCSwipeOptions;

/*!
 * The `UIView (MDCSwipeToChoose)` category adds a pan gesture recognizer
 * to any view, via the `mdc_swipeToChooseSetup:` method. By specifying
 * blocks to be executed when the view is panned via an instance of
 * `MDCSwipeOptions`, you may add custom behavior based on the panning motion.
 *
 * This is a more generic version of the `MDCSwipeToChooseView` class.
 */
@interface UIView (MDCSwipeToChoose)

/*!
 * Adds swipe-to-choose functionality to an instance of `UIView`.
 * You may customize the selection threshold and other parameters by
 * setting the corresponding settings on the `options` argument.
 * Passing `nil` for the `options` parameter configures the view with
 * the default set of options.
 */
- (void)mdc_swipeToChooseSetup:(MDCSwipeOptions *)options;

/*!
 * Programmatically swipes the view in the direction specified.
 *
 * Specifying a direction of MDCSwipeDirectionNone swipes the view
 * if the swipe threshold is currently exceeded, and returns it to
 * its original position otherwise.
 *
 * If you haven't called `mdc_swipeToChooseSetup:` already, this will call
 * that method and perform setup using the default set of options.
 */
- (void)mdc_swipe:(MDCSwipeDirection)direction;

@end
