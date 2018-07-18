//
//  Bike Rack.swift
//  Bike Chicago
//
//  Created by Alush Benitez on 7/18/18.
//  Copyright © 2018 Alush Benitez. All rights reserved.
//

import Foundation
import MapKit

class BikeRack: NSObject, MKAnnotation {
    let title: String?
    let subtitle: String?
    let coordinate: CLLocationCoordinate2D
    
    
    
    init(title: String, subtitle: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        super.init()
    }
    
    init?(json: [Any]) {
        // 1
        self.title = json[9] as? String
        self.subtitle = json[12] as? String
        // 2
        if let latitude = Double(json[14] as! String),
            let longitude = Double(json[15] as! String) {
            self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        } else {
            self.coordinate = CLLocationCoordinate2D()
        }
    }
}

