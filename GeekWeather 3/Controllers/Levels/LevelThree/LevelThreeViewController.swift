//
//  LevelThreeViewController.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 8/22/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import UIKit
import GWFoundation
import MapKit

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

struct ItemData {
    var firstItemLabel: String
    var firstItemValue: String
    var width: CGFloat
}

struct DetailsData {
    var firstItemLabel: String
    var firstItemValue: String
    var secondItemLabel: String
    var secondItemValue: String
}

final class LevelThreeViewController: BaseView {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let view = Bundle.main.loadNibNamed("LevelThreeViewController", owner: self, options: nil)?.first as! LevelThreeViewController
        loadXib(view, self)
        createBlurView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func didRecieve(from notification: NSNotification) {
        guard let weatherModel = notification.userInfo?["weatherModel"] as? WeatherModel else { return }
        self.weatherModel = weatherModel
    }
    
    override func didUpdateValues() {

    }
    
    func receive(location: CLLocation?) {
        guard let loc = location?.coordinate else { return }
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: loc, span: span)
        mapView.setRegion(region, animated: true)
        
    }
    
}
