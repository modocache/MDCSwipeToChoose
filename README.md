# MDCSwipeToChoose

[![Build Status](https://travis-ci.org/modocache/MDCSwipeToChoose.svg?branch=master)](https://travis-ci.org/modocache/MDCSwipeToChoose)

Swipe to "like" or "dislike" any view, just like Tinder.app. Build a flashcard app, a photo viewer, and more, in minutes, not hours!

- Use `UIView+MDCSwipeToChoose` to add a swipe gesture and callbacks to any `UIView`.
- Use `MDCSwipeToChooseView` to get a UI nearly identical to Tinder.app in just a few lines of code.

![](http://cl.ly/image/0M1j1J0E0s3G/MDCSwipeToChoose-v0.2.0.gif)

You may view slides on some the architecture decisions that went into this library [here](http://modocache.io/ios-ui-component-api-design).

## How to Install via CocoaPods

Place the following in your Podfile and run `pod install`:

```objc
pod "MDCSwipeToChoose"
```

## How to Use

Check out [the sample app](https://github.com/modocache/MDCSwipeToChoose/tree/master/Examples/LikedOrNope) for an example of how to use `MDCSwipeToChooseView` to build the UI in the GIF above.

> **NOTE:** You must run `pod install` in the `Examples/LikedOrNope` directory before building the example app.

Every public class contains documentation in its header file.

### Swiping Yes/No

The following is an example of how you can use `MDCSwipeToChooseView` to display a photo. The user can choose to delete it by swiping left, or save it by swiping right.

#### Objective-c

```objc
#import <MDCSwipeToChoose/MDCSwipeToChoose.h>

// ... in a view controller

#pragma mark - Creating and Customizing a MDCSwipeToChooseView

- (void)viewDidLoad {
    [super viewDidLoad];

    // You can customize MDCSwipeToChooseView using MDCSwipeToChooseViewOptions.
    MDCSwipeToChooseViewOptions *options = [MDCSwipeToChooseViewOptions new];
    options.delegate = self;
    options.likedText = @"Keep";
    options.likedColor = [UIColor blueColor];
    options.nopeText = @"Delete";
    options.onPan = ^(MDCPanState *state){
        if (state.thresholdRatio == 1.f && state.direction == MDCSwipeDirectionLeft) {
            NSLog(@"Let go now to delete the photo!");
        }
    };

    MDCSwipeToChooseView *view = [[MDCSwipeToChooseView alloc] initWithFrame:self.view.bounds
                                                                     options:options];
    view.imageView.image = [UIImage imageNamed:@"photo"];
    [self.view addSubview:view];
}

#pragma mark - MDCSwipeToChooseDelegate Callbacks

// This is called when a user didn't fully swipe left or right.
- (void)viewDidCancelSwipe:(UIView *)view {
    NSLog(@"Couldn't decide, huh?");
}

// Sent before a choice is made. Cancel the choice by returning `NO`. Otherwise return `YES`.
- (BOOL)view:(UIView *)view shouldBeChosenWithDirection:(MDCSwipeDirection)direction {
    if (direction == MDCSwipeDirectionLeft) {
        return YES;
    } else {
        // Snap the view back and cancel the choice.
        [UIView animateWithDuration:0.16 animations:^{
            view.transform = CGAffineTransformIdentity;
            view.center = [view superview].center;
        }];
        return NO;
    }
}

// This is called then a user swipes the view fully left or right.
- (void)view:(UIView *)view wasChosenWithDirection:(MDCSwipeDirection)direction {
    if (direction == MDCSwipeDirectionLeft) {
        NSLog(@"Photo deleted!");
    } else {
        NSLog(@"Photo saved!");
    }
}
```

As of version 0.2.0, you may also swipe a view programmatically:

```objc
[self.swipeToChooseView mdc_swipe:MDCSwipeDirectionLeft];
```

#### Swift

To use objective-c code from swift, you need to use bridging-header.

```BridgingHeader
#ifndef BridgingHeader_h
#define BridgingHeader_h

#import <UIKit/UIKit.h>
#import <MDCSwipeToChoose/MDCSwipeToChoose.h>

#endif

```

```swift
import UIKit

// ... in a view controller

override func viewDidLoad() {
    super.viewDidLoad()

    var options = MDCSwipeToChooseViewOptions()
    options.delegate = self
    options.likedText = "Keep"
    options.likedColor = UIColor.blueColor()
    options.nopeText = "Delete"
    options.onPan = { state -> Void in
        if state.thresholdRatio == 1 && state.direction == MDCSwipeDirection.Left {
            println("Photo deleted!")
        }
    }

    var view = MDCSwipeToChooseView(frame: self.view.bounds, options: options)
    view.imageView.image = UIImage(named: "photo.png")
    self.view.addSubview(view)
}

override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
}

// This is called when a user didn't fully swipe left or right.
func viewDidCancelSwipe(view: UIView) -> Void{
    println("Couldn't decide, huh?")
}

// Sent before a choice is made. Cancel the choice by returning `false`. Otherwise return `true`.
func view(view: UIView, shouldBeChosenWithDirection: MDCSwipeDirection) -> Bool{
    if (shouldBeChosenWithDirection == MDCSwipeDirection.Left) {
        return true;
    } else {
        // Snap the view back and cancel the choice.
        UIView.animateWithDuration(0.16, animations: { () -> Void in
            view.transform = CGAffineTransformIdentity
            view.center = view.superview!.center
        })
        return false;
    }
}

// This is called then a user swipes the view fully left or right.
func view(view: UIView, wasChosenWithDirection: MDCSwipeDirection) -> Void{
    if wasChosenWithDirection == MDCSwipeDirection.Left {
        println("Photo deleted!")
    }else{
        println("Photo saved!")
    }
}

```

## More Generic Swiping

You don't have to use a subclass of `MDCChooseView`. You can use the `mdc_swipeToChooseSetup:` method on any `UIView` to enable swipe-to-choose.

In the following example, we adjust the opacity of a `UIWebView` when it's panned left and right.

```objc
#import <MDCSwipeToChoose/MDCSwipeToChoose.h>

// ... in a view controller

- (void)viewDidLoad {
    [super viewDidLoad];

    MDCSwipeOptions *options = [MDCSwipeOptions new];
    options.delegate = self;
    options.onPan = ^(MDCPanState *state){
        switch (state.direction) {
            case MDCSwipeDirectionLeft:
                self.webView.alpha = 0.5f - state.thresholdRatio;
                break;
            case MDCSwipeDirectionRight:
                self.webView.alpha = 0.5f + state.thresholdRatio;
                break;
            case MDCSwipeDirectionNone:
                self.webView.alpha = 0.5f;
                break;
        }
    };
    [self.webView mdc_swipeToChooseSetup:options];
}
```
##Swiping in Swift


The following is an example of how you can use `MDCSwipeToChooseView` to display a photo in swift. The user can choose to delete it by swiping left, or save it by swiping right.

First you must create a BridgingHeader.h file
```objc
#ifndef ProjectName_BridgingHeader_h
#define ProjectName_BridgingHeader_h


#import <UIKit/UIKit.h>
#import <MDCSwipeToChoose/MDCSwipeToChoose.h>

#endif
```
You must then add the bridging header file to the project by navigating to Build Settings then searching for 'Bridging Header'. Double click the field and type: ProjectName/BridgingHeader.h as the value

```swift
// Creating and Customizing a MDCSwipeToChooseView

override func viewDidLoad(){
    super.viewDidLoad()

    // You can customize MDCSwipeToChooseView using MDCSwipeToChooseViewOptions.
    var options:MDCSwipeToChooseViewOptions = MDCSwipeToChooseViewOptions()
    options.delegate = self
    options.likedText = "Keep"
    options.likedColor = [UIColor blueColor]
    options.nopeText = "Delete"
    options.onPan = { state -> Void in
    if (state.thresholdRatio == 1.0 && state.direction == MDCSwipeDirection.Left) {
        Println("Let go now to delete the photo!")
    }
}

var view:MDCSwipeToChooseView = MDCSwipeToChooseView(frame:self.view.bounds, options:options)
    view.imageView.image = UIImage(named:"photo")
    self.view.addSubview(view)
}

// MDCSwipeToChooseDelegate Callbacks

// This is called when a user didn't fully swipe left or right.
func viewDidCancelSwipe(view: UIView) -> Void{
    Println("Couldn't decide, huh?")
}

// Sent before a choice is made. Cancel the choice by returning `NO`. Otherwise return `YES`.
func view(view:UIView, shouldBeChosenWithDirection:MDCSwipeDirection) -> BOOL {
    if (shouldBeChosenWithDirection == MDCSwipeDirection.Left) {
        return YES;
    } else {
        // Snap the view back and cancel the choice.
        UIView.animateWithDuration(0.16, animations: {
        view.transform = CGAffineTransformIdentity
        view.center = self.superview.center
        }
    return NO;
    }
}

// This is called then a user swipes the view fully left or right.
func view(view: UIView, wasChosenWithDirection: MDCSwipeDirection) -> Void{
    if (wasChosenWithDirection == MDCSwipeDirection.Left) {
        Println("Photo deleted!");
    } else {
        Println("Photo saved!");
    }
}
```

As of version 0.2.0, you may also swipe a view programmatically:

```objc
self.swipeToChooseView(mdc_swipe:MDCSwipeDirection.Left)
```


## License

All the source code is distributed under the [MIT license](http://www.opensource.org/licenses/mit-license.php). See the LICENSE file for details. The license does not apply to the images used in the sample apps.
