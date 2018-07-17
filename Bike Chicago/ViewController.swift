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
    
    @IBOutlet var leadingC: NSLayoutConstraint!
    @IBOutlet var trailingC: NSLayoutConstraint!
    
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var hamburgerView: UIView!
    
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var streetLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var startStreetLabel: UILabel!
    @IBOutlet weak var endStreetLabel: UILabel!
    @IBOutlet weak var directionsButton: UIButton!
    
    
    @IBOutlet weak var smallView: UIView!
    @IBOutlet weak var etaBike: UILabel!
    @IBOutlet weak var etaWalk: UILabel!
    @IBOutlet weak var distanceSmallView: UILabel!
    
    
    
    var selectedMapItem = MKMapItem()
    var mapItems = [MKMapItem]()
    let locationManager = CLLocationManager()
    let regionRadius: CLLocationDistance = 20000
    var locValue: CLLocationCoordinate2D? = nil
    var coordinateRegion: MKCoordinateRegion? = nil
    var search2 = ""
    
    var hamburgerIsVisible = false
    
    var selectedLong = 0.0
    var selectedLat = 0.0
    
    var bikeRoutes = [BikeRoute]()
    
    var milesAndETA = [Double]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        mapView.delegate = self
        infoView.alpha = 0
        directionsButton.layer.cornerRadius = 20
        smallView.alpha = 0
        smallView.layer.cornerRadius = 10
        
        
        let initialLocation = CLLocation(latitude: 41.8781, longitude: -87.6298)
        centerMapOnLocation(location: initialLocation)
        mapView.showsUserLocation = true
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest // You can change the locaiton accuary here.
            locationManager.startUpdatingLocation()
        }
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
    
    func parse(json: JSON?) {
        
        let maxNum = (json?.arrayValue.count)!
        
        bikeRoutes = [BikeRoute](repeating: BikeRoute(), count: maxNum)
        
        DispatchQueue.global(qos: .userInteractive).async {
            for i in 0..<120 {
                self.addResults(result: (json?.arrayValue[i])!, i: i)
            }
            DispatchQueue.main.async {
                self.addRoutes()
                print("section 1 Done")
            }
        }
        DispatchQueue.global(qos: .userInteractive).async {
            for i in 120..<240 {
                self.addResults(result: (json?.arrayValue[i])!, i: i)
            }
            DispatchQueue.main.async {
                self.addRoutes()
                print("section 2 Done")
            }
        }
        DispatchQueue.global(qos: .userInteractive).async {
            for i in 240..<360 {
                self.addResults(result: (json?.arrayValue[i])!, i: i)
            }
            DispatchQueue.main.async {
                self.addRoutes()
                print("section 3 Done")
            }
        }
        DispatchQueue.global(qos: .userInteractive).async {
            for i in 360..<480 {
                self.addResults(result: (json?.arrayValue[i])!, i: i)
            }
            DispatchQueue.main.async {
                self.addRoutes()
                print("section 4 Done")
            }
        }
        DispatchQueue.global(qos: .userInteractive).async {
            for i in 480..<maxNum {
                self.addResults(result: (json?.arrayValue[i])!, i: i)
                
            }
            DispatchQueue.main.async {
                self.addRoutes()
                print("section 5 Done")
            }
        }
        
    }
    
    func addResults(result: JSON, i: Int){
        
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
            let coord = CLLocationCoordinate2DMake(Double(coordPair[1].stringValue)!, Double(coordPair[0].stringValue)!)
            coords.append(coord)
        }
        
        let route = MKPolyline(coordinates: coords, count: coords.count)
        
        bikeRoutes.insert((BikeRoute(routeType: routeType, streetName: streetName, startStreet: startStreet, endStreet: endStreet, lengthInFeet: routeLength, route: route)), at: i)
        
    }
    
    
    
    func centerMapOnLocation(location: CLLocation) {
        coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                              regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion!, animated: true)
    }
    
    func addRoutes() {
        for overlay in mapView.overlays{
            mapView.remove(overlay)
        }
        for route in bikeRoutes {
            mapView.add(route.routeLine)
        }
    }
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let polyLineRenderer = MKPolylineRenderer(overlay: overlay)
            polyLineRenderer.lineWidth = 1.0
            polyLineRenderer.strokeColor = .blue
            
            /*
             if overlay.routeType == "Cycle Track" {
             polyLineRenderer.strokeColor = .red
             } else if overlay.routeType == "Bike Lane" {
             polyLineRenderer.strokeColor = .blue
             } else if overlay.routeType == "Buffered Bike Lane" {
             polyLineRenderer.strokeColor = .green
             } else if overlay.routeType == "Shared-Lane" {
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
                        self.mapItems.append(mapItem)
                    }
                }
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        for mapItem in mapItems {
            if mapItem.placemark.coordinate.latitude == view.annotation?.coordinate.latitude &&
                mapItem.placemark.coordinate.longitude == view.annotation?.coordinate.longitude {
                selectedMapItem = mapItem
                selectedLat = mapItem.placemark.coordinate.latitude
                selectedLong = mapItem.placemark.coordinate.longitude
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
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
//        var etaAndMiles = getDirections(lat: selectedLat, long: selectedLong, showPolyline: false)
//        let miles = String(etaAndMiles[0])
//        let eta = String(etaAndMiles[1])
        
        infoView.layer.cornerRadius = 20
        streetLabel.text = selectedMapItem.name!
        startStreetLabel.text = ""
        endStreetLabel.text = ""
        //distanceLabel.text = miles
        //directionsButton.setTitle("Directions - \(eta)", for: .normal)
        
        UIView.animate(withDuration: 0.3) {
            self.infoView.alpha = 0.95
        }
        
    }
    
    @IBAction func searchTapped(_ sender: Any) {
        displayMesage(message: "Search for a place")
    }
    
    
    @IBAction func tappedAway(_ sender: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.3) {
            self.infoView.alpha = 0
        }
    }
    
    @IBAction func directionsTapped(_ sender: Any) {
        getDirections(lat: selectedLat, long: selectedLong, showPolyline: true)
        UIView.animate(withDuration: 0.3) {
            self.infoView.alpha = 0
        }
        UIView.animate(withDuration: 0.3) {
            self.smallView.alpha = 0.9
        }
    }
    
    @IBAction func onOffRoadTapped(_ sender: Any) {
    }
    
    @IBAction func onBufferedTapped(_ sender: Any) {
    }
    
    @IBAction func onNormalTapped(_ sender: Any) {
    }
    
    @IBAction func onSharedTapped(_ sender: Any) {
    }
    @IBAction func onHamburgerTapped(_ sender: Any) {
        //if the hamburger menu is NOT visible, then move the ubeView back to where it used to be
        if !hamburgerIsVisible {
            leadingConstraint.constant = -150
            //this constant is NEGATIVE because we are moving it 150 points OUTWARD and that means -150
            //trailingC.constant = -150
            
            //1
            hamburgerIsVisible = true
        } else {
            //if the hamburger menu IS visible, then move the ubeView back to its original position
            leadingConstraint.constant = 0
            //trailingC.constant = 0
            
            //2
            hamburgerIsVisible = false
        }
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }) { (animationComplete) in
            print("The animation is complete!")
        }
    }
    
    @IBOutlet weak var onHamburgerTapped: UIBarButtonItem!
    func getDirections(lat: Double, long: Double, showPolyline: Bool) {
        
        let request = MKDirectionsRequest()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: (locValue?.latitude)!, longitude: (locValue?.longitude)!), addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: lat, longitude: long), addressDictionary: nil))
        request.requestsAlternateRoutes = false
        request.transportType = .walking
        
        print(lat)
        print(long)
        
        print(request)
        
        let directions = MKDirections(request: request)
        
        directions.calculate { [unowned self] response, error in
            let unwrappedResponse = response
            for route in (unwrappedResponse?.routes)! {
                //if showPolyline {
                self.mapView.add(route.polyline)
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                //}
                print("here")
                self.distanceSmallView.text = "\(String(format: "%.1f", route.distance / 1609.34)) mi"
                self.etaBike.text = "\(String(format: "%.1f", (route.expectedTravelTime / 4.0) / 60)) min"
                self.etaWalk.text = "\(String(format: "%.1f", route.expectedTravelTime / 60.0)) min"
            }
        }
    }
}
