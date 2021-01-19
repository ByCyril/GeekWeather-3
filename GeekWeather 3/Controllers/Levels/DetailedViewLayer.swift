//
//  DetailedViewLayer.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 1/19/21.
//  Copyright © 2021 ByCyril. All rights reserved.
//

import UIKit
import GWFoundation

final class DetailedViewLayer: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    private var detailsData = [ItemData]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        delegate = self
        dataSource = self
        backgroundColor = .clear
        register(DetailedViewCell.self, forCellWithReuseIdentifier: "cell")
        flashScrollIndicators()
    }
    
    func populate(_ weatherModel: WeatherModel) {
        
        let current = weatherModel.current
        
        let itemOne = ItemData(firstItemLabel: "Sunrise",
                               firstItemValue: current.sunrise.convertTime())
        
        let itemTwo = ItemData(firstItemLabel: "Sunset",
                               firstItemValue: current.sunset.convertTime())
        
        let itemThree = ItemData(firstItemLabel: "Dew Point",
                                 firstItemValue: weatherModel.current.dew_point.kelvinToSystemFormat())
        
        let itemFour = ItemData(firstItemLabel: "Visibility",
                                firstItemValue: weatherModel.current.visibility.mToSystemFormat())
        
        let itemFive = ItemData(firstItemLabel: "Chance of Rain",
                                firstItemValue: weatherModel.daily.first!.pop.percentage(chop: true))
        
        let itemSix = ItemData(firstItemLabel: "Cloud Cover",
                               firstItemValue: current.clouds.percentage(chop: true))
        
        let uvi = current.uvi
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
        
        let itemSeven = ItemData(firstItemLabel: "Humidity",
                                 firstItemValue: current.humidity.percentage(chop: true))
        
        let itemEight = ItemData(firstItemLabel: "UV Index",
                                 firstItemValue: uviLevel)
        
        let itemNine = ItemData(firstItemLabel: "Wind Speed",
                                firstItemValue: current.wind_speed.msToSystemFormat())
        
        let itemTen = ItemData(firstItemLabel: "Pressure",
                               firstItemValue: current.pressure.stringRound() + " hPa")
        
        detailsData = [itemOne, itemTwo, itemThree, itemFour, itemFive, itemSix, itemSeven, itemEight, itemNine, itemTen]
        reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let firstItem: NSString = detailsData[indexPath.row].firstItemLabel as NSString
        let firstValue: NSString = detailsData[indexPath.row].firstItemValue as NSString
        
        let firstItemWidth = firstItem.size(withAttributes: nil).width
        let firstValueWidth = firstValue.size(withAttributes: nil).width
        
        if firstItemWidth > firstValueWidth {
            return CGSize(width: firstItemWidth + 125, height: 50)
        } else {
            return CGSize(width: firstValueWidth + 125, height: 50)
        }
    
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return detailsData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? DetailedViewCell else { return UICollectionViewCell() }
        
        let data = detailsData[indexPath.row]
        
        cell.firstItemLabel.text = data.firstItemLabel
        cell.firstItemValue.text = data.firstItemValue
        
        return cell
    }
    
}
