//
// MDCSwipeOptions.h
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

@class MDCPanState;
@class MDCSwipeResult;
@protocol MDCSwipeToChooseDelegate;

typedef void (^MDCSwipeToChooseOnPanBlock)(MDCPanState *state);
typedef void (^MDCSwipeToChooseOnChosenBlock)(MDCSwipeResult *state);

/*!
 * A set of options used to customize the behavior of the
 * `UIView (MDCSwipeToChoose)` category.
 */
@interface MDCSwipeOptions : NSObject

/*!
 * The delegate that receives messages pertaining to the swipe choices of the view.
 */
@property (nonatomic, weak) id<MDCSwipeToChooseDelegate> delegate;

/*!
 * The duration of the animation that occurs when a swipe is cancelled. By default, this
 * animation simply slides the view back to its original position. A default value is
 * provided in the `-init` method.
 */
@property (nonatomic, assign) NSTimeInterval swipeCancelledAnimationDuration;

/*!
 * Animation options for the swipe-cancelled animation. Default values are provided in the
 * `-init` method.
 */
@property (nonatomic, assign) UIViewAnimationOptions swipeCancelledAnimationOptions;

/*!
 * THe duration of the animation that moves a view to its threshold, caused when `mdc_swipe:`
 * is called. A default value is provided in the `-init` method.
 */
@property (nonatomic, assign) NSTimeInterval swipeAnimationDuration;

/*!
 * Animation options for the animation that moves a view to its threshold, caused when
 * `mdc_swipe:` is called. A default value is provided in the `-init` method.
 */
@property (nonatomic, assign) UIViewAnimationOptions swipeAnimationOptions;

/*!
 * The distance, in pixels, that a view must be panned in order to constitue a selection.
 * For example, if the `threshold` is `100.f`, panning the view `101.f` pixels to the right
 * is considered a selection in the `MDCSwipeDirectionRight` direction. A default value is
 * provided in the `-init` method.
 */
@property (nonatomic, assign) CGFloat threshold;

/*!
 * When a view is panned, it is rotated slightly. Adjust this value to increase or decrease
 * the angle of rotation.
 */
@property (nonatomic, assign) CGFloat rotationFactor;

/*!
 * A callback to be executed when the view is panned. The block takes an instance of
 * `MDCPanState` as an argument. Use this `state` instance to determine the pan direction
 * and the distance until the threshold is reached.
 */
@property (nonatomic, copy) MDCSwipeToChooseOnPanBlock onPan;

/*!
 * A callback to be executed when the view is swiped and chosen. The default
 is the block returned by the `-exitScreenOnChosenWithDuration:block:` method.

 @warning that this block must execute the `MDCSwipeResult` argument's `onCompletion`
 block in order to properly notify the delegate of the swipe result.
 */
@property (nonatomic, copy) MDCSwipeToChooseOnChosenBlock onChosen;

/*!
 * The default callback for when a view is swiped an chosen. This callback moves the view
 * outside of the bounds of its parent view, then removes it from the view hierarchy.
 */
+ (MDCSwipeToChooseOnChosenBlock)exitScreenOnChosenWithDuration:(NSTimeInterval)duration
                                                        options:(UIViewAnimationOptions)options;

@end
