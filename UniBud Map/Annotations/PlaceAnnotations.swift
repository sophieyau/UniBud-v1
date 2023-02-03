//
//  PlaceAnnotations.swift
//  UniBud Map
//
//  Created by Sophie Yau on 22/01/2023.
//

import Foundation

// providing the data to the pins that are displayed on the VIEW
import MapKit

class PlaceAnnotations: MKPointAnnotation{
    
    let mapItem: MKMapItem
    let id = UUID()
    var isSelected: Bool = false
    
    init(mapItem: MKMapItem) {
        self.mapItem = mapItem
        super.init()
        self.coordinate = mapItem.placemark.coordinate
    }
    
    var name: String {
        mapItem.name ?? ""
    }
    
    var phone: String {
        mapItem.phoneNumber ?? ""
    }
    
    var address: String {
        "\(mapItem.placemark.subThoroughfare ?? "") \(mapItem.placemark.thoroughfare ?? "") \(mapItem.placemark.locality ?? "") \(mapItem.placemark.countryCode ?? "")"
    }
    
    var location: CLLocation {
        // we will pass default location if map placemark not found
        mapItem.placemark.location ?? CLLocation.default
    }
}
