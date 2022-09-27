//
//  LocationManager.swift
//  WeatherApp
//
//  Created by Nguyễn Thị Vân Anh on 26/09/2022.
//

import Foundation
import CoreLocation
typealias LocationCompletion = (CLLocation) -> ()

//class LocationManager {
//    func getCurrentLocation() ->  CLLocation? {
//        let locationManager = CLLocationManager()
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        guard let currentLocation = locationManager.location else {
//            return nil
//        }
//        return currentLocation
//    }
//}

extension LocationManager : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("location manager authorization status changed")

        switch status {
        case .authorizedAlways:
            print("user allow app to get location data when app is active or in background")
            manager.requestLocation()

        case .authorizedWhenInUse:
            print("user allow app to get location data only when app is active")
            manager.requestLocation()

        case .denied:
            print("user tap 'disallow' on the permission dialog, cant get location data")

        case .restricted:
            print("parental control setting disallow location data")

        case .notDetermined:
            print("the location permission dialog haven't shown before, user haven't tap allow/disallow")

        default:
            print("default")
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            self.currentLocation = location

            if let current = currentCompletion {
                current(location)
            }

            if isUpdatingLocation, let updating = locationCompletion {
                updating(location)
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error.localizedDescription)")
    }
}

final class LocationManager: NSObject {
    private let locationManager = CLLocationManager()
    private var currentLocation: CLLocation?
    private var currentCompletion: LocationCompletion?
    private var locationCompletion: LocationCompletion?
    private var isUpdatingLocation = false
    //singleton
    private static var sharedLocationManager: LocationManager = {
        let locationManager = LocationManager()
        return locationManager
    }()

    class func shared() -> LocationManager {
        return sharedLocationManager
    }

    //MARK: - init
    override init() {
        super.init()
        configLocationManager()
    }

    func configLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 10
        locationManager.allowsBackgroundLocationUpdates = true
    }

    func request() {
            let status = CLLocationManager.authorizationStatus()

            if(status == .denied || status == .restricted || !CLLocationManager.locationServicesEnabled()){
                return
            }

            if(status == .notDetermined){
                locationManager.requestWhenInUseAuthorization()
                return
            }

            locationManager.requestLocation()
        }

    func getCurrentLocation() -> CLLocation? {
         return currentLocation
     }

     func getCurrentLocation(completion: @escaping LocationCompletion) {
         currentCompletion = completion
         locationManager.requestLocation()
     }

    func startUpdating(completion: @escaping LocationCompletion) {
            locationCompletion = completion
            isUpdatingLocation = true
            locationManager.startUpdatingLocation()
        }

    func stopUpdating() {
            locationManager.stopUpdatingLocation()
            isUpdatingLocation = false
        }
}
