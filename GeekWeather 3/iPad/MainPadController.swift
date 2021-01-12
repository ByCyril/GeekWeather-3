//
//  MainPadController.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 1/2/21.
//  Copyright © 2021 ByCyril. All rights reserved.
//

import UIKit
import GWFoundation
import SwiftUI

final class MainHostingController: UIHostingController<iPadMainView> {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override init(rootView: iPadMainView) {
        super.init(rootView: rootView)
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
}



final class MainPadController: UIViewController, NetworkLayerDelegate {
 
    private let networkLayer = NetworkLayer()
    private let gradientLayer = CAGradientLayer()
    private let theme = UserDefaults.standard.string(forKey: "Theme") ?? "System-"
    
    var weatherModel: WeatherModel?
    var location: String?
    
    var vc: MainHostingController?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        createGradientLayer()
        networkLayer.delegate = self
        
        let settingsButton = UIButton()
        settingsButton.setImage(UIImage(systemName: "gearshape"), for: .normal)
        settingsButton.addTarget(self, action: #selector(showSettings), for: .touchUpInside)
        view.addSubview(settingsButton)
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        settingsButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25).isActive = true
        settingsButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -25).isActive = true
        
        let searchButton = UIButton()
        searchButton.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        searchButton.addTarget(self, action: #selector(searchLocation), for: .touchUpInside)
        view.addSubview(searchButton)
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        searchButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25).isActive = true
        searchButton.trailingAnchor.constraint(equalTo: settingsButton.leadingAnchor, constant: -25).isActive = true

        NotificationCenter.default.addObserver(self, selector: #selector(didUpdate), name: Notification.Name("UpdateValues"), object: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) { [weak self] in
            self?.networkLayer.fetch()
        }
    }
    
    @objc
    func searchLocation() {
        let vc = StoryboardManager.main().instantiateViewController(withIdentifier: "SavedLocationViewController")
        let attributes = [NSAttributedString.Key.font: GWFont.AvenirNext(style: .Bold, size: 35)]
        vc.navigationController?.navigationBar.largeTitleTextAttributes = attributes
        present(vc, animated: true, completion: nil)
    }
    
    @objc
    func showSettings() {
        GWTransition.present(SettingsController(), from: self)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        vc?.view.frame = view.frame
    }
        
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        guard traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) else {
            return
        }
        let theme = UserDefaults.standard.string(forKey: "Theme") ?? "System-"
        gradientLayer.colors = [UIColor(named: theme + "GradientTopColor")!.cgColor,
                                UIColor(named: theme + "GradientBottomColor")!.cgColor]
    }
    
    func createGradientLayer() {
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor(named: theme + "GradientTopColor")!.cgColor,
                                UIColor(named: theme + "GradientBottomColor")!.cgColor]
        
        view.layer.insertSublayer(gradientLayer, at: 0)
        view.setNeedsDisplay()
    }
    
    func didFinishFetching(weatherModel: WeatherModel, location: String) {
        self.weatherModel = weatherModel
        self.location = location
        
        let swiftUIView = iPadMainView(weatherModel: weatherModel, location: location)
        vc = MainHostingController(rootView: swiftUIView)
        vc?.view.alpha = 0
        addChild(vc!)
        vc?.view.tag = 25
        view.insertSubview(vc!.view, at: 1)
        vc?.didMove(toParent: self)
        
        UIView.animate(withDuration: 0.4) {
            self.vc?.view.alpha = 1
        }
    }
    
    @objc
    func didUpdate() {
        guard let weatherModel = self.weatherModel, let location = self.location else { return }
        
        vc?.view.removeFromSuperview()
        vc?.removeFromParent()
        
        vc = MainHostingController(rootView: iPadMainView(weatherModel: weatherModel, location: location))
        vc?.view.alpha = 0
        addChild(vc!)
        vc?.view.tag = 25
        view.insertSubview(vc!.view, at: 1)
        vc?.didMove(toParent: self)
        
        UIView.animate(withDuration: 0.4) {
            self.vc?.view.alpha = 1
        }
    }
    
    func didFail(errorTitle: String, errorDetail: String) {
        
    }
    
}
