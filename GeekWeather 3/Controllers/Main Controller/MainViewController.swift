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
    @IBOutlet var shadowView: UIView!
    
    private let gradientLayer = CAGradientLayer()
    private let shadowOpacity: CGFloat = 0.75
    
    private var levelOneViewController: LevelOneViewController?
    private var levelTwoViewController: LevelTwoViewController?
    private var levelThreeViewController: LevelThreeViewController?
    
    let theme = UserDefaults.standard.string(forKey: "Theme") ?? "System-"
    
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        initMethod()
        createShadows()
        createGradient()
        
        NotificationCenter.default.addObserver(self, selector: #selector(newLocation(_:)), name: Notification.Name("NewLocationLookup"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(unitDidChange(_:)), name: Notification.Name("UnitChange"), object: nil)
    }
    
    @objc
    func unitDidChange(_ notification: NSNotification) {
//        let count = UserDefaults.standard.integer(forKey: "NumberOfCalls")
//        if count >= 5 {
//            let mock = Mocks.mockedResponse()
//            networkManager = NetworkManager(self, mock!)
//            return
//        }
//
//        guard let unit = notification.object as? String else { return }
//
//        if let location = locationManager?.locationManager.location {
//
//            hideScrollView()
//
//            var req: RequestURL
//            if unit == "imperial" {
//                req = RequestURL(location: location, .imperial)
//            } else {
//                req = RequestURL(location: location, .metric)
//            }
//            networkManager?.fetch(req)
//        }
    }

    func createShadows() {
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowRadius = 5
        shadowView.layer.shadowOpacity = Float(shadowOpacity)
        shadowView.alpha = 0
        
        shadowView.backgroundColor = UIColor(named: theme + "GradientTopColor")
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 10)
    }
    
    func createGradient() {
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor(named: theme + "GradientTopColor")!.cgColor,
                                UIColor(named: theme + "GradientBottomColor")!.cgColor]
        
        view.layer.insertSublayer(gradientLayer, at: 0)
        view.setNeedsDisplay()
    }
    
    func initMethod() {
        
        if let error = Mocks.mockError() {
            networkManager = NetworkManager(self, error)
            return
        }
        
        if let data = Mocks.mockedResponse() {
            networkManager = NetworkManager(self, data)
        } else {
            networkManager = NetworkManager(self)
        }
        
        locationManager = LocationManager(self)
        locationManager?.beginFetchingLocation()
    }
    
    @objc
    func newLocation(_ notification: NSNotification) {
        navView?.rollableTitleView.hideTitles()
        hideScrollView()
        
//        let count = UserDefaults.standard.integer(forKey: "NumberOfCalls")
//        if count >= 5 {
//            let mock = Mocks.mockedResponse()
//            networkManager = NetworkManager(self, mock!)
//            return
//        }
        
        if let location = notification.object as? CLLocation {
            hideScrollView { [weak self] (_) in
                self?.currentLocation(location)
            }
        } else {
            hideScrollView { [weak self] (_) in
                self?.locationManager?.beginFetchingLocation()
            }
        }
    }
    
    func initUI() {
        
        scrollView.alpha = 0
        scrollView.delegate = self
        view.insertSubview(scrollView, at: 0)
        
        guard let navView = self.navView else { return }
        let scrollViewYOffset = navView.frame.size.height + UIApplication.shared.windows[0].safeAreaInsets.top
        let trueHeight = view.bounds.size.height - scrollViewYOffset
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: navView.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        view.layoutIfNeeded()
        
        scrollView.contentSize = CGSize(width: view.frame.size.width, height: trueHeight*3)

        levelOneViewController = LevelOneViewController(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: trueHeight))
        levelTwoViewController = LevelTwoViewController(frame: CGRect(x: 0, y: trueHeight, width: view.bounds.size.width, height: trueHeight))
        levelThreeViewController = LevelThreeViewController(frame: CGRect(x: 0, y: trueHeight * 2, width: view.bounds.size.width, height: trueHeight))

        scrollView.addSubview(levelOneViewController!)
        scrollView.addSubview(levelTwoViewController!)
        scrollView.addSubview(levelThreeViewController!)
    }
    
    func accessibilityScrollStatus(for scrollView: UIScrollView) -> String? {
        let offsetY = scrollView.contentOffset.y
        let page = offsetY / scrollView.frame.size.height
        return ["Today View", "Forecast View", "Details View"][Int(page)]
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.levelOneViewController?.blurredEffectView.alpha = 0
            self?.levelTwoViewController?.blurredEffectView.alpha = 0
            self?.levelThreeViewController?.blurredEffectView.alpha = 0
            self?.levelOneViewController?.transform = .identity
            self?.levelTwoViewController?.transform = .identity
            self?.levelThreeViewController?.transform = .identity
            self?.shadowView.alpha = 0
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        HapticManager.soft()
    }
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        
//        UIView.animate(withDuration: 0.4) { [weak self] in
////            self?.levelOneViewController?.blurredEffectView.alpha = 0
////            self?.levelTwoViewController?.blurredEffectView.alpha = 0
////            self?.levelThreeViewController?.blurredEffectView.alpha = 0
////            self?.levelOneViewController?.transform = .identity
////            self?.levelTwoViewController?.transform = .identity
////            self?.levelThreeViewController?.transform = .identity
////            self?.shadowView.alpha = 0
//            
//        }
//    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        let scale: CGFloat = 0.925
        let alpha = shadowOpacity
        
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.levelOneViewController?.blurredEffectView.alpha = 0.35
            self?.levelTwoViewController?.blurredEffectView.alpha = 0.35
            self?.levelThreeViewController?.blurredEffectView.alpha = 0.35
            self?.levelOneViewController?.transform = .init(scaleX: scale, y: scale)
            self?.levelTwoViewController?.transform = .init(scaleX: scale, y: scale)
            self?.levelThreeViewController?.transform = .init(scaleX: scale, y: scale)
            self?.shadowView.alpha = alpha
            HapticManager.soft()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollPercentage = (scrollView.contentOffset.y / scrollView.contentSize.height)
        let navScrollViewHeight = (225 * scrollPercentage)
        navView?.rollableTitleView.animateWithOffset(navScrollViewHeight)
    }
    
    @IBAction func presentSavedLocationController() {
        let vc = StoryboardManager.main().instantiateViewController(withIdentifier: "SavedLocationViewController")
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func presentSettingsController() {
        GWTransition.present(SettingsController(), from: self)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        guard traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) else {
            return
        }
        let theme = UserDefaults.standard.string(forKey: "Theme") ?? "System-"
        gradientLayer.colors = [UIColor(named: theme + "GradientTopColor")!.cgColor,
                                UIColor(named: theme + "GradientBottomColor")!.cgColor]
    }
    
    func currentLocation(_ location: CLLocation) {
        locationManager?.lookupCurrentLocation(location)
        let req = RequestURL(location: location)
        networkManager?.fetch(req)
    }
    
    func didFinishFetching(_ weatherModel: WeatherModel) {

        let count = UserDefaults.standard.integer(forKey: "NumberOfCalls") + 1
        UserDefaults.standard.setValue(count, forKey: "NumberOfCalls")
        UserDefaults.standard.setValue(Date(), forKey: "LastUpdated")
        
        DispatchQueue.main.async { [weak self] in
            self?.animateMainScrollView()
            self?.notificationManager.post(data: ["weatherModel": weatherModel], to: NotificationName.observerID("weatherModel"))
        }
    }
    
    func animateMainScrollView() {
        navView?.rollableTitleView.showTitles()
        scrollView.isScrollEnabled = true
        showScrollView()
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
        
        let animation = AnimationType(name: "denied", speed: 0.35, size: CGSize(width: 250, height: 250), message: errorMsg)
        vc.displayAnimation(with: animation)
        
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .fullScreen
        
        present(vc, animated: true, completion: nil)
    }
    
    func hideScrollView(_ completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 1,
                       options: .curveEaseInOut,
                       animations: { [weak self] in
            self?.scrollView.alpha = 0
        }, completion: completion)
    }
    
    func showScrollView(_ completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 1,
                       options: .curveEaseInOut,
                       animations: { [weak self] in
            self?.scrollView.alpha = 1
        }, completion: completion)
    }
    
}
