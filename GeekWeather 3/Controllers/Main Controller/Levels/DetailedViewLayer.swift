//
//  DetailedViewLayer.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 1/19/21.
//  Copyright © 2021 ByCyril. All rights reserved.
//

import UIKit

extension DetailedViewLayer: DetailedFlowLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, widthForItemAtIndexPath indexPath: IndexPath) -> CGFloat {
        return detailsData[indexPath.row].width
    }
}

final class DetailedViewLayer: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    private var detailsData = [ItemData]()
    private var weatherModel: WeatherModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if let layout = collectionViewLayout as? DetailedFlowLayout {
            layout.delegate = self
        }
        
        delegate = self
        dataSource = self
        backgroundColor = .clear
        register(DetailedViewCell.self, forCellWithReuseIdentifier: "cell")
        flashScrollIndicators()
    }
    
    func update() {
        guard let weatherModel = self.weatherModel else { return }
        populate(weatherModel)
    }
    
    func populate(_ weatherModel: WeatherModel) {
        
        self.weatherModel = weatherModel
        let current = weatherModel.current
        
        let itemOne = ItemData(firstItemLabel: "Sunrise",
                               firstItemValue: current.sunrise.convertTime(weatherModel.timezone).lowercased(),
                               width: 115)
        
        let itemTwo = ItemData(firstItemLabel: "Sunset",
                               firstItemValue: current.sunset.convertTime(weatherModel.timezone).lowercased(),
                               width: 115)
        
        let itemThree = ItemData(firstItemLabel: "Dew Point",
                                 firstItemValue: weatherModel.current.dew_point.kelvinToSystemFormat(),
                                 width: 90)
        
        let itemFour = ItemData(firstItemLabel: "Visibility",
                                firstItemValue: weatherModel.current.visibility.mToSystemFormat(),
                                width: 115)
        
        let itemFive = ItemData(firstItemLabel: "Chance of Rain",
                                firstItemValue: weatherModel.daily.first!.pop.percentage(chop: true),
                                width: 125)
        
        let itemSix = ItemData(firstItemLabel: "Cloud Cover",
                               firstItemValue: current.clouds.percentage(chop: true),
                               width: 115)
        
        let uvi = current.uvi
        var uviLevel = uvi.stringRound()
        
        if (0...2) ~= uvi {
            uviLevel += " Low"
        } else if (3...5) ~= uvi {
            uviLevel += " Moderate"
        } else if (6...7) ~= uvi {
            uviLevel += " High"
        } else if (8...9) ~= uvi {
            uviLevel += " Very High"
        } else if uvi >= 11 {
            uviLevel += " Extreme"
        }
        
        let itemSeven = ItemData(firstItemLabel: "Humidity",
                                 firstItemValue: current.humidity.percentage(chop: true),
                                 width: 85)
        
        let itemEight = ItemData(firstItemLabel: "UV Index",
                                 firstItemValue: uviLevel,
                                 width: 125)
        
        let itemNine = ItemData(firstItemLabel: "Wind Speed",
                                firstItemValue: current.wind_speed.msToSystemFormat(),
                                width: 145)
        
        let itemTen = ItemData(firstItemLabel: "Pressure",
                               firstItemValue: current.pressure.stringRound() + " hPa",
                               width: 165)
        
        detailsData = [itemOne, itemThree, itemTwo, itemFour, itemFive, itemSix, itemSeven, itemEight, itemNine, itemTen]
        reloadData()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    var d = 0.1
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        d = 0
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        cell.transform = .init(scaleX: 0.001, y: 0.001)
        d += 0.05
        UIView.animate(withDuration: 0.4,
                       delay: d,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.5,
                       options: .curveEaseInOut) {
            cell.transform = .identity
            cell.alpha = 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return detailsData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? DetailedViewCell else { return UICollectionViewCell() }
        
        let data = detailsData[indexPath.row]
        
        cell.firstItemLabel.text = data.firstItemLabel
        cell.firstItemValue.text = data.firstItemValue
        cell.applyAccessibility(with: data.firstItemLabel, and: data.firstItemValue, trait: .staticText)
        
        return cell
    }
    
}
