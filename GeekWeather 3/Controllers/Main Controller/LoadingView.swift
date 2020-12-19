//
//  LoadingView.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 12/17/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import UIKit
import Lottie

final class LoadingView: UIView {
    
    private var animationView: AnimationView = {
        let animationView = AnimationView()
        animationView.animation = Animation.named("loader")
        animationView.animationSpeed = 1.5
        animationView.loopMode = .loop
        animationView.play()
        animationView.translatesAutoresizingMaskIntoConstraints = false
        return animationView
    }()
    
    init() {
        super.init(frame: .zero)
        
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initUI() {
        backgroundColor = .clear
        animationView.backgroundColor = .clear
        
        addSubview(animationView)
        NSLayoutConstraint.activate([animationView.leadingAnchor.constraint(equalTo: leadingAnchor),
                                     animationView.trailingAnchor.constraint(equalTo: trailingAnchor),
                                     animationView.topAnchor.constraint(equalTo: topAnchor),
                                     animationView.bottomAnchor.constraint(equalTo: bottomAnchor)])
        
        layoutIfNeeded()
    }
    
    func displayErrorAnimation() {
        
    }
    
}
