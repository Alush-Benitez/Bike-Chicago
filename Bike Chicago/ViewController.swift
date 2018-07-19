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
    
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var hamburgerView: UIView!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var streetLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var startStreetLabel: UILabel!
    @IBOutlet weak var endStreetLabel: UILabel!
    @IBOutlet weak var directionsButton: UIButton!
    @IBOutlet weak var toLabel: UILabel!
    
    @IBOutlet weak var offRoadOutlet: UIButton!
    @IBOutlet weak var bufferedOutlet: UIButton!
    @IBOutlet weak var normalButtonOutlet: UIButton!
    @IBOutlet weak var sharedLaneOutlet: UIButton!
    @IBOutlet weak var cycleTrackOutlet: UIButton!
    
    @IBOutlet weak var smallView: UIView!
    @IBOutlet weak var etaBike: UILabel!
    @IBOutlet weak var etaWalk: UILabel!
    @IBOutlet weak var distanceSmallView: UILabel!
    
    
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    
    var bikeRacks: [BikeRack] = []
    var selectedMapItem = MKMapItem()
    var mapItems = [MKMapItem]()
    let locationManager = CLLocationManager()
    let regionRadius: CLLocationDistance = 20000
    var locValue: CLLocationCoordinate2D? = nil
    var coordinateRegion: MKCoordinateRegion? = nil
    var search2 = ""
    var selectedPathTypes = [1,1,1,1,1]
    
    let map = MKMapView()
    //let mapTap = UITapGestureRecognizer(target: self, action: #selector(mapTapped(_:)))
    
    var hamburgerIsVisible = false
    
    var selectedLong = 0.0
    var selectedLat = 0.0
    
    var bikeRoutes = [BikeRoute]()
    
    var milesAndETA = [Double]()
    
    var offRoadColors = UIColor(displayP3Red: 162/255.0, green: 99/255.0, blue: 81/255.0, alpha: 1.0)
    var bufferedColors = UIColor(displayP3Red: 134/255.0, green: 76/255.0, blue: 188/255.0, alpha: 1.0)
    var bikeLaneColors = UIColor(displayP3Red: 13/255.0, green: 174/255.0, blue: 230/255.0, alpha: 1.0)
    var sharedLaneColors = UIColor(displayP3Red: 25/255.0, green: 178/255.0, blue: 54/255.0, alpha: 1.0)
    var cycleTrackColors = UIColor(displayP3Red: 1.0, green: 59/255.0, blue: 61/255.0, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadInitialData()

        //let mapTap = UITapGestureRecognizer(target: self, action: #selector(mapTapped(_:)))
        //mapView.addGestureRecognizer(mapTap)
        
        hamburgerView.layer.cornerRadius = 20;
        hamburgerView.layer.masksToBounds = true;
        hamburgerView.alpha = 0.0
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        mapView.delegate = self
        infoView.alpha = 0
        directionsButton.layer.cornerRadius = 10
        smallView.alpha = 0
        smallView.layer.cornerRadius = 10
        goButton.layer.cornerRadius = 10
        cancelButton.layer.cornerRadius = 5
        cancelButton.alpha = 0
        goButton.alpha = 0
        infoView.layer.cornerRadius = 20
        
        
        
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
            for i in 0..<100 {
                self.addResults(result: (json?.arrayValue[i])!, i: i)
            }
            DispatchQueue.main.sync {
                self.addRoutes()
                print("section 1 Done")
            }
        }
        DispatchQueue.global(qos: .userInteractive).async {
            for i in 100..<200 {
                self.addResults(result: (json?.arrayValue[i])!, i: i)
            }
            DispatchQueue.main.sync {
                self.addRoutes()
                print("section 2 Done")
            }
        }
        DispatchQueue.global(qos: .userInteractive).async {
            for i in 200..<300 {
                self.addResults(result: (json?.arrayValue[i])!, i: i)
            }
            DispatchQueue.main.sync {
                self.addRoutes()
                print("section 3 Done")
            }
        }
        DispatchQueue.global(qos: .userInteractive).async {
            for i in 300..<400 {
                self.addResults(result: (json?.arrayValue[i])!, i: i)
            }
            DispatchQueue.main.sync {
                self.addRoutes()
                print("section 4 Done")
            }
        }
        DispatchQueue.global(qos: .userInteractive).async {
            for i in 400..<480 {
                self.addResults(result: (json?.arrayValue[i])!, i: i)
            }
            DispatchQueue.main.sync {
                self.addRoutes()
                print("section 5 Done")
            }
        }
        DispatchQueue.global(qos: .userInteractive).async {
            for i in 480..<maxNum {
                self.addResults(result: (json?.arrayValue[i])!, i: i)
            }
            DispatchQueue.main.sync {
                self.addRoutes()
                print("section 6 Done")
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
        mapView.removeOverlays(mapView.overlays)
        for route in bikeRoutes {
            mapView.add(route.routeLine)
        }
    }
    
    func reloadLinesWithToggle(){
        mapView.removeOverlays(mapView.overlays)
        for route in bikeRoutes {
            if routeShouldLoad(route: route){
                mapView.add(route.routeLine)
            }
        }
    }
    
    func routeShouldLoad(route: BikeRoute) -> Bool{
        let type = route.routeType
        if (type == "OFF-STREET TRAIL" || type == "ACCESS PATH") && selectedPathTypes[0] == 1 {
            return true
        }
        else if (type == "BUFFERED BIKE LANE" || type == "GREEN WAVE") && selectedPathTypes[1] == 1{
            return true
        }
        else if type == "BIKE LANE" && selectedPathTypes[2] == 1{
            return true
        }
        else if (type == "SHARED-LANE" || type == "NEIGHBORHOOD GREENWAY") && selectedPathTypes[3] == 1{
            return true
        }
        else if type == "CYCLE TRACK" && selectedPathTypes[4] == 1{
            return true
        }
        return false
    }
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let polyLineRenderer = MKPolylineRenderer(overlay: overlay)
            for route in bikeRoutes{
                if overlay as! MKPolyline == (route.routeLine as MKPolyline) {
                    polyLineRenderer.lineWidth = 1.5
                    if route.routeType == "CYCLE TRACK" {
                        polyLineRenderer.strokeColor = UIColor(red: 1.0, green: 59/255.0, blue: 61/255.0, alpha: 1)
                    } else if route.routeType == "BIKE LANE" {
                        polyLineRenderer.strokeColor = UIColor(red: 13/255.0, green: 174/255.0, blue: 230/255.0, alpha: 1)
                    } else if route.routeType == "BUFFERED BIKE LANE" || route.routeType == "GREEN WAVE"{
                        polyLineRenderer.strokeColor = UIColor(red: 134/255.0, green: 76/255.0, blue: 188/255.0, alpha: 1)
                    } else if route.routeType == "SHARED-LANE" || route.routeType == "NEIGHBORHOOD GREENWAY" {
                        polyLineRenderer.strokeColor = UIColor(red: 25/255.0, green: 178/255.0, blue: 54/255.0, alpha: 1)
                    } else if route.routeType == "OFF-STREET TRAIL" || route.routeType == "ACCESS PATH" {
                        polyLineRenderer.strokeColor = UIColor(red: 162/255.0, green: 99/255.0, blue: 81/255.0, alpha: 1)
                    } else {print("error \(route.streetName)    __--\(route.routeType)    \n")}
                    
//                    if route.isBold{
//                        polyLineRenderer.lineWidth = 20.0
//                    }
                    
                    return polyLineRenderer

                } else {
                    polyLineRenderer.strokeColor = .black
                    polyLineRenderer.lineWidth = 0.6
                }
            }
            
            polyLineRenderer.lineWidth = 1.0
            //print(polyLineRenderer.strokeColor)
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
        infoView.layer.cornerRadius = 20
        directionsButton.isHidden = false
        toLabel.isHidden = true
        distanceLabel.isHidden = true
        streetLabel.text = selectedMapItem.name!
        startStreetLabel.text = ""
        endStreetLabel.text = ""
        
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
        
        var count = 0
        
        for bikeRack in bikeRacks {
            if count <= 3 {
                var temp = [BikeRack]()
                if bikeRack.coordinate.latitude > selectedLat - 0.002 && bikeRack.coordinate.latitude < selectedLat + 0.002 {
                    if bikeRack.coordinate.longitude > selectedLong - 0.002 && bikeRack.coordinate.longitude < selectedLong + 0.0002 {
                        temp.append(bikeRack)
                        mapView.addAnnotations(temp)
                        count += 1
                    }
                }
            }
        }
        
        UIView.animate(withDuration: 0.3) {
            self.infoView.alpha = 0
        }
        UIView.animate(withDuration: 0.3) {
            self.smallView.alpha = 0.9
        }
        UIView.animate(withDuration: 0.3) {
            self.goButton.alpha = 0.9
        }
        UIView.animate(withDuration: 0.3) {
            self.cancelButton.alpha = 0.9
        }
    }
    
    
    func selectChange(button: UIButton){
        if button.alpha == 1.0 {
            button.alpha = 0.5
        }
        else if button.alpha == 0.5{
            button.alpha = 1.0
        }
    }
    
    func pathToggle(index: Int){
        
        if selectedPathTypes[index] == 1{
            selectedPathTypes[index] = 0
        }
        else{
            selectedPathTypes[index] = 1
        }
        
    }
    
    @IBAction func onOffRoadTapped(_ sender: Any) {
        pathToggle(index: 0)
        selectChange(button: offRoadOutlet)
        reloadLinesWithToggle()

    }
    
    @IBAction func onBufferedTapped(_ sender: Any) {
        pathToggle(index: 1)
        selectChange(button: bufferedOutlet)
        reloadLinesWithToggle()

    }
    
    @IBAction func onNormalTapped(_ sender: Any) {
        pathToggle(index: 2)
        selectChange(button: normalButtonOutlet)
        reloadLinesWithToggle()

    }
    
    @IBAction func onSharedTapped(_ sender: Any) {
        pathToggle(index: 3)
        selectChange(button: sharedLaneOutlet)
        reloadLinesWithToggle()

    }
    
    @IBAction func onCycleTrackTapped(_ sender: Any) {
        pathToggle(index: 4)
        selectChange(button: cycleTrackOutlet)
        reloadLinesWithToggle()

    }
    
    
    
    @IBAction func onHamburgerTapped(_ sender: Any) {
        //if the hamburger menu is visible, then move the ubeView back to where it used to be
        if hamburgerIsVisible {
            hamburgerView.alpha = 0.0
            leadingConstraint.constant = -150
            //this constant is NEGATIVE because we are moving it 150 points OUTWARD and that means -150
            hamburgerIsVisible = false
        } else {
            //if the hamburger menu IS NOT visible, then move the ubeView back to its original position
            hamburgerView.alpha = 1.0
            leadingConstraint.constant = 0
            //trailingC.constant = 0
            //2
            hamburgerIsVisible = true
        }
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }) { (animationComplete) in
        }
    }
    
    func getDirections(lat: Double, long: Double, showPolyline: Bool) {
        
        let request = MKDirectionsRequest()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: (locValue?.latitude)!, longitude: (locValue?.longitude)!), addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: lat, longitude: long), addressDictionary: nil))
        request.requestsAlternateRoutes = false
        request.transportType = .walking
        
        let directions = MKDirections(request: request)
        
        directions.calculate { [unowned self] response, error in
            let unwrappedResponse = response
            for route in (unwrappedResponse?.routes)! {
                self.mapView.add(route.polyline)
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                self.distanceSmallView.text = "\(String(format: "%.1f", route.distance / 1609.34)) mi"
                self.etaBike.text = "\(String(Int((route.expectedTravelTime / 4.0) / 60.0 / 60))) hr \(String(Int(route.expectedTravelTime / 4) % 60)) min"
                self.etaWalk.text = "\(String(Int(route.expectedTravelTime / 60 / 60))) hr \(String(Int(route.expectedTravelTime) % 60)) min"
            }
        }
    }
    
    @IBAction func goButtonTapped(_ sender: Any) {
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking]
        MKMapItem.openMaps(with: [selectedMapItem], launchOptions: launchOptions)
    }
    
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        
        for overlay in mapView.overlays {
            if !checkIfRoute(route: overlay) {
                mapView.remove(overlay)
            }
        }
    
        UIView.animate(withDuration: 0.3) {
            self.smallView.alpha = 0
        }
        UIView.animate(withDuration: 0.3) {
            self.goButton.alpha = 0
        }
        UIView.animate(withDuration: 0.3) {
            self.cancelButton.alpha = 0
        }
        
        for bikeRack in bikeRacks {
            mapView.removeAnnotation(bikeRack)
        }
    }
    
    func checkIfRoute(route: MKOverlay) -> Bool{
        for bikeroute in bikeRoutes {
            if route as! MKPolyline == (bikeroute.routeLine as MKPolyline) {
                return true
            }
        }
        return false
    }
    
    
    @objc func mapTapped(_ tap: UITapGestureRecognizer) {
        if tap.state == .recognized/* && tap.state == .recognized*/ {
            // Get map coordinate from touch point
            let touchPt: CGPoint = tap.location(in: mapView)
            let coord: CLLocationCoordinate2D = mapView.convert(touchPt, toCoordinateFrom: mapView)
            let maxMeters: Double = meters(fromPixel: 2, at: touchPt)
            var nearestDistance: Float = MAXFLOAT
            var nearestPoly: MKPolyline? = nil
            // for every overlay ...
            for overlay: MKOverlay in mapView.overlays {
                // .. if MKPolyline ...
                if (overlay is MKPolyline) {
                    // ... get the distance ...
                    let distance: Float = Float(distanceOf(pt: MKMapPointForCoordinate(coord), toPoly: overlay as! MKPolyline))
                    // ... and find the nearest one
                    if distance < nearestDistance {
                        nearestDistance = distance
                        nearestPoly = overlay as! MKPolyline
                        
                    }
                    
                }
            }
            
            if Double(nearestDistance) <= maxMeters {
                print("Touched poly: \(nearestPoly) distance: \(nearestDistance)")
                showInfoWhenLaneTapped(line: nearestPoly!)
                makeBold(routeToBold: nearestPoly!)
            } else {
                infoView.alpha = 0.0
            }
        }
    }
    
    func distanceOf(pt: MKMapPoint, toPoly poly: MKPolyline) -> Double {
        var distance: Double = Double(MAXFLOAT)
        for n in 0..<poly.pointCount {
            let ptA = poly.points()[n]
            let ptB = poly.points()[n + 1]
            let xDelta: Double = ptB.x - ptA.x
            let yDelta: Double = ptB.y - ptA.y
            if xDelta == 0.0 && yDelta == 0.0 {
                // Points must not be equal
                continue
            }
            let u: Double = ((pt.x - ptA.x) * xDelta + (pt.y - ptA.y) * yDelta) / (xDelta * xDelta + yDelta * yDelta)
            var ptClosest: MKMapPoint
            if u < 0.0 {
                ptClosest = ptA
            }
            else if u > 1.0 {
                ptClosest = ptB
            }
            else {
                ptClosest = MKMapPointMake(ptA.x + u * xDelta, ptA.y + u * yDelta)
            }
            
            distance = min(distance, MKMetersBetweenMapPoints(ptClosest, pt))
        }
        return distance
    }
    
    func meters(fromPixel px: Int, at pt: CGPoint) -> Double {
        let ptB = CGPoint(x: pt.x + CGFloat(px), y: pt.y)
        let coordA: CLLocationCoordinate2D = mapView.convert(pt, toCoordinateFrom: mapView)
        let coordB: CLLocationCoordinate2D = mapView.convert(ptB, toCoordinateFrom: mapView)
        return MKMetersBetweenMapPoints(MKMapPointForCoordinate(coordA), MKMapPointForCoordinate(coordB))
    }
    
    func makeBold(routeToBold: MKPolyline){
        for route in bikeRoutes{
            if route.isBold == true{
                mapView.remove(route.routeLine)
                route.isBold = false
                mapView.add(route.routeLine)
            }
            if routeToBold == (route.routeLine) {
                mapView.remove(routeToBold)
                route.isBold = true
                mapView.add(routeToBold)
                //showInfoWhenLaneTapped(line: nearestPoly!)
            }
        }
    }
    
    func showInfoWhenLaneTapped(line: MKPolyline) {
        UIView.animate(withDuration: 0.3) {
            self.infoView.alpha = 0.9
        }
        distanceLabel.isHidden = false
        directionsButton.isHidden = true
        toLabel.isHidden = true
        for route in bikeRoutes {
            if route.routeLine == line {
                //if route.streetName.first != String {
                    //streetLabel.text = route.streetName.lowercased()
                //} else {
                    streetLabel.text = route.streetName.capitalized
                //}
                startStreetLabel.text = route.startStreet.capitalized
                endStreetLabel.text = route.endStreet.capitalized
                distanceLabel.text = String(format: "%.2f", route.lengthInFeet/5280.0) + " mi"
            }
        }
    }
    
    
    func loadInitialData() {
        guard let fileName = Bundle.main.path(forResource: "rows", ofType: "json")
            else { return }
        let optionalData = try? Data(contentsOf: URL(fileURLWithPath: fileName))
        
        guard
            let data = optionalData,
            let json = try? JSONSerialization.jsonObject(with: data),
            let dictionary = json as? [String: Any],
            let works = dictionary["data"] as? [[Any]]
            else { return }
        let validWorks = works.compactMap { BikeRack(json: $0) }
        bikeRacks.append(contentsOf: validWorks)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dvc = segue.destination as! HelpViewController
        dvc.offRoadColors = self.offRoadColors
        dvc.bufferedColors = self.bufferedColors
        dvc.sharedLaneColors = self.sharedLaneColors
        dvc.cycleTrackColors = self.cycleTrackColors
        dvc.bikeLaneColors = self.bikeLaneColors
    }
}
