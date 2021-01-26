//
//  MainViewController.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 7/26/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import UIKit
import GWFoundation
import CoreLocation
import Lottie
import WidgetKit
import SwiftUI

extension MainViewController: NetworkLayerDelegate {
    
    func didFinishFetching(weatherModel: WeatherModel, location: String) {
        UserDefaults.standard.setValue(Date(), forKey: "LastUpdated")
        animateMainScrollView()
  
        UIView.animate(withDuration: 0.15) { [weak self] in
            self?.loadingView.alpha = 0
        }
        print("🚨 alert",weatherModel.alerts)
        removeErrorItems()
        navView?.rollableTitleView.todayLabel.text = location
        notificationManager.post(data: ["weatherModel": weatherModel],
                                 to: NotificationName.observerID("weatherModel"))
        
        levelThreeViewController?.receive(location: networkLayer.locationManager?.location)
    }
    
    func didFail(errorTitle: String, errorDetail: String) {
        
        hideScrollView()
        
        UIView.animate(withDuration: 0.15) { [weak self] in
            self?.loadingView.alpha = 0
        }
        
        createErrorView(errorTitle: errorTitle, errorDetail)
    }
    
}

class MainViewController: UIViewController, UIScrollViewDelegate, UIScrollViewAccessibilityDelegate, DetailsViewHostingControllerDelegate {
    
    private let notificationManager = NotificationManager()
    private var detailsView = DetailsViewModal()
    
    let networkLayer = NetworkLayer()
    
    @IBOutlet var navView: NavigationView?
    @IBOutlet var shadowView: UIView!
    
    private var flexibleCenterYConstraint: NSLayoutConstraint?
    
    private let gradientLayer = CAGradientLayer()
    private let shadowOpacity: CGFloat = 0.75
    
    private var levelOneViewController: LevelOneViewController?
    private var levelTwoViewController: LevelTwoViewController?
    private var levelThreeViewController: LevelThreeViewController?
    private var detailsViewHostingController: DetailsViewHostingController?
    private var backdropView: UIView?
    
    let theme = UserDefaults.standard.string(forKey: "Theme") ?? "System-"
    
