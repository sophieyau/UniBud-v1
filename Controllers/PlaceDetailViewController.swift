//
//  PlaceDetailViewController.swift
//  UniBud Map
//
//  Created by Sophie Yau on 23/01/2023.
//

// everything in the detail view of a shop
import Foundation
import UIKit

class PlaceDetailViewController: UIViewController {
let place: PlaceAnnotations
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        return label
    }()

    lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.alpha = 0.4
        return label
    }()
    // directions button and function
    var directionButton: UIButton = {
        var config = UIButton.Configuration.bordered()
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Directions", for: .normal)
        return button
    }()
    
    var callButton: UIButton = {
        var config = UIButton.Configuration.bordered()
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Call", for: .normal)
        return button
    }()

init(place: PlaceAnnotations) {
    self.place = place
    super.init(nibName: nil, bundle: nil)
   setUpUI()
}
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
      
        }
    // open up Apple maps
    @objc func directionButtonTapped(_ sender: UIButton) {
        
        let coordinate = place.location.coordinate
        guard let url = URL(string: "http://maps.apple.com/?daddr=\(coordinate.latitude),\(coordinate.longitude)")
        else { return }
        
        UIApplication.shared.open(url)
        
    }
    // func to call shop
    // place.phone = (+44) 7549654969
    // what we need = 07549765969 pls see string + extensions for reformatting!
    @objc func callButtonTapped(_ sender: UIButton) {
        guard let url = URL(string: "tel: //\(place.phone.formatPhoneForCall)")
        else { return }
        // to remove brackets and other signs for the phone number
        
        UIApplication.shared.open(url)
        
        
    }
    
    
    
    private func setUpUI() {
        let stackView = UIStackView()
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.axis = .vertical
        stackView.spacing = UIStackView.spacingUseSystem
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
    
        // assign name and address
        nameLabel.text = place.name
        addressLabel.text = place.address
        
        // adding to the view
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(addressLabel)
        
        // constraints on name label
        nameLabel.widthAnchor.constraint(equalToConstant: view.bounds.width - 20).isActive = true
        
        // adding buttons sidebyside in a horizontal stack view
        let contactStackView = UIStackView()
        contactStackView.translatesAutoresizingMaskIntoConstraints = false
        contactStackView.axis = .horizontal
        contactStackView.spacing = UIStackView.spacingUseSystem
        
        // action for when direction button is tapped (but done programmatically)
        directionButton.addTarget(self, action: #selector(directionButtonTapped), for: .touchUpInside)
        
        // call button
        callButton.addTarget(self, action: #selector(callButtonTapped), for: .touchUpInside)
        
        contactStackView.addArrangedSubview(directionButton)
        contactStackView.addArrangedSubview(callButton)
        
        stackView.addArrangedSubview(contactStackView)
        
        view.addSubview(stackView)
        
    }

    
}
