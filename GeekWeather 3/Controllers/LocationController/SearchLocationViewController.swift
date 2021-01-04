//
//  SearchLocationViewController.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 9/6/20.
//  Copyright © 2020 ByCyril. All rights reserved.
//

import UIKit
import MapKit
import CoreData

final class ActivityManager {
    let persistenceManager: PersistenceManager
    
    init(_ persistenceManager: PersistenceManager) {
        self.persistenceManager = persistenceManager
    }
    
    func saveResults(savedLocation: SavedLocation) {
        persistenceManager.save()
    }
    
}

final class SearchLocationViewController: UITableViewController, UISearchControllerDelegate, UISearchBarDelegate {
    
    private var searchResults = [MKLocalSearchCompletion]()
    private var searchCompleter = MKLocalSearchCompleter()
    
    private var dataSource: UITableViewDiffableDataSource<Section, MKLocalSearchCompletion>?
    private var coreDataManager = PersistenceManager.shared
        
    init() {
        super.init(style: .plain)
        configureDataSource()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchCompleter.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchCompleter.cancel()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    func createSnapshot(_ data: [MKLocalSearchCompletion]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, MKLocalSearchCompletion>()
        snapshot.appendSections([.main])
        snapshot.appendItems(data)
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
    
    func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, MKLocalSearchCompletion>(tableView: tableView, cellProvider: { (tableView, indexPath, obj) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.backgroundColor = .clear
            cell.textLabel?.text = obj.title
            cell.detailTextLabel?.text = obj.subtitle
            return cell
        })
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedItem = dataSource?.itemIdentifier(for: indexPath) {
            lookupLocation(selectedItem)
        }
    }
    
    private func lookupLocation(_ obj: MKLocalSearchCompletion) {
        let activityManager = ActivityManager(coreDataManager)
        let savedLocation = SavedLocation(context: coreDataManager.context)
        
        let searchRequest = MKLocalSearch.Request(completion: obj)
        searchRequest.resultTypes = .address
        
        MKLocalSearch(request: searchRequest).start { [weak self] (response, error) in
            if let location = response?.mapItems.first?.placemark {
                
                savedLocation.address = location.title
                savedLocation.location = location.location!
                savedLocation.isDefault = false
                savedLocation.isDefaultForWidget = false
                activityManager.saveResults(savedLocation: savedLocation)
                
                self?.view.window?.rootViewController?.dismiss(animated: true, completion: {
                    NotificationCenter.default.post(name: Notification.Name("NewLocationLookup"), object: location.location!)
                })
            }
        }
    }
    
}

extension SearchLocationViewController: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        createSnapshot(completer.results)
    }
}

extension SearchLocationViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        searchCompleter.resultTypes = .address
        searchCompleter.queryFragment = searchController.searchBar.text ?? ""
    }
}
