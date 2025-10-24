//
//  ContentView.swift
//  Flexithon02
//
//  Main Weather UI Layout
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = WeatherViewModel()
    @State private var showManualInput = false
    @State private var cityInput = ""

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [Color(red: 0.4, green: 0.49, blue: 0.92), Color(red: 0.46, green: 0.29, blue: 0.64)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    // Status message
                    if let statusMessage = viewModel.statusMessage {
                        statusBanner(message: statusMessage, isError: viewModel.isError)
                    }

                    if viewModel.isLoading {
                        loadingView()
                    } else if let weather = viewModel.weather {
                        weatherCard(weather: weather)
                    }

                    // Manual city input
                    if showManualInput {
                        manualInputView()
                    } else if viewModel.weather != nil {
                        Button("Change Location") {
                            showManualInput = true
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white.opacity(0.2))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding(.horizontal)
                    } else if viewModel.isError {
                        // Show "Enter City" button when location fails
                        Button("Enter City Manually") {
                            showManualInput = true
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .foregroundColor(Color(red: 0.4, green: 0.49, blue: 0.92))
                        .cornerRadius(12)
                        .padding(.horizontal)
                    }

                    // Retry button for location errors (only show if manual input is not visible)
                    if viewModel.isError && viewModel.weather == nil && !showManualInput {
                        Button("Retry Location") {
                            Task {
                                await viewModel.fetchWeatherForCurrentLocation()
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white.opacity(0.3))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
        }
        .task {
            await viewModel.fetchWeatherForCurrentLocation()
        }
    }

    // MARK: - Status Banner

    private func statusBanner(message: String, isError: Bool) -> some View {
        Text(message)
            .font(.subheadline)
            .foregroundColor(isError ? .red : .white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(isError ? Color.red.opacity(0.2) : Color.white.opacity(0.2))
            .cornerRadius(12)
            .padding(.horizontal)
    }

    // MARK: - Loading View

    private func loadingView() -> some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.5)
                .tint(.white)

            Text("Loading weather...")
                .font(.headline)
                .foregroundColor(.white)
        }
        .padding(40)
    }

    // MARK: - Weather Card

    private func weatherCard(weather: WeatherData) -> some View {
        VStack(spacing: 15) {
            // Weather icon
            Text(weatherIcon(for: weather.condition))
                .font(.system(size: 80))

            // City name
            Text(weather.cityName)
                .font(.title)
                .fontWeight(.semibold)
                .foregroundColor(.white)

            // Temperature
            Text(String(format: "%.0f°C", weather.temperature))
                .font(.system(size: 64, weight: .bold))
                .foregroundColor(.white)

            // Condition
            Text(weather.condition.capitalized)
                .font(.title3)
                .foregroundColor(.white.opacity(0.9))

            // Details grid
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                detailCard(label: "Feels Like", value: String(format: "%.0f°C", weather.feelsLike))
                detailCard(label: "Humidity", value: "\(weather.humidity)%")
                detailCard(label: "Wind", value: String(format: "%.1f m/s", weather.windSpeed))
                detailCard(label: "Pressure", value: "\(weather.pressure) hPa")
            }
            .padding(.top, 10)

            // Refresh button
            Button(action: {
                Task {
                    await viewModel.fetchWeatherForCurrentLocation()
                }
            }) {
                HStack {
                    Image(systemName: "arrow.clockwise")
                    Text("Refresh")
                }
                .font(.subheadline)
                .foregroundColor(.white)
            }
            .padding(.top, 10)
        }
        .padding(30)
        .background(Color.white.opacity(0.15))
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 10)
        .padding(.horizontal)
    }

    // MARK: - Detail Card

    private func detailCard(label: String, value: String) -> some View {
        VStack(spacing: 5) {
            Text(label)
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
                .textCase(.uppercase)

            Text(value)
                .font(.headline)
                .foregroundColor(.white)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white.opacity(0.2))
        .cornerRadius(12)
    }

    // MARK: - Manual Input View

    private func manualInputView() -> some View {
        VStack(spacing: 15) {
            TextField("Enter city name", text: $cityInput)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            HStack(spacing: 15) {
                Button("Search") {
                    Task {
                        await viewModel.fetchWeatherForCity(cityInput)
                        showManualInput = false
                        cityInput = ""
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .foregroundColor(Color(red: 0.4, green: 0.49, blue: 0.92))
                .cornerRadius(12)

                Button("Cancel") {
                    showManualInput = false
                    cityInput = ""
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.white.opacity(0.2))
                .foregroundColor(.white)
                .cornerRadius(12)
            }
            .padding(.horizontal)
        }
    }

    // MARK: - Weather Icon Helper

    private func weatherIcon(for condition: String) -> String {
        let icons: [String: String] = [
            "Clear": "☀️",
            "Clouds": "☁️",
            "Rain": "🌧️",
            "Snow": "❄️",
            "Thunderstorm": "⛈️",
            "Drizzle": "🌦️",
            "Mist": "🌫️",
            "Fog": "🌫️",
            "Haze": "🌫️"
        ]
        return icons[condition] ?? "🌤️"
    }
}

#Preview {
    ContentView()
}
