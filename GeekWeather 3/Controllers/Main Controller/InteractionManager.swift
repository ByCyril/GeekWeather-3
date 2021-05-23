//
//  InteractionManager.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 5/22/21.
//  Copyright © 2021 ByCyril. All rights reserved.
//

import UIKit

final class InteractionManager {
    
    private let interactionView: UIView
    private let view: UIView
    
    private let cornerRadius: CGFloat = 15
    private let difference: CGFloat = 125
    
    init(_ interactionView: UIView,_ view: UIView) {
        self.interactionView = interactionView
        self.view = view
        setup()
    }
    
    private func setup() {
        interactionView.backgroundColor = .systemBlue
        interactionView.layer.shadowColor = UIColor.black.cgColor
        interactionView.layer.shadowOffset = .zero
        interactionView.layer.shadowOpacity = 1.0
        interactionView.layer.shadowRadius = 5
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        interactionView.addGestureRecognizer(panGesture)
    }
    
    @objc
    private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        gesture.setTranslation(.zero, in: view)
        
        let velocity = gesture.velocity(in: view)
        
        switch gesture.state {
        case .changed:
//            interactionView.frame.origin.y += translation.y
            
//            let cornerRadius = interactionView.frame.height / 2
//            let percentage = (interactionView.frame.origin.y / (interactionView.frame.height / 4))
            
//            interactionView.layer.cornerRadius = cornerRadius * percentage
            
//            print(translation.y,percentage,cornerRadius * percentage)
        case .ended:
            if velocity.y > 0 {
                
            } else {
                
            }
        
        default:
            break
        }
    }
    
    private func show() {
        
    }
    
    private func hide() {
        
    }
    
    private func curve() {
        
    }
    
}
