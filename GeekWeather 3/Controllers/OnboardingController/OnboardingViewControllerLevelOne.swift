//
//  OnboardingViewControllerLevelOne.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 12/28/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import UIKit

final class OnboardingViewControllerLevelOne: OnboardingBaseViewController {
    
    @IBOutlet var logoView: UIImageView!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var cyrilLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        noteLabel.alpha = 0
        cyrilLabel.alpha = 0
        continueButton.alpha = 0
        continueButton.isEnabled = false
        continueButton.layer.borderWidth = 2
        continueButton.layer.cornerRadius = 10
        
        logoView.layer.cornerRadius = 35
        view.backgroundColor = UIColor(named: "demo-background")!
        
        let backgroundView = UIView(frame: view.bounds)
        backgroundView.backgroundColor = UIColor(named: "demo-background")!
        view.insertSubview(backgroundView, at: 1)
        
        UIView.animate(withDuration: 1, delay: 1.5, options: .curveEaseInOut) { [weak self] in
            backgroundView.alpha = 0
            self?.firstAnimation()
        }

    }
    
    @objc
    func firstAnimation() {
        view.backgroundColor = UIColor(named: "demo-background")!
        
        UIView.animate(withDuration: 1, delay: 2, options: .curveEaseInOut) {
            self.logoView.transform = .init(translationX: 0, y: -100)
        }
        
        UIView.animate(withDuration: 2, delay: 3, options: .curveEaseInOut) {
            self.noteLabel.alpha = 1
        }
        
        UIView.animate(withDuration: 2, delay: 4.5, options: .curveEaseInOut) {
            self.cyrilLabel.alpha = 1
        }
        
        UIView.animate(withDuration: 2, delay: 5.5, options: .curveEaseInOut) {
            self.continueButton.alpha = 1
            self.continueButton.isEnabled = true
            self.continueButton.layer.borderColor = self.continueButton.titleLabel?.textColor.cgColor
        }

    }
}
