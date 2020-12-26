//
//  SceneDelegate.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 7/26/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    var mainViewController: MainViewController?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }.forEach { windowScene in
            windowScene.sizeRestrictions?.minimumSize = CGSize(width: 480, height: 670)
            windowScene.sizeRestrictions?.maximumSize = CGSize(width: 480, height: 670)
        }
        
        guard let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MainViewController") as? MainViewController else { return }
        guard let windowScene = (scene as? UIWindowScene) else { return }

        mainViewController = vc
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.rootViewController = mainViewController
        window?.windowScene = windowScene
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) { }
    func sceneDidBecomeActive(_ scene: UIScene) { }
    func sceneWillResignActive(_ scene: UIScene) { }

    func sceneWillEnterForeground(_ scene: UIScene) {
        if let lastUpdate = UserDefaults.standard.value(forKey: "LastUpdated") as? Date {
            guard let minutesPassed = Calendar.current.dateComponents([.minute], from: lastUpdate, to: Date()).minute else { return }

            if minutesPassed >= 15 {
                mainViewController?.locationManager?.beginFetchingLocation()
            }
        }
    }

    func sceneDidEnterBackground(_ scene: UIScene) {}


}

