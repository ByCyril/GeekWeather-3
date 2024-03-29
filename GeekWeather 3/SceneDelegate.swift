//
//  SceneDelegate.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 7/26/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    var mainViewController: MainViewController?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        if let vc = GWTest.forceViewController() {
            setWindow(with: windowScene, vc: vc)
            return
        }
        
        if UserDefaults.standard.bool(forKey: SharedUserDefaults.Keys.ExistingUser) {
            
            if UIDevice.current.userInterfaceIdiom == .pad {
                let vc = MainPadController()
                
                //                let vc = UIHostingController(rootView: iPadMainView())
                
                #if targetEnvironment(macCatalyst)
                windowScene.sizeRestrictions?.maximumSize = CGSize(width: 660, height: 1260)
                
                #else
                print("Your regular code")
                #endif
                
                setWindow(with: windowScene, vc: vc)
                return
            }
            
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
        
        window?.windowScene = windowScene
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        
//        mainViewController?.levelOneViewController?.shrink()
//        mainViewController?.networkLayer.cache.removeAllObjects()
//        mainViewController?.networkLayer.fetch()
//
        guard let lastUpdate = UserDefaults.standard.value(forKey: SharedUserDefaults.Keys.LastUpdated) as? Date else { return }

        let differenceInSeconds = abs(lastUpdate.timeIntervalSince(Date()))
        let minutesPassed = differenceInSeconds / 60

        print("⏱",minutesPassed)
        if minutesPassed >= 15 {
//            mainViewController?.levelOneViewController?.shrink()
//            mainViewController?.networkLayer.cache.removeAllObjects()
//            mainViewController?.networkLayer.fetch()
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
//        mainViewController?.networkLayer.cache.removeAllObjects()
        UserDefaults.standard.setValue(nil, forKey: SharedUserDefaults.Keys.LastUpdated)        
    }

    func sceneDidEnterBackground(_ scene: UIScene) {}
    func sceneDidBecomeActive(_ scene: UIScene) { }
    func sceneWillResignActive(_ scene: UIScene) { }

}
