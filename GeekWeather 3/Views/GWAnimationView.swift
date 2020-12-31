//
//  GWAnimationView.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 12/17/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import UIKit
import Lottie

final class GWAnimationView: UIView {
    
    private var animationView = AnimationView()
    
    var animationType: AnimationType
    
    init(_ animationType: AnimationType) {
        self.animationType = animationType
        super.init(frame: .zero)
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initUI() {
        
        animationView.animation = Animation.named(animationType.name)
        animationView.animationSpeed = animationType.speed
        animationView.loopMode = .autoReverse
        animationView.play()
        animationView.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundColor = .clear
        
        addSubview(animationView)
        NSLayoutConstraint.activate([animationView.centerXAnchor.constraint(equalTo: centerXAnchor),
                                     animationView.centerYAnchor.constraint(equalTo: centerYAnchor),
                                     animationView.widthAnchor.constraint(equalToConstant: animationType.size.width),
                                     animationView.heightAnchor.constraint(equalToConstant: animationType.size.height)])
        
        layoutIfNeeded()
        
    }
    
}
