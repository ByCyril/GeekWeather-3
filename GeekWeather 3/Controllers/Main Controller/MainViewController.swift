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

class MainViewController: UIViewController, UIScrollViewDelegate, LocationManagerDelegate, NetworkManagerDelegate, UIScrollViewAccessibilityDelegate {
 
    private let notificationManager = NotificationManager()
    
    private var levels = [BaseView]()
    
    private var weatherModel: WeatherModel?
    private var networkManager: NetworkManager?
    var locationManager: LocationManager?
    
    @IBOutlet var navView: NavigationView?
    @IBOutlet var customNavView: UIView!
    
    @IBOutlet var shadowView: UIView!
    
    private let gradientLayer = CAGradientLayer()
    
    private var levelOneViewController: LevelOneViewController?
    private var levelTwoViewController: LevelTwoViewController?
    private var levelThreeViewController: LevelThreeViewController?
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.isScrollEnabled = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isAccessibilityElement = false
        return scrollView
    }()
    
    let shadowOpacity: CGFloat = 0.75
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "GradientBottomColor")
        initMethod()
        
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowRadius = 5
        shadowView.layer.shadowOpacity = Float(shadowOpacity)
        shadowView.alpha = 0
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 10)
        shadowView.backgroundColor = UIColor(named: "GradientBottomColor")
        
        scrollView.delegate = self
        view.insertSubview(scrollView, at: 0)
        
    }
    
    func createGradient() {
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor(named: "GradientTopColor")!.cgColor,
                                UIColor(named: "GradientBottomColor")!.cgColor]
        
        view.layer.insertSublayer(gradientLayer, at: 0)
        view.setNeedsDisplay()
    }
    
    func initMethod() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(newLocation(_:)), name: Notification.Name("NewLocationLookup"), object: nil)
        
        locationManager = LocationManager(self)
        locationManager?.beginFetchingLocation()
        
        if let error = Mocks.mockError() {
            networkManager = NetworkManager(self, error)
            return
        }
        
        if let data = Mocks.mockedResponse() {
            networkManager = NetworkManager(self, data)
        } else {
            networkManager = NetworkManager(self)
        }
    }
    
    @objc
    func newLocation(_ notification: NSNotification) {
        guard let location = notification.object as? CLLocation else { return }
        navView?.rollableTitleView.hideTitles()
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut) {
            self.scrollView.transform = .init(translationX: 0, y: self.view.frame.size.height * 2)
        } completion: { (_) in
            self.currentLocation(location)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard let navView = self.navView else { return }
        let scrollViewYOffset = navView.frame.size.height + UIApplication.shared.windows[0].safeAreaInsets.top
        let trueHeight = view.bounds.size.height - scrollViewYOffset
        
        scrollView.frame = CGRect(x: 0, y: scrollViewYOffset, width: view.frame.size.width, height: trueHeight)
        scrollView.transform = .init(translationX: 0, y: view.frame.size.height)
        
        if scrollView.subviews.count == 0 {
            initUI()
        }
    }
    
    func accessibilityScrollStatus(for scrollView: UIScrollView) -> String? {
        let offsetY = scrollView.contentOffset.y
        let page = offsetY / scrollView.frame.size.height
    
        return ["Today View", "Forecast View", "Details View"][Int(page)]
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        UIView.animate(withDuration: 0.1) {
            self.shadowView.alpha = 0
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        shadowView.isHidden = false
        UIView.animate(withDuration: 0.1) {
            self.shadowView.alpha = self.shadowOpacity
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollPercentage = (scrollView.contentOffset.y / scrollView.contentSize.height)        
        let navScrollViewHeight = (225 * scrollPercentage)
        navView?.rollableTitleView.animateWithOffset(navScrollViewHeight)
    }

    func initUI() {
        guard let navView = self.navView else { return }
        let scrollViewYOffset = navView.frame.size.height + UIApplication.shared.windows[0].safeAreaInsets.top
        let trueHeight = view.bounds.size.height - scrollViewYOffset
        
        scrollView.contentSize = CGSize(width: view.frame.size.width, height: trueHeight*3)

        levelOneViewController = LevelOneViewController(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: trueHeight))
        levelTwoViewController = LevelTwoViewController(frame: CGRect(x: 0, y: trueHeight, width: view.bounds.size.width, height: trueHeight))
        levelThreeViewController = LevelThreeViewController(frame: CGRect(x: 0, y: trueHeight * 2, width: view.bounds.size.width, height: trueHeight))

        scrollView.addSubview(levelOneViewController!)
        scrollView.addSubview(levelTwoViewController!)
        scrollView.addSubview(levelThreeViewController!)
        
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
    
    func currentLocation(_ location: CLLocation) {
        let req = RequestURL(location: location, .imperial)
        networkManager?.fetch(req)
    }
    
    func didFinishFetching(_ weatherModel: WeatherModel) {
        let location = CLLocation(latitude: weatherModel.lat, longitude: weatherModel.lon)
        locationManager?.lookupCurrentLocation(location)
        
        UserDefaults.standard.setValue(Date(), forKey: "LastUpdated")
        
        DispatchQueue.main.async { [weak self] in
            self?.animateMainScrollView()
            self?.notificationManager.post(data: ["weatherModel": weatherModel], to: NotificationName.observerID("weatherModel"))
        }
    }
    
    func animateMainScrollView() {
        navView?.rollableTitleView.showTitles()
        scrollView.isScrollEnabled = true
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut) { [weak self] in
            self?.scrollView.transform = .identity
        }
    }
    
    func locationError(_ errorMsg: String,_ status: CLAuthorizationStatus?) {
        presentError(errorMsg)
    }
    
    func networkError(_ error: Error?) {
        guard let error = error else { return }
        presentError(error.localizedDescription)
    }
    
    func presentError(_ errorMsg: String) {
        guard let vc = storyboard?.instantiateViewController(identifier: "ErrorViewController") as? ErrorViewController else { return }
        
        let animation = AnimationType(name: "denied", speed: 0.5, size: CGSize(width: 250, height: 250), message: errorMsg)
        vc.displayAnimation(with: animation)
        
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .fullScreen
        
        present(vc, animated: true, completion: nil)
    }
    
}
