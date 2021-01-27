//
//  DetailsViewHostingController.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 1/24/21.
//  Copyright © 2021 ByCyril. All rights reserved.
//

import UIKit
import SwiftUI

protocol GWUIHostingControllerDelegate: AnyObject {
    func didDismissModal()
}

final class AlertViewHostingController: UIHostingController<AlertContainer> {
    
    weak var delegate: GWUIHostingControllerDelegate?
    
    override init(rootView: AlertContainer) {
        super.init(rootView: rootView)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .coverVertical
        view.backgroundColor = .clear
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerHandler(_:)))
        view.addGestureRecognizer(panGesture)
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    func panGestureRecognizerHandler(_ sender: UIPanGestureRecognizer) {
        
        let translationY = sender.translation(in: sender.view!).y

        let velocity = sender.velocity(in: sender.view)

        
        if sender.state == .changed {
            view.transform = .init(translationX: 0, y: translationY)
        } else if sender.state == .ended || sender.state == .cancelled {

            if velocity.y >= 100 {
                hideDown()
                delegate?.didDismissModal()
            }  else {
                snapBack()
            }
        }
        
    }
    
    @objc
    private func snapBack() {
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 1,
                       options: .curveEaseInOut,
                       animations: { [weak self] in
                        self?.view.transform = .identity
        })
    }
    
    @objc
    private func hideDown() {
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 1,
                       options: .curveEaseInOut,
                       animations: { [weak self] in
                        self?.view.transform = .init(translationX: 0, y: 200)
        })
    }

    deinit {
        Mocks.reclaimedMemory(self)
    }
}
