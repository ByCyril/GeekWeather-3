//
//  NotificationNames.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 7/26/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import UIKit

final class Observe {
    static let data = Data()
    static let state = State()
    static let error = Error()
}

class NotificationName {
    static func observerID(_ name: String) -> Notification.Name {
        return Notification.Name(name.uppercased())
    }
}

final class State: NotificationName {
//    MARK: Location
    let locationServiceDisabled = observerID("LocationServiceDisabled")
    
//    MARK: Network
    let networkTimedOut = observerID("NetworkTimedOut")
    
}

final class Data: NotificationName {
    let response = observerID("weather_response")
    let location = observerID("location_response")
}

final class Error: NotificationName {
    let locationPermissionDenied = observerID("permission_denied")
}
