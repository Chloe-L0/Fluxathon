//
//  WeatherView.swift
//  Flexithon02
//
//  Main Weather UI Layout
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @EnvironmentObject var userSelection: UserSelection
    @State private var showManualInput = false
    @State private var cityInput = ""
    @State private var showCitySelection = false

    var body: some View {
        VStack(spacing: 0) {
            // Main content
            ScrollView {
                VStack(spacing: 20) {
                    // Weather Card
                    weatherCardFromImage()
                    
                    // Activity Section
                    activitySectionFromImage()
                    
                    // Upcoming Section
                    upcomingSectionFromImage()
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 100) // Space for bottom nav
            }
            
            // Bottom Navigation Bar
            bottomNavigationFromImage()
        }
        .background(Color.white.ignoresSafeArea())
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

    // MARK: - Weather Card from Image
    
    private func weatherCardFromImage() -> some View {
        VStack(spacing: 0) {
            // Main dark weather card
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.black)
                    .frame(height: 180)
                
                if viewModel.isLoading {
                    loadingView()
                } else if let weather = viewModel.weather {
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("\(Int(weather.temperature))°C")
                                .font(.system(size: 48, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text(weather.cityName)
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        VStack {
                            Text(DateFormatter.monthDay.string(from: Date()))
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            // Weather emoji based on condition
                            Text(weatherEmoji(for: weather.condition))
                                .font(.system(size: 40))
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                } else {
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("--°C")
                                .font(.system(size: 48, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text("Tap to select city")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        VStack {
                            Text(DateFormatter.monthDay.string(from: Date()))
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            Text("🌤️")
                                .font(.system(size: 40))
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                }
            }
            .onTapGesture {
                showCitySelection = true
            }
            
            // Weather details grid
            if let weather = viewModel.weather {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    weatherDetailFromImage(label: "Feels like", value: "\(Int(weather.feelsLike))°C")
                    weatherDetailFromImage(label: "Humidity", value: "\(weather.humidity)%")
                    weatherDetailFromImage(label: "Wind", value: "\(String(format: "%.1f", weather.windSpeed)) m/s")
                    weatherDetailFromImage(label: "Pressure", value: "\(weather.pressure) hPa")
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 20)
            } else {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    weatherDetailFromImage(label: "Feels like", value: "--°C")
                    weatherDetailFromImage(label: "Humidity", value: "--%")
                    weatherDetailFromImage(label: "Wind", value: "-- m/s")
                    weatherDetailFromImage(label: "Pressure", value: "-- hPa")
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 20)
            }
        }
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
        .sheet(isPresented: $showCitySelection) {
            CitySelectionView(viewModel: viewModel)
        }
    }
    
    // MARK: - Weather Detail from Image
    
    private func weatherDetailFromImage(label: String, value: String) -> some View {
        VStack(spacing: 8) {
            Text(label)
                .font(.caption)
                .foregroundColor(.gray)
                .textCase(.uppercase)
            
            Text(value)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.black)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
    
    // MARK: - Activity Section from Image
    
    private func activitySectionFromImage() -> some View {
        VStack(spacing: 16) {
            Text("Activity")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 24) {
                    // Outdoor Volleyball Card
                    volleyballCard()
                    
                    // Escape Room Card
                    escapeRoomCard()
                }
                .padding(.horizontal, 24)
            }
        }
    }
    
    // MARK: - Volleyball Card
    
    private func volleyballCard() -> some View {
        NavigationLink(destination: ActivityInfoView()) {
            VStack(spacing: 0) {
                // Main card with HP6.png background
                ZStack {
                    if let image = UIImage(named: "HP6") {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 230)  // ← Make image bigger by increasing height
                            .clipped()
                    } else {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.orange)
                            .frame(height: 230)
                            .overlay(
                                Text("HP6 Image Not Found")
                                    .foregroundColor(.white)
                                    .font(.caption)
                            )
                    }
                }
            }
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
            .frame(width: 230)
        }
        .buttonStyle(PlainButtonStyle()) // Remove default button styling
    }
    
    // MARK: - Escape Room Card
    
    private func escapeRoomCard() -> some View {
        VStack(spacing: 0) {
            // Main card with blue.png background
            ZStack {
                if let image = UIImage(named: "blue") {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 230)  // ← Make image bigger by increasing height
                        .clipped()
                } else {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.orange)
                        .frame(height: 230)
                        .overlay(
                            Text("Blue Image Not Found")
                                .foregroundColor(.white)
                                .font(.caption)
                        )
                }
            }
        }
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
        .frame(width: 230)
    }
    
    // MARK: - Upcoming Section from Image
    
    private func upcomingSectionFromImage() -> some View {
        VStack(spacing: 12) {
            Text("Upcoming")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .frame(height: 100)
                .overlay(
                    Text("No upcoming events")
                        .foregroundColor(.gray)
                )
             .padding(12)
            .background(Color.white)
        }
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
        .frame(width: 200)
    }
    
    // MARK: - Bottom Navigation from Image
    
    private func bottomNavigationFromImage() -> some View {
        HStack(spacing: 0) {
            // Home tab (active)
            VStack(spacing: 4) {
                Image(systemName: "house.fill")
                    .font(.title2)
                    .foregroundColor(.white)
                Text("Home")
                    .font(.caption)
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            
            // Activity tab
            VStack(spacing: 4) {
                Image(systemName: "star.square.fill")
                    .font(.title2)
                    .foregroundColor(.gray)
                Text("Activity")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity)
            
            // Chat tab
            VStack(spacing: 4) {
                Image(systemName: "bubble.left.and.bubble.right.fill")
                    .font(.title2)
                    .foregroundColor(.gray)
                Text("Chat")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity)
            
            // Me tab
            VStack(spacing: 4) {
                Image(systemName: "person.fill")
                    .font(.title2)
                    .foregroundColor(.gray)
                Text("Me")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.vertical, 12)
        .background(Color.black.opacity(0.8))
    }
    
    // MARK: - Helper Functions
    
    private func weatherEmoji(for condition: String) -> String {
        switch condition.lowercased() {
        case "clear":
            return "☀️"
        case "clouds":
            return "☁️"
        case "rain":
            return "🌧️"
        case "snow":
            return "❄️"
        case "thunderstorm":
            return "⛈️"
        case "mist", "fog":
            return "🌫️"
        default:
            return "🌤️"
        }
    }
}

// MARK: - Date Formatter Extension

extension DateFormatter {
    static let monthDay: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd"
        return formatter
    }()
}

// MARK: - City Selection View

struct CitySelectionView: View {
    @ObservedObject var viewModel: HomeViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""
    @State private var recentCities = ["New York", "London", "Tokyo", "Paris", "Sydney"]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Search bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    TextField("Search for a city...", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding(.horizontal)
                
                // Recent cities
                VStack(alignment: .leading, spacing: 12) {
                    Text("Recent Cities")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        ForEach(recentCities, id: \.self) { city in
                            Button(action: {
                                selectCity(city)
                            }) {
                                Text(city)
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    .background(Color.blue)
                                    .cornerRadius(20)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Manual input section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Enter City Name")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    HStack {
                        TextField("City name", text: $searchText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Button("Search") {
                            if !searchText.isEmpty {
                                selectCity(searchText)
                            }
                        }
                        .disabled(searchText.isEmpty)
                    }
                    .padding(.horizontal)
                }
                
                Spacer()
            }
            .navigationTitle("Select City")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func selectCity(_ city: String) {
        Task {
            await viewModel.fetchWeatherForCity(city)
            dismiss()
        }
    }
}

#Preview {
    HomeView()
}
