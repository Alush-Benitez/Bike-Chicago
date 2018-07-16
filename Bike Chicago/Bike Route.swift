//
//  Bike Route.swift
//  Bike Chicago
//
//  Created by Alush Benitez on 7/13/18.
//  Copyright © 2018 Alush Benitez. All rights reserved.
//

import Foundation
import MapKit



var points = [CLLocationCoordinate2D]()

class BikeRoute: MKPolyline {
    //    var routeType = ""
    //    var streetName = ""
    //    var startStreet = ""
    //    var endStreet = ""
    //    var lengthInFeet = 0.0
    
    var completeBikeData = [Dictionary<String, Any>]()
    var separatePathCoordinates = [[CLLocationCoordinate2D]]()
    var compiledPathCoordinates = [CLLocationCoordinate2D]()
    
    var polylines: [MKPolyline] = []
    
    var count = 0
    
    let defaults = UserDefaults.standard
    
    
    let query = "https://data.cityofchicago.org/resource/hvv9-38ut.json"
    //    var cdn = [Array<Any>]()
    
    var lengths = [Double]()
    var routeTypes = [String]()
    var streetNames = [String]()
    var startStreets = [String]()
    var endStreets = [String]()
    
    override init(/*routeType: String, streetName: String, startStreet: String, endStreet: String, lengthInFeet: Double*/){
        super.init()
        getJSONFromURL()
        //print(self.separatePathCoordinates)
    }
    
    func parse(json: JSON) {
        for result in json.arrayValue {
            self.routeTypes.append(result["bikeroute"].stringValue)
            self.streetNames.append(result["street"].stringValue)
            self.startStreets.append(result["f_street"].stringValue)
            self.endStreets.append(result["t_street"].stringValue)
            self.lengths.append(result["shape_leng"].doubleValue)
            
            var b = 0
            for _ in result["the_geom"]["coordinates"] {
                let lat = result["the_geom"]["coordinates"][b][0].stringValue
                let long = result["the_geom"]["coordinates"][b][1].stringValue
                let oneCoordinate = CLLocationCoordinate2DMake(Double(long)!, Double(lat)!)
                self.compiledPathCoordinates.append(oneCoordinate)
                b += 1
                if b == (result["the_geom"]["coordinates"].arrayValue).count {
                    let myPolyline = MKPolyline.init(coordinates: compiledPathCoordinates, count: compiledPathCoordinates.count)
                    polylines.append(myPolyline)
                    compiledPathCoordinates.removeAll()
                }
            }
            
        }
    }
    
    func getJSONFromURL() {
        if let url = URL(string: query) {
            if let data = try? Data(contentsOf: url) {
                let json = try! JSON(data: data)
                self.parse(json: json)
            }
        }
    }    
}



