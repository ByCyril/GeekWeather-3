//
//  FlipperGestureManager.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 8/20/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import UIKit

final class FlipperGestureManager {
    
    private var flipperStaticView: FlipperStaticView
    private var flipperState: FlipperState
    private var animatingLayers: [FlipperAnimationLayer]
    
    private let not = (!)
    
    init(_ flipperStaticView: FlipperStaticView,_ flipperState: FlipperState,_ animatingLayers: [FlipperAnimationLayer]) {
        self.flipperState = flipperState
        self.animatingLayers = animatingLayers
        self.flipperStaticView = flipperStaticView
    }
    
    func panBegan(_ gesture: UIPanGestureRecognizer) {
        if animationsArePassedHalfway() {
            if flipperState == .inactive {
                flipperState = .began
            }
            
            let animationLayer = FlipperAnimationLayer(frame: flipperStaticView.rightSide.bounds, isFirstOrLast: false)
            
            if let hiZanimLayer = getHighestZIndexFlipperAnimationLayer() {
                animationLayer.zPosition = hiZanimLayer.zPosition + animationLayer.bounds.size.height
            } else {
                animationLayer.zPosition = 0
            }
            
            animatingLayers.append(animationLayer)
        } else {
            enableGesture(gesture, false)
        }
    }
    
    func animationsArePassedHalfway() -> Bool{
        var passedHalfWay = false
        
        if flipperState == FlipperState.inactive {
            passedHalfWay = true
        } else if animatingLayers.count > 0 {
            //LOOP through this and check the new animation layer with current animations to make sure we dont allow the same animation to happen on a flip up
            for animLayer in animatingLayers {
                let animationLayer = animLayer as FlipperAnimationLayer
                var layerIsPassedHalfway = false
                
                let rotationX = animationLayer.presentation()?.value(forKeyPath: "transform.rotation.x") as! CGFloat
                
                if animationLayer.flipDirection == .right && rotationX > 0 {
                    layerIsPassedHalfway = true
                } else if animationLayer.flipDirection == .left && rotationX == 0 {
                    layerIsPassedHalfway = true
                }
                
                if layerIsPassedHalfway == false {
                    passedHalfWay = false
                    break
                } else {
                    passedHalfWay = true
                }
            }
        } else {
            passedHalfWay = true
        }
        
        return passedHalfWay
    }
    
    func enableGesture(_ gesture: UIPanGestureRecognizer,_ enabled: Bool) {
        gesture.isEnabled = enabled
    }
    
    func getHighestZIndexFlipperAnimationLayer() -> FlipperAnimationLayer? {
        return animatingLayers.sorted { (view0, view1) -> Bool in
            return view0.zPosition > view1.zPosition
        }.first
    }
    
}
