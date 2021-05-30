//
//  MainViewController.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 7/26/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import UIKit
import CoreLocation
import Lottie
import WidgetKit
import SwiftUI
import MapKit
import CoreHaptics

extension MainViewController: NetworkLayerDelegate {
    
    func didFinishFetching(weatherModel: WeatherModel, location: String) {
        UserDefaults.standard.setValue(Date(), forKey: "LastUpdated")
        
        UIView.animate(withDuration: 0.15) { [weak self] in
            self?.loadingView.alpha = 0
        }
        
        removeErrorItems()

        notificationManager.post(data: ["weatherModel": weatherModel, "location": location],
                                 to: NotificationName.observerID("weatherModel"))
        
    }
    
    func didFail(errorTitle: String, errorDetail: String) {
        
        print("#################################")
        print("🚨Error🚨")
        print("#################################")
        
        UIView.animate(withDuration: 0.15) { [weak self] in
            self?.loadingView.alpha = 0
        }
        
        createErrorView(errorTitle: errorTitle, errorDetail)
        UINotificationFeedbackGenerator().notificationOccurred(.error)
    }
    
}

final class MainViewController: UIViewController, GWUIHostingControllerDelegate {
    
    private let notificationManager: NotificationManager = NotificationManager()
    
    private let networkLayer: NetworkLayer = NetworkLayer()
    
    private let gradientLayer: CAGradientLayer = CAGradientLayer()
    private let shadowOpacity: CGFloat = 0.75
    
    private var levelOneViewController: LevelOneViewController?
    private var levelTwoViewController: LevelTwoViewController?
    
    private var detailsViewHostingController: DetailsViewHostingController?
    private var alertViewHostingController: AlertViewHostingController?
    private var backdropView: UIView?
        
    private let errorTitleLabel: UILabel = UILabel()
    private let errorTextView: UITextView = UITextView()
    private let tryAgainButton: UIButton = UIButton()
    
    private var interactionManager: InteractionManager?
    
    @IBOutlet var settingsButton: UIButton!
    @IBOutlet var searchButton: UIButton!
    
    private let loadingView: AnimationView = {
        let animation = AnimationView(name: "fetching")
        animation.translatesAutoresizingMaskIntoConstraints = false
        animation.alpha = 0
        animation.animationSpeed = 0.85
        animation.loopMode = .loop
        animation.play()
        return animation
    }()
    
