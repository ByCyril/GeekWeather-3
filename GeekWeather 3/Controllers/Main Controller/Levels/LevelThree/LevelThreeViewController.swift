//
//  LevelThreeViewController.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 8/22/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import UIKit
import MapKit

struct ItemData {
    var firstItemLabel: String
    var firstItemValue: String
    var height: CGFloat
}

final class LevelThreeViewController: BaseView {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    
    init(frame: CGRect,_ bundle: Bundle = Bundle.main) {
        super.init(frame: frame)
        let view = bundle.loadNibNamed("LevelThreeViewController", owner: self, options: nil)?.first as! LevelThreeViewController
        loadXib(view, self)
        layer.masksToBounds = true
//        mapView.showsUserLocation = true
        createBlurView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func didRecieve(from notification: NSNotification) {
        guard let weatherModel = notification.userInfo?["weatherModel"] as? WeatherModel else { return }
        self.weatherModel = weatherModel
        let location = CLLocation(latitude: weatherModel.lat, longitude: weatherModel.lon)
        receive(location: location)
    }
    
    override func didUpdateValues() {

    }
    
    func receive(location: CLLocation?) {
        guard let loc = location?.coordinate else { return }
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: loc, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    override func mainViewController(isScrolling: Bool) {
        UIView.animate(withDuration: 0.1) { [weak self] in
            self?.layer.cornerRadius = isScrolling ? 25 : 0
        }
    }
}
