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
            if interactionView.frame.origin.y > 45 {
                interactionView.frame.origin.y += translation.y
            }
        case .ended:
            curve()
            if velocity.y > 0 {
                hide()
            } else {
                show()
            }
        
        default:
            break
        }
    }
    
    private func curve() {
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 1,
                       options: .curveEaseInOut,
                       animations: { [unowned self] in
            self.interactionView.layer.cornerRadius = self.cornerRadius
        })
    }
    
    private func show() {
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 1,
                       options: .curveEaseInOut,
                       animations: { [unowned self] in
            self.interactionView.frame.origin.y = 50
            self.interactionView.layer.cornerRadius = self.cornerRadius
        })
    }
    
    private func hide() {
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 1,
                       options: .curveEaseInOut,
                       animations: { [unowned self] in
            self.interactionView.frame.origin.y = self.view.frame.size.height - self.difference
            self.interactionView.layer.cornerRadius = 0
        })
    }
    
}
