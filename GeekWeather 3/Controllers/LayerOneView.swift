//
//  LayerOneView.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 1/2/21.
//  Copyright © 2021 ByCyril. All rights reserved.
//

import UIKit
import GWFoundation

final class LayerOneView: UIView {
    
    private var locationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = GWFont.AvenirNext(style: .Bold, size: 40)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var tempLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = GWFont.AvenirNext(style: .Bold, size: 75)
        return label
    }()
    
    private var highTempLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = GWFont.AvenirNext(style: .Bold, size: 30)
        return label
    }()
    
    private var lowTempLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = GWFont.AvenirNext(style: .Medium, size: 30)
        return label
    }()
    
    private var iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    init() {
        super.init(frame: .zero)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(listenForLocation(_:)),
                                               name: NotificationName.observerID("currentLocation"),
                                               object: nil)

        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc
    func listenForLocation(_ notification: NSNotification) {
        if let currentLocation = notification.userInfo?["currentLocation"] as? String {
            locationLabel.text = currentLocation
        }
    }
    
    func initUI() {
        
        let containerView: UIStackView = {
            let stack = UIStackView()
            stack.alignment = .leading
            stack.distribution = .fillProportionally
            stack.axis = .vertical
            stack.translatesAutoresizingMaskIntoConstraints = false
            return stack
        }()
        
        let tempContainers: UIStackView = {
            let stack = UIStackView()
            stack.alignment = .leading
            stack.distribution = .fillEqually
            stack.axis = .horizontal
            stack.spacing = 5
            return stack
        }()
        
        tempContainers.addArrangedSubview(highTempLabel)
        tempContainers.addArrangedSubview(lowTempLabel)
        
        containerView.addArrangedSubview(tempLabel)
        containerView.addArrangedSubview(tempContainers)
        
        addSubview(containerView)
        addSubview(locationLabel)
        addSubview(iconView)
        
        let padding: CGFloat = 25
        
        NSLayoutConstraint.activate([
            locationLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: padding),
            locationLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: padding),
            
            iconView.topAnchor.constraint(equalTo: locationLabel.bottomAnchor),
            iconView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: padding),
            iconView.heightAnchor.constraint(equalToConstant: 150),
            iconView.widthAnchor.constraint(equalTo: iconView.heightAnchor),
            iconView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            containerView.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: padding),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            containerView.heightAnchor.constraint(equalTo: iconView.heightAnchor),
            containerView.centerYAnchor.constraint(equalTo: iconView.centerYAnchor)
        ])
        
        layoutIfNeeded()
    }
    
    func populate(_ weatherModel: WeatherModel) {
        iconView.image = UIImage(named: weatherModel.current.weather.first!.icon)
        tempLabel.text = weatherModel.current.temp.kelvinToSystemFormat()
        highTempLabel.text = weatherModel.daily.first!.temp.max.kelvinToSystemFormat()
        lowTempLabel.text = weatherModel.daily.first!.temp.min.kelvinToSystemFormat()
    }
    
}
