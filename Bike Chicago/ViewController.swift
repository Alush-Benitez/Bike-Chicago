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

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet var mapView: MKMapView!
    
    let regionRadius: CLLocationDistance = 10000
    var bikeRoutes = [BikeRoute]()
    var count = 0
    
    var routeType = ""
    var streetName = ""
    var startStreet = ""
    var endStreet = ""
    var lengthInFeet = 0.0
    
    var locValue: CLLocationCoordinate2D? = nil
    
    var search2 = ""
    var coordinateRegion: MKCoordinateRegion? = nil
    
    
    //let bikeRouteClass = BikeRoute()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        mapView.delegate = self
        let initialLocation = CLLocation(latitude: 41.8781, longitude: -87.6298)
        centerMapOnLocation(location: initialLocation)
        mapView.showsUserLocation = true
        
        grabData()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            locValue = location.coordinate
        }
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
        DispatchQueue.main.async {
            for i in 0..<120 {
                self.addResults(result: (json?.arrayValue[i])!)
            }
            self.addRoutes()
        }
        DispatchQueue.main.async {
            
            for i in 120..<240 {
                self.addResults(result: (json?.arrayValue[i])!)
            }
            self.addRoutes()
        }
        DispatchQueue.main.async {
            
            for i in 240..<360 {
                self.addResults(result: (json?.arrayValue[i])!)
            }
            self.addRoutes()
        }
        DispatchQueue.main.async {
            
            for i in 360..<480 {
                self.addResults(result: (json?.arrayValue[i])!)
            }
            self.addRoutes()
        }
        DispatchQueue.main.async {
            
            for i in 480..<(json?.arrayValue.count)! {
                self.addResults(result: (json?.arrayValue[i])!)
            }
            self.addRoutes()
        }
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
        coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion!, animated: true)
    }
    
    func addRoutes() {
        mapView.removeOverlays(mapView.overlays)
        for route in bikeRoutes {
            print(route.routeLine.debugDescription)
            mapView.add(route.routeLine)
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let polyLineRenderer = MKPolylineRenderer(overlay: overlay)
            polyLineRenderer.lineWidth = 1.0
            polyLineRenderer.strokeColor = .blue
            /*
            if routeType == "Cycle Track" {
                polyLineRenderer.strokeColor = .red
            } else if routeType == "Bike Lane" {
                polyLineRenderer.strokeColor = .blue
            } else if routeType == "Buffered Bike Lane" {
                polyLineRenderer.strokeColor = .green
            } else if routeType == "Shared-Lane" {
                polyLineRenderer.strokeColor = .black
            } else {
                polyLineRenderer.strokeColor = .orange
            }
 */
            
            return polyLineRenderer
        }
        return MKPolylineRenderer()
    }
    
    
    
    func displayMesage(message:String){
        let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        
        alert.addTextField { (textField) in
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        let insertAction = UIAlertAction(title: "Search", style: .default) { (action) in
            let searchTextField = alert.textFields![0] as UITextField
            searchTextField.autocapitalizationType = .words
            self.search2 = searchTextField.text!
            self.loadOptions()
        }
        alert.addAction(insertAction)
        present(alert, animated: true, completion: nil)
    }
    
    
    func loadOptions() {
        
        for annotation in mapView.annotations {
            self.mapView.removeAnnotation(annotation)
        }
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = search2
        request.region = coordinateRegion!
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            if let response = response {
                for _ in response.mapItems {
                    for mapItem in response.mapItems {
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = mapItem.placemark.coordinate
                        annotation.title = mapItem.name
                        self.mapView.addAnnotation(annotation)
                        self.getDirections()
                    }
                }
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let identifier = ""
        var markerView = MKMarkerAnnotationView()
        
        if let dequedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
            markerView = dequedView
        } else {
            markerView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        markerView.canShowCallout = true
        markerView.rightCalloutAccessoryView = UIButton(type: .infoLight)
        return markerView
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        loadOptions()
    }
    
    
    @IBAction func searchTapped(_ sender: Any) {
        displayMesage(message: "Search for a place")
    }
    
    func getDirections() {
        
        let request = MKDirectionsRequest()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: (locValue?.latitude)!, longitude: (locValue?.longitude)!), addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 37.783333, longitude: -122.416667), addressDictionary: nil))
        request.requestsAlternateRoutes = true
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        
        directions.calculate { [unowned self] response, error in
            guard let unwrappedResponse = response else { return }
            
            for route in unwrappedResponse.routes {
                self.mapView.add(route.polyline)
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            }
        }
    }
    
    
    
}
