//
//  MainViewController.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 7/26/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import UIKit
import GWFoundation
import CoreLocation

class MainViewController: UIViewController, UIScrollViewDelegate {
    
    private let notificationManager = NotificationManager()
    
    private var levels = [BaseView]()
    private var weatherModel: WeatherModel?

    @IBOutlet var navView: NavigationView!
    @IBOutlet var customNavView: UIView!
    
    private let gradientLayer = CAGradientLayer()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        view.addSubview(scrollView)
        
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor(named: "GradientTopColor")!.cgColor,
                                UIColor(named: "GradientBottomColor")!.cgColor]

        view.layer.insertSublayer(gradientLayer, at: 0)
        view.setNeedsDisplay()

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let scrollViewYOffset = navView.frame.size.height + UIApplication.shared.windows[0].safeAreaInsets.top
        let trueHeight = view.bounds.size.height - scrollViewYOffset
        
        scrollView.frame = CGRect(x: 0, y: scrollViewYOffset, width: view.frame.size.width, height: trueHeight)

        initUI()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollPercentage = (scrollView.contentOffset.y / scrollView.contentSize.height)        
        let navScrollViewHeight = (225 * scrollPercentage)
        navView.rollableTitleView.animateWithOffset(navScrollViewHeight)
    }

    func initUI() {
        
        let scrollViewYOffset = navView.frame.size.height + UIApplication.shared.windows[0].safeAreaInsets.top
        let trueHeight = view.bounds.size.height - scrollViewYOffset
        
        scrollView.contentSize = CGSize(width: view.frame.size.width, height: trueHeight*3)

        let levelOneViewController = LevelOneViewController(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: trueHeight))
        let levelTwoViewController = LevelTwoViewController(frame: CGRect(x: 0, y: trueHeight, width: view.bounds.size.width, height: trueHeight))
        let levelThreeViewController = LevelThreeViewController(frame: CGRect(x: 0, y: trueHeight * 2, width: view.bounds.size.width, height: trueHeight))

        scrollView.addSubview(levelOneViewController)
        scrollView.addSubview(levelTwoViewController)
        scrollView.addSubview(levelThreeViewController)
        
        notificationManager.post(data: ["weatherModel": weatherModel!], to: NotificationName.observerID("weatherModel"))
    }
        
    func prepareToDeliverData(_ weatherModel: WeatherModel) {
        self.weatherModel = weatherModel
    }
    
    @IBAction func presentSavedLocationController() {
        GWTransition.present(SavedLocationViewController(), from: self)
    }
    
    @IBAction func presentSettingsController() {
        GWTransition.present(SettingsController(), from: self)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        guard traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) else {
            return
        }

        gradientLayer.colors = [UIColor(named: "GradientTopColor")!.cgColor,
                                UIColor(named: "GradientBottomColor")!.cgColor]
    }
    
}
