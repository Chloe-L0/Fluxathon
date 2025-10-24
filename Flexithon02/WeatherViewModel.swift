//
//  WeatherViewModel.swift
//  Flexithon02
//
//  Handles weather API fetching and location management
//

import Foundation
import SwiftUI
import Combine
import CoreLocation

@MainActor
class WeatherViewModel: ObservableObject {
    // MARK: - Published Properties

    @Published var weather: WeatherData?
    @Published var isLoading = false
    @Published var statusMessage: String?
    @Published var isError = false

    // MARK: - Private Properties

    private let locationManager = LocationManager()
    private var refreshTimer: Timer?

    // SECURITY NOTE: In production apps, API keys should NEVER be exposed in client code.
    // Use a backend proxy server or secure environment configuration instead.
    // This placeholder is for demonstration purposes only.
    private let apiKey = "64ad9345573e9dca5425c43612fa7598" // <-- Replace with your actual OpenWeatherMap API key

    private let baseURL = "https://api.openweathermap.org/data/2.5/weather"

    // MARK: - Initialization

    init() {
        setupAutoRefresh()
    }

    deinit {
        refreshTimer?.invalidate()
    }

    // MARK: - Public Methods

    /// Fetch weather for current location using GPS
    func fetchWeatherForCurrentLocation() async {
        isLoading = true
        statusMessage = "Detecting your location..."
        isError = false

        do {
            let coordinate = try await locationManager.requestLocation()
            statusMessage = "Fetching weather data..."

            await fetchWeather(latitude: coordinate.latitude, longitude: coordinate.longitude)
        } catch LocationError.denied {
            // Fallback to a default location (San Francisco) when permission denied
            statusMessage = "Location denied. Showing weather for San Francisco..."
            await fetchWeather(latitude: 37.7749, longitude: -122.4194)
        } catch LocationError.unavailable {
            // Fallback to a default location when unavailable
            statusMessage = "Location unavailable. Showing weather for San Francisco..."
            await fetchWeather(latitude: 37.7749, longitude: -122.4194)
        } catch LocationError.timeout {
            // Fallback on timeout
            statusMessage = "Location timeout. Showing weather for San Francisco..."
            await fetchWeather(latitude: 37.7749, longitude: -122.4194)
        } catch {
            statusMessage = "Location error. Showing weather for San Francisco..."
            await fetchWeather(latitude: 37.7749, longitude: -122.4194)
        }
    }

    /// Fetch weather for a specific city name
    func fetchWeatherForCity(_ city: String) async {
        guard !city.isEmpty else {
            statusMessage = "Please enter a city name"
            isError = true
            return
        }

        isLoading = true
        statusMessage = "Fetching weather for \(city)..."
        isError = false

        let urlString = "\(baseURL)?q=\(city)&units=metric&appid=\(apiKey)"

        guard let encodedURL = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: encodedURL) else {
            statusMessage = "Invalid city name"
            isError = true
            isLoading = false
            return
        }

        await performWeatherRequest(url: url)
    }

    // MARK: - Private Methods

    /// Fetch weather using latitude and longitude
    private func fetchWeather(latitude: Double, longitude: Double) async {
        let urlString = "\(baseURL)?lat=\(latitude)&lon=\(longitude)&units=metric&appid=\(apiKey)"

        guard let url = URL(string: urlString) else {
            statusMessage = "Invalid URL"
            isError = true
            isLoading = false
            return
        }

        await performWeatherRequest(url: url)
    }

    /// Perform the actual network request with timeout handling
    private func performWeatherRequest(url: URL) async {
        var request = URLRequest(url: url)
        request.timeoutInterval = 8.0

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw WeatherError.invalidResponse
            }

            // Handle HTTP status codes
            switch httpResponse.statusCode {
            case 200:
                let decoder = JSONDecoder()
                let apiResponse = try decoder.decode(OpenWeatherResponse.self, from: data)

                // Map API response to our WeatherData model
                weather = WeatherData(
                    cityName: apiResponse.name,
                    temperature: apiResponse.main.temp,
                    feelsLike: apiResponse.main.feels_like,
                    humidity: apiResponse.main.humidity,
                    pressure: apiResponse.main.pressure,
                    windSpeed: apiResponse.wind.speed,
                    condition: apiResponse.weather.first?.main ?? "Unknown"
                )

                statusMessage = "📍 Location detected - Updated just now"
                isError = false

            case 401:
                statusMessage = "Invalid API key. Please check your configuration."
                isError = true

            case 404:
                statusMessage = "City not found. Please try again."
                isError = true

            case 429:
                statusMessage = "Rate limit exceeded. Please try again later."
                isError = true

            default:
                statusMessage = "API error: HTTP \(httpResponse.statusCode)"
                isError = true
            }

        } catch let error as URLError {
            if error.code == .timedOut {
                statusMessage = "Request timed out. Please check your connection."
            } else if error.code == .notConnectedToInternet {
                statusMessage = "No internet connection. Please check your network."
            } else {
                statusMessage = "Network error: \(error.localizedDescription)"
            }
            isError = true

        } catch {
            statusMessage = "Failed to decode weather data: \(error.localizedDescription)"
            isError = true
        }

        isLoading = false
    }

    /// Setup auto-refresh every 10 minutes
    private func setupAutoRefresh() {
        refreshTimer = Timer.scheduledTimer(withTimeInterval: 600, repeats: true) { [weak self] _ in
            Task { @MainActor in
                await self?.fetchWeatherForCurrentLocation()
            }
        }
    }
}

// MARK: - Supporting Types

enum WeatherError: LocalizedError {
    case invalidResponse
    case decodingFailed

    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Invalid server response"
        case .decodingFailed:
            return "Failed to decode weather data"
        }
    }
}

// MARK: - OpenWeatherMap API Response Models

struct OpenWeatherResponse: Codable {
    let name: String
    let main: MainWeather
    let weather: [WeatherCondition]
    let wind: Wind
}

struct MainWeather: Codable {
    let temp: Double
    let feels_like: Double
    let humidity: Int
    let pressure: Int
}

struct WeatherCondition: Codable {
    let main: String
    let description: String
}

struct Wind: Codable {
    let speed: Double
}
