//
//  TestViewController.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 12/31/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import UIKit

final class TestViewController: UIViewController {
    
    var pageIndicator = PageIndicator(frame: CGRect(x: 100, y: 100, width: 35, height: (35 * 3) + 20))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(pageIndicator)
    }
    
    @IBAction func pageZero() {
        pageIndicator.currentPage = 0
    }
    
    @IBAction func pageOne() {
        pageIndicator.currentPage = 1
    }
    
    @IBAction func pageTwo() {
        pageIndicator.currentPage = 2
    }
}
