//
//  PBadgeView.swift
//  PBadgeView
//
//  Created by 邓杰豪 on 2016/9/13.
//  Copyright © 2016年 邓杰豪. All rights reserved.
//

import UIKit

enum PBadgeViewHorizontalAlignment : Int {
    case None
    case Left
    case Center
    case Right
}

enum PBadgeViewVerticalAlignment : Int {
    case None
    case Top
    case Middle
    case Bottom
}

class PBadgeView: UIView {
    
    var text:NSString?
    var textColor:UIColor?
    var font:UIFont?
    var textAlignmentShift:CGSize?
    var pixelPerfectText:Bool?
    var badgeBackgroundColor:UIColor?
    var showGloss:Bool?
    var cornerRadius:CGFloat?
    var horizontalAlignment:PBadgeViewHorizontalAlignment?
    var verticalAlignment:PBadgeViewVerticalAlignment?
    var alignmentShift:CGSize?
    var animateChanges:Bool?
    var animationDuration:Double?
    var minimumWidth:CGFloat?
    var maxmumWidth:CGFloat?
    var hidesWhenZero:Bool?
    var borderWidth:CGFloat?
    var borderColor:UIColor?
    var shadowColor:UIColor?
    var shadowOffSet:CGSize?
    var shadowRadius:CGFloat?
    var shadowText:Bool?
    var shadowBorder:Bool?
    var shadowBadge:Bool?
    var autoSetCornerRadius:Bool?
    var textLayer:CATextLayer?
    var borderLayer:CAShapeLayer?
    var backgroundLayer:CAShapeLayer?
    var glossMaskLayer:CAShapeLayer?
    var glossLayer:CAGradientLayer?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp()
    {
        self.backgroundColor = UIColor.clear
        self.isUserInteractionEnabled = false
        self.clipsToBounds = false
        
        self.textColor = UIColor.white
        self.textAlignmentShift = CGSize.zero
        self.font = UIFont.systemFont(ofSize: 16)
        self.badgeBackgroundColor = UIColor.red
        self.showGloss = false
        self.cornerRadius = self.frame.size.height / 2
        self.horizontalAlignment = .Right
        self.verticalAlignment = .Top
        self.alignmentShift = CGSize.init(width: 0, height: 0)
        self.animateChanges = true
        self.animationDuration = 0.2
        self.borderWidth = 0
        self.borderColor = UIColor.white
        self.shadowColor = UIColor.init(white: 0, alpha: 0.5)
        self.shadowOffSet = CGSize.init(width: 1, height: 1)
        self.shadowRadius = 1
        self.shadowText = false
        self.shadowBorder = false
        self.shadowBadge = false
        self.hidesWhenZero = false
        self.pixelPerfectText = true
        
        if self.frame.size.height == 0
        {
            var frame = self.frame
            frame.size.height = 24
            self.minimumWidth = 24
            self.frame = frame
        }
        else
        {
            self.minimumWidth = self.frame.size.height
        }
        
        self.maxmumWidth = CGFloat.greatestFiniteMagnitude
        
        self.textLayer = CATextLayer.init()
        self.textLayer?.foregroundColor = self.textColor?.cgColor
        self.textLayer?.font = self.font?.fontName as CFTypeRef?
        self.textLayer?.fontSize = (self.font?.pointSize)!
        self.textLayer?.alignmentMode = kCAAlignmentCenter
        self.textLayer?.truncationMode = kCATruncationEnd
        self.textLayer?.isWrapped = false
        self.textLayer?.frame = CGRect.init(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        self.textLayer?.contentsScale = UIScreen.main.scale
        
        self.borderLayer = CAShapeLayer.init()
        self.borderLayer?.strokeColor = self.borderColor?.cgColor
        self.borderLayer?.fillColor = UIColor.clear.cgColor
        self.borderLayer?.lineWidth = self.borderWidth!
        self.borderLayer?.frame = CGRect.init(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        self.borderLayer?.contentsScale = UIScreen.main.scale
        
        self.backgroundLayer = CAShapeLayer.init()
        self.backgroundLayer?.fillColor = self.badgeBackgroundColor?.cgColor
        self.backgroundLayer?.frame = CGRect.init(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        self.backgroundLayer?.contentsScale = UIScreen.main.scale
        
        self.glossLayer = CAGradientLayer.init()
        self.glossLayer?.frame = CGRect.init(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        self.glossLayer?.contentsScale = UIScreen.main.scale
        self.glossLayer?.colors = [UIColor.init(white: 1, alpha: 0.8).cgColor,UIColor.init(white: 1, alpha: 0).cgColor]
        self.glossLayer?.startPoint = CGPoint.init(x: 0, y: 0)
        self.glossLayer?.endPoint = CGPoint.init(x: 0, y: 0.6)
        self.glossLayer?.locations = [0,0.8,1]
        self.glossLayer?.type = kCAGradientLayerAxial
        
        self.glossMaskLayer = CAShapeLayer.init()
        self.glossMaskLayer?.fillColor = UIColor.white.cgColor
        self.glossMaskLayer?.frame = CGRect.init(x: 0, y: 0, width: self.frame.width, height: self.frame.size.height)
        self.glossMaskLayer?.contentsScale = UIScreen.main.scale
        self.glossLayer?.mask = self.glossMaskLayer
        
        self.layer.addSublayer(self.backgroundLayer!)
        self.layer.addSublayer(self.borderLayer!)
        self.layer.addSublayer(self.textLayer!)
        
        let frameAnimation = CABasicAnimation.init()
        frameAnimation.duration = self.animationDuration!
        frameAnimation.timingFunction = CAMediaTimingFunction.value(forUndefinedKey: kCAMediaTimingFunctionLinear) as! CAMediaTimingFunction?
        
        let actions:NSDictionary = ["path":frameAnimation]
        
        self.backgroundLayer?.actions = actions as? [String : CAAction]
        self.borderLayer?.actions = actions as? [String : CAAction]
        self.glossMaskLayer?.actions = actions as? [String : CAAction]
    }
    
    func autoSetBadgeFrame()
    {
        var frame = self.frame
        
        frame.size.width = self.sizeForString(string: self.text!, includeBuffer: true).width
        if frame.size.width < self.minimumWidth!
        {
            frame.size.width = self.minimumWidth!
        }
        else if frame.size.width > self.maxmumWidth!
        {
            frame.size.width = self.maxmumWidth!
        }
        
        if  self.horizontalAlignment == .Left
        {
            frame.origin.x = 0 - frame.size.width / 2 + (self.alignmentShift?.width)!
        }
        else if self.horizontalAlignment == .Center
        {
            frame.origin.x = ((self.superview?.bounds.size.width)! / 2) - (frame.size.width / 2) + (self.alignmentShift?.width)!
        }
        else if self.horizontalAlignment == .Right
        {
            frame.origin.x = (self.superview?.bounds.size.width)! - (frame.size.width / 2) + (self.alignmentShift?.width)!
        }
        
        if self.verticalAlignment == .Top
        {
            frame.origin.y = 0 - (frame.size.height / 2) + (self.alignmentShift?.height)!
        }
        else if self.verticalAlignment == .Middle
        {
            frame.origin.y = ((self.superview?.bounds.size.height)! / 2) - (frame.size.height / 2) + (self.alignmentShift?.height)!
        }
        else if self.verticalAlignment == .Bottom
        {
            frame.origin.y = (self.superview?.bounds.size.height)! - (frame.size.height / 2) + (self.alignmentShift?.height)!
        }
        
        if self.autoSetCornerRadius == true {
            self.cornerRadius = self.frame.size.height / 2
        }
        
        if self.pixelPerfectText == true {
            let roundScale = 1 / UIScreen.main.scale
            frame = CGRect.init(x: (frame.origin.x / roundScale) * roundScale, y: (frame.origin.y / roundScale) * roundScale, width: (frame.size.width / roundScale) * roundScale, height: (frame.size.height / roundScale) * roundScale)
        }
        
        self.frame = frame
        let tempFrame = CGRect.init(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        self.backgroundLayer?.frame = tempFrame
        let textFrame:CGRect?
        if self.pixelPerfectText == true
        {
            let roundScale = 1 / UIScreen.main.scale
            textFrame = CGRect.init(x: (self.alignmentShift?.width)!, y: (((self.frame.size.height - (self.font?.lineHeight)!) / 2) / roundScale) * roundScale + (self.alignmentShift?.height)!, width: self.frame.size.width, height: (self.font?.lineHeight)!)
        }
        else
        {
            textFrame = CGRect.init(x: (self.textAlignmentShift?.width)!, y: ((self.frame.size.height - (self.font?.lineHeight)!) / 2) + (self.textAlignmentShift?.height)!, width: self.frame.size.width, height: (self.font?.lineHeight)!)
        }
        
        self.textLayer?.frame = textFrame!
        self.glossLayer?.frame = tempFrame
        self.glossMaskLayer?.frame = tempFrame
        self.borderLayer?.frame = tempFrame
        
        let path = UIBezierPath.init(roundedRect: tempFrame, cornerRadius: self.cornerRadius!)
        self.backgroundLayer?.path = path.cgPath
        self.borderLayer?.path = path.cgPath
        self.glossMaskLayer?.path = UIBezierPath.init(roundedRect:self.bounds.insetBy(dx: self.borderWidth! / 2, dy: self.borderWidth! / 2) , cornerRadius: self.cornerRadius!).cgPath
        
    }
    
    func sizeForString(string:NSString, includeBuffer include:Bool)->CGSize
    {
        if self.font == nil
        {
            return CGSize.init(width: 0, height: 0)
        }
        
        let widthPadding:CGFloat?
        if self.pixelPerfectText == true
        {
            let roundScale = 1 / UIScreen.main.scale
            widthPadding = (((self.font?.pointSize)! * 0.375) / roundScale) * roundScale
        }
        else
        {
            widthPadding = (self.font?.pointSize)! * 0.375
        }
        
        let attributedString = NSAttributedString.init(string:  String(string) , attributes: [NSFontAttributeName:self.font])
        
        var textSize = attributedString.boundingRect(with: CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions.init(rawValue: 0), context: nil).size
        
        if  include == true {
            textSize.width += widthPadding! * 2
        }
        
        if self.pixelPerfectText == true {
            let roundScale = 1 / UIScreen.main.scale
            textSize.width = (textSize.width / roundScale) * roundScale
            textSize.height = (textSize.height / roundScale) * roundScale
        }
        
        return textSize
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let textFrame:CGRect?
        if self.pixelPerfectText == true
        {
            let roundScale = 1 / UIScreen.main.scale
            textFrame = CGRect.init(x: (self.textAlignmentShift?.width)!, y: ((((self.frame.size.height - (self.font?.lineHeight)!) / 2) / roundScale) * roundScale) + (self.textAlignmentShift?.height)!, width: self.frame.size.width, height: (self.font?.lineHeight)!)
        }
        else
        {
            textFrame = CGRect.init(x: (self.textAlignmentShift?.width)!, y: ((self.frame.size.height - (self.font?.lineHeight)!) / 2) + (self.textAlignmentShift?.height)!, width: self.frame.size.width, height: (self.font?.lineHeight)!)
        }
        self.textLayer?.frame = textFrame!
        self.backgroundLayer?.frame = CGRect.init(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height)
        self.glossLayer?.frame = CGRect.init(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height)
        self.glossMaskLayer?.frame = CGRect.init(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height)
        self.borderLayer?.frame = CGRect.init(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height)
        
        let path = UIBezierPath.init(roundedRect: self.bounds, cornerRadius: self.cornerRadius!)
        self.backgroundLayer?.path = path.cgPath
        self.borderLayer?.path = path.cgPath
        self.glossMaskLayer?.path = UIBezierPath.init(roundedRect:self.bounds.insetBy(dx: self.borderWidth! / 2, dy: self.borderWidth! / 2) , cornerRadius: self.cornerRadius!).cgPath
    }
    
    func setText(text:NSString)
    {
        self.text = text
        if sizeForString(string: self.textLayer?.string as! NSString, includeBuffer: true).width >= sizeForString(string: text, includeBuffer: true).width
        {
            self.textLayer?.string = text
            self.setNeedsDisplay()
        }
        else
        {
            if self.animateChanges == true
            {
                delay(self.animationDuration!, closure: {
                    self.textLayer?.string = text
                })
            }
            else
            {
                self.textLayer?.string = text
            }
        }
        
        autoSetBadgeFrame()
        hideForZeroIfNeeded()
    }
    
    func setTextColor(textColor:UIColor)
    {
        self.textColor = textColor
        self.textLayer?.foregroundColor = self.textColor?.cgColor
    }
    
    func setFont(font:UIFont)
    {
        self.font = font
        self.textLayer?.fontSize = font.pointSize
        self.textLayer?.font = font.fontName as CFTypeRef?
        autoSetBadgeFrame()
    }
    
    func setAnimateChanges(animateChanges:Bool)
    {
        self.animateChanges = animateChanges
        if self.animateChanges == true
        {
            let frameAnimation = CABasicAnimation.init()
            frameAnimation.duration = self.animationDuration!
            frameAnimation.timingFunction = CAMediaTimingFunction.value(forUndefinedKey: kCAMediaTimingFunctionLinear) as! CAMediaTimingFunction?
            
            let actions:NSDictionary = ["path":frameAnimation]
            
            self.backgroundLayer?.actions = actions as? [String : CAAction]
            self.borderLayer?.actions = actions as? [String : CAAction]
            self.glossMaskLayer?.actions = actions as? [String : CAAction]
        }
        else
        {
            self.backgroundLayer?.actions = nil
            self.borderLayer?.actions = nil
            self.glossMaskLayer?.actions = nil
        }
    }
    
    func setBadgeBackgroundColor(badgeBackgroundColor:UIColor)
    {
        self.badgeBackgroundColor = badgeBackgroundColor;
        self.backgroundLayer?.fillColor = self.badgeBackgroundColor?.cgColor;
    }
    
    func setShowGloss(showGloss:Bool)
    {
        self.showGloss = showGloss;
        if self.showGloss == true
        {
            self.layer.addSublayer(self.glossLayer!)
        }
        else
        {
            self.glossLayer?.removeFromSuperlayer()
        }
    }
    
    func setCornerRadius(cornerRadius:CGFloat)
    {
        self.cornerRadius = cornerRadius
        self.autoSetCornerRadius = false
        
        let path = UIBezierPath.init(roundedRect: self.bounds, cornerRadius: self.cornerRadius!)
        self.backgroundLayer?.path = path.cgPath
        self.glossMaskLayer?.path = path.cgPath
        self.borderLayer?.path = path.cgPath
    }
    
    func setHorizontalAlignment(horizontalAlignment:PBadgeViewHorizontalAlignment)
    {
        self.horizontalAlignment = horizontalAlignment
        autoSetBadgeFrame()
    }
    
    func setVerticalAlignment(verticalAlignment:PBadgeViewVerticalAlignment)
    {
        self.verticalAlignment = verticalAlignment
        autoSetBadgeFrame()
    }
    
    func setAlignmentShift(alignmentShift:CGSize)
    {
        self.alignmentShift = alignmentShift
        autoSetBadgeFrame()
    }
    
    func setMinimumWidth(minimumWidth:CGFloat)
    {
        self.minimumWidth = minimumWidth
        autoSetBadgeFrame()
    }
    
    func setMaximumWidth(maxmumWidth:CGFloat)
    {
        var maxmumWidthS:CGFloat = 0
        if maxmumWidth < self.frame.size.height
        {
            maxmumWidthS = self.frame.size.height
        }
        self.maxmumWidth = maxmumWidthS
        autoSetBadgeFrame()
        self.setNeedsDisplay()
    }
    
    func setHidesWhenZero(hidesWhenZero:Bool)
    {
        self.hidesWhenZero = hidesWhenZero
        hideForZeroIfNeeded()
    }
    
    func setBorderWidth(borderWidth:CGFloat)
    {
        self.borderWidth = borderWidth
        self.borderLayer?.lineWidth = borderWidth
        self.setNeedsLayout()

    }
    
    func setBorderColor(borderColor:UIColor)
    {
        self.borderColor = borderColor
        self.borderLayer?.strokeColor = self.borderColor?.cgColor
    }
    
    func setShadowColor(shadowColor:UIColor)
    {
        self.shadowColor = shadowColor
//        self.shadowBadge = shadowBadge
//        self.shadowText = shadowText
//        self.shadowBorder = shadowBorder
    }
    
    func setShadowOffset(shadowOffSet:CGSize)
    {
        self.shadowOffSet = shadowOffSet
    }
    
    func setShadowRadius(shadowRadius:CGFloat)
    {
        self.shadowRadius = shadowRadius
    }
    
    func setShadowText(shadowText:Bool)
    {
        self.shadowText = shadowText
        
        if self.shadowText == true
        {
            self.textLayer?.shadowColor = self.shadowColor?.cgColor
            self.textLayer?.shadowOffset = self.shadowOffSet!
            self.textLayer?.shadowRadius = self.shadowRadius!
            self.textLayer?.shadowOpacity = 1
        }
        else
        {
            self.textLayer?.shadowColor = nil
            self.textLayer?.shadowOpacity = 0
        }
    }
    
    func setShadowBorder(shadowBorder:Bool)
    {
        self.shadowBorder = shadowBorder
        
        if self.shadowBorder == true
        {
            self.textLayer?.shadowColor = self.shadowColor?.cgColor
            self.textLayer?.shadowOffset = self.shadowOffSet!
            self.textLayer?.shadowRadius = self.shadowRadius!
            self.textLayer?.shadowOpacity = 1
        }
        else
        {
            self.textLayer?.shadowColor = nil
            self.textLayer?.shadowOpacity = 0
        }
    }
    
    func setShadowBadge(shadowBadge:Bool)
    {
        self.shadowBadge = shadowBadge
        
        if self.shadowBadge == true
        {
            self.textLayer?.shadowColor = self.shadowColor?.cgColor
            self.textLayer?.shadowOffset = self.shadowOffSet!
            self.textLayer?.shadowRadius = self.shadowRadius!
            self.textLayer?.shadowOpacity = 1
        }
        else
        {
            self.textLayer?.shadowColor = nil
            self.textLayer?.shadowOpacity = 0
        }
    }
    
    func hideForZeroIfNeeded()
    {
        self.isHidden = ((self.text?.isEqual(to: "0"))! && self.hidesWhenZero!)
    }
    
     func delay(_ delay:Double, queue:DispatchQueue? = nil, closure:@escaping ()->()) {
        let q = queue ?? DispatchQueue.main
        let t = DispatchTime.now() + Double(Int64( delay * Double(NSEC_PER_SEC)))
        q.asyncAfter(deadline: t, execute: closure)
    }
}

