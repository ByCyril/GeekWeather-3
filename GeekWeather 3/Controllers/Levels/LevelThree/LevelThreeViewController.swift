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

final class LevelThreeTableViewCell: UITableViewCell {
    @IBOutlet var firstItemLabel: UILabel!
    @IBOutlet var firstItemValue: UILabel!
    @IBOutlet var secondItemLabel: UILabel!
    @IBOutlet var secondItemValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
    }
}

struct DetailsData {
    var firstItemLabel: String
    var firstItemValue: String
    var secondItemLabel: String
    var secondItemValue: String
}

final class LevelThreeViewController: BaseView, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet var summaryLabel: UILabel!
    @IBOutlet var iconView: UIImageView!
    
    private var detailsData = [DetailsData]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        let view = Bundle.main.loadNibNamed("LevelThreeViewController", owner: self, options: nil)?.first as! LevelThreeViewController
        
        loadXib(view, self)
        
        tableView.backgroundColor = .clear
        tableView.register(UINib(nibName: "LevelThreeTableViewCell", bundle: .main), forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func update(from notification: NSNotification) {
        if let weatherModel = notification.userInfo?["weatherModel"] as? WeatherModel {
            prepareGeekyData(weatherModel)
            prepareSummary(weatherModel)
        }
    }
    
    func prepareSummary(_ weatherModel: WeatherModel) {
        let high = weatherModel.daily.first!.temp.max.temp()
        let low = weatherModel.daily.first!.temp.min.temp()
        let description = weatherModel.current.weather.first!.description.capitalizingFirstLetter()
        let location = "San Jose, CA"
        let summary = "\(description) in \(location) with a high of \(high) and a low of \(low)"
        
        summaryLabel.text = summary
        iconView.image = UIImage(named: weatherModel.current.weather.first!.icon)
    }
    
    func prepareGeekyData(_ weatherModel: WeatherModel) {
        let current = weatherModel.current
        
        let firstRow = DetailsData(firstItemLabel: "Sunrise",
                                        firstItemValue: current.sunrise.date(.time),
                                        secondItemLabel: "Sunset",
                                        secondItemValue: current.sunset.date(.time))
        
        let secondRow = DetailsData(firstItemLabel: "High Temperature",
                                      firstItemValue: weatherModel.daily.first!.temp.max.temp(),
                                      secondItemLabel: "Low Temperature",
                                      secondItemValue: weatherModel.daily.first!.temp.min.temp())
        
        let thirdRow = DetailsData(firstItemLabel: "Chance of Rain",
                                   firstItemValue: weatherModel.daily.first!.pop.percentage(chop: true),
                                   secondItemLabel: "Cloud Cover",
                                   secondItemValue: current.clouds.percentage(chop: true))
        
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
        
        let fourthRow = DetailsData(firstItemLabel: "Humidity",
                                    firstItemValue: current.humidity.percentage(chop: true),
                                    secondItemLabel: "UV Index",
                                    secondItemValue: uviLevel)
        
        detailsData = [firstRow, secondRow, thirdRow, fourthRow]
        tableView.reloadData()
    }
        
    override func getContentOffset(_ offset: CGPoint) {
        let height = frame.size.height
        tableView.alpha = (1 - ((offset.y) / height)) * -1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LevelThreeTableViewCell
        let data = detailsData[indexPath.row]
        
        cell.firstItemLabel.text = data.firstItemLabel
        cell.firstItemValue.text = data.firstItemValue
        cell.secondItemLabel.text = data.secondItemLabel
        cell.secondItemValue.text = data.secondItemValue
        
        return cell
    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return geekyData.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? LevelThreeCollectionViewCell
//
//        let data = geekyData[indexPath.row]
//
//        cell?.titleLabel.text = data.title
//        cell?.iconView.image = UIImage(named: data.image)
//        cell?.infoLabel.text = data.info
//        cell?.layer.cornerRadius = 10
//
//        return cell!
//    }
//    let spacing: CGFloat = 10
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        let numberOfItemsPerRow: CGFloat = 3
//        let spacingBetweenCells: CGFloat = 10
//
//        let totalSpacing = (2 * spacing) + ((numberOfItemsPerRow - 1) * spacingBetweenCells)
//
//        let width = (collectionView.bounds.width - totalSpacing) / numberOfItemsPerRow
//        return CGSize(width: width, height: width)
//
//    }
    
    
    
}
