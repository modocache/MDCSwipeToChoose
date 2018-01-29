//
//  MDCSwipeToChooseDelegate.h
//  MDCSwipeToChoose
//
//  Created by Brian Ivan Gesiak on 4/8/14.
//  Copyright (c) 2014 modocache. All rights reserved.
//

#import <UIKit/UIKit.h>
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
 * Sent before a choice is made. Return `no` to prevent the choice from being made,
 * and `yes` otherwise.
 */
- (void)view:(UIView *)view shouldBeChosenWithDirection:(MDCSwipeDirection)direction
         yes:(void (^)(void))yes
          no:(void (^)(void))no;

/*!
 * Sent after a choice is made. When using the default `MDCSwipeOptions`, the `view`
 * is removed from the view hierarchy by the time this message is sent.
 */
- (void)view:(UIView *)view wasChosenWithDirection:(MDCSwipeDirection)direction;

//MARK:- Change By SimformSolutions, To send the current position of view to controller

/*!
 * Sent the view point to controller.
 * send when user move the view
 */
-(void)view:(UIView *)view wasChosenWithPosition:(CGPoint)points;
@end
