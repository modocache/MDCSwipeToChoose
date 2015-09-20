//
// MDCSwipeToChooseViewOptions.h
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

#import <Foundation/Foundation.h>
#import "MDCSwipeOptions.h"

/*!
 * `MDCSwipeToChooseViewOptions` may be used to customize the behavior and
 * appearance of a `MDCSwipeToChooseView`.
 */
@interface MDCSwipeToChooseViewOptions : NSObject

/*!
 * The delegate that receives messages pertaining to the swipe choices of the view.
 */
@property (nonatomic, weak) id<MDCSwipeToChooseDelegate> delegate;

/*!
 * The text displayed in the `yesView`. A default value is provided in the
 * `-init` method.
 */
@property (nonatomic, copy) NSString *yesText;

/*!
 * The color of the text and border of the `yesView`. A default value is provided in the
 * `-init` method.
 */
@property (nonatomic, strong) UIColor *yesColor;

/*!
 * The image used to displayed in the `yesView`. If this is present, it will take
 * precedence over the yesText
 */
@property (nonatomic, strong) UIImage *yesImage;

/*!
 * The rotation angle of the `yesView`. A default value is provided in the
 * `-init` method.
 */
@property (nonatomic, assign) CGFloat yesRotationAngle;

/*!
 * The text displayed in the `noView`. A default value is provided in the
 * `-init` method.
 */
@property (nonatomic, copy) NSString *noText;

/*!
 * The color of the text and border of the `noView`. A default value is provided in the
 * `-init` method.
 */
@property (nonatomic, strong) UIColor *noColor;

/*!
 * The image used to displayed in the `noView`. If this is present, it will take
 * precedence over the noText
 */
@property (nonatomic, strong) UIImage *noImage;

/*!
 * The rotation angle of the `noView`. A default value is provided in the
 * `-init` method.
 */
@property (nonatomic, assign) CGFloat noRotationAngle;

/*!
 * The text displayed in the `noView`. A default value is provided in the
 * `-init` method.
 */
@property (nonatomic, copy) NSString *maybeText;

/*!
 * The color of the text and border of the `maybeView`. A default value is provided in the
 * `-init` method.
 */
@property (nonatomic, strong) UIColor *maybeColor;

/*!
 * The image used to displayed in the `maybeView`. If this is present, it will take
 * precedence over the noText
 */
@property (nonatomic, strong) UIImage *maybeImage;

/*!
 * The rotation angle of the `maybeView`. A default value is provided in the
 * `-init` method.
 */
@property (nonatomic, assign) CGFloat maybeRotationAngle;

/*!
 * The distance, in pixels, that a view must be panned in order to constitue a selection.
 * For example, if the `threshold` is `100.f`, panning the view `101.f` pixels to the right
 * is considered a selection in the `MDCSwipeDirectionRight` direction. A default value is
 * provided in the `-init` method.
 */
@property (nonatomic, assign) CGFloat threshold;

/*!
 * A callback to be executed when the view is panned. The block takes an instance of
 * `MDCPanState` as an argument. Use this `state` instance to determine the pan direction
 * and the distance until the threshold is reached.
 */
@property (nonatomic, copy) MDCSwipeToChooseOnPanBlock onPan;

@end
