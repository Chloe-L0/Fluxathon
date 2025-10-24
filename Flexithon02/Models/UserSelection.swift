//
//  UserSelection.swift
//  Flexithon02
//
//  Shared data model for passing data between pages
//

import Foundation
import SwiftUI
import Combine

class UserSelection: ObservableObject {
    @Published var weatherData: WeatherData?
    @Published var selectedActivity: Activity?
    @Published var userLocation: String = ""
    
    func reset() {
        weatherData = nil
        selectedActivity = nil
        userLocation = ""
    }
}
