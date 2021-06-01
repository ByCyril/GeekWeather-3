//  InteractionManager.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 5/22/21.
//  Copyright © 2021 ByCyril. All rights reserved.
//

import UIKit

final class InteractionManager {
    
    private let interactionView: LevelOneViewController
    private let view: UIView
    
    private let cornerRadius: CGFloat = 15
    private let difference: CGFloat = 100
    private var isCollapsed: Bool = false
    
    init(_ interactionView: LevelOneViewController,_ view: UIView) {
        self.interactionView = interactionView
        self.view = view
        setup()
    }
    
    private func setup() {
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
        
        if !isCollapsed && velocity.y < 0 {
            show()
            return
        }
        
        switch gesture.state {
        case .began:
            if isCollapsed == false {
                HapticManager.soft()
            }
        case .changed:
            if interactionView.frame.origin.y >= 0 {
                interactionView.frame.origin.y += translation.y
            }
        case .ended:
            curve()
            if velocity.y > 0 {
                hide()
                isCollapsed = true
                HapticManager.soft()
            } else {
                show()
                isCollapsed = false
                HapticManager.soft()
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
    
    func show() {
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 1,
                       options: .curveEaseInOut,
                       animations: { [unowned self] in
            self.interactionView.frame.origin.y = 0
            self.interactionView.layer.cornerRadius = self.cornerRadius
                       })
    }
    
    func hide() {
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
