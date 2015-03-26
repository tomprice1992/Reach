//
//  GooglePlace.swift
//  Reach
//  Created by Tom Price 2015
//

import UIKit
import Foundation
import CoreLocation

class GooglePlace {
  //defining place variables
  let name: String
  let address: String
    //below commented out is you know what
 //let phone: String
  let coordinate: CLLocationCoordinate2D
  let placeType: String
  let photoReference: String?
  var photo: UIImage?
  
    //creating the place dictionary
  init(dictionary:NSDictionary, acceptedTypes: [String])
  {
    //self explanitory pretty much
    name = dictionary["name"] as String
    address = dictionary["vicinity"] as String
  //  phone = dictionary["formatted_phone_number"] as String
    let location = dictionary["geometry"]?["location"] as NSDictionary
    let lat = location["lat"] as CLLocationDegrees
    let lng = location["lng"] as CLLocationDegrees
    coordinate = CLLocationCoordinate2DMake(lat, lng)
    
    if let photos = dictionary["photos"] as? NSArray {
      let photo = photos.firstObject as NSDictionary
      photoReference = photo["photo_reference"] as? NSString
    }
    
    //dunno why is says resaurant....but it works lol
    var foundType = "restaurant"
    let possibleTypes = acceptedTypes.count > 0 ? acceptedTypes : ["taxi_stand"]
    for type in dictionary["types"] as [String] {
      if contains(possibleTypes, type) {
        foundType = type
        break
      }
    }
    placeType = foundType
  }
}
