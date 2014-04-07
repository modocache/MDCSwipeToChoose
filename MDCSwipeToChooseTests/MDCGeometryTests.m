//
// MDCGeometryTests.m
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

#import <XCTest/XCTest.h>
#import "MDCGeometry.h"

@interface MDCGeometryTests : XCTestCase
@property (nonatomic, assign) double desiredAccuracy;
@end

@implementation MDCGeometryTests

- (void)setUp {
    [super setUp];
    self.desiredAccuracy = 0.000001;
}

- (void)testMDCDegreesToRadiansRightAngles {
    XCTAssertEqualWithAccuracy(MDCDegreesToRadians(90), M_PI_2, self.desiredAccuracy,
                               @"Expected 90° to equal π/2 radians.");
    XCTAssertEqualWithAccuracy(MDCDegreesToRadians(180), M_PI, self.desiredAccuracy,
                               @"Expected 180° to equal π radians.");
}

- (void)testMDCDegreesToRadiansNonRightAngles {
    XCTAssertEqualWithAccuracy(MDCDegreesToRadians(30), M_PI_2/3.0, self.desiredAccuracy,
                               @"Expected 30° to equal π/6 radians.");
    XCTAssertEqualWithAccuracy(MDCDegreesToRadians(45), M_PI_4, self.desiredAccuracy,
                               @"Expected 45° to equal 2π/3 radians.");
    XCTAssertEqualWithAccuracy(MDCDegreesToRadians(120), (2 * M_PI)/3.0, self.desiredAccuracy,
                               @"Expected 120° to equal 2π/3 radians.");
}

- (void)testMDCDegreesToRadiansArbitraryAngles {
    XCTAssertEqualWithAccuracy(MDCDegreesToRadians(7), 0.122173048, self.desiredAccuracy,
                               @"Expected approximately correct radian conversion.");
    XCTAssertEqualWithAccuracy(MDCDegreesToRadians(892), 15.5683369, self.desiredAccuracy,
                               @"Expected approximately correct radian conversion.");
}

@end
