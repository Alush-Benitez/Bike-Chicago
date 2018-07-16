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
    
    let locationManager = CLLocationManager()
    
    let regionRadius: CLLocationDistance = 20000
    
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
        
        //DispatchQueue.global(qos: .userInitiated).async {
            //[unowned self] in
            //self.addRoute()
        //}
        
        let initialLocation = CLLocation(latitude: 41.8781, longitude: -87.6298)
        centerMapOnLocation(location: initialLocation)
        mapView.showsUserLocation = true
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest // You can change the locaiton accuary here.
            locationManager.startUpdatingLocation()
        }
        
        
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
    
    func centerMapOnLocation(location: CLLocation) {
        coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion!, animated: true)
    }
    
    func addRoute() {
        for polyline in BikeRoute().polylines {
            mapView.add(polyline)
            //routeType = BikeRoute().routeTypes[count]
        }
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        print("blahj")
        if overlay is MKPolyline {
            print("Inside yay")
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
