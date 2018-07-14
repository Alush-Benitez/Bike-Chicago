//
//  ViewController.swift
//  Bike Chicago
//
//  Created by Alush Benitez on 7/13/18.
//  Copyright © 2018 Alush Benitez. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet var mapView: MKMapView!
    
    //let bikeRouteClass = BikeRoute()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let bikeRouteClass = BikeRoute()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
