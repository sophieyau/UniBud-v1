//
//  PlacesTableView.swift
//  UniBud Map
//
//  Created by Sophie Yau on 22/01/2023.
//

import Foundation
import UIKit
import MapKit

class PlacesTableViewController: UITableViewController {
    var userLocation: CLLocation
    var places: [PlaceAnnotations]
    // so we can calculate how far or close the place is
    init(userLocation: CLLocation, places: [PlaceAnnotations]) {
        self.userLocation = userLocation
        self.places = places
        super.init(nibName: nil, bundle: nil)
        
        // register cell
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "PlaceCell")
        self.places.swapAt(indexForSelectedRow ?? 0, 0)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private var indexForSelectedRow: Int? {
        self.places.firstIndex(where: { $0.isSelected == true })
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        places.count
    }
    
    private func calculateDistance(from: CLLocation, to: CLLocation) -> CLLocationDistance {
        from.distance(from: to)
    }
    
    // displaying distance from user's location to the place in MINUTES ( not hours or in meters for user-friendliness)
    private func calculateWalkingTime(distance: CLLocationDistance) -> String {
            let distanceInMiles = distance * 0.000621371
            let distanceInFeet = distance * 3.28084
        let walkingTimeInMinutes:Int = Int(distance / 80)
            print("Distance in miles: \(distanceInMiles)")
            print("Distance in feet: \(distanceInFeet)")
            print("Walking time in minutes: \(walkingTimeInMinutes)")
            return "\(walkingTimeInMinutes) minutes"
    }
        
        
        // allow user can access information about each shop from selected place
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let place = places[indexPath.row]
            let placeDetailVC = PlaceDetailViewController(place: place)
            present(placeDetailVC, animated: true)
            
        }
        
        // pop up window with shops and distance from user's location
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceCell", for: indexPath)
            let place = places[indexPath.row]
            
            //cell configuration =  what kind of data will it display?
            var content = cell.defaultContentConfiguration()
            content.text = place.name
            content.secondaryText = calculateWalkingTime(distance: calculateDistance(from: userLocation, to: place.location))
            
            cell.contentConfiguration = content
            // if a place is selected, change the colour of the cell
            cell.backgroundColor = place.isSelected ? UIColor.systemOrange : UIColor.clear
            
            return cell
        }
        

        }
