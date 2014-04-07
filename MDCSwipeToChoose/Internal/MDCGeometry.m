//
// MDCGeometry.m
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

#import "MDCGeometry.h"

#pragma mark - Public Interface

CGPoint MDCCGPointAdd(const CGPoint a, const CGPoint b) {
    return CGPointMake(a.x + b.x,
                       a.y + b.y);
}

CGPoint MDCCGPointSubtract(const CGPoint minuend, const CGPoint subtrahend) {
    return CGPointMake(minuend.x - subtrahend.x,
                       minuend.y - subtrahend.y);
}

CGFloat MDCDegreesToRadians(const CGFloat degrees) {
    return degrees * (M_PI/180.0);
}

CGRect MDCCGRectExtendedOutOfBounds(const CGRect rect,
                                    const CGRect bounds,
                                    const CGPoint translation) {
    CGRect destination = rect;
    while (!CGRectIsNull(CGRectIntersection(bounds, destination))) {
        destination = CGRectMake(CGRectGetMinX(destination) + translation.x,
                                 CGRectGetMinY(destination) + translation.y,
                                 CGRectGetWidth(destination),
                                 CGRectGetHeight(destination));
    }

    return destination;
}