    private let errorTitleLabel = UILabel()
    private let errorTextView = UITextView()
    
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
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.isScrollEnabled = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isAccessibilityElement = false
        return scrollView
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
        createLoadingAnimation()
        createShadows()
        createGradient()
        prepareDetailsView()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(newLocation(_:)),
                                               name: Notification.Name("NewLocationLookup"),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(presentDetailsView(_:)),
                                               name: Notification.Name("DailyItemSelection"),
                                               object: nil)
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
    }
    
    func prepareDetailsView() {
        
        detailsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(detailsView)
        
        flexibleCenterYConstraint = detailsView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: view.frame.height * 2)
        flexibleCenterYConstraint?.isActive = true
        
        let padding: CGFloat = 15
        
        NSLayoutConstraint.activate([
            detailsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            detailsView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            detailsView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            detailsView.heightAnchor.constraint(equalToConstant: view.frame.height * 0.55)
        ])
        
        view.layoutIfNeeded()
    }
    
    func createShadows() {
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowRadius = 5
        shadowView.layer.shadowOpacity = Float(shadowOpacity)
        shadowView.alpha = 0
        
        shadowView.backgroundColor = UIColor(named: theme + "GradientTopColor")
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 10)
    }
    
    func createGradient() {
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor(named: theme + "GradientTopColor")!.cgColor,
                                UIColor(named: theme + "GradientBottomColor")!.cgColor]
        
        view.layer.insertSublayer(gradientLayer, at: 0)
        view.setNeedsDisplay()
    }
    
    func createErrorView(errorTitle: String, _ errorDetails: String) {
        
        errorTitleLabel.text = errorTitle
        errorTitleLabel.font = GWFont.AvenirNext(style: .Bold, size: 20)
        errorTitleLabel.textAlignment = .center
        
        errorTextView.text = errorDetails
        errorTextView.textAlignment = .center
        errorTextView.backgroundColor = .clear
        errorTextView.font = GWFont.AvenirNext(style: .Medium, size: 17)
        errorTextView.isEditable = false
        
        let tryAgainButton = UIButton()
        tryAgainButton.setTitle("Try Again", for: .normal)
        tryAgainButton.titleLabel?.font = GWFont.AvenirNext(style: .Bold, size: 17)
        tryAgainButton.layer.borderColor = UIColor.white.cgColor
        tryAgainButton.layer.borderWidth = 2
        tryAgainButton.layer.cornerRadius = 10
        tryAgainButton.setTitleColor(.white, for: .normal)
        
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
    
    func initMethod() {
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
        navView?.rollableTitleView.hideTitles()
        levelOneViewController?.shrink()
        removeErrorItems()
        loadingView.play()
        
        UIView.animate(withDuration: 0.4) {
            self.loadingView.alpha = 1
        }
        
        if let location = notification.object as? CLLocation {
            hideScrollView { [weak self] (_) in
                self?.scrollView.setContentOffset(.zero, animated: false)
                self?.networkLayer.fetch(with: location)
            }
        } else {
            hideScrollView { [weak self] (_) in
                self?.scrollView.setContentOffset(.zero, animated: false)
                self?.networkLayer.fetch()
            }
        }
        
    }
    
    func initUI() {
        
        scrollView.alpha = 0
        scrollView.delegate = self
        view.insertSubview(scrollView, at: 0)
        
        guard let navView = self.navView else { return }
        let scrollViewYOffset = navView.frame.size.height + UIApplication.shared.windows[0].safeAreaInsets.top
        let trueHeight = view.bounds.size.height - scrollViewYOffset
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: navView.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        view.layoutIfNeeded()
        
        scrollView.contentSize = CGSize(width: view.frame.size.width, height: trueHeight*3)
        
        levelOneViewController = LevelOneViewController(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: trueHeight))
        levelTwoViewController = LevelTwoViewController(frame: CGRect(x: 0, y: trueHeight, width: view.bounds.size.width, height: trueHeight))
        levelThreeViewController = LevelThreeViewController(frame: CGRect(x: 0, y: trueHeight * 2, width: view.bounds.size.width, height: trueHeight))
        
        scrollView.addSubview(levelOneViewController!)
        scrollView.addSubview(levelTwoViewController!)
        scrollView.addSubview(levelThreeViewController!)
    }
    
    func accessibilityScrollStatus(for scrollView: UIScrollView) -> String? {
        let offsetY = scrollView.contentOffset.y
        let page = offsetY / scrollView.frame.size.height
        return ["Today View", "Forecast View", "Details View"][Int(page)]
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        HapticManager.soft()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        levelThreeViewController?.mainViewController(isScrolling: false)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard !UserDefaults.standard.bool(forKey: "ScrollAnimationToggle") else { return }
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.levelOneViewController?.blurredEffectView.alpha = 0
            self?.levelTwoViewController?.blurredEffectView.alpha = 0
            self?.levelThreeViewController?.blurredEffectView.alpha = 0
            self?.levelOneViewController?.transform = .identity
            self?.levelTwoViewController?.transform = .identity
            self?.levelThreeViewController?.transform = .identity
            self?.shadowView.alpha = 0
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        guard !UserDefaults.standard.bool(forKey: "ScrollAnimationToggle") else { return }
        let scale: CGFloat = 0.95
        let alpha = shadowOpacity
        let blurEffect: CGFloat = 0.25
        levelThreeViewController?.mainViewController(isScrolling: true)
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.levelOneViewController?.blurredEffectView.alpha = blurEffect
            self?.levelTwoViewController?.blurredEffectView.alpha = blurEffect
            self?.levelThreeViewController?.blurredEffectView.alpha = blurEffect
            self?.levelOneViewController?.transform = .init(scaleX: scale, y: scale)
            self?.levelTwoViewController?.transform = .init(scaleX: scale, y: scale)
            self?.levelThreeViewController?.transform = .init(scaleX: scale, y: scale)
            self?.shadowView.alpha = alpha
            HapticManager.soft()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollPercentage = (scrollView.contentOffset.y / scrollView.contentSize.height)
        let navScrollViewHeight = (225 * scrollPercentage)
        navView?.rollableTitleView.animateWithOffset(navScrollViewHeight)
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
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        guard traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) else {
            return
        }
        let theme = UserDefaults.standard.string(forKey: "Theme") ?? "System-"
        gradientLayer.colors = [UIColor(named: theme + "GradientTopColor")!.cgColor,
                                UIColor(named: theme + "GradientBottomColor")!.cgColor]
    }
    
    func animateMainScrollView() {
        navView?.rollableTitleView.showTitles()
        scrollView.isScrollEnabled = true
        scrollView.setContentOffset(.zero, animated: true)
        showScrollView()
    }
    
    func hideScrollView(_ completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 1,
                       options: .curveEaseInOut,
                       animations: { [weak self] in
                        self?.scrollView.alpha = 0
                       }, completion: completion)
    }
    
    func showScrollView(_ completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 1,
                       options: .curveEaseInOut,
                       animations: { [weak self] in
                        self?.scrollView.alpha = 1
                       }, completion: completion)
    }
    
}
