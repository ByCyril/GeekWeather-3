//
//  PageIndicator.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 12/31/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import UIKit

final class PageIndicator: UIView {
    
    var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 35
        return stackView
    }()
    
    var dotOne = UIView()
    var dotTwo = UIView()
    var dotThree = UIView()
    
    private var flexibleTopAnchor: NSLayoutConstraint?
    private var flexibleBottomAnchor: NSLayoutConstraint?
    
    private let scale: CGFloat = 2.5
    private let cutOff: CGFloat = 0.45
    
    var currentPage: CGFloat = 0 {
        didSet {
            if (0..<cutOff) ~= currentPage {
                flexibleTopAnchor?.constant = offset
                flexibleBottomAnchor?.constant = offset
                
                UIView.animate(withDuration: 0.4) {
                    self.dotOne.transform = .init(scaleX: self.scale, y: self.scale)
                    self.dotTwo.transform = .identity
                    self.dotThree.transform = .identity
                }
            } else if (cutOff..<(cutOff + 1)) ~= currentPage {
                flexibleTopAnchor?.constant = 0
                flexibleBottomAnchor?.constant = 0
                
                UIView.animate(withDuration: 0.4) {
                    self.dotOne.transform = .identity
                    self.dotTwo.transform = .init(scaleX: self.scale, y: self.scale)
                    self.dotThree.transform = .identity
                    
                }
                
            } else if ((cutOff + 1)...2) ~= currentPage{
                flexibleTopAnchor?.constant = -offset
                flexibleBottomAnchor?.constant = -offset
                
                UIView.animate(withDuration: 0.4) {
                    self.dotOne.transform = .identity
                    self.dotTwo.transform = .identity
                    self.dotThree.transform = .init(scaleX: self.scale, y: self.scale)
                }
            }
            
            UIView.animate(withDuration: 0.4) {
                self.layoutIfNeeded()
            }
        }
    }
    
    var offset: CGFloat = 0
  
    override init(frame: CGRect) {
        super.init(frame: frame)
        offset = (frame.height / 3) + (stackView.spacing / 2)
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initUI() {
                
        addSubview(stackView)
        
        flexibleTopAnchor = stackView.topAnchor.constraint(equalTo: topAnchor, constant: offset)
        flexibleTopAnchor?.isActive = true
        dotOne.transform = .init(scaleX: scale, y: scale)
        flexibleBottomAnchor = stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: offset)
        flexibleBottomAnchor?.isActive = true
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
        
        [dotOne, dotTwo, dotThree].forEach { (dot) in
            dot.layer.cornerRadius = frame.size.width / 2
            dot.backgroundColor = UIColor(named: "White")
            stackView.addArrangedSubview(dot)
        }
    
        layoutIfNeeded()
        
    }
 
    func animate(with scrollPercentage: CGFloat) {
        
        let percOffset = frame.height * scrollPercentage
        print(percOffset, scrollPercentage)
        if percOffset < 0 { return }
        if percOffset > frame.height * 2 { return }
        
        flexibleTopAnchor?.constant -= percOffset
        flexibleBottomAnchor?.constant -= percOffset
    }
}
