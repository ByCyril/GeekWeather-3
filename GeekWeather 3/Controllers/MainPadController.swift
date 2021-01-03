//
//  MainPadController.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 1/2/21.
//  Copyright © 2021 ByCyril. All rights reserved.
//

import GWFoundation
import CoreLocation
import UIKit

final class MainPadController: UIViewController, NetworkManagerDelegate, LocationManagerDelegate {

    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var tempLabel: UILabel!
    @IBOutlet var lowTempLabel: UILabel!
    @IBOutlet var highTempLabel: UILabel!
    @IBOutlet var iconView: UIImageView!
    
    private var hourlyDataSource: UICollectionViewDiffableDataSource<Section, Hourly>?
    private var dailyDataSource: UICollectionViewDiffableDataSource<Section, Daily>?
    
    private var locationManager: LocationManager?
    private var networkManager: NetworkManager?

    private let gradientLayer = CAGradientLayer()
    let theme = UserDefaults.standard.string(forKey: "Theme") ?? "System-"

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    lazy var hourlyView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 80, height: 125)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.alwaysBounceHorizontal = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    lazy var dailyView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 100, height: 140)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.alwaysBounceHorizontal = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
    
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initMethod()
        createGradient()
        setupHourlyView()
        setupDailyView()
    }
        
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
    
    func initMethod() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(listenForLocation(_:)), name: NotificationName.observerID("currentLocation"), object: nil)
        
        if let mock = Mocks.mockedResponse() {
            networkManager = NetworkManager(self, mock)
        } else {
            networkManager = NetworkManager(self)
        }
        
        locationManager = LocationManager(self)
        locationManager?.beginFetchingLocation()
    }
    
    func createGradient() {
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor(named: theme + "GradientTopColor")!.cgColor,
                                UIColor(named: theme + "GradientBottomColor")!.cgColor]
        
        view.layer.insertSublayer(gradientLayer, at: 0)
        view.setNeedsDisplay()
    }
    
    @objc
    func listenForLocation(_ notification: NSNotification) {
        if let currentLocation = notification.userInfo?["currentLocation"] as? String {
            locationLabel.text = currentLocation
        }
    }
    
    func setupHourlyView() {
        view.addSubview(hourlyView)
        
        let padding: CGFloat = 35
        
        NSLayoutConstraint.activate([
            hourlyView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hourlyView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hourlyView.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: padding),
            hourlyView.heightAnchor.constraint(equalToConstant: 125)
        ])
        
        view.layoutIfNeeded()
        
        let registration = UICollectionView.CellRegistration<LevelTwoHourlyViewCell, Hourly> { cell, indexPath, data in
            let time = (indexPath.row == 0) ? "Now" : data.dt.convertHourTime()
            cell.timestampLabel.text = time
            cell.iconView.image = UIImage(named: data.weather.first!.icon)
            cell.tempLabel.text = data.temp.kelvinToSystemFormat()
        }
        
        hourlyDataSource = UICollectionViewDiffableDataSource(collectionView: hourlyView, cellProvider: { (collectionView, indexpath, data) -> LevelTwoHourlyViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: registration, for: indexpath, item: data)
        })
    }
    
    func setupDailyView() {
        view.addSubview(dailyView)
        
        let padding: CGFloat = 35
        dailyView.backgroundColor = .red
        
        NSLayoutConstraint.activate([
            
            dailyView.topAnchor.constraint(equalTo: hourlyView.bottomAnchor, constant: padding),
            dailyView.centerXAnchor.constraint(equalTo: hourlyView.centerXAnchor),
            dailyView.heightAnchor.constraint(equalToConstant: 150)
//            dailyView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            dailyView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            dailyView.topAnchor.constraint(equalTo: hourlyView.bottomAnchor, constant: padding),
//            dailyView.heightAnchor.constraint(equalToConstant: 150)
        ])
        
        view.layoutIfNeeded()
        
        let registration = UICollectionView.CellRegistration<LevelTwoDailyViewCell, Daily> { (cell, indexPath, daily) in
            
            let summary = daily.weather.first!.description
            
            if indexPath.row == 0 {
                cell.dayLabel.text = "Today"
                cell.applyAccessibility(with: "Forecast throughout the week", and: "Today. \(summary), and a high of \(daily.temp.max.kelvinToSystemFormat()) and a low of \(daily.temp.min.kelvinToSystemFormat())", trait: .staticText)
            } else {
                let day = Double(daily.dt).date(.shortDay)
                cell.dayLabel.text = day
                cell.applyAccessibility(with: "On \(day)", and: "\(summary), and a high of \(daily.temp.max.kelvinToSystemFormat()) and a low of \(daily.temp.min.kelvinToSystemFormat())", trait: .staticText)
            }
            
            cell.iconView.image = UIImage(named: daily.weather.first!.icon)
            cell.highTempLabel.text = daily.temp.max.kelvinToSystemFormat()
            cell.lowTempLabel.text = daily.temp.min.kelvinToSystemFormat()
        }
        
        dailyDataSource = UICollectionViewDiffableDataSource(collectionView: dailyView, cellProvider: { (collectionView, indexpath, data) -> LevelTwoDailyViewCell? in
            let cell = collectionView.dequeueConfiguredReusableCell(using: registration, for: indexpath, item: data)
            cell.verticalLayout()
            return cell
        })
    }
    
    func populate(with weatherModel: WeatherModel) {
        var hourlySnapshot = NSDiffableDataSourceSnapshot<Section, Hourly>()
        hourlySnapshot.appendSections([.main])
        hourlySnapshot.appendItems(Array(weatherModel.hourly[..<20]))
        hourlyDataSource?.apply(hourlySnapshot)
        
        var dailySnapshot = NSDiffableDataSourceSnapshot<Section, Daily>()
        dailySnapshot.appendSections([.main])
        dailySnapshot.appendItems(weatherModel.daily)
        dailyDataSource?.apply(dailySnapshot)
    }
    
    func didFinishFetching(_ weatherModel: WeatherModel) {
        DispatchQueue.main.async { [weak self] in
            self?.tempLabel.text = weatherModel.current.temp.kelvinToSystemFormat()
            self?.highTempLabel.text = weatherModel.daily.first?.temp.max.kelvinToSystemFormat() ?? "na"
            self?.lowTempLabel.text = weatherModel.daily.first?.temp.min.kelvinToSystemFormat() ?? "na"
            self?.iconView.image = UIImage(named: weatherModel.current.weather.first?.icon ?? "na")
            self?.populate(with: weatherModel)
        }
    }
    
    func networkError(_ error: Error?) {
        
    }
    
    func currentLocation(_ location: CLLocation) {
        locationManager?.lookupCurrentLocation(location)
        let url = RequestURL(location: location)
        networkManager?.fetch(url)
    }
    
    func locationError(_ errorMsg: String, _ status: CLAuthorizationStatus?) {
        
    }
    
}
