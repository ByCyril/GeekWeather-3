//
//  View+Extension.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 8/21/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import UIKit

extension UIView {
    func takeSnapshot() -> UIImage {
        self.setNeedsDisplay()
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    func takeSnapShotWithoutScreenUpdate() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        var image:UIImage? = nil
        
        if self.drawHierarchy(in: self.bounds, afterScreenUpdates: false) {
            image = UIGraphicsGetImageFromCurrentImageContext()
        }

        UIGraphicsEndImageContext()
        
        return image
    }
}
