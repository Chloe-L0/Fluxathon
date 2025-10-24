//
//  LocationManager.swift
//  Flexithon02
//
//  Handles CoreLocation permissions and coordinate retrieval
//

import Foundation
import CoreLocation

/// Custom errors for location handling
enum LocationError: LocalizedError {
    case denied
    case unavailable
    case timeout

    var errorDescription: String? {
        switch self {
        case .denied:
            return "Location access was denied"
        case .unavailable:
            return "Location services are unavailable"
        case .timeout:
            return "Location request timed out"
        }
    }
}

/// Manages location permissions and coordinate fetching
class LocationManager: NSObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    private var continuation: CheckedContinuation<CLLocationCoordinate2D, Error>?
    private var timeoutTask: Task<Void, Never>?
    private var authContinuation: CheckedContinuation<Void, Never>?

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyKilometer
    }

    /// Request user's current location with timeout
    func requestLocation() async throws -> CLLocationCoordinate2D {
        // Check if location services are enabled
        guard CLLocationManager.locationServicesEnabled() else {
            throw LocationError.unavailable
        }

        // Check authorization status
        let status = manager.authorizationStatus

        switch status {
        case .notDetermined:
            // Request permission and wait for user response
            await withCheckedContinuation { continuation in
                self.authContinuation = continuation
                manager.requestWhenInUseAuthorization()
            }
            // After permission is handled, try again
            return try await requestLocation()

        case .restricted, .denied:
            throw LocationError.denied

        case .authorizedWhenInUse, .authorizedAlways:
            // Permission granted, fetch location
            return try await fetchCurrentLocation()

        @unknown default:
            throw LocationError.unavailable
        }
    }

    /// Fetch the actual location coordinates
    private func fetchCurrentLocation() async throws -> CLLocationCoordinate2D {
        return try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation

            // Set a 10-second timeout
            timeoutTask = Task {
                try? await Task.sleep(nanoseconds: 10_000_000_000)
                if self.continuation != nil {
                    self.continuation?.resume(throwing: LocationError.timeout)
                    self.continuation = nil
                }
            }

            manager.requestLocation()
        }
    }

    // MARK: - CLLocationManagerDelegate

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }

        timeoutTask?.cancel()
        continuation?.resume(returning: location.coordinate)
        continuation = nil
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        timeoutTask?.cancel()

        if let clError = error as? CLError {
            switch clError.code {
            case .denied:
                continuation?.resume(throwing: LocationError.denied)
            default:
                continuation?.resume(throwing: LocationError.unavailable)
            }
        } else {
            continuation?.resume(throwing: error)
        }

        continuation = nil
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        // Resume waiting continuation when authorization status changes
        if let continuation = authContinuation {
            authContinuation = nil
            continuation.resume()
        }
    }
}
