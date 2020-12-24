//
//  LebelTwoViewController.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 8/20/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import UIKit
import GWFoundation
import Charts

final class LevelTwoCellView: UITableViewCell {
    @IBOutlet var dayLabel: UILabel!
    @IBOutlet var highTempLabel: UILabel!
    @IBOutlet var lowTempLabel: UILabel!
    @IBOutlet var iconView: UIImageView!
    @IBOutlet var precipView: UIStackView!
    @IBOutlet var percLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dayLabel.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: dayLabel.font)
        highTempLabel.font = UIFontMetrics(forTextStyle: .callout).scaledFont(for: highTempLabel.font)
        lowTempLabel.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: lowTempLabel.font)
        
        [dayLabel, highTempLabel, lowTempLabel].forEach { (element) in
            element?.isAccessibilityElement = false
            element?.adjustsFontForContentSizeCategory = true
            element?.sizeToFit()
            element?.numberOfLines = 0
        }
        
        isAccessibilityElement = true
        
    }
    
//    override func updateConstraints() {
//        if traitCollection.preferredContentSizeCategory.isAccessibilityCategory {
//            guard let str = dayLabel.text else { return }
//            let index = str.index(str.startIndex, offsetBy: 3)
//            dayLabel.text = String(str[..<index])
//        }
//        super.updateConstraints()
//    }
//
//    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
//        let isAccessibilityCategory = traitCollection.preferredContentSizeCategory.isAccessibilityCategory
//
//        if isAccessibilityCategory != previousTraitCollection?.preferredContentSizeCategory.isAccessibilityCategory {
//            setNeedsUpdateConstraints()
//        }
//    }
}

final class LevelTwoCollectionViewCell: UICollectionViewCell {
    @IBOutlet var timestampLabel: UILabel!
    @IBOutlet var tempLabel: UILabel!
    @IBOutlet var iconView: UIImageView!
}

enum Section {
    case main
}

final class LevelTwoViewController: BaseView, UITableViewDelegate, UITableViewDataSource {
   
    @IBOutlet var containerView: UIView!
    var dailyTableView: UITableView!
    var scrollView: UIScrollView!
    
    @IBOutlet weak var segmentController: UISegmentedControl!
    
    private var lineChart = LineChartView()
    
    private var weatherModel: WeatherModel?
    private var dataSource: UITableViewDiffableDataSource<Section, Daily>!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let view = Bundle.main.loadNibNamed("LevelTwoViewController", owner: self)!.first as! LevelTwoViewController
        loadXib(view, self)
        
        scrollViewSetup()
        tableViewSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func getContentOffset(_ offset: CGPoint) {
        
        let height = frame.size.height
        var alpha: CGFloat = 0
        
        if offset.y <= height {
            alpha = (1 - ((offset.y + height) / height)) * -1
        } else {
            alpha = 1 - ((offset.y - height) / height)
        }
        
        dailyTableView.alpha = alpha
        scrollView.alpha = alpha
        
    }
    
    private func scrollViewSetup() {
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: frame.width, height: 100))
        scrollView.contentSize = CGSize(width: frame.width * 7.5, height: 100)
        scrollView.isScrollEnabled = true
        addSubview(scrollView)
        
        lineChart.frame = CGRect(x: 25, y: 0,
                                 width: scrollView.contentSize.width - 25,
                                 height: scrollView.frame.size.height)
        lineChart.xAxis.drawGridLinesEnabled = false
        lineChart.xAxis.drawAxisLineEnabled = false
        lineChart.leftAxis.drawLabelsEnabled = false
        lineChart.leftAxis.drawGridLinesEnabled = false
        lineChart.legend.enabled = false
        lineChart.xAxis.labelPosition = .bottom
        lineChart.pinchZoomEnabled = false
        lineChart.dragEnabled = false
        lineChart.dragDecelerationEnabled = false
        lineChart.rightAxis.drawLabelsEnabled = false
        scrollView.addSubview(lineChart)
    }
    
    private func tableViewSetup() {
        let bottomPadding = UIApplication.shared.windows[0].safeAreaInsets.bottom + 125
        
        dailyTableView = UITableView(frame: CGRect(x: 0, y: 100, width: frame.width, height: frame.height - bottomPadding))
        dailyTableView.backgroundView?.backgroundColor = .clear
        dailyTableView.backgroundColor = .clear
        dailyTableView.estimatedRowHeight = 70
        dailyTableView.rowHeight = UITableView.automaticDimension
        dailyTableView.dataSource = self
        dailyTableView.delegate = self
        dailyTableView.separatorStyle = .none
        dailyTableView.register(UINib(nibName: "LevelTwoCellView", bundle: .main), forCellReuseIdentifier: "cell")
        addSubview(dailyTableView)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let dailyCount = weatherModel?.daily.count else { return 0 }
        return (tableView.frame.size.height / CGFloat(dailyCount))
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherModel?.daily.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? LevelTwoCellView
        cell?.backgroundColor = .clear
        
        let daily = weatherModel!.daily[indexPath.row]
        let summary = daily.weather.first!.description
        
        if indexPath.row == 0 {
            cell?.dayLabel.text = "Today"
            cell?.applyAccessibility(with: "Forecast throughout the week", and: "Today. \(summary), and a high of \(daily.temp.max.temp()) and a low of \(daily.temp.min.temp())", trait: .staticText)
        } else {
            let day = Double(daily.dt).date(.day)
            cell?.dayLabel.text = day
            cell?.applyAccessibility(with: "On \(day)", and: "\(summary), and a high of \(daily.temp.max.temp()) and a low of \(daily.temp.min.temp())", trait: .staticText)
        }
        
        if daily.pop > 0.15 {
            cell?.percLabel.text = "Chance of Rain " + daily.pop.percentage(chop: false)
            cell?.percLabel.isHidden = false
        } else {
            cell?.percLabel.isHidden = true
        }
        
        cell?.iconView.image = UIImage(named: daily.weather.first!.icon)
        cell?.highTempLabel.text = daily.temp.max.temp()
        cell?.lowTempLabel.text = daily.temp.min.temp()
        cell?.selectionStyle = .none
        
        return cell!
    }
    
    override func update(from notification: NSNotification) {
        guard let weatherModel = notification.userInfo?["weatherModel"] as? WeatherModel else { return }
        self.weatherModel = weatherModel
        dailyTableView.reloadData()
        
        var entries = [ChartDataEntry]()
        var timestamps = [String]()
        
        let hourlyData = weatherModel.hourly[0..<weatherModel.hourly.count]
        
        for (i,data) in hourlyData.enumerated() {
            let entry = ChartDataEntry(x: Double(i), y: data.temp)
            timestamps.append(data.dt.date(.hour))
            entries.append(entry)
        }
        
        let set = LineChartDataSet(entries: entries)
        set.colors = ChartColorTemplates.liberty()
        
        let data = LineChartData(dataSet: set)
        
        lineChart.data = data
        lineChart.rightAxis.removeAllLimitLines()

    }
    
}
