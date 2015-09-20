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
        [self constructImageView];
        [self constructYesView];
        [self constructNoView];
        [self constructMaybeView];
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
    self.layer.borderColor = [UIColor colorWith8BitRed:220.f
                                                 green:220.f
                                                  blue:220.f
                                                 alpha:1.f].CGColor;
}

- (void)constructImageView {
    _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    _imageView.clipsToBounds = YES;
    [self addSubview:_imageView];
}

- (void)constructYesView {
    CGFloat width = self.imageView.frame.size.width - 2*MDCSwipeToChooseViewHorizontalPadding;
    CGFloat height = self.imageView.frame.size.height/4;
    CGRect frame = CGRectMake(MDCSwipeToChooseViewHorizontalPadding, self.imageView.frame.size.height/2 - height/2, width, height);
    if (self.options.yesImage) {
        self.yesView = [[UIImageView alloc] initWithImage:self.options.yesImage];
        self.yesView.frame = frame;
        self.yesView.contentMode = UIViewContentModeScaleAspectFit;
    } else {
        self.yesView = [[UIView alloc] initWithFrame:frame];
        [self.yesView constructBorderedLabelWithText:self.options.yesText
                                                 color:self.options.yesColor
                                                 angle:self.options.yesRotationAngle];
    }
    self.yesView.alpha = 0.f;
    [self.imageView addSubview:self.yesView];
}

- (void)constructNoView {
    CGFloat width = self.imageView.frame.size.width - 2*MDCSwipeToChooseViewHorizontalPadding;
    CGFloat height = self.imageView.frame.size.height/4;
    CGRect frame = CGRectMake(MDCSwipeToChooseViewHorizontalPadding, self.imageView.frame.size.height/2 - height/2, width, height);
    if (self.options.noImage) {
        self.noView = [[UIImageView alloc] initWithImage:self.options.noImage];
        self.noView.frame = frame;
        self.noView.contentMode = UIViewContentModeScaleAspectFit;
    } else {
        self.noView = [[UIView alloc] initWithFrame:frame];
        [self.noView constructBorderedLabelWithText:self.options.noText
                                                color:self.options.noColor
                                                angle:self.options.noRotationAngle];
    }
    self.noView.alpha = 0.f;
    [self.imageView addSubview:self.noView];
}

- (void)constructMaybeView {
    CGFloat width = self.imageView.frame.size.width - 2*MDCSwipeToChooseViewHorizontalPadding;
    CGFloat height = self.imageView.frame.size.height/4;
    CGRect frame = CGRectMake(MDCSwipeToChooseViewHorizontalPadding, self.imageView.frame.size.height/2 - height/2, width, height);
    if (self.options.maybeImage) {
        self.maybeView = [[UIImageView alloc] initWithImage:self.options.maybeImage];
        self.maybeView.frame = frame;
        self.maybeView.contentMode = UIViewContentModeScaleAspectFit;
    } else {
        self.maybeView = [[UIView alloc] initWithFrame:frame];
        [self.maybeView constructBorderedLabelWithText:self.options.maybeText
                                                 color:self.options.maybeColor
                                                 angle:self.options.maybeRotationAngle];
  }
  self.maybeView.alpha = 0.f;
  [self.imageView addSubview:self.maybeView];
}

- (void)setupSwipeToChoose {
    MDCSwipeOptions *options = [MDCSwipeOptions new];
    options.delegate = self.options.delegate;
    options.threshold = self.options.threshold;

    __block UIView *yesImageView = self.yesView;
    __block UIView *noImageView = self.noView;
    __block UIView *maybeImageView = self.maybeView;

    __weak MDCSwipeToChooseView *weakself = self;
    options.onPan = ^(MDCPanState *state) {
        if (state.direction == MDCSwipeDirectionNone) {
            yesImageView.alpha = 0.f;
            noImageView.alpha = 0.f;
            maybeImageView.alpha = 0.f;
        } else if (state.direction == MDCSwipeDirectionLeft) {
            yesImageView.alpha = 0.f;
            noImageView.alpha = state.thresholdRatio;
            maybeImageView.alpha = 0.f;
        } else if (state.direction == MDCSwipeDirectionRight) {
            yesImageView.alpha = state.thresholdRatio;
            noImageView.alpha = 0.f;
            maybeImageView.alpha = 0.f;
        }
        else if (state.direction == MDCSwipeDirectionVertical) {
            yesImageView.alpha = 0.f;
            noImageView.alpha = 0.f;
            maybeImageView.alpha = state.thresholdRatio;
        }

        if (weakself.options.onPan) {
            weakself.options.onPan(state);
        }
    };

    [self mdc_swipeToChooseSetup:options];
}

@end
