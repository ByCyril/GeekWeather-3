//
//  GeekWeather_3App.swift
//  GeekWeatherWidgetOS Extension
//
//  Created by Cyril Garcia on 1/22/21.
//  Copyright © 2021 ByCyril. All rights reserved.
//

import SwiftUI

@main
struct GeekWeather_3App: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }.onAppear()
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
