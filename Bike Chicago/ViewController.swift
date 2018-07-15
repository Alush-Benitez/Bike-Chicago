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
    
    var polylines: [MKPolyline] = []
    
    //let bikeRouteClass = BikeRoute()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let bikeRouteClass = BikeRoute()
//        print(bikeRouteClass.routeTypes.count)
//        print(bikeRouteClass.streetNames.count)
//        print(bikeRouteClass.endStreets.count)
//        print(bikeRouteClass.startStreets.count)
//        print(bikeRouteClass.lengths.count)
        
        mapView.delegate = self
        let initialLocation = CLLocation(latitude: 41.8781, longitude: -87.6298)
        centerMapOnLocation(location: initialLocation)
        mapView.showsUserLocation = true
        addRoute()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func addRoute() {
        for bunchOfCords in BikeRoute().separatePathCoordinates {
            //print(bunchOfCords)
            let myPolyline = MKPolyline(coordinates: bunchOfCords, count: bunchOfCords.count)
            //mapView.add(myPolyline)
            polylines.append(myPolyline)
            self.mapView.add(myPolyline, level: MKOverlayLevel.aboveRoads)
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        print("blahj")
        if overlay is MKPolyline {
//            let renderer = MKPolylineRenderer(overlay: overlay)
//            renderer.strokeColor = UIColor.orange
//            renderer.lineWidth = 3
//            print("herefklhsadjfnkjfenm,badnklje")
//            return renderer
            
            let polyLineRenderer = MKPolylineRenderer(overlay: overlay)
            polyLineRenderer.strokeColor = .blue
            polyLineRenderer.lineWidth = 2.0
            
            return polyLineRenderer
        }
        return MKPolylineRenderer()
    }
}
