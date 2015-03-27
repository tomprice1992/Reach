//
//  TypesTableViewController.swift
//  Reach
//  Created by Tom Price 2015
//

//This file is used to display the possible types when you press the top right button

import UIKit

protocol TypesTableViewControllerDelegate: class {
  func typesController(controller: TypesTableViewController, didSelectTypes types: [String])
}

class TypesTableViewController: UITableViewController {
  
        // this is creating the dictionary with the possible search terms being taxi_stand
    
  let possibleTypesDictionary = ["taxi_stand":"Taxi_Stand"]
  var selectedTypes: [String]!
  weak var delegate: TypesTableViewControllerDelegate!
  var sortedKeys: [String] {
    get {
      return sorted(possibleTypesDictionary.keys)
    }
  }
  
    @IBAction func phoneCall(sender: AnyObject) {
        UIApplication .sharedApplication() .openURL(NSURL(string:"tel:0000000000")!)
        }
    
  // this is just another link to go back and to remember the selectedtype from this menu

  @IBAction func donePressed(sender: AnyObject) {
    delegate?.typesController(self, didSelectTypes: selectedTypes)
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return possibleTypesDictionary.count
  }
  
    
    //following function is linking the cellitems with the label and imageview when we click on a taxi rank
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("TypeCell", forIndexPath: indexPath) as UITableViewCell
    let key = sortedKeys[indexPath.row]
    let type = possibleTypesDictionary[key]!
    cell.textLabel?.text = type
    cell.imageView?.image = UIImage(named: key)
    cell.accessoryType = contains(selectedTypes!, key) ? .Checkmark : .None
    return cell
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    let key = sortedKeys[indexPath.row]
    if contains(selectedTypes!, key) {
      selectedTypes = selectedTypes.filter({$0 != key})
    } else {
      selectedTypes.append(key)
    }
    
    tableView.reloadData()
  }
}
