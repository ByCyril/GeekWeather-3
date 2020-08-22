//
//  FlipperStaticView.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 8/20/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import UIKit

class FlipperStaticView: CATransformLayer {
    
    convenience init(frame: CGRect) {
        self.init()
        self.frame = frame
        self.addSublayer(topSide)
        self.addSublayer(bottomSide)
        
        self.zPosition = -1_000_000
    }
    
    override init() {
        super.init()
    }

    lazy var topSide:CALayer = {
        var lSide = CALayer(layer: self)
        var frame = self.bounds
        frame.size.height = frame.size.height / 2
        frame.origin.y = 0
        lSide.frame = frame
        lSide.contentsScale = UIScreen.main.scale
        return lSide
    }()
    
    lazy var bottomSide:CALayer = {
        var rSide = CALayer(layer: self)
        var frame = self.bounds
        frame.size.height = frame.size.height / 2
        frame.origin.y = frame.size.height / 2
        rSide.frame = frame
        rSide.contentsScale = UIScreen.main.scale
        return rSide
        }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addSublayer(topSide)
        self.addSublayer(bottomSide)
    }

    override init(layer: Any) {
        super.init(layer: layer)
        self.addSublayer(topSide)
        self.addSublayer(bottomSide)
    }
    
    func updateFrame(_ newFrame:CGRect) {
        self.frame = newFrame
        updatePageLayerFrames(newFrame)
    }
    
    fileprivate func updatePageLayerFrames(_ newFrame:CGRect) {
        var frame = newFrame
        
        frame.size.height = frame.size.height / 2
        topSide.frame = frame
        
        frame.origin.y = frame.size.height
        bottomSide.frame = frame
    }
    
    func setTheRightSide(_ image:UIImage) {
        
        let tmpImageRef = image.cgImage
        let rightImgRef = tmpImageRef?.cropping(to: CGRect(x: 0,
                                                           y: image.size.height/2 * UIScreen.main.scale,
                                                           width: image.size.width * UIScreen.main.scale,
                                                           height: image.size.height/2 * UIScreen.main.scale))
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(0)
        bottomSide.contents = rightImgRef
        CATransaction.commit()
    }
    
    func setTheLeftSide(_ image:UIImage) {
        let tmpImageRef = image.cgImage
        
        let leftImgRef = tmpImageRef?.cropping(to: CGRect(x: 0,
                                                          y: 0,
                                                          width: image.size.width * UIScreen.main.scale,
                                                          height: image.size.height/2 * UIScreen.main.scale))
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(0)
        topSide.contents = leftImgRef
        CATransaction.commit()
    }
    
}
