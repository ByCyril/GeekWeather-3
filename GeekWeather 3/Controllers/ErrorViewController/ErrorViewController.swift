//
//  ErrorViewController.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 12/21/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import UIKit

struct AnimationType {
    var name: String
    var speed: CGFloat
    var size: CGSize
    var message: String
}

final class ErrorViewController: UIViewController {
    private let gradientLayer = CAGradientLayer()

    private var animationView: GWAnimationView?
    private var errorMessageView: UITextView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor(named: "GradientTopColor")!.cgColor,
                                UIColor(named: "GradientBottomColor")!.cgColor]

        view.layer.insertSublayer(gradientLayer, at: 0)
        view.setNeedsDisplay()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        guard traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) else {
            return
        }

        gradientLayer.colors = [UIColor(named: "GradientTopColor")!.cgColor,
                                UIColor(named: "GradientBottomColor")!.cgColor]
    }
    
    func displayAnimation(with animation: AnimationType) {
        animationView = GWAnimationView(animation)
        animationView?.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView!)
        
        if let animationView = self.animationView {
            NSLayoutConstraint.activate([animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                         animationView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                                         animationView.widthAnchor.constraint(equalToConstant: 250),
                                         animationView.heightAnchor.constraint(equalTo: animationView.widthAnchor)])
        }
        
        errorMessageView = UITextView()
        errorMessageView?.text = animation.message
        errorMessageView?.backgroundColor = .clear
        errorMessageView?.font = GWFont.AvenirNext(style: .Regular, size: 25)
        errorMessageView?.textAlignment = .center
        errorMessageView?.textColor = .white
        errorMessageView?.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(errorMessageView!)
        
        if let errorMessageView = self.errorMessageView {
            NSLayoutConstraint.activate([
                errorMessageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                errorMessageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                errorMessageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                errorMessageView.topAnchor.constraint(equalTo: animationView!.bottomAnchor)
            ])
        }
        
        view.layoutIfNeeded()
    }
    
    
    
}
