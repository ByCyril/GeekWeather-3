//
//  LevelThreeViewController.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 8/22/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import UIKit
import GWFoundation

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

final class LevelThreeCollectionViewCell: UICollectionViewCell {
    var firstItemLabel = UILabel()
    var firstItemValue = UILabel()
    let container = UIView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
     
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        
        let label = GWFont.AvenirNext(style: .Regular, size: 15)
        let value = GWFont.AvenirNext(style: .Medium, size: 25)
        
        firstItemLabel.numberOfLines = 0
        firstItemValue.numberOfLines = 0
        firstItemLabel.adjustsFontForContentSizeCategory = true
        firstItemValue.adjustsFontForContentSizeCategory = true
        firstItemLabel.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: label, maximumPointSize: 25)
        firstItemValue.font = UIFontMetrics(forTextStyle: .subheadline).scaledFont(for: value, maximumPointSize: 35)
        
        firstItemLabel.translatesAutoresizingMaskIntoConstraints = false
        firstItemValue.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.backgroundColor = UIColor.white.withAlphaComponent(0.15)
        contentView.layer.cornerRadius = 20
    
        contentView.addSubview(firstItemLabel)
        contentView.addSubview(firstItemValue)
        
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.rightAnchor.constraint(equalTo: rightAnchor),
            contentView.leftAnchor.constraint(equalTo: leftAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            firstItemLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            firstItemLabel.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor),
            firstItemLabel.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor),
            
            firstItemValue.topAnchor.constraint(equalTo: firstItemLabel.topAnchor),
            firstItemValue.leadingAnchor.constraint(equalTo: leadingAnchor),
            firstItemValue.trailingAnchor.constraint(equalTo: trailingAnchor),
            firstItemValue.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        layoutIfNeeded()
    }
  
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

struct ItemData {
    var firstItemLabel: String
    var firstItemValue: String
}

struct DetailsData {
    var firstItemLabel: String
    var firstItemValue: String
    var secondItemLabel: String
    var secondItemValue: String
}

final class LevelThreeViewController: BaseView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet var summaryLabel: UILabel!
    @IBOutlet var iconView: UIImageView!
    
    @IBOutlet var collectionViewFlowLayout: UICollectionViewFlowLayout! {
        didSet {
            collectionViewFlowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }
    
    private var detailsData = [ItemData]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let view = Bundle.main.loadNibNamed("LevelThreeViewController", owner: self, options: nil)?.first as! LevelThreeViewController
        loadXib(view, self)
        
        createBlurView()
        
        collectionView.backgroundColor = .clear
        collectionView.register(LevelThreeCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.flashScrollIndicators()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func didRecieve(from notification: NSNotification) {
        guard let weatherModel = notification.userInfo?["weatherModel"] as? WeatherModel else { return }
        self.weatherModel = weatherModel
        prepareDetailsData(weatherModel)
        prepareSummary(weatherModel)
    }
    
    override func didUpdateValues() {
        guard let weatherModel = self.weatherModel else { return }
        prepareDetailsData(weatherModel)
        prepareSummary(weatherModel)
    }
    
    func prepareSummary(_ weatherModel: WeatherModel) {
        let high = weatherModel.daily.first!.temp.max.kelvinToSystemFormat()
        let low = weatherModel.daily.first!.temp.min.kelvinToSystemFormat()
        let description = weatherModel.current.weather.first!.description.capitalizingFirstLetter()
        let summary = "\(description) with a high of \(high) and a low of \(low)."
        
        summaryLabel.text = summary
        iconView.image = UIImage(named: weatherModel.current.weather.first!.icon)
    }
    
    func prepareDetailsData(_ weatherModel: WeatherModel) {
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
        collectionView.reloadData()
    }
    
    override func getContentOffset(_ offset: CGPoint) {
        let height = frame.size.height
        collectionView.alpha = (1 - ((offset.y) / height)) * -1
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return detailsData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? LevelThreeCollectionViewCell else { return UICollectionViewCell() }
        
        let data = detailsData[indexPath.row]
        
        cell.firstItemLabel.text = data.firstItemLabel
        cell.firstItemValue.text = data.firstItemValue
        
        return cell
    }
    
}
