//
//  ChoosePersonView.swift
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

class ChoosePersonView: MDCSwipeToChooseView {
    
    let ChoosePersonViewImageLabelWidth:CGFloat = 42.0;
    var person: Person!
    var informationView: UIView!
    var nameLabel: UILabel!
    var carmeraImageLabelView:ImagelabelView!
    var interestsImageLabelView: ImagelabelView!
    var friendsImageLabelView: ImagelabelView!
    
    init(frame: CGRect, person: Person, options: MDCSwipeToChooseViewOptions) {
        
        super.init(frame: frame, options: options)
        self.person = person
        
        self.imageView.image = self.person.Image!
        self.autoresizingMask = UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleWidth
        UIViewAutoresizing.FlexibleBottomMargin
        
        self.imageView.autoresizingMask = self.autoresizingMask
        constructInformationView()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func constructInformationView() -> Void{
        var bottomHeight:CGFloat = 60.0
        var bottomFrame:CGRect = CGRectMake(0,
            CGRectGetHeight(self.bounds) - bottomHeight,
            CGRectGetWidth(self.bounds),
            bottomHeight);
        self.informationView = UIView(frame:bottomFrame)
        self.informationView.backgroundColor = UIColor.whiteColor()
        self.informationView.clipsToBounds = true
        self.informationView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleTopMargin
        self.addSubview(self.informationView)
        constructNameLabel()
        constructCameraImageLabelView()
        constructInterestsImageLabelView()
        constructFriendsImageLabelView()
    }
    
    func constructNameLabel() -> Void{
        var leftPadding:CGFloat = 12.0
        var topPadding:CGFloat = 17.0
        var frame:CGRect = CGRectMake(leftPadding,
            topPadding,
            floor(CGRectGetWidth(self.informationView.frame)/2),
            CGRectGetHeight(self.informationView.frame) - topPadding)
        self.nameLabel = UILabel(frame:frame)
        self.nameLabel.text = "\(person.Name), \(person.Age)"
        self.informationView .addSubview(self.nameLabel)
    }
    func constructCameraImageLabelView() -> Void{
        var rightPadding:CGFloat = 10.0
        var image:UIImage = UIImage(named:"camera")!
        self.carmeraImageLabelView = buildImageLabelViewLeftOf(CGRectGetWidth(self.informationView.bounds), image:image, text:person.NumberOfPhotos.stringValue)
        self.informationView.addSubview(self.carmeraImageLabelView)
    }
    func constructInterestsImageLabelView() -> Void{
        var image: UIImage = UIImage(named: "book")!
        self.interestsImageLabelView = self.buildImageLabelViewLeftOf(CGRectGetMinX(self.carmeraImageLabelView.frame), image: image, text:person.NumberOfPhotos.stringValue)
        self.informationView.addSubview(self.interestsImageLabelView)
    }
    
    func constructFriendsImageLabelView() -> Void{
        var image:UIImage = UIImage(named:"group")!
        self.friendsImageLabelView = buildImageLabelViewLeftOf(CGRectGetMinX(self.interestsImageLabelView.frame), image:image, text:"No Friends")
        self.informationView.addSubview(self.friendsImageLabelView)
    }
    
    func buildImageLabelViewLeftOf(x:CGFloat, image:UIImage, text:NSString) -> ImagelabelView{
        var frame:CGRect = CGRect(x:x-ChoosePersonViewImageLabelWidth, y: 0,
            width: ChoosePersonViewImageLabelWidth,
            height: CGRectGetHeight(self.informationView.bounds))
        var view:ImagelabelView = ImagelabelView(frame:frame, image:image, text:text)
        view.autoresizingMask = UIViewAutoresizing.FlexibleLeftMargin
        return view
    }
}
