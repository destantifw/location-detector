//
//  LocationService.swift
//  location-detector
//
//  Created by destanti on 31/07/22.
//

import CoreLocation
import UIKit
import Combine

class LocationViewModel : NSObject, ObservableObject {
    
    
    @Published var locationList: [String]?
    @Published var isPermissionDenied: Bool = false
    @Published var isUpdatingLocation: Bool = false
    
    private var _timeInterval: Double = 60
    
    private var locationManager: CLLocationManager?
    
    override init() {
        super.init()
        self._initLocationManager()
    }
    
    private func _initLocationManager(){
        locationList = []
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
    }
    
    func requestLocation(){
        isUpdatingLocation = true
        locationManager?.requestLocation()
        Timer.scheduledTimer(withTimeInterval: _timeInterval, repeats: true) { [weak self] (t) in
            self?.locationManager?.requestLocation()
        }
    }
    
    
}

extension LocationViewModel : CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case .denied:
            isPermissionDenied = true
            break
        case .authorizedWhenInUse:
            isPermissionDenied = false
            manager.requestAlwaysAuthorization()
            break
        default :
                isPermissionDenied = false;
            break
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let currentDateTime = Date()
            let hour = (Calendar.current.component(.hour, from: currentDateTime))
            let minutes = (Calendar.current.component(.minute, from: currentDateTime))
            let second = (Calendar.current.component(.second, from: currentDateTime))
            
            let currentTimeLoc = " \(hour) : \(minutes) : \(second) loc : \(location.coordinate.latitude), \(location.coordinate.longitude)"
            
            
            if (!(locationList?.contains(currentTimeLoc))!) {
                locationList?.append(currentTimeLoc)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error \(error.localizedDescription)");
    }
    
}
