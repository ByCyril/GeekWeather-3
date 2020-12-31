//
//  GWFont.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 12/26/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import UIKit

final class GWFont {
    enum GWFontStyle: String {
        case Heavy
        case Medium
        case Regular
        case Bold
    }
    
    static func AvenirNext(style: GWFontStyle, size: CGFloat) -> UIFont {
        return UIFont(name: "AvenirNext-\(style.rawValue)", size: size)!
    }
}
