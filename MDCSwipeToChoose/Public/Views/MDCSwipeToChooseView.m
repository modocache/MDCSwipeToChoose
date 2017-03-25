//
// MDCSwipeToChooseView.m
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

#import "MDCSwipeToChooseView.h"
#import "MDCSwipeToChoose.h"
#import "MDCGeometry.h"
#import "UIView+MDCBorderedLabel.h"
#import "UIColor+MDCRGB8Bit.h"
#import <QuartzCore/QuartzCore.h>

static CGFloat const MDCSwipeToChooseViewHorizontalPadding = 10.f;
static CGFloat const MDCSwipeToChooseViewTopPadding = 20.f;
static CGFloat const MDCSwipeToChooseViewImageTopPadding = 100.f;
static CGFloat const MDCSwipeToChooseViewLabelWidth = 65.f;

@interface MDCSwipeToChooseView ()
@property (nonatomic, strong) MDCSwipeToChooseViewOptions *options;
@end

@implementation MDCSwipeToChooseView

#pragma mark - Object Lifecycle

- (instancetype)initWithFrame:(CGRect)frame options:(MDCSwipeToChooseViewOptions *)options {
    self = [super initWithFrame:frame];
    if (self) {
        _options = options ? options : [MDCSwipeToChooseViewOptions new];
        [self setupView];
        [self constructContentView];
        [self constructLikedView];
        [self constructNopeView];
        [self setupSwipeToChoose];
    }
    return self;
}

#pragma mark - Internal Methods

- (void)setupView {
    self.backgroundColor = [UIColor clearColor];
    self.layer.cornerRadius = 5.f;
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = 2.f;
    self.layer.borderColor = [UIColor mdc_colorWith8BitRed:220.f
                                                 green:220.f
                                                  blue:220.f
                                                 alpha:1.f].CGColor;
}

- (void)constructContentView {
    _contentView = [[UIView alloc] initWithFrame:self.bounds];
    _contentView.clipsToBounds = YES;
    [self addSubview:_contentView];
}

- (void)constructLikedView {
    CGFloat yOrigin = (self.options.likedImage ? MDCSwipeToChooseViewImageTopPadding : MDCSwipeToChooseViewTopPadding);

    CGRect frame = CGRectMake(MDCSwipeToChooseViewHorizontalPadding,
                              yOrigin,
                              CGRectGetMidX(self.contentView.bounds),
                              MDCSwipeToChooseViewLabelWidth);
    if (self.options.likedImage) {
        self.likedView = [[UIImageView alloc] initWithImage:self.options.likedImage];
        self.likedView.frame = frame;
        self.likedView.contentMode = UIViewContentModeScaleAspectFit;
    } else {
        self.likedView = [[UIView alloc] initWithFrame:frame];
        [self.likedView constructBorderedLabelWithText:self.options.likedText
                                                 color:self.options.likedColor
                                                  font:self.options.likedFont
                                                 angle:self.options.likedRotationAngle];
    }
    self.likedView.alpha = 0.f;
    [self.contentView addSubview:self.likedView];
}

- (void)constructNopeView {
    CGFloat width = CGRectGetMidX(self.contentView.bounds);
    CGFloat xOrigin = CGRectGetMaxX(self.contentView.bounds) - width - MDCSwipeToChooseViewHorizontalPadding;
    CGFloat yOrigin = (self.options.nopeImage ? MDCSwipeToChooseViewImageTopPadding : MDCSwipeToChooseViewTopPadding);
    CGRect frame = CGRectMake(xOrigin,
                              yOrigin,
                              width,
                              MDCSwipeToChooseViewLabelWidth);
    if (self.options.nopeImage) {
        self.nopeView = [[UIImageView alloc] initWithImage:self.options.nopeImage];
        self.nopeView.frame = frame;
        self.nopeView.contentMode = UIViewContentModeScaleAspectFit;
    } else {
        self.nopeView = [[UIView alloc] initWithFrame:frame];
        [self.nopeView constructBorderedLabelWithText:self.options.nopeText
                                                color:self.options.nopeColor
                                                 font:self.options.nopeFont
                                                angle:self.options.nopeRotationAngle];
    }
    self.nopeView.alpha = 0.f;
    [self.contentView addSubview:self.nopeView];
}

- (void)setupSwipeToChoose {
    MDCSwipeOptions *options = [MDCSwipeOptions new];
    options.delegate = self.options.delegate;
    options.threshold = self.options.threshold;
    options.swipeEnabled = self.options.swipeEnabled;

    __block UIView *likedImageView = self.likedView;
    __block UIView *nopeImageView = self.nopeView;
    __weak MDCSwipeToChooseView *weakself = self;
    options.onPan = ^(MDCPanState *state) {
        if (state.direction == MDCSwipeDirectionNone) {
            likedImageView.alpha = 0.f;
            nopeImageView.alpha = 0.f;
        } else if (state.direction == MDCSwipeDirectionLeft) {
            likedImageView.alpha = 0.f;
            nopeImageView.alpha = state.thresholdRatio;
        } else if (state.direction == MDCSwipeDirectionRight) {
            likedImageView.alpha = state.thresholdRatio;
            nopeImageView.alpha = 0.f;
        }

        if (weakself.options.onPan) {
            weakself.options.onPan(state);
        }
    };

    [self mdc_swipeToChooseSetup:options];
}

@end