    private let errorView: AnimationView = {
        let animation = AnimationView(name: "denied")
        animation.translatesAutoresizingMaskIntoConstraints = false
        animation.animationSpeed = 0.45
        animation.loopMode = .autoReverse
        animation.play()
        return animation
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        initMethod()
        createGradient()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(newLocation(_:)),
                                               name: Notification.Name("NewLocationLookup"),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(presentDetailsView(_:)),
                                               name: Notification.Name("DailyItemSelection"),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(presentWeatherAlert(_:)),
                                               name: Notification.Name("PresentWeatherAlert"),
                                               object: nil)

    }
    
    @objc
    func presentWeatherAlert(_ obj: NSNotification) {
        guard let alerts = obj.object as? [Alert] else { return }
        
        backdropView = UIView(frame: view.bounds)
        backdropView?.backgroundColor = UIColor.white.withAlphaComponent(0.15)
        backdropView?.alpha = 0
        
        let alertContainer = AlertContainer(alerts: alerts) {
            self.didDismissModal()
        }
        
        alertViewHostingController = AlertViewHostingController(rootView: alertContainer)
        alertViewHostingController?.delegate = self
        view.addSubview(backdropView!)
        
        UIView.animate(withDuration: 0.4) { [weak self] in
            self?.backdropView?.alpha = 1
        }
        
        present(alertViewHostingController!, animated: true)
        
    }
    
    @objc
    func presentDetailsView(_ obj: NSNotification) {
        guard let daily = obj.object as? Daily else { return }
        
        backdropView = UIView(frame: view.bounds)
        backdropView?.backgroundColor = UIColor.white.withAlphaComponent(0.15)
        backdropView?.alpha = 0
        
        let dailyView = ContainerView(dailyModel: daily, dismissAction: { [weak self] in
            self?.didDismissModal()
        })
        
        detailsViewHostingController = DetailsViewHostingController(rootView: dailyView)
        detailsViewHostingController?.delegate = self
        view.addSubview(backdropView!)
        
        UIView.animate(withDuration: 0.4) { [weak self] in
            self?.backdropView?.alpha = 1
        }
        
        present(detailsViewHostingController!, animated: true)
        
    }
    
    func didDismissModal() {
        UIView.animate(withDuration: 0.4) { [weak self] in
            self?.backdropView?.alpha = 0
        } completion: {  [weak self] _ in
            self?.backdropView?.removeFromSuperview()
            self?.detailsViewHostingController = nil
        }
        dismiss(animated: true)
    }
    
    func removeErrorItems() {
        errorView.removeFromSuperview()
        errorTitleLabel.removeFromSuperview()
        errorTextView.removeFromSuperview()
        tryAgainButton.removeFromSuperview()
    }
    
    func createGradient() {
        view.backgroundColor = UIColor(named: "demo-background")!
    }
    
    func createErrorView(errorTitle: String, _ errorDetails: String) {
        
        errorView.animationSpeed = 0.45
        errorView.loopMode = .autoReverse
        errorView.play()
        
        errorTitleLabel.text = errorTitle
        errorTitleLabel.font = GWFont.AvenirNext(style: .Bold, size: 20)
        errorTitleLabel.textAlignment = .center
        
        errorTextView.text = errorDetails
        errorTextView.textAlignment = .center
        errorTextView.backgroundColor = .clear
        errorTextView.font = GWFont.AvenirNext(style: .Medium, size: 17)
        errorTextView.isEditable = false
        
        tryAgainButton.setTitle("Try Again", for: .normal)
        tryAgainButton.titleLabel?.font = GWFont.AvenirNext(style: .Bold, size: 17)
        tryAgainButton.layer.borderColor = UIColor.white.cgColor
        tryAgainButton.layer.borderWidth = 2
        tryAgainButton.layer.cornerRadius = 10
        tryAgainButton.setTitleColor(.white, for: .normal)
        tryAgainButton.addTarget(self, action: #selector(initMethod), for: .touchUpInside)
        tryAgainButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tryAgainButton)
        
        [errorTextView, errorTitleLabel].forEach { (element) in
            element.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(element)
        }
        
        view.addSubview(errorView)
        let size: CGFloat = 225
        let padding: CGFloat = 25
        
        NSLayoutConstraint.activate([
            errorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            errorView.heightAnchor.constraint(equalToConstant: size),
            errorView.widthAnchor.constraint(equalToConstant: size),
            
            errorTitleLabel.topAnchor.constraint(equalTo: errorView.bottomAnchor),
            errorTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            errorTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            errorTextView.topAnchor.constraint(equalTo: errorTitleLabel.bottomAnchor),
            errorTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            errorTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            errorTextView.bottomAnchor.constraint(equalTo: tryAgainButton.topAnchor, constant: -padding),
            
            tryAgainButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            tryAgainButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            tryAgainButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
        ])
        
        view.layoutIfNeeded()
    }
    
    func createLoadingAnimation() {
        view.addSubview(loadingView)
        loadingView.play()
        let size: CGFloat = 150
        
        UIView.animate(withDuration: 0.4) {
            self.loadingView.alpha = 1
        }
        
        NSLayoutConstraint.activate([
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loadingView.heightAnchor.constraint(equalToConstant: size),
            loadingView.widthAnchor.constraint(equalToConstant: size),
        ])
        
        view.layoutIfNeeded()
    }
    
    @objc
    func initMethod() {
        
        removeErrorItems()
        createLoadingAnimation()
        
        if let lastUpdated = sharedUserDefaults?.value(forKey: SharedUserDefaults.Keys.WidgetLastUpdated) as? Date {
            
            let differenceInSeconds = abs(lastUpdated.timeIntervalSince(Date()))
            let minutesPassed = differenceInSeconds / 60
            
            print("⏱",minutesPassed)
            if minutesPassed >= 10 {
                WidgetCenter.shared.reloadAllTimelines()
            }
        }
        
        networkLayer.delegate = self
        networkLayer.fetch()
    }
    
    @objc
    func newLocation(_ notification: NSNotification) {
        
        levelOneViewController?.shrink()
        removeErrorItems()
        loadingView.play()
        
        UIView.animate(withDuration: 0.4) {
            self.loadingView.alpha = 1
        }
        
        if let location = notification.object as? SavedLocation {
            if let address = location.address, let coord = location.location {
                networkLayer.beginFetchingWeatherData(coord, address)
            } else {
                didFail(errorTitle: "Error", errorDetail: "Could not fetch location. Try a new location. If the error persists, please let the developer know!")
            }
        } else {
            networkLayer.fetch()
        }
        
    }
    
    func initUI() {
        
        settingsButton.layer.cornerRadius = 35 / 2
        searchButton.layer.cornerRadius = 35 / 2
        
        settingsButton.backgroundColor = UIColor.white.withAlphaComponent(0.05)
        searchButton.backgroundColor = UIColor.white.withAlphaComponent(0.05)
        
        settingsButton.tintColor = .white
        searchButton.tintColor = .white

        view.layoutIfNeeded()
        
        let trueHeight = view.frame.height
                
        levelOneViewController = LevelOneViewController(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: trueHeight))
        levelTwoViewController = LevelTwoViewController(frame: CGRect(x: 0, y: trueHeight - 170, width: view.bounds.size.width, height: trueHeight))
        
        interactionManager = InteractionManager(levelTwoViewController!, view)
        view.addSubview(levelTwoViewController!)
        view.insertSubview(levelOneViewController!, at: 0)
                
        levelOneViewController?.layoutIfNeeded()
        levelTwoViewController?.layoutIfNeeded()
    }

    @IBAction func presentSavedLocationController() {
        let vc = StoryboardManager.main().instantiateViewController(withIdentifier: "SavedLocationViewController")
        let attributes = [NSAttributedString.Key.font: GWFont.AvenirNext(style: .Bold, size: 35)]
        vc.navigationController?.navigationBar.largeTitleTextAttributes = attributes
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func presentSettingsController() {
        GWTransition.present(SettingsController(), from: self)
    }
 
}
