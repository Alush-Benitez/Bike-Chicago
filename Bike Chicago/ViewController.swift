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
    
    
    //let bikeRouteClass = BikeRoute()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //let bikeRouteClass = BikeRoute()
//        print(bikeRouteClass.routeTypes.count)
//        print(bikeRouteClass.streetNames.count)
//        print(bikeRouteClass.endStreets.count)
//        print(bikeRouteClass.startStreets.count)
//        print(bikeRouteClass.lengths.count)
        
        points.append(CLLocationCoordinate2DMake(35.3289, -120.7394))
        points.append(CLLocationCoordinate2DMake(35.3287, -120.7396))
        points.append(CLLocationCoordinate2DMake(35.3284, -120.7392))
        points.append(CLLocationCoordinate2DMake(35.3286, -120.7389))

        let polyline = MKPolyline(coordinates: points, count: points.count)
        mapView.add(polyline)
        
        
        addRoute()
        mapView.delegate = self
        let initialLocation = CLLocation(latitude: 41.8781, longitude: -87.6298)
        centerMapOnLocation(location: initialLocation)
        mapView.showsUserLocation = true
        
        
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
        for polyline in polylines {
            mapView.add(polyline)
        }
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        print("blahj")
        if overlay is MKPolyline {
            let polyLineRenderer = MKPolylineRenderer(overlay: overlay)
            polyLineRenderer.strokeColor = .blue
            polyLineRenderer.lineWidth = 2.0
            
            return polyLineRenderer
        }
        return MKPolylineRenderer()
    }
}
