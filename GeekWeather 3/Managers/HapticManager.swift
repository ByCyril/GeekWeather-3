//
//  HapticManager.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 12/30/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import UIKit

final class HapticManager {
    static func soft() {
        if UserDefaults.standard.bool(forKey: "DisableHaptic") { return }
        UIImpactFeedbackGenerator(style: .soft).impactOccurred()
    }
    
    static func success() {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }
}
