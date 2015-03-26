//
//  MarkerInfoView.swift
//  Reach
//  Created by Tom Price 2015
//

import UIKit

class MarkerInfoView: UIView {
    
//this is the class for the XIB file below just linking up the uilabels, imageview and textfields
  @IBOutlet var placePhone: UITextField!
  @IBOutlet weak var placePhoto: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
    
    //this function can be deleted,  phone numbers
    @IBAction func dialPhone(sender: AnyObject) {
        if nameLabel.text == "Carriages"
        {
            placePhone.text == "0161 465 475"
        }
        else
        {
        }
    }

}
