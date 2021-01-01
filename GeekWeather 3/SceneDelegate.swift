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
        
        resetLimit()

        guard let windowScene = (scene as? UIWindowScene) else { return }

        if let vc = GWTest.forceViewController() {
            setWindow(with: windowScene, vc: vc)
            return
        }

        if UserDefaults.standard.bool(forKey: "ExistingUser") {
            guard let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MainViewController") as? MainViewController else { return }
            mainViewController = vc
            setWindow(with: windowScene, vc: mainViewController!)
        } else {
            let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "OnboardingViewControllerLevelOne")
            setWindow(with: windowScene, vc: vc)
        }
    }
    
    func setWindow(with windowScene: UIWindowScene, vc: UIViewController) {
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.rootViewController = vc
        window?.windowScene = windowScene
        window?.makeKeyAndVisible()
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        if let lastUpdate = UserDefaults.standard.value(forKey: "LastUpdated") as? Date {
            
            let differenceInSeconds = abs(lastUpdate.timeIntervalSince(Date()))
            let minutesPassed = differenceInSeconds / 60

            if minutesPassed >= 15 {
                mainViewController?.locationManager?.beginFetchingLocation()
            }
        }
    }

    func sceneDidEnterBackground(_ scene: UIScene) { }
    func sceneDidDisconnect(_ scene: UIScene) { }
    func sceneDidBecomeActive(_ scene: UIScene) { }
    func sceneWillResignActive(_ scene: UIScene) { }
    
    func resetLimit() {
        let day = Date().timeIntervalSince1970.date(.day)
        
        if let savedDay = UserDefaults.standard.string(forKey: "APILimitCountStart") {
            if savedDay != day {
                UserDefaults.standard.setValue(0, forKey: "NumberOfCalls")
                UserDefaults.standard.setValue(day, forKey: "APILimitCountStart")
            }
        } else {
            UserDefaults.standard.setValue(day, forKey: "APILimitCountStart")
        }
        
    }
}
