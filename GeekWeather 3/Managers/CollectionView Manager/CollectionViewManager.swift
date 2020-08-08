//
//  CollectionViewManager.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 8/4/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import UIKit

class CollectionViewManager: NSObject {
    var views = [BaseView]()
    
    init(_ views: [BaseView]) {
        super.init()
        self.views = views
    }
}
