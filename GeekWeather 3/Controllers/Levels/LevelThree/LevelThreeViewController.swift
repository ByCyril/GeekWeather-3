//
//  LevelThreeViewController.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 8/22/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import UIKit
import GWFoundation

final class LevelThreeCollectionViewCell: UICollectionViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var iconView: UIImageView!
    @IBOutlet var infoLabel: UILabel!
}

struct GeekyData {
    var title: String
    var image: String
    var info: String
}

final class LevelThreeViewController: BaseView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet weak var containerView: UIView!
    
    private var geekyData = [GeekyData]()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        let view = Bundle.main.loadNibNamed("LevelThreeViewController", owner: self, options: nil)?.first as! LevelThreeViewController
        
        loadXib(view, self)
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        collectionView.collectionViewLayout = layout
        
        collectionView.backgroundColor = .clear
        collectionView.register(UINib(nibName: "LevelThreeCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "cell")
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func update(from notification: NSNotification) {
        if let weatherModel = notification.userInfo?["weatherModel"] as? WeatherModel {
            prepareGeekyData(weatherModel)
        }
    }
    
    func prepareGeekyData(_ weatherModel: WeatherModel) {
        let current = weatherModel.current
        let cloudCover = GeekyData(title: "Cloud Cover",
                                image: "04d",
                                info: current.clouds.percentage(chop: true))
        
        let humidity = GeekyData(title: "Humidity",
                                image: "humidity",
                                info: current.humidity.percentage(chop: true))
        
//        needs formatting
        let windSpeed = GeekyData(title: "Wind Speed", image: "50n", info: current.wind_speed.stringRound())
        
        let uvi = current.uvi
        var uviLevel = uvi.stringRound()
        
        if (0...2) ~= uvi {
            uviLevel += "\nLow"
        } else if (3...5) ~= uvi {
            uviLevel += "\nModerate"
        } else if (6...7) ~= uvi {
            uviLevel += "\nHigh"
        } else if (8...9) ~= uvi {
            uviLevel += "\nVERY HIGH"
        } else if uvi >= 11 {
            uviLevel += "\nExtreme"
        }
        
        let uvIndex = GeekyData(title: "UV Index", image: "uvi", info: uviLevel)
        
        let sunrise = GeekyData(title: "Sunrise", image: "01d", info: current.sunrise.date(.time))
        
        let sunset = GeekyData(title: "Sunset", image: "01n", info: current.sunset.date(.time))
        
        let percipPer = weatherModel.daily.first!.pop.percentage(chop: true)
        let chanceOfRain = GeekyData(title: "Chance of Rain", image: "rain", info: percipPer)
        
        let max = weatherModel.daily.first!.temp.max.temp()
        let highTemp = GeekyData(title: "High Temperature", image: "018-high temperature", info: max)
        
        let min = weatherModel.daily.first!.temp.min.temp()
        let lowTemp = GeekyData(title: "Low Temperature", image: "019-low temperature", info: min)
        
        geekyData = [sunrise, sunset, chanceOfRain,
                     highTemp, lowTemp, cloudCover,
                     humidity, uvIndex, windSpeed]
        collectionView.reloadData()
    }
        
    override func getContentOffset(_ offset: CGPoint) {
        let height = frame.size.height
        collectionView.alpha = (1 - ((offset.y) / height)) * -1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return geekyData.count
    }
       
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? LevelThreeCollectionViewCell
        
        let data = geekyData[indexPath.row]
        
        cell?.titleLabel.text = data.title
        cell?.iconView.image = UIImage(named: data.image)
        cell?.infoLabel.text = data.info
        cell?.layer.cornerRadius = 10
        
        return cell!
    }
    let spacing: CGFloat = 10
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let numberOfItemsPerRow: CGFloat = 3
        let spacingBetweenCells: CGFloat = 10
        
        let totalSpacing = (2 * spacing) + ((numberOfItemsPerRow - 1) * spacingBetweenCells)
        
        let width = (collectionView.bounds.width - totalSpacing) / numberOfItemsPerRow
        return CGSize(width: width, height: width)
        
    }
    
    
    
}
