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

class ViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet var mapView: MKMapView!
    
    let regionRadius: CLLocationDistance = 10000
    var bikeRoutes = [BikeRoute]()
    var count = 0
    
    
    //let bikeRouteClass = BikeRoute()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        let initialLocation = CLLocation(latitude: 41.8781, longitude: -87.6298)
        centerMapOnLocation(location: initialLocation)
        mapView.showsUserLocation = true
        
        grabData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func grabData() {
        let query = "https://data.cityofchicago.org/resource/hvv9-38ut.json"
        if let url = URL(string: query) {
            if let data = try? Data(contentsOf: url) {
                let json = try! JSON(data: data)
                self.parse(json: json)
            }
        }
    }
    
    let group = DispatchGroup()
    
    
    func parse(json: JSON?) {
        for i in 0..<120 {
            addResults(result: (json?.arrayValue[i])!)
        }
        
        for i in 120..<240 {
            addResults(result: (json?.arrayValue[i])!)
        }
        
        for i in 240..<360 {
            addResults(result: (json?.arrayValue[i])!)
        }
        
        for i in 360..<480 {
            addResults(result: (json?.arrayValue[i])!)
        }
        
        for i in 480..<(json?.arrayValue.count)! {
            addResults(result: (json?.arrayValue[i])!)
        }
        addRoutes()
    }
    
    
    func addResults(result: JSON){
        
        var routeType = ""
        var streetName = ""
        var startStreet = ""
        var endStreet = ""
        var coords = [CLLocationCoordinate2D]()
        var routeLength = 0.0
        
        routeType = (result["bikeroute"].stringValue)
        streetName = (result["street"].stringValue)
        startStreet = (result["f_street"].stringValue)
        endStreet = (result["t_street"].stringValue)
        routeLength = (result["shape_leng"].doubleValue)
        
        let coordPairs = ((result["the_geom"])["coordinates"].arrayValue)
        
        for coordPair in coordPairs {
            print(" INDEX 1\(Double(coordPair[1].stringValue)!)")
            print(" INDEX 0\(Double(coordPair[0].stringValue)!)")
            let coord = CLLocationCoordinate2DMake(Double(coordPair[1].stringValue)!, Double(coordPair[0].stringValue)!)
            coords.append(coord)
            
        }
        
        let route = MKPolyline(coordinates: coords, count: coords.count)
        
        bikeRoutes.append(BikeRoute(routeType: routeType, streetName: streetName, startStreet: startStreet, endStreet: endStreet, lengthInFeet: routeLength, route: route))
    }
    
    
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func addRoutes() {
        for route in bikeRoutes {
            print(route.routeLine.debugDescription)
            mapView.add(route.routeLine)
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let polyLineRenderer = MKPolylineRenderer(overlay: overlay)
            polyLineRenderer.strokeColor = .blue
            polyLineRenderer.lineWidth = 2.0
            
            return polyLineRenderer
        }
        return MKPolylineRenderer()
    }
}
