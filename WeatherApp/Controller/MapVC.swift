//
//  MapVC.swift
//  WeatherApp
//
//  Created by Nguyễn Duy Việt on 22/09/2022.
//

import UIKit
import MapKit

class MapVC: UIViewController {
    
    @IBOutlet weak var map: MKMapView!
    
    var coordinates: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupViews()
    }
    
    func setupViews() {
        if let coor = self.coordinates {
            let pin = MKPointAnnotation()
            pin.coordinate = coor
            map.addAnnotation(pin)
            let region = MKCoordinateRegion(center: coor, latitudinalMeters: CLLocationDistance(exactly: 100)!, longitudinalMeters: CLLocationDistance(exactly: 100)!)
            map.setRegion(map.regionThatFits(region), animated: true)
        }
    }
    @IBAction func tapOnGoBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
