//
//  BaseView.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 8/10/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import UIKit
import GWFoundation

class BaseView: UIView, NotificationManagerDelegate {
     
    let notificationManager = NotificationManager()
    let gradientLayer = CAGradientLayer()
    
    var weatherModel: WeatherModel?
    
    private var view: UIView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        notificationManager.delegate = self
        notificationManager.listen(for: NotificationName.observerID("weatherModel"), in: self)
        NotificationCenter.default.addObserver(self, selector: #selector(didUpdateValues), name: Notification.Name("UpdateValues"), object: nil)
        initUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
       
    func loadXib(_ view: UIView,_ main: UIView) {
        view.frame = bounds
        view.backgroundColor = .clear
        view.clipsToBounds = true
        view.layoutIfNeeded()
        main.addSubview(view)
    }
    
    var blurredEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        return blurredEffectView
    }()
 
    func createBlurView() {
        blurredEffectView.layer.cornerRadius = 25
        blurredEffectView.alpha = 0
        blurredEffectView.frame = bounds
        blurredEffectView.clipsToBounds = true
        insertSubview(blurredEffectView, at: 0)
    }
    
    func initUI() {}
    func applyAccessibility() {}
    func didRecieve(from notification: NSNotification) {}
    func getContentOffset(_ offset: CGPoint) {}
    
    @objc func didUpdateValues() {}
    
    func mainViewController(isScrolling: Bool) {}
}
