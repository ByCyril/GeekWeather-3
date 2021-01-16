//
//  DailyContainerView.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 1/12/21.
//  Copyright © 2021 ByCyril. All rights reserved.
//

import UIKit

final class DailyContainerView: UIView {
    lazy var dailyView: UICollectionView = {
        let config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.alwaysBounceHorizontal = true
        collectionView.flashScrollIndicators()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        
        return collectionView
    }()
    
    var containerView = UIView()
    
    let gradientLayer = CAGradientLayer()
    let theme = UserDefaults.standard.string(forKey: "Theme") ?? "System-"
 
    func createGradientLayer() {
        gradientLayer.colors = [UIColor(named: theme + "GradientTopColor")!.cgColor,
                                UIColor(named: theme + "GradientBottomColor")!.cgColor]
        
        containerView.layer.insertSublayer(gradientLayer, at: 0)
        setNeedsDisplay()
    }
    
    func initUI() {
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.alpha = 0
        addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        backgroundColor = .clear
        layer.cornerRadius = 20
        layer.masksToBounds = true
        addSubview(dailyView)
        
        NSLayoutConstraint.activate([
            dailyView.topAnchor.constraint(equalTo: topAnchor),
            dailyView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dailyView.trailingAnchor.constraint(equalTo: trailingAnchor),
            dailyView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        layoutIfNeeded()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = containerView.bounds
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        createGradientLayer()
        initUI()
    }
 
}
