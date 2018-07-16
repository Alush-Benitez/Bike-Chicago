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
    var routeLine = MKPolyline()
    
    
    init(routeType: String, streetName: String, startStreet: String, endStreet: String, lengthInFeet: Double, route: MKPolyline){
        super.init()
        self.routeType = routeType
        self.streetName = streetName
        self.startStreet = startStreet
        self.endStreet = endStreet
        self.lengthInFeet = lengthInFeet
        self.routeLine = route
    }
    
    override init() {
        super.init()
        self.routeType = ""
        self.streetName = ""
        self.startStreet = ""
        self.endStreet = ""
        self.lengthInFeet = 0
        self.routeLine = MKPolyline()
    }
    
    
}



