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

final class MainPadController: UIViewController, NetworkLayerDelegate {
 
    private let networkLayer = NetworkLayer()
    private let gradientLayer = CAGradientLayer()
    private let theme = UserDefaults.standard.string(forKey: "Theme") ?? "System-"

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        createGradientLayer()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
            self.networkLayer.delegate = self
            self.networkLayer.fetch()
        }
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
        let swiftUIView = iPadMainView(weatherModel: weatherModel, location: location)
        let viewCtrl = UIHostingController(rootView: swiftUIView)
        viewCtrl.modalPresentationStyle = .fullScreen
        viewCtrl.modalTransitionStyle = .crossDissolve
        present(viewCtrl, animated: true) 
    }
    
    func didFail(errorTitle: String, errorDetail: String) {
        
    }
    
}

final class test: UIHostingController<iPadMainView> {
    override init(rootView: iPadMainView) {
        super.init(rootView: rootView)
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
