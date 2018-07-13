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
    
    
    init(routeType: String, streetName: String, startStreet: String, endStreet: String, lengthInFeet: Double){
        self.routeType = routeType
        self.streetName = streetName
        self.startStreet = startStreet
        self.endStreet = endStreet
        self.lengthInFeet = lengthInFeet
    }
    /*
    init?(json: [Any]) {
        // 1
        self.routeType = (json[8] as? String)!
        self.streetName = (json[11] as? String)!
        self.startStreet = (json[12] as? String)!
        self.endStreet = (json[13] as? String)!
        self.lengthInFeet = (json[15] as? Double)!

        // 2
        if let latitude = Double(json[14] as! String),
            let longitude = Double(json[15] as! String) {
            self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        } else {
            self.coordinate = CLLocationCoordinate2D()
        }
    }
 */
    
    init?(json: [Any]) {
        // 1
//        self.routeType = json[0]["bikeroute"]
//        self.streetName = (json[11] as? String)!
//        self.startStreet = (json[12] as? String)!
//        self.endStreet = (json[13] as? String)!
//        self.lengthInFeet = (json[15] as? Double)!
//
//        // 2
//        if let latitude = Double(json[14] as! String),
//            let longitude = Double(json[15] as! String) {
//            self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
//        } else {
//            self.coordinate = CLLocationCoordinate2D()
//        }
    }
    
    func parse(json: JSON) {
        for result in json.arrayValue {
            self.routeType = result[0]["bikeroute"].stringValue
            print(self.routeType)
//            let name = result["name"].stringValue
//            let description = result["description"].stringValue
//            let source = ["id":id,"name":name,"description":description]
//            sources.append(source)
        }
//        DispatchQueue.main.async {
//            [unowned self] in
//            self.tableView.reloadData()
//        }
    }
 

}
