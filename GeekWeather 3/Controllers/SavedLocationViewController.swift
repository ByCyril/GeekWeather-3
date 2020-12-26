//
//  SavedLocationViewController.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 9/6/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import UIKit

final class SavedLocationViewController: UICollectionViewController {
    
    private var locationSearchController: UISearchController?
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        view.backgroundColor = .systemBackground
        collectionView.backgroundColor = .clear
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "New Location"
        
        setupSearchController()
        initUI()
    }
    
    private func initUI() {
        let backButton = UIButton()
        backButton.setImage(UIImage(named: "back"), for: .normal)
        backButton.addTarget(self, action: #selector(dismissController), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: backButton)
        barButton.tintColor = UIColor.tertiarySystemFill
        navigationItem.setRightBarButton(barButton, animated: true)
    }
    
    @objc
    func dismissController() {
        dismiss(animated: true, completion: nil)
    }
    
    private func setupSearchController() {
  
        let searchLocationController = SearchLocationViewController()
        locationSearchController = UISearchController(searchResultsController: searchLocationController)
        locationSearchController?.searchResultsUpdater = searchLocationController
        locationSearchController?.delegate = searchLocationController
        locationSearchController?.hidesNavigationBarDuringPresentation = false
        locationSearchController?.automaticallyShowsCancelButton = false
        locationSearchController?.searchBar.delegate = searchLocationController
        locationSearchController?.searchBar.sizeToFit()
        locationSearchController?.searchBar.placeholder = "Search City or Zip Code"
        
        navigationItem.titleView = locationSearchController?.searchBar
        navigationItem.searchController = locationSearchController
        definesPresentationContext = true
    }
    
    deinit {
        reclaimedMemory()
    }
    
    func reclaimedMemory(_ fileName: String = #file,
                         _ funcName: String = #function,
                         _ lineNumber: Int = #line) {
        
        Swift.print("")
        Swift.print("##########")
        Swift.print("Reclaimed memory")
        Swift.print("CLASS:",String(describing: type(of: self)))
        Swift.print("##########")
        Swift.print("")
    }
    
}
