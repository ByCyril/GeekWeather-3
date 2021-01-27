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
    
    private let locationManager = CLLocationManager()
    
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
        
        if indexPath.section > 0 {
            let obj = savedLocation[indexPath.row]
            view.window?.rootViewController?.dismiss(animated: true, completion: {
                NotificationCenter.default.post(name: Notification.Name("NewLocationLookup"), object: obj)
            })
        } else {
            if !UserDefaults.standard.bool(forKey: "ExistingUser") || locationManager.authorizationStatus != .authorizedWhenInUse {
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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return savedLocation.count
        }
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        
        if indexPath.row == 0 && indexPath.section == 0 && locationManager.authorizationStatus != .authorizedWhenInUse {
            UINotificationFeedbackGenerator().notificationOccurred(.error)
            return
        }
        
        let savedLocation = self.savedLocation
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let deleteItem = UIAlertAction(title: "Remove from List", style: .destructive) { [weak self] (_) in
            let obj = savedLocation[indexPath.row]
            PersistenceManager.shared.delete(item: obj)
            self?.savedLocation.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        let setDefaultLocation = UIAlertAction(title: "Set Default Location", style: .default) { (_) in
            if indexPath.row == 0 && indexPath.section == 0 {
                sharedUserDefaults?.removeObject(forKey: SharedUserDefaults.Keys.DefaultLocation)
                tableView.reloadData()
                HapticManager.success()
                return
            }
            
            let obj = savedLocation[indexPath.row ]
            let coord = ["lon": obj.location!.coordinate.longitude,
                         "lat": obj.location!.coordinate.latitude,
                         "name": obj.address!] as [String : Any]
            sharedUserDefaults?.setValue(coord, forKey: SharedUserDefaults.Keys.DefaultLocation)
            tableView.reloadData()
            HapticManager.success()
        }
        
        let setWidgetDefaultLocation = UIAlertAction(title: "Set Default Location for Widgets", style: .default) { (_) in
            if indexPath.row == 0 && indexPath.section == 0 {
                sharedUserDefaults?.removeObject(forKey: SharedUserDefaults.Keys.WidgetDefaultLocation)
                HapticManager.success()
                WidgetCenter.shared.reloadAllTimelines()
                return
            }
            let obj = savedLocation[indexPath.row]
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
        
        if indexPath.section != 0 {
            alert.addAction(deleteItem)
        }
        
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "Recent Searches"
        }
        return ""
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if indexPath.row == 0 && indexPath.section == 0 {
            if UserDefaults.standard.bool(forKey: "ExistingUser") && locationManager.authorizationStatus == .authorizedWhenInUse {
                cell.textLabel?.text = "Current Location"
                cell.imageView?.image = UIImage(systemName: "location.fill")
                cell.accessoryType = .detailButton
                cell.selectionStyle = .default
            } else {
                cell.textLabel?.text = "Unavailable"
                cell.imageView?.image = UIImage(systemName: "location.slash")
                cell.selectionStyle = .none
                cell.accessoryType = .none
            }
            
            if sharedUserDefaults?.value(forKey: SharedUserDefaults.Keys.DefaultLocation) == nil {
                cell.detailTextLabel?.text = "Default Location"
                cell.accessoryType = .detailButton
                cell.selectionStyle = .default
            } else {
                cell.detailTextLabel?.text = nil
                cell.accessoryType = .detailButton
                cell.selectionStyle = .default
            }
            
        } else if indexPath.section == 1 {
            cell.textLabel?.text = savedLocation[indexPath.row].address
            cell.accessoryType = .detailButton
            cell.selectionStyle = .default
            cellDefaultLabels(cell, indexPath)
        }
        
        return cell
    }
    
    func cellDefaultLabels(_ cell: UITableViewCell,_ indexPath: IndexPath) {
        if let loc = sharedUserDefaults?.value(forKey: SharedUserDefaults.Keys.DefaultLocation) as? [String: Any] {
            if let city = loc["name"] as? String {
                if city == savedLocation[indexPath.row].address! {
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
