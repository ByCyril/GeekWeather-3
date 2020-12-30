//
//  SavedLocationViewController.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 9/6/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import UIKit

final class SavedLocationViewController: UITableViewController {
    
    private var locationSearchController: UISearchController?
    private let coreDataManager = PersistenceManager.shared
    private var savedLocation = [SavedLocation]()
    
    init() {
        super.init(style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .none
        
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationSearchController?.isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search Location"
        setupSearchController()
        initUI()
        savedLocation = coreDataManager.fetch(SavedLocation.self)
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
    
    func setupSearchController() {
  
        let searchLocationController = SearchLocationViewController()
        locationSearchController = UISearchController(searchResultsController: searchLocationController)
        locationSearchController?.searchResultsUpdater = searchLocationController
        locationSearchController?.delegate = searchLocationController
        locationSearchController?.hidesNavigationBarDuringPresentation = false
        locationSearchController?.automaticallyShowsCancelButton = false
        locationSearchController?.searchBar.delegate = searchLocationController
        locationSearchController?.searchBar.sizeToFit()
        locationSearchController?.searchBar.placeholder = "Search City or Zip Code"
        locationSearchController?.isActive = true
        
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
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selection = indexPath.row - 1
        
        if selection > -1 {
            let obj = savedLocation[selection]
            view.window?.rootViewController?.dismiss(animated: true, completion: {
                NotificationCenter.default.post(name: Notification.Name("NewLocationLookup"), object: obj.location)
            })
        } else {
            view.window?.rootViewController?.dismiss(animated: true, completion: {
                NotificationCenter.default.post(name: Notification.Name("NewLocationLookup"), object: nil)
            })
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedLocation.count + 1
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let obj = savedLocation[indexPath.row - 1]
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let deleteItem = UIAlertAction(title: "Remove from List", style: .destructive) { (_) in
            PersistenceManager.shared.delete(item: obj)
            self.savedLocation.remove(at: indexPath.row - 1)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(deleteItem)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if indexPath.row == 0 {
            cell.textLabel?.text = "Current Location"
            cell.imageView?.image = UIImage(named: "current")
        } else {
            cell.textLabel?.text = savedLocation[indexPath.row - 1].address
            cell.accessoryType = .detailButton
        }
        
        return cell
    }
    
}
