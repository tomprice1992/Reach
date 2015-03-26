//  Reach
//  Created by Tom Price 2015
//
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    // 1
    //my unique server key
    let googleMapsApiKey = "AIzaSyDnXFxi7TjDsGm0OSLe9Ptrybdn83sLcsI"
    
    func application(application: UIApplication!, didFinishLaunchingWithOptions launchOptions: NSDictionary!) -> Bool {
        // 2
        GMSServices.provideAPIKey(googleMapsApiKey)
        return true
    }
}