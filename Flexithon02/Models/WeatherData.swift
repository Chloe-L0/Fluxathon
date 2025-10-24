//
//  WeatherData.swift
//  Flexithon02
//
//  Core weather data model
//

import Foundation

/// Represents the weather data displayed in the UI
struct WeatherData: Codable, Identifiable {
    let id = UUID()
    let cityName: String
    let temperature: Double
    let feelsLike: Double
    let humidity: Int
    let pressure: Int
    let windSpeed: Double
    let condition: String // e.g., "Clear", "Clouds", "Rain"

    enum CodingKeys: String, CodingKey {
        case cityName, temperature, feelsLike, humidity, pressure, windSpeed, condition
    }
}
