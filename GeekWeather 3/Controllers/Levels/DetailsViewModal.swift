//
//  DetailsViewModal.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 1/2/21.
//  Copyright © 2021 ByCyril. All rights reserved.
//

import UIKit
import GWFoundation

final class DetailsViewModal: UIView {
    
    var iconView = UIImageView()
    var dayLabel = UILabel()
    var summaryLabel = UILabel()
    
    private var containerStackView: UIStackView?
    private var leftCol: UIStackView?
    private var rightCol: UIStackView?
    
    init() {
        super.init(frame: .zero)
        initUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initUI() {
        containerStackView = createStackView(.horizontal, .fillEqually)
        addSubview(containerStackView!)
        
        let topContainer = createStackView(.horizontal, .fill)
        topContainer.spacing = 15
        topContainer.addArrangedSubview(iconView)
        
        summaryLabel.textColor = .white
        summaryLabel.font = GWFont.AvenirNext(style: .Medium, size: 17)
        dayLabel.textColor = .white
        dayLabel.font = GWFont.AvenirNext(style: .Bold, size: 35)
        
        let contentStack = createStackView(.vertical, .fillProportionally)
        contentStack.addArrangedSubview(dayLabel)
        contentStack.addArrangedSubview(summaryLabel)
        topContainer.addArrangedSubview(contentStack)
        
        
        addSubview(topContainer)
        
        let padding: CGFloat = 25
        
        NSLayoutConstraint.activate([
            iconView.heightAnchor.constraint(equalToConstant: 75),
            iconView.widthAnchor.constraint(equalToConstant: 75),
            topContainer.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: padding),
            topContainer.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: padding),
            topContainer.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            topContainer.heightAnchor.constraint(equalToConstant: 75)
        ])
       
        
        leftCol = createStackView(.vertical, .fillEqually)
        leftCol?.spacing = 7
        rightCol = createStackView(.vertical, .fillEqually)
        rightCol?.spacing = 7
        
        containerStackView?.addArrangedSubview(leftCol!)
        containerStackView?.addArrangedSubview(rightCol!)
        
        
        NSLayoutConstraint.activate([
            containerStackView!.topAnchor.constraint(equalTo: summaryLabel.bottomAnchor, constant: padding),
            containerStackView!.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -padding),
            containerStackView!.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: padding),
            containerStackView!.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        ])
        
        layoutIfNeeded()
    }
    
    func presentData(_ daily: Daily) {
    
        backgroundColor = UIColor(named: "System-GradientTopColor")
        layer.cornerRadius = 15
        
        let dataOne = DetailsData(firstItemLabel: "Sunrise",
                                    firstItemValue: daily.sunrise.convertTime(),
                                    secondItemLabel: "Sunset",
                                    secondItemValue: daily.sunset.convertTime())
        
        let dataTwo = DetailsData(firstItemLabel: "Chance of Rain",
                                  firstItemValue: daily.pop.percentage(chop: false),
                                  secondItemLabel: "Cloud Cover",
                                  secondItemValue: daily.clouds.percentage(chop: false))
        
        
        let dataThree = DetailsData(firstItemLabel: "Wind Speed",
                                    firstItemValue: daily.wind_speed.msToSystemFormat(),
                                    secondItemLabel: "Wind Degrees",
                                    secondItemValue: daily.wind_deg.stringRound())
        
        let uvi = daily.uvi
        var uviLevel = uvi.stringRound()
        
        if (0...2) ~= uvi {
            uviLevel += " Low"
        } else if (3...5) ~= uvi {
            uviLevel += " Moderate"
        } else if (6...7) ~= uvi {
            uviLevel += " High"
        } else if (8...9) ~= uvi {
            uviLevel += " VERY HIGH"
        } else if uvi >= 11 {
            uviLevel += " Extreme"
        }
        
        let dataFour = DetailsData(firstItemLabel: "Humidty",
                                   firstItemValue: daily.humidity.percentage(chop: false),
                                    secondItemLabel: "UV Index",
                                    secondItemValue: uviLevel)
        
        let dataFive = DetailsData(firstItemLabel: "Dew Point",
                                     firstItemValue: daily.dew_point.kelvinToSystemFormat(),
                                    secondItemLabel: "Pressure",
                                    secondItemValue: daily.pressure.stringRound() + " hPa")
        
        for item in [dataOne, dataTwo, dataThree, dataFour, dataFive] {
            let firstItemStack = createStackView(.vertical, .fillProportionally)
            
            let firstItemLabel = UILabel()
            firstItemLabel.text = item.firstItemLabel
            firstItemLabel.font = GWFont.AvenirNext(style: .Medium, size: 12)
            firstItemLabel.textColor = .white
            firstItemLabel.alpha = 0.75
            
            let firstItemValue = UILabel()
            firstItemValue.text = item.firstItemValue
            firstItemValue.font = GWFont.AvenirNext(style: .Medium, size: 20)
            firstItemValue.textColor = .white
            firstItemStack.addArrangedSubview(firstItemLabel)
            firstItemStack.addArrangedSubview(firstItemValue)
            
            let secondItemStack = createStackView(.vertical, .fillProportionally)
            
            let secondItemLabel = UILabel()
            secondItemLabel.text = item.secondItemLabel
            secondItemLabel.font = GWFont.AvenirNext(style: .Medium, size: 12)
            secondItemLabel.textColor = .white
            secondItemLabel.alpha = 0.75
            let secondItemValue = UILabel()
            secondItemValue.text = item.secondItemValue
            secondItemValue.font = GWFont.AvenirNext(style: .Medium, size: 20)
            secondItemValue.textColor = .white
            secondItemStack.addArrangedSubview(secondItemLabel)
            secondItemStack.addArrangedSubview(secondItemValue)
            
            leftCol?.addArrangedSubview(firstItemStack)
            rightCol?.addArrangedSubview(secondItemStack)
        }
    }
    
    func createStackView(_ axis: NSLayoutConstraint.Axis, _ distribution: UIStackView.Distribution) -> UIStackView {
        let stackView = UIStackView()
        stackView.alignment = .leading
        stackView.distribution = distribution
        stackView.axis = axis
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
}
