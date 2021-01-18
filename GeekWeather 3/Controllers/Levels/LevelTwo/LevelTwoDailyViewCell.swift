//
//  LevelTwoDailyViewCell.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 12/28/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import UIKit

final class LevelTwoDailyViewCell: UICollectionViewCell {
    
    let dayLabel = UILabel()
    let highTempLabel = UILabel()
    let lowTempLabel = UILabel()
    let tempContainerView = UIStackView()
    let iconView = UIImageView()
    
    var iPhoneVerticalLayoutConstraints = [NSLayoutConstraint]()
    var iPhoneHorizontalLayoutConstraints = [NSLayoutConstraint]()
    
    let containerView = UIView()
    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: .default, reuseIdentifier: "cell")
//
//    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
        layout()
        setupAccessibilityElements()
    }
    
    func initUI() {
        
        backgroundColor = .clear
        
        containerView.backgroundColor = UIColor.white.withAlphaComponent(0.15)
        containerView.layer.cornerRadius = 20
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)
        
        let padding: CGFloat = 10
        
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding ),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding)
        ])
        
        dayLabel.minimumScaleFactor = 0.1
        dayLabel.font = GWFont.AvenirNext(style: .Medium, size: 25)
        highTempLabel.font = GWFont.AvenirNext(style: .Bold, size: 27)
        lowTempLabel.font = GWFont.AvenirNext(style: .Medium, size: 25)
        
        dayLabel.textColor = .white
        highTempLabel.textColor = .white
        lowTempLabel.textColor = .white
        
        tempContainerView.addArrangedSubview(highTempLabel)
        tempContainerView.addArrangedSubview(lowTempLabel)
        tempContainerView.spacing = 10
        tempContainerView.alignment = .trailing
        tempContainerView.axis = .horizontal
        tempContainerView.distribution = .fillEqually
        
        [dayLabel, iconView, tempContainerView].forEach { (element) in
            element.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(element)
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
            iconView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            iconView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            iconView.heightAnchor.constraint(equalToConstant: 45),
            iconView.widthAnchor.constraint(equalToConstant: 45),
            
            dayLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding),
            dayLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -padding),
            dayLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: padding),
            
            tempContainerView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            tempContainerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding)
        ]
        
        NSLayoutConstraint.deactivate(iPhoneVerticalLayoutConstraints)
        NSLayoutConstraint.activate(iPhoneHorizontalLayoutConstraints)
        layoutIfNeeded()
    }
    
    func iPhoneLayoutVerticalLayout() {
        let padding: CGFloat = 10
        tempContainerView.alignment = .leading
        
        iPhoneVerticalLayoutConstraints = [
            iconView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            iconView.heightAnchor.constraint(equalToConstant: 75),
            iconView.widthAnchor.constraint(equalToConstant: 75),
            iconView.centerYAnchor.constraint(equalTo: dayLabel.centerYAnchor),
            
            dayLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            dayLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: padding),
            dayLabel.bottomAnchor.constraint(equalTo: tempContainerView.topAnchor, constant: -padding),
            dayLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            
            tempContainerView.topAnchor.constraint(equalTo: dayLabel.bottomAnchor),
            tempContainerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            tempContainerView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -padding),
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
        highTempLabel.font = UIFontMetrics(forTextStyle: .callout).scaledFont(for: highTempLabel.font)
        lowTempLabel.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: lowTempLabel.font)
        
        [dayLabel, highTempLabel, lowTempLabel].forEach { (element) in
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
