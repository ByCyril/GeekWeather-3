//
//  SavedLocationViewController.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 9/6/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import UIKit
import WidgetKit
import CoreLocation

final class SavedLocationViewController: UITableViewController {
    
    private var locationSearchController: UISearchController?
    private let coreDataManager = PersistenceManager.shared
    private var savedLocation = [SavedLocation]()
    
    var hideCurrentLocationOption = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Search Location"
        tableView.separatorStyle = .none
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
        savedLocation = coreDataManager.fetch(SavedLocation.self)
    }
    
    @IBAction func dismissController() {
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
        locationSearchController?.searchBar.searchTextField.font = GWFont.AvenirNext(style: .Regular, size: 17)
        locationSearchController?.searchBar.placeholder = "Search City or Zip Code"
        locationSearchController?.isActive = true
        
        navigationItem.searchController = locationSearchController
        definesPresentationContext = true
    }
    
    deinit {
        Mocks.reclaimedMemory(self)
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selection = indexPath.row - 1
        
        if selection > -1 {
            let obj = savedLocation[selection]
            view.window?.rootViewController?.dismiss(animated: true, completion: {
                NotificationCenter.default.post(name: Notification.Name("NewLocationLookup"), object: obj)
            })
        } else {
            if !UserDefaults.standard.bool(forKey: "ExistingUser") {
                UINotificationFeedbackGenerator().notificationOccurred(.error)
                tableView.deselectRow(at: indexPath, animated: true)
                return
            }
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
        
        let savedLocation = self.savedLocation
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let deleteItem = UIAlertAction(title: "Remove from List", style: .destructive) { [weak self] (_) in
            let obj = savedLocation[indexPath.row - 1]
            PersistenceManager.shared.delete(item: obj)
            self?.savedLocation.remove(at: indexPath.row - 1)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        let setDefaultLocation = UIAlertAction(title: "Set Default Location", style: .default) { (_) in
            if indexPath.row == 0 {
                sharedUserDefaults?.removeObject(forKey: SharedUserDefaults.Keys.DefaultLocation)
                tableView.reloadData()
                HapticManager.success()
                return
            }
            
            let obj = savedLocation[indexPath.row - 1]
            let coord = ["lon": obj.location!.coordinate.longitude,
                         "lat": obj.location!.coordinate.latitude,
                         "name": obj.address!] as [String : Any]
            sharedUserDefaults?.setValue(coord, forKey: SharedUserDefaults.Keys.DefaultLocation)
            tableView.reloadData()
            HapticManager.success()
        }
        
        let setWidgetDefaultLocation = UIAlertAction(title: "Set Default Location for Widgets", style: .default) { (_) in
            if indexPath.row == 0 {
                sharedUserDefaults?.removeObject(forKey: SharedUserDefaults.Keys.WidgetDefaultLocation)
                HapticManager.success()
                WidgetCenter.shared.reloadAllTimelines()
                return
            }
            let obj = savedLocation[indexPath.row - 1]
            let coord = ["lon": obj.location!.coordinate.longitude,
                         "lat": obj.location!.coordinate.latitude,
                         "name": obj.address!] as [String : Any]
            sharedUserDefaults?.setValue(coord, forKey: SharedUserDefaults.Keys.WidgetDefaultLocation)
            HapticManager.success()
            WidgetCenter.shared.reloadAllTimelines()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(setDefaultLocation)
        alert.addAction(setWidgetDefaultLocation)
        
        if indexPath.row != 0 {
            alert.addAction(deleteItem)
        }
        
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if indexPath.row == 0 {
            if UserDefaults.standard.bool(forKey: "ExistingUser") {
                cell.textLabel?.text = "Current Location"
            } else {
                cell.textLabel?.text = "Unavailable"
            }
            
            if sharedUserDefaults?.value(forKey: SharedUserDefaults.Keys.DefaultLocation) == nil {
                cell.detailTextLabel?.text = "Default Location"
            } else {
                cell.detailTextLabel?.text = nil
            }
            
            cell.imageView?.image = UIImage(named: "current")
            
        } else {
            cell.textLabel?.text = savedLocation[indexPath.row - 1].address
            cellDefaultLabels(cell, indexPath)
        }
        
        cell.accessoryType = .detailButton
        
        return cell
    }
    
    func cellDefaultLabels(_ cell: UITableViewCell,_ indexPath: IndexPath) {
        if let loc = sharedUserDefaults?.value(forKey: SharedUserDefaults.Keys.DefaultLocation) as? [String: Any] {
            if let city = loc["name"] as? String {
                if city == savedLocation[indexPath.row - 1].address! {
                    cell.detailTextLabel?.text = "Default Location"
                } else {
                    cell.detailTextLabel?.text = nil
                }
            } else {
                cell.detailTextLabel?.text = nil
            }
            
        } else {
            cell.detailTextLabel?.text = nil
        }
    }
    
}
