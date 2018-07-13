//
//  Bike Route.swift
//  Bike Chicago
//
//  Created by Alush Benitez on 7/13/18.
//  Copyright © 2018 Alush Benitez. All rights reserved.
//

import Foundation
import MapKit

class BikeRoute: MKPolyline {
    var routeType = ""
    var streetName = ""
    var startStreet = ""
    var endStreet = ""
    var lengthInFeet = 0.0
    var coordinates: [Double] = []
    
    /*
    init(routeType: String, streetName: String, startStreet: String, endStreet: String, lengthInFeet: Double){
        self.routeType = routeType
        self.streetName = streetName
        self.startStreet = startStreet
        self.endStreet = endStreet
        self.lengthInFeet = lengthInFeet
    }
    
    init?(json: [Any]) {
        self.routeType = json[bikeroute] as? String
        self.streetName = json[
    }
    */
    
    func parse() {
        for result in json[].arrayValue {
            let routeType = result[]
        }
    }
}
