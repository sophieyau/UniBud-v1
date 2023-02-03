//
//  ViewController.swift
//  UniBud Map
//
//  Created by Sophie Yau on 21/01/2023.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    // This is so we can request access to user's location
    var locationManager: CLLocationManager?
    private var places: [PlaceAnnotations] = []
    
    
    lazy var mapView: MKMapView = {
        let map = MKMapView()
        map.delegate = self
        map.showsUserLocation = true
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    // Textfield to search for shops in categories (ONLY WANT IT EXECUTED ONCE)
    lazy var searchTextField: UITextField = {
        let searchTextField = UITextField()
        // curved corners
        searchTextField.layer.cornerRadius = 10
        searchTextField.delegate = self
        searchTextField.clipsToBounds = true
        //bg of textfield = white
        searchTextField.backgroundColor = UIColor.white
        // placeholder text in textfield
        searchTextField.placeholder = "Get some bangin' deals!"
        // setting padding so there is a tiny gap from where the user types
        searchTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        // padding to be displayed always
        searchTextField.leftViewMode = .always
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        return searchTextField
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //initialising the location manager
        locationManager = CLLocationManager()
        // view controller will become the delegate
        locationManager?.delegate = self
        
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.requestLocation()
        
        // Do any additional setup after loading the view.
        setUpUI()
    }
    
    private func setUpUI() {
        
        view.addSubview(searchTextField)
        view.addSubview(mapView)
        
        // adding constraints to the mapView
        // width of the mapview is equal to the view width
        mapView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        mapView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        // centre mapview horizontal on the screen
        mapView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        // centre mapView vertically on the screen
        mapView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        view.bringSubviewToFront(searchTextField)
        //adding constraints to the searchTextField
        searchTextField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        // placed in the centre horizontally
        searchTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        searchTextField.widthAnchor.constraint(equalToConstant: view.bounds.size.width/1.2).isActive = true
        // placing searchbar in top region of the view
        searchTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 60).isActive = true
        // instead of return key will say "GO"
        searchTextField.returnKeyType = .go
        
    }
    private func checkLocationAuthorization() {
        guard let locationManager = locationManager,
              let location = locationManager.location else { return }
        
        switch locationManager.authorizationStatus {
            // check location
        case .authorizedWhenInUse, .authorizedAlways:
            // zoomed in when user is on app, creating a region based on location coordinate
            let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 700, longitudinalMeters: 700)
            mapView.setRegion(region, animated: true)
            // if user says they do not want to allow access to location
        case .denied:
            print("You cannot find deals based on your location if you do not give us access :(")
        case .notDetermined, .restricted:
            print("Hmm.. your location cannot be determined! Sorry, pls try UniBud again later!")
        @unknown default:
            print("Unknown error! Bummers, unable to get your location!")
        }
        
        
    }
    
    private func presentPlacesSheet(places: [PlaceAnnotations]) {
        
        guard let locationManager = locationManager,
              let userLocation = locationManager.location
        else {return}
        
        let placesTVC = PlacesTableViewController(userLocation: userLocation, places: places)
        placesTVC.modalPresentationStyle = .pageSheet
        
        if let sheet = placesTVC.sheetPresentationController {
            //coming from the bottom
            sheet.prefersGrabberVisible = true
            sheet.detents = [.medium(), .large()]
            present(placesTVC, animated: true)
        }
    }
    
    // function to find nearby places
    private func findNearbyPlaces(by query: String) {
        
        // clear all annotations/pins
        mapView.removeAnnotations(mapView.annotations)
        
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.region = mapView.region
        
        let search = MKLocalSearch(request: request)
        search.start { [weak self] response, error in
            
            guard let response = response, error == nil else { return }
            
            self?.places = response.mapItems.map(PlaceAnnotations.init)
            self?.places.forEach { place in
                self?.mapView.addAnnotation(place)
            }
            if let places = self?.places {
                self?.presentPlacesSheet(places: places)
            }
            
        }
        
    }
    
} 

extension ViewController: UITextFieldDelegate {
    // when user presses on return button on the keyboard, this function gets fired
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // or give me empty
        let text = textField.text ?? ""
        if !text.isEmpty {
            textField.resignFirstResponder()
            // find nearby or nearby places by calling function
            findNearbyPlaces(by: text)
        }
        return true
    }
    
}
// highlighting the chosen annotation pin point
extension ViewController: MKMapViewDelegate {
    // function to clear all selected
    private func clearAllSelections() {
        self.places = self.places.map { place in
            place.isSelected = false
            return place
        }
    }
    func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
        
        // clear all selected so it is deselected
        clearAllSelections()
        
        guard let selectionAnnotation = annotation as? PlaceAnnotations else { return }
  // search for particular place, will mark it and present the places sheet
       let placeAnnotation = self.places.first(where: {$0.id == selectionAnnotation.id })
        placeAnnotation?.isSelected = true
        
        presentPlacesSheet(places: self.places)
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    checkLocationAuthorization()
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error!")
    }
}

