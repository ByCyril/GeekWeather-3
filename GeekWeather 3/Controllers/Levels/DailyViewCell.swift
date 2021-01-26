//
//  DailyViewCell.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 12/28/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import UIKit

final class DailyViewCell: UITableViewCell {
    
    let dayLabel = UILabel()
    let tempLabels = UILabel()
    let tempContainerView = UIStackView()
    let iconView = UIImageView()
    
    var iPhoneVerticalLayoutConstraints = [NSLayoutConstraint]()
    var iPhoneHorizontalLayoutConstraints = [NSLayoutConstraint]()
    
    let containerView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: "cell")
        initUI()
        layout()
        setupAccessibilityElements()
    }
    
    func initUI() {
        
        backgroundColor = .clear

        dayLabel.minimumScaleFactor = 0.1
        dayLabel.font = GWFont.AvenirNext(style: .Medium, size: 25)
        tempLabels.font = GWFont.AvenirNext(style: .Medium, size: 21)
        
        dayLabel.textColor = .white
        tempLabels.textColor = .white
        
        tempContainerView.addArrangedSubview(tempLabels)
        tempContainerView.spacing = 10
        tempContainerView.alignment = .trailing
        tempContainerView.axis = .horizontal
        tempContainerView.distribution = .fillEqually
        
        [dayLabel, iconView, tempContainerView].forEach { (element) in
            element.translatesAutoresizingMaskIntoConstraints = false
            addSubview(element)
        }
    }
    
    func layout() {
        if traitCollection.preferredContentSizeCategory >= .extraExtraExtraLarge {
            iPhoneLayoutVerticalLayout()
        } else {
            iPhoneLayoutHorizontalLayout()
        }
    }
    
    func iPhoneLayoutHorizontalLayout() {
        let padding: CGFloat = 10
        
        iPhoneHorizontalLayoutConstraints = [
            iconView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            iconView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconView.heightAnchor.constraint(equalToConstant: 45),
            iconView.widthAnchor.constraint(equalToConstant: 45),
            
            dayLabel.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            dayLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),
            dayLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: padding),
            
            tempContainerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            tempContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -(padding + 5))
        ]
        
        NSLayoutConstraint.deactivate(iPhoneVerticalLayoutConstraints)
        NSLayoutConstraint.activate(iPhoneHorizontalLayoutConstraints)
        layoutIfNeeded()
    }
    
    func iPhoneLayoutVerticalLayout() {
        let padding: CGFloat = 10
        tempContainerView.alignment = .leading
        
        iPhoneVerticalLayoutConstraints = [
            iconView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            iconView.heightAnchor.constraint(equalToConstant: 75),
            iconView.widthAnchor.constraint(equalToConstant: 75),
            iconView.centerYAnchor.constraint(equalTo: dayLabel.centerYAnchor),
            
            dayLabel.topAnchor.constraint(equalTo: topAnchor),
            dayLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: padding),
            dayLabel.bottomAnchor.constraint(equalTo: tempContainerView.topAnchor, constant: -padding),
            dayLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            tempContainerView.topAnchor.constraint(equalTo: dayLabel.bottomAnchor),
            tempContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            tempContainerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),
        ]
        
        NSLayoutConstraint.deactivate(iPhoneHorizontalLayoutConstraints)
        NSLayoutConstraint.activate(iPhoneVerticalLayoutConstraints)
        layoutIfNeeded()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        guard let traitCollection = previousTraitCollection else { return }
        if traitCollection.preferredContentSizeCategory >= .extraExtraExtraLarge {
            iPhoneLayoutVerticalLayout()
        } else {
            iPhoneLayoutHorizontalLayout()
        }
    }
    
    func setupAccessibilityElements() {
        dayLabel.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: dayLabel.font)
        tempLabels.font = UIFontMetrics(forTextStyle: .callout).scaledFont(for: tempLabels.font)
        
        [dayLabel, tempLabels].forEach { (element) in
            element.isAccessibilityElement = false
            element.adjustsFontForContentSizeCategory = true
            element.sizeToFit()
            element.numberOfLines = 1
        }
        
        isAccessibilityElement = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
