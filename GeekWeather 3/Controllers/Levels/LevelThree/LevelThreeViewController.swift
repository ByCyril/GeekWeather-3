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
        
        let label = GWFont.AvenirNext(style: .Regular, size: 15)
        let value = GWFont.AvenirNext(style: .Medium, size: 25)
        
        firstItemLabel.numberOfLines = 0
        firstItemValue.numberOfLines = 0
        secondItemLabel.numberOfLines = 0
        secondItemValue.numberOfLines = 0
        
        firstItemLabel.adjustsFontForContentSizeCategory = true
        firstItemValue.adjustsFontForContentSizeCategory = true
        secondItemLabel.adjustsFontForContentSizeCategory = true
        secondItemValue.adjustsFontForContentSizeCategory = true
        
        firstItemLabel.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: label, maximumPointSize: 25)
        firstItemValue.font = UIFontMetrics(forTextStyle: .subheadline).scaledFont(for: value, maximumPointSize: 35)
        secondItemLabel.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: label, maximumPointSize: 25)
        secondItemValue.font = UIFontMetrics(forTextStyle: .subheadline).scaledFont(for: value, maximumPointSize: 35)
        
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
        
        createBlurView()
        
        tableView.backgroundColor = .clear
        tableView.register(UINib(nibName: "LevelThreeTableViewCell", bundle: .main), forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.flashScrollIndicators()
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
        
        let firstRow = DetailsData(firstItemLabel: "Sunrise",
                                   firstItemValue: current.sunrise.convertTime(),
                                   secondItemLabel: "Sunset",
                                   secondItemValue: current.sunset.convertTime())
        
        let secondRow = DetailsData(firstItemLabel: "Dew Point",
                                    firstItemValue: weatherModel.current.dew_point.kelvinToSystemFormat(),
                                    secondItemLabel: "Visibility",
                                    secondItemValue: weatherModel.current.visibility.mToSystemFormat())

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
        
        let fifthRow = DetailsData(firstItemLabel: "Wind Speed",
                                   firstItemValue: current.wind_speed.msToSystemFormat(),
                                    secondItemLabel: "Pressure",
                                    secondItemValue: current.pressure.stringRound() + " hPa")
        
        detailsData = [firstRow, secondRow, thirdRow, fourthRow, fifthRow]
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? LevelThreeTableViewCell else { return UITableViewCell() }
        let data = detailsData[indexPath.row]
        
        cell.firstItemLabel.text = data.firstItemLabel
        cell.firstItemValue.text = data.firstItemValue
        cell.secondItemLabel.text = data.secondItemLabel
        cell.secondItemValue.text = data.secondItemValue
        
        return cell
    }
    
}
