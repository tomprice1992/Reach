//
//  MapViewController.swift
//  Feed Me
//
//  Created by Ron Kliffer on 8/30/14.
//  Copyright (c) 2014 Ron Kliffer. All rights reserved.
//

import UIKit

class MapViewController: UIViewController, TypesTableViewControllerDelegate, CLLocationManagerDelegate, GMSMapViewDelegate {
  
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var mapView: GMSMapView!
  @IBOutlet weak var mapCenterPinImage: UIImageView!
  @IBOutlet weak var pinImageVerticalConstraint: NSLayoutConstraint!
  var searchedTypes = ["taxi"]
    
  let locationManager = CLLocationManager()
    
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    locationManager.delegate = self
    locationManager.requestWhenInUseAuthorization()
    mapView.delegate = self
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "Types Segue" {
      let navigationController = segue.destinationViewController as UINavigationController
      let controller = segue.destinationViewController.topViewController as TypesTableViewController
      controller.selectedTypes = searchedTypes
      controller.delegate = self
    }
  }
  
  // MARK: - Types Controller Delegate
  func typesController(controller: TypesTableViewController, didSelectTypes types: [String]) {
    searchedTypes = sorted(controller.selectedTypes)
    dismissViewControllerAnimated(true, completion: nil)
  }
    
    @IBAction func mapTypeSegmentPressed(sender: AnyObject) {
        let segmentedControl = sender as UISegmentedControl
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            mapView.mapType = kGMSTypeNormal
        case 1:
            mapView.mapType = kGMSTypeSatellite
        case 2:
            mapView.mapType = kGMSTypeHybrid
        default:
            mapView.mapType = mapView.mapType
        }
    }
    
    // 1
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        // 2
        if status == .AuthorizedWhenInUse {
            
            // 3
            locationManager.startUpdatingLocation()
            
            //4
            mapView.myLocationEnabled = true
            mapView.settings.myLocationButton = true
        }
    }
    
    // 5
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        if let location = locations.first as? CLLocation {
            
            // 6
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            
            // 7
            locationManager.stopUpdatingLocation()
        }
    }
    
    func mapView(mapView: GMSMapView!, willMove gesture: Bool) {
        addressLabel.lock()
    }
    
    func reverseGeocodeCoordinate(coordinate: CLLocationCoordinate2D) {
        
        // 1
        let geocoder = GMSGeocoder()
        
        // 2
        geocoder.reverseGeocodeCoordinate(coordinate) { response , error in
                  self.addressLabel.unlock()
            
            if let address = response?.firstResult() {
                
                // 3
                let lines = address.lines as [String]
                self.addressLabel.text = join("\n", lines)
 
                let labelHeight = self.addressLabel.intrinsicContentSize().height
                self.mapView.padding = UIEdgeInsets(top: self.topLayoutGuide.length, left: 0, bottom: labelHeight, right: 0)
                
                UIView.animateWithDuration(0.25) {
                    //2
                    self.pinImageVerticalConstraint.constant = ((labelHeight - self.topLayoutGuide.length) * 0.5)
                    self.view.layoutIfNeeded()
                }
      // 4
      UIView.animateWithDuration(0.25) {
        self.view.layoutIfNeeded()
      }
    }
  }
    }
    
    func mapView(mapView: GMSMapView!, idleAtCameraPosition position: GMSCameraPosition!) {
        reverseGeocodeCoordinate(position.target)
    }
    


    
}

