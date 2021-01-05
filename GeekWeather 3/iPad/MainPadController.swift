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
    func didFail(with error: String) {
        
    }
    

    private let networkLayer = NetworkLayer()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        networkLayer.delegate = self
        networkLayer.fetch()
    }
    
    func didFinishFetching(weatherModel: WeatherModel, location: String) {
        let swiftUIView = iPadMainView(weatherModel: weatherModel, location: location)
        let viewCtrl = UIHostingController(rootView: swiftUIView)
        
        UIApplication.shared.windows.first?.rootViewController = viewCtrl
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
}
