//
//  MapViewController.swift
//  Reach
//  Created by Tom Price 2015
//
import UIKit

class MapViewController: UIViewController, TypesTableViewControllerDelegate, CLLocationManagerDelegate, GMSMapViewDelegate {
//creating outlet links for the addressLabel, mapView from the storyboard

    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var mapView: GMSMapView!
//centerpinimage is the pin image which is in the middle of the screen, defining it here

  @IBOutlet weak var mapCenterPinImage: UIImageView!
//just a constraint to keep it in the center of the screen

  @IBOutlet weak var pinImageVerticalConstraint: NSLayoutConstraint!
//defining new variable which will the search for taxis in the google api

  var searchedTypes = ["taxi_stand"]
    
  let locationManager = CLLocationManager()
    
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    locationManager.delegate = self
    locationManager.requestWhenInUseAuthorization()
    mapView.delegate = self
  }
  
    //a "segue" is basically a linker from one storyboard controller to the next, so this checks to see if we have a linker named "types segue" and if we do then we will open the chosen new view controller for the user. "TypesTableViewController"

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
    //calling the function below to fetch the nearby places when the above selectedTypes is selected
    fetchNearbyPlaces(mapView.camera.target)
  }
    //this links to the little refresh icon at the top left, just fetches nearby places

    @IBAction func refreshPlaces(sender:
        AnyObject)
    { fetchNearbyPlaces(mapView.camera.target) 
    }
    //this checks the segment control (normal, hybrid, satelite) and changes the mapview to the correct one
    
    @IBAction func mapTypeSegmentPressed(sender: AnyObject) {
        let segmentedControl = sender as UISegmentedControl
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            
            //if case 0 (ie none selected) then the map will return as normal

            mapView.mapType = kGMSTypeNormal
        case 1:
            
            //case 1 is the first segment control which says 'satellite' so changes map to that
            
            mapView.mapType = kGMSTypeSatellite
        case 2:
            //etc...
            mapView.mapType = kGMSTypeHybrid
        default:
            mapView.mapType = mapView.mapType
        }
    
        
    //this function puts the info in the marker window when you click/touch a taxi icon
  
    }
    func mapView(mapView: GMSMapView!, markerInfoContents marker: GMSMarker!) -> UIView! {
        let placeMarker = marker as PlaceMarker
        
        if let infoView = UIView.viewFromNibName("MarkerInfoView") as? MarkerInfoView {
            //changes the nameLabel in 'MarkerInfoView.xib to the name of the place in the google api (place.name) >

            infoView.nameLabel.text = placeMarker.place.name
            //infoView.placePhone.text = placeMarker.place.phone
            // Thats the stuff about the phone which we cant get working
            
            //this let statement places the photo in the UIImage we have created in the MarkerInfoView.xib
            if let photo = placeMarker.place.photo {
                infoView.placePhoto.image = photo
            } else {
                infoView.placePhoto.image = UIImage(named: "generic")
            }
            
            return infoView
        } else {
            return nil
        }
    }
    //this is just enabling myLocation so the app can find your location
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            
            locationManager.startUpdatingLocation()
            
            mapView.myLocationEnabled = true
            mapView.settings.myLocationButton = true
        }
    }
    
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        if let location = locations.first as? CLLocation {
            
            //this function positions the camera (view) of the map at your defined zoom and angle. you can change the zoom so it's defaultly more zoomed in or out
            
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            
            // 7
            locationManager.stopUpdatingLocation()
            
            fetchNearbyPlaces(location.coordinate)
        }
    }
    
    //dont worry bout this, it justs hides the addresslabel at the bottom of the screen until it has found a new location

    func mapView(mapView: GMSMapView!, willMove gesture: Bool) {
        addressLabel.lock()
    }
    
    //this is the size of the radius on the map, so the bigger it is the more taxi companies are returned for the bigger area

    var mapRadius: Double {
        get {
            let region = mapView.projection.visibleRegion()
            let verticalDistance = GMSGeometryDistance(region.farLeft, region.nearLeft)
            let horizontalDistance = GMSGeometryDistance(region.farLeft, region.farRight)
            return max(horizontalDistance, verticalDistance)*0.5
        }
    }
    
    let dataProvider = GoogleDataProvider()
    
    //calling the google dataprovider
    
    func fetchNearbyPlaces(coordinate: CLLocationCoordinate2D) {
        // 1
        mapView.clear()
        // 2
        
        //now its gonna fetch nearby places bases on the mapradius set above and look in GooglePlace for places and then set it up with the PlaceMarker we created before

        dataProvider.fetchPlacesNearCoordinate(coordinate, radius:mapRadius, types: searchedTypes) { places in
            for place: GooglePlace in places {
                // 3
                let marker = PlaceMarker(place: place)
                // 4
                marker.map = self.mapView
            }
        }
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
                
                //this just adds a padding to the addresslabel so the google logo and location refresher thing can be seend

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

