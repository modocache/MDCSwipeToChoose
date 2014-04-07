//
//  MDCSwipeToChooseDelegate.h
//  MDCSwipeToChoose
//
//  Created by Brian Ivan Gesiak on 4/8/14.
//  Copyright (c) 2014 modocache. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDCSwipeDirection.h"

/*!
 * Classes that adopt the `MDCSwipeToChooseDelegate` protcol may respond to
 * swipe events, such as when a view has been swiped and chosen, or when a
 * swipe has been cancelled and no choice has been made.
 *
 * To customize the animation and appearance of a MDCSwipeToChoose-based view,
 * use `MDCSwipeOptions` and the `-mdc_swipeToChooseSetup:` method.
 */
@protocol MDCSwipeToChooseDelegate <NSObject>
@optional

/*!
 * Sent when a view was not swiped past the selection threshold. The view is
 * returned to its original position before this message is sent.
 */
- (void)viewDidCancelSwipe:(UIView *)view;

/*!
 * Sent before a choice is made. Return `NO` to prevent the choice from being made,
 * and `YES` otherwise.
 */
- (BOOL)view:(UIView *)view shouldBeChosenWithDirection:(MDCSwipeDirection)direction;

/*!
 * Sent after a choice is made. When using the default `MDCSwipeOptions`, the `view`
 * is removed from the view hierarchy by the time this message is sent.
 */
- (void)view:(UIView *)view wasChosenWithDirection:(MDCSwipeDirection)direction;

@end
