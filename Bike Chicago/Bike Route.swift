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
    var completeBikeData = [String:Any]()
    
    //let bikeDataClass = BikeData()
    
    override init(/*routeType: String, streetName: String, startStreet: String, endStreet: String, lengthInFeet: Double*/){
        super.init()
        //        var firstRouteType = bikeDataClass.bikeData[0]["bikeroute"]
        //        print(firstRouteType)
        
        
        //        let json = JSON(data: bikedata.json!)
        //        for (index, subjson): (String, JSON) in json{
        //            let value = subjson["key"].stringValue
        //        }
        //        self.routeType = routeType
        //        self.streetName = streetName
        //        self.startStreet = startStreet
        //        self.endStreet = endStreet
        //        self.lengthInFeet = lengthInFeet
        //        parse(json: json)
    }
    
    func parse(json: JSON) {
        print(json[0]["bikeroute"])
        print(routeType)
    }
    
    func readJson() -> [String:Any] {
        do {
            if let file = Bundle.main.url(forResource: "bikedata", withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let completeBikeData = json as? [String: Any] {
                    // json is a dictionary
                    print(completeBikeData)
                } else if let completeBikeData = json as? [Any] {
                    // json is an array
                    print(completeBikeData)
                } else {
                    print("JSON is invalid")
                }
            } else {
                print("no file")
            }
        } catch {
            print(error.localizedDescription)
        }
        return completeBikeData
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



