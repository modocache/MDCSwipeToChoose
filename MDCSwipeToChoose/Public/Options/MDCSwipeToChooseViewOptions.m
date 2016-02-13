//
// MDCSwipeToChooseViewOptions.m
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

#import "MDCSwipeToChooseViewOptions.h"
#import "UIColor+MDCRGB8Bit.h"

@implementation MDCSwipeToChooseViewOptions

- (instancetype)init {
    self = [super init];
    if (self) {
        _likedText = [NSLocalizedString(@"liked", nil) uppercaseString];
        _likedColor = [UIColor colorWith8BitRed:29.f green:245.f blue:106.f alpha:1.f];
        _likedRotationAngle = -15.f;
        _likedTextSize = 48.f;
        
        _nopeText = [NSLocalizedString(@"nope", nil) uppercaseString];
        _nopeColor = [UIColor colorWith8BitRed:247.f green:91.f blue:37.f alpha:1.f];
        _nopeRotationAngle = 15.f;
        _nopeTextSize = 48.f;
        
        _threshold = 100.f;
    }
    return self;
}

@end
