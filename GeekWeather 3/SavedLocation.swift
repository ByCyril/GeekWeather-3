//
//  SavedLocation.swift
//  GeekWeather 3
//
//  Created by Cyril Garcia on 10/9/21.
//  Copyright © 2021 ByCyril. All rights reserved.
//

import Foundation
import CoreData
import CoreLocation

@objc(SavedLocation)
public class SavedLocation: NSManagedObject {

}

extension SavedLocation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavedLocation> {
        return NSFetchRequest<SavedLocation>(entityName: "SavedLocation")
    }

    @NSManaged public var address: String?
    @NSManaged public var isDefault: Bool
    @NSManaged public var isDefaultForWidget: Bool
    @NSManaged public var location: CLLocation?

}

extension SavedLocation : Identifiable {

}
