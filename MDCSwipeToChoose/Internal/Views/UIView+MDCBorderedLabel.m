//
// UIView+MDCBorderedLabel.m
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

#import "UIView+MDCBorderedLabel.h"
#import "MDCGeometry.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView (MDCBorderedLabel)

- (void)constructBorderedLabelWithText:(NSString *)text
                                 color:(UIColor *)color
                                 angle:(CGFloat)angle {
    [self constructBorderedLabelWithText:text color:color angle:angle borderWidth:nil font:nil];
}

- (void)constructBorderedLabelWithText:(NSString *)text color:(UIColor *)color angle:(CGFloat)angle borderWidth:(NSNumber *)borderWidth font:(UIFont *)font
{
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = borderWidth ? [borderWidth floatValue] : 5.f;
    self.layer.cornerRadius = 10.f;

    UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
    label.text = [text uppercaseString];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = font ? font : [UIFont fontWithName:@"HelveticaNeue-CondensedBlack"
                                 size:48.f];
    label.textColor = color;
    [self addSubview:label];

    self.transform = CGAffineTransformRotate(CGAffineTransformIdentity,
                                             MDCDegreesToRadians(angle));
}

@end
