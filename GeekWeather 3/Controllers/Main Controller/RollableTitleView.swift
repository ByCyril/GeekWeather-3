//
//  RollableTitleView.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 12/18/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import UIKit

final class RollableTitleView: UIView {

    var forecastLabel = UILabel()
    var geekLabel = UILabel()
    var todayLabel = UILabel()
    
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        NotificationCenter.default.addObserver(self, selector: #selector(update(_:)), name: NotificationName.observerID("currentLocation"), object: nil)
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        initUI()
    }
        
    func initUI() {

        todayLabel.text = "--"
        geekLabel.text = "Details"
        forecastLabel.text = "Forecast"
        
        [forecastLabel, geekLabel, todayLabel].forEach { (label) in
            label.notAccessibilityElement()
            label.adjustsFontSizeToFitWidth = true
            label.font = GWFont.AvenirNext(style: .Bold, size: 35)
            label.translatesAutoresizingMaskIntoConstraints = false
        }
        
        bottomPadding = itemHeight * 2
        
        addSubview(labelContainer)
        labelContainer.backgroundColor = .clear
        backgroundColor = .clear
        
        labelContainer.addArrangedSubview(todayLabel)
        labelContainer.addArrangedSubview(forecastLabel)
        labelContainer.addArrangedSubview(geekLabel)
        
        topAnimationConstraint = labelContainer.topAnchor.constraint(equalTo: topAnchor, constant: itemHeight)
        topAnimationConstraint?.isActive = true
        
        labelContainer.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        labelContainer.heightAnchor.constraint(equalToConstant: itemHeight).isActive = true
        labelContainer.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        bottomAnimatorConstraint = labelContainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: itemHeight * 2)
        bottomAnimatorConstraint?.isActive = true
        
        layoutIfNeeded()
    }
    
    @objc
    func update(_ notification: NSNotification) {
        if let currentLocation = notification.userInfo?["currentLocation"] as? String {
            todayLabel.text = currentLocation
        }
    }
    
    func animateWithOffset(_ offsetY: CGFloat) {
        if offsetY < 0 { return }
        if offsetY > itemHeight * 2 { return }
        bottomAnimatorConstraint?.constant = bottomPadding - offsetY
        topAnimationConstraint?.constant = -offsetY
    }
    
    func hideTitles() {
        topAnimationConstraint?.constant = itemHeight
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut) { [weak self] in
            self?.layoutIfNeeded()
        }
    }
    
    func showTitles() {
        topAnimationConstraint?.constant = 0
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut) { [weak self] in
            self?.layoutIfNeeded()
        }
        
    }
}
