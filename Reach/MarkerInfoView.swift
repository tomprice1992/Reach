//
//  MarkerInfoView.swift
//  Feed Me
//
//  Created by Ron Kliffer on 8/30/14.
//  Copyright (c) 2014 Ron Kliffer. All rights reserved.
//

import UIKit

class MarkerInfoView: UIView {
    

  @IBOutlet var placePhone: UITextField!
  @IBOutlet weak var placePhoto: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
    
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
