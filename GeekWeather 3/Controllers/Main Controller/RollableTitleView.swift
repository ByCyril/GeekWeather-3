//
//  RollableTitleView.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 12/18/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import UIKit

final class RollableTitleView: UIView {
    
    var todayLabel: UILabel = {
        let label = UILabel()
        label.text = "Today"
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 35)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var forecastLabel: UILabel = {
        let label = UILabel()
        label.text = "Forecast"
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 35)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var geekLabel: UILabel = {
        let label = UILabel()
        label.text = "Details"
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 35)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var labelContainer: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .fillEqually
        stack.alignment = .leading
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    var bottomAnimatorConstraint: NSLayoutConstraint?
    var topAnimationConstraint: NSLayoutConstraint?
    
    var bottomPadding: CGFloat = 0
    var itemHeight: CGFloat = 75
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        initUI()
    }
    
    func initUI() {
        
        bottomPadding = itemHeight * 2
        
        addSubview(labelContainer)
        labelContainer.backgroundColor = .clear
        backgroundColor = .clear
        
        labelContainer.addArrangedSubview(todayLabel)
        labelContainer.addArrangedSubview(forecastLabel)
        labelContainer.addArrangedSubview(geekLabel)
        
        topAnimationConstraint = labelContainer.topAnchor.constraint(equalTo: topAnchor)
        topAnimationConstraint?.isActive = true
        
        labelContainer.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        labelContainer.heightAnchor.constraint(equalToConstant: itemHeight).isActive = true
        labelContainer.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        bottomAnimatorConstraint = labelContainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: itemHeight * 2)
        bottomAnimatorConstraint?.isActive = true
        
        layoutIfNeeded()
    }
    
    func animateWithOffset(_ offsetY: CGFloat) {
        bottomAnimatorConstraint?.constant = bottomPadding - offsetY
        topAnimationConstraint?.constant = -offsetY
    }
    
}
