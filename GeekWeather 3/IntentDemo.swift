//
//  IntentDemo.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 2/1/21.
//  Copyright © 2021 ByCyril. All rights reserved.
//

import UIKit
import Intents
import IntentsUI

public class CurrentWeatherIntent: INIntent {
    var currentLocation: CLLocation?
}

public class CurrentWeatherIntentResponse {
    
}

public protocol CurrentWeatherIntentHandling: NSObjectProtocol {
    func handle(intent: CurrentWeatherIntent, completion: @escaping (CurrentWeatherIntentResponse) -> Void)
}

final class IntentDemo {
    
    func createIntent() {
        
    }
}
