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
    var separatePathCoordinates = [[CLLocationCoordinate2D]]()
    var compiledPathCoordinates = [CLLocationCoordinate2D]()
    //var coordinates: [Double] = []
    var completeBikeData = [Dictionary<String, Any>]()
    
    let query = "https://data.cityofchicago.org/resource/hvv9-38ut.json"
    var cdn = [Array<Any>]()
    
    //let bikeDataClass = BikeData()
    
    override init(/*routeType: String, streetName: String, startStreet: String, endStreet: String, lengthInFeet: Double*/){
        super.init()
        
        if let url = URL(string: query) {
            if let data = try? Data(contentsOf: url) {
                let json = try! JSON(data: data)
                self.parse(json: json)
            }
        }
        print(self.separatePathCoordinates)
    }
    
    func parse(json: JSON) {
        for result in json.arrayValue {
            //            let id = result["id"].stringValue
            //            let name = result["name"].stringValue
            //            let description = result["description"].stringValue
            //            let source = ["id":id,"name":name,"description":description]
            //            sources.append(source)
            self.routeType = result["bikeroute"].stringValue
            self.streetName = result["street"].stringValue
            self.startStreet = result["f_street"].stringValue
            self.endStreet = result["t_street"].stringValue
            self.lengthInFeet = result["shape_leng"].doubleValue
            
            //let lat = result["the_geom"]["coordiates"][i][0].stringValue
            var b = 0
            //                if result["the_geom"]["coordinates"].count > i {
            for _ in result["the_geom"]["coordinates"] {
                let lat = result["the_geom"]["coordinates"][b][0].stringValue
                let long = result["the_geom"]["coordinates"][b][1].stringValue
                var oneCoordinate = CLLocationCoordinate2D(latitude: Double(lat)!, longitude: Double(long)!)
                self.compiledPathCoordinates.append(oneCoordinate)
                b += 1
                if b == (result["the_geom"]["coordinates"].arrayValue).count {
                    self.separatePathCoordinates.append(compiledPathCoordinates)
                    compiledPathCoordinates.removeAll()
                }
            }
            print(self.separatePathCoordinates.count)
            //                }
            //self.pathCoordinates = [CLLocationCoordinate2D(latitude: Double(lat)!, longitude: Double(long)!)]
            //print(self.pathCoordinates)
            //self.pathCoordinates = CLLocationCoordinate2D(result[i]["the_geom"]["coordinates"].arrayValue)
            //print(this)
        }
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
    
    //    init?(json: [Any]) {
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



