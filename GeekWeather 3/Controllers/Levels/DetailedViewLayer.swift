//
//  DetailedViewLayer.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 1/19/21.
//  Copyright © 2021 ByCyril. All rights reserved.
//

import UIKit
import GWFoundation

final class DetailedViewLayer: UICollectionView {
    
    private var detailsData = [ItemData]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
        register(DetailedViewCell.self, forCellWithReuseIdentifier: "cell")
        flashScrollIndicators()
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        super.init(frame: frame, collectionViewLayout: flowLayout)
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
