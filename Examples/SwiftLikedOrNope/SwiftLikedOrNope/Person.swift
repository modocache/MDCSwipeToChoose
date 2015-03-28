//
//  Person.swift
//  SwiftLikedOrNope
//
// Copyright (c) 2014 to present, Richard Burdish @rjburdish
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

import UIKit

class Person: NSObject, Printable {
    
    let Name: NSString
    let Image: UIImage!
    let Age: NSNumber
    let NumberOfSharedFriends: NSNumber?
    let NumberOfSharedInterests: NSNumber
    let NumberOfPhotos: NSNumber
    
    override var description: String {
        return "Name: \(Name), \n Image: \(Image), \n Age: \(Age) \n NumberOfSharedFriends: \(NumberOfSharedFriends) \n NumberOfSharedInterests: \(NumberOfSharedInterests) \n NumberOfPhotos/: \(NumberOfPhotos)"
    }
    
    init(name: NSString?, image: UIImage?, age: NSNumber?, sharedFriends: NSNumber?, sharedInterest: NSNumber?, photos:NSNumber?) {
        self.Name = name ?? ""
        self.Image = image
        self.Age = age ?? 0
        self.NumberOfSharedFriends = sharedFriends ?? 0
        self.NumberOfSharedInterests = sharedInterest ?? 0
        self.NumberOfPhotos = photos ?? 0
    }
}