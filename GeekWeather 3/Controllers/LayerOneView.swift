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
        label.font = GWFont.AvenirNext(style: .Bold, size: 30)
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

        let mainContainerView: UIStackView = {
            let stack = UIStackView()
            stack.alignment = .fill
            stack.distribution = .fillEqually
            stack.axis = .horizontal
            stack.translatesAutoresizingMaskIntoConstraints = false
            stack.spacing = 15
            return stack
        }()
        
        let containerView: UIStackView = {
            let stack = UIStackView()
            stack.alignment = .leading
            stack.distribution = .fill
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
        
        addSubview(locationLabel)
        
        mainContainerView.addArrangedSubview(iconView)
        mainContainerView.addArrangedSubview(containerView)
        addSubview(mainContainerView)
        
        let padding: CGFloat = 25
        
        NSLayoutConstraint.activate([
            
            locationLabel.topAnchor.constraint(equalTo: topAnchor, constant: padding * 2),
            locationLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconView.heightAnchor.constraint(equalToConstant: 150),
            iconView.widthAnchor.constraint(equalToConstant: 150),
            
            mainContainerView.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: padding * 2),
            mainContainerView.centerXAnchor.constraint(equalTo: locationLabel.centerXAnchor),
            mainContainerView.bottomAnchor.constraint(equalTo: bottomAnchor),
 
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
