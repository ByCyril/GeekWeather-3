//
//  StoryboardManager.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 12/30/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import UIKit

final class StoryboardManager {
    static func settings() -> UIStoryboard {
        return UIStoryboard(name: "Settings", bundle: .main)
    }
    
    static func main() -> UIStoryboard {
        return UIStoryboard(name: "Main", bundle: .main)
    }
}
