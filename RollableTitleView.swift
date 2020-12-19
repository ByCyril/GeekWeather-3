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
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var forecastLabel: UILabel = {
        let label = UILabel()
        label.text = "Forecast"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var geekLabel: UILabel = {
        let label = UILabel()
        label.text = "GeekWeather Data"
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
    var itemHeight: CGFloat = 0
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        initUI()
    }
    
    func initUI() {
        
        bottomPadding = itemHeight * 2
        
        addSubview(labelContainer)
        labelContainer.backgroundColor = .clear
        backgroundColor = .clear
        todayLabel.backgroundColor = .green
        forecastLabel.backgroundColor = .red
        geekLabel.backgroundColor = .blue
        
        todayLabel.frame.size.width = frame.size.width
        forecastLabel.frame.size.width = frame.size.width
        geekLabel.frame.size.width = frame.size.width
        
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
        print(offsetY)
        bottomAnimatorConstraint?.constant = bottomPadding - offsetY
        topAnimationConstraint?.constant = -offsetY
    }
    
}
