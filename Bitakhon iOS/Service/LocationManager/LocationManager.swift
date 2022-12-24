//
// Created by Mickael Belhassen on 03/01/2022.
//

import Foundation
import CoreLocation

protocol LocationManagerService {
    var authorizationStatus: CLAuthorizationStatus { get }

    func requestLocationPermissionIfNeeded()
    func getCurrentCoordinate() async -> CLLocationCoordinate2D
}

class LocationManager: NSObject, LocationManagerService {
    let locationManager = CLLocationManager()

    // MARK: Properties

    var coordinateContinuationHandler: CheckedContinuation<CLLocationCoordinate2D, Never>?
    var authorizationStatus: CLAuthorizationStatus { locationManager.authorizationStatus }


    override init() {
        super.init()
        setup()
    }

}


// MARK: - Setup

private extension LocationManager {

    func setup() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

}


// MARK: - Actions

extension LocationManager {

    func requestLocationPermissionIfNeeded() {
        locationManager.requestAlwaysAuthorization()
    }


    func getCurrentCoordinate() async -> CLLocationCoordinate2D {
        await withCheckedContinuation { continuation in
            coordinateContinuationHandler = continuation
            locationManager.startUpdatingLocation()
        }
    }

}


// MARK: - Delegate methods

extension LocationManager: CLLocationManagerDelegate {

    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinate = manager.location?.coordinate else { return }
        coordinateContinuationHandler?.resume(returning: coordinate)
        coordinateContinuationHandler = nil
    }

}
