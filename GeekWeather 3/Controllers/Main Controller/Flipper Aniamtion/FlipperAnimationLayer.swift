//
//  FlipperAnimationLayer.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 8/20/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import UIKit
import Darwin

struct AnimationProperties {
    var currentAngle:CGFloat
    var startAngle:CGFloat
    var endFlipAngle:CGFloat
}

enum FlipDirection {
    case top
    case bottom
    case notSet
}

enum FlipAnimationStatus {
    case none
    case beginning
    case active
    case completing
    case complete
    case interrupt
    case fail
}

class FlipperAnimationLayer: CATransformLayer {
    
    var flipDirection:FlipDirection = .notSet
    var flipAnimationStatus = FlipAnimationStatus.none
    var flipProperties = AnimationProperties(currentAngle: 0, startAngle: 0, endFlipAngle: CGFloat.pi)
    var isFirstOrLastPage:Bool = false
    
    lazy var frontLayer:CALayer = {
        var fLayer = CALayer(layer: self)
        fLayer.frame = self.bounds
        fLayer.isDoubleSided = false
        fLayer.transform = CATransform3DMakeRotation(CGFloat.pi, 1, 0, 0);
        self.addSublayer(fLayer)
        return fLayer
    }()
    
    lazy var backLayer:CALayer = {
        var bLayer = CALayer(layer: self)
        bLayer.frame = self.bounds
        bLayer.isDoubleSided = false
        bLayer.transform = CATransform3DMakeRotation(0, 1, 0, 0);
        self.addSublayer(bLayer)
        return bLayer
    }()
    
    convenience init(frame:CGRect, isFirstOrLast:Bool) {
        self.init()
        self.flipAnimationStatus = FlipAnimationStatus.beginning
        self.anchorPoint = CGPoint(x: 0.5, y: 1)
        self.frame = frame
        
        isFirstOrLastPage = isFirstOrLast
    }
    
    func updateFlipDirection(_ direction:FlipDirection) {
        
        flipDirection = direction
        if flipDirection == .top {
            flipProperties.currentAngle = CGFloat.pi
            flipProperties.startAngle = CGFloat.pi
            flipProperties.endFlipAngle = 0
            self.transform = CATransform3DMakeRotation(CGFloat.pi, 1, 0, 0);
        } else {
            flipProperties.currentAngle = 0
            flipProperties.startAngle = 0
            flipProperties.endFlipAngle = CGFloat.pi
            self.transform = CATransform3DMakeRotation(0, 1, 0, 0);
        }
    }
    
    func setTheFrontLayer(_ image:UIImage) {
        let tmpImageRef = image.cgImage
        let rightImgRef = tmpImageRef?.cropping(to: CGRect(x: 0,
                                                           y: image.size.height/2 * UIScreen.main.scale,
                                                           width: image.size.width * UIScreen.main.scale,
                                                           height: image.size.height/2 * UIScreen.main.scale))

        frontLayer.contents = rightImgRef
    }
    
    func setTheBackLayer(_ image:UIImage) {
        let tmpImageRef = image.cgImage
        let rightImgRef = tmpImageRef?.cropping(to: CGRect(x: 0,
                                                           y: 0,
                                                           width: image.size.width * UIScreen.main.scale,
                                                           height: image.size.height/2 * UIScreen.main.scale))
        
        backLayer.contents = rightImgRef
    }
}
