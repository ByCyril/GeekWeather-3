//
//  FlipperView.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 8/20/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import UIKit

enum FlipperState {
    case began
    case active
    case inactive
}

protocol FlipperViewDataSource: AnyObject {
    func viewForPage(_ page: Int, flipper: FlipperView) -> UIView
}

final class FlipperView: UIView {
    
    var viewControllerSnapshots: [UIImage?] = []
    weak var dataSource: FlipperViewDataSource?
    
    var flipperState = FlipperState.inactive
    var activeView: UIView?
    var currentPage = 0

    
}
