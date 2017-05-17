//
//  MainViewController.swift
//  CSCI3310
//
//  Created by Ka Hong Ngai on 17/5/2017.
//  Copyright © 2017 CSCI3310. All rights reserved.
//

import UIKit
import CoreLocation
let storedItemsKey = "storedItems"
class MainViewController: UIViewController {
  
    let locationManager = CLLocationManager()
   var beacons = [Beacon]()
    override func viewDidLoad() {
        super.viewDidLoad()
      
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        loadBeacons();
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  func loadBeacons() {
    // todo: hard code an array of Beacon object
    guard let storedItems = UserDefaults.standard.array(forKey: storedItemsKey) as? [Data] else { return }
    for itemData in storedItems {
      guard let beacon = NSKeyedUnarchiver.unarchiveObject(with: itemData) as? Beacon else { continue }
      beacons.append(beacon)
      startMonitoringItem(beacon)
    }
  }
  
  func startMonitoringItem(_ beacon: Beacon) {
    let beaconRegion = beacon.asBeaconRegion()
    locationManager.startMonitoring(for: beaconRegion)
    locationManager.startRangingBeacons(in: beaconRegion)
  }
  
  func stopMonitoringItem(_ beacon: Beacon) {
    let beaconRegion = beacon.asBeaconRegion()
    locationManager.stopMonitoring(for: beaconRegion)
    locationManager.stopRangingBeacons(in: beaconRegion)
  }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

extension MainViewController: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
    print("Failed monitoring region: \(error.localizedDescription)")
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("Location manager failed: \(error.localizedDescription)")
  }
  
  func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
    
  }
}
