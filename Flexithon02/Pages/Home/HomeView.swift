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

    var body: some View {
        VStack(spacing: 0) {
            // Status bar
            HStack {
                Text("9:41")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.black)
                
                Spacer()
                
                HStack(spacing: 4) {
                    Image(systemName: "cellularbars")
                        .font(.system(size: 12))
                    Image(systemName: "wifi")
                        .font(.system(size: 12))
                    Image(systemName: "battery.100")
                        .font(.system(size: 12))
                }
                .foregroundColor(.black)
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
            
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
        .background(Color.white)
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
                    .fill(Color.gray.opacity(0.8))
                    .frame(height: 180)
                
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("78°F")
                            .font(.system(size: 48, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("Savannah, GA")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    VStack {
                        Text("OCT 24")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        // Blue character
                        Text("👀")
                            .font(.system(size: 40))
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
            }
            
            // Weather details grid
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                weatherDetailFromImage(label: "Feels like", value: "78°F")
                weatherDetailFromImage(label: "Humidity", value: "40%")
                weatherDetailFromImage(label: "Wind", value: "3.6 m/s")
                weatherDetailFromImage(label: "Pressure", value: "1021 hPa")
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 20)
        }
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
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
                HStack(spacing: 16) {
                    // Outdoor Volleyball Card
                    volleyballCard()
                    
                    // Escape Room Card
                    escapeRoomCard()
                }
                .padding(.horizontal, 16)
            }
        }
    }
    
    // MARK: - Volleyball Card
    
    private func volleyballCard() -> some View {
        VStack(spacing: 0) {
            // Main card with yellow-orange background
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.orange)
                    .frame(height: 160)
                
                VStack {
                    // Top row with Sunny tag and temperature
                    HStack {
                        // Sunny tag
                        Text("Sunny")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.yellow)
                            .cornerRadius(12)
                        
                        Spacer()
                        
                        // Temperature range
                        Text("72-78 °F")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                    }
                    .padding(.horizontal, 12)
                    .padding(.top, 12)
                    
                    Spacer()
                    
                    // Bottom row with content and character
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            // Activity title with star
                            HStack {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.black)
                                    .font(.caption)
                                Text("Outdoor Volleyball")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.black)
                            }
                            
                            // Time with clock
                            HStack {
                                Image(systemName: "clock")
                                    .foregroundColor(.black)
                                    .font(.caption)
                                Text("Today 3:00 pm - 5:00 pm")
                                    .font(.subheadline)
                                    .foregroundColor(.black)
                            }
                            
                            // Participants
                            HStack(spacing: -8) {
                                // First participant - dark blue
                                Circle()
                                    .fill(Color.blue)
                                    .frame(width: 24, height: 24)
                                    .overlay(
                                        Text("👤")
                                            .font(.caption)
                                            .foregroundColor(.white)
                                    )
                                
                                // Second participant - light green
                                Circle()
                                    .fill(Color.green)
                                    .frame(width: 24, height: 24)
                                    .overlay(
                                        Text("👤")
                                            .font(.caption)
                                            .foregroundColor(.white)
                                    )
                                
                                // Third participant - light purple
                                Circle()
                                    .fill(Color.purple)
                                    .frame(width: 24, height: 24)
                                    .overlay(
                                        Text("👤")
                                            .font(.caption)
                                            .foregroundColor(.white)
                                    )
                                
                                // Additional participant slots
                                ForEach(0..<3, id: \.self) { _ in
                                    Circle()
                                        .fill(Color.white)
                                        .frame(width: 24, height: 24)
                                        .overlay(
                                            Text("+")
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                        )
                                }
                            }
                        }
                        
                        Spacer()
                        
                        // Orange character
                        Text("😊")
                            .font(.system(size: 30))
                    }
                    .padding(.horizontal, 12)
                    .padding(.bottom, 12)
                }
            }
        }
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
        .frame(width: 200)
    }
    
    // MARK: - Escape Room Card
    
    private func escapeRoomCard() -> some View {
        VStack(spacing: 0) {
            // Card header
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.blue)
                    .frame(height: 120)
                
                VStack {
                    HStack {
                        Text("Rainy")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.blue)
                            .cornerRadius(8)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 12)
                    .padding(.top, 8)
                    
                    Spacer()
                }
            }
            
            // Card content
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    Text("Escape for")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                }
                
                HStack {
                    Image(systemName: "clock")
                        .foregroundColor(.gray)
                    Text("Today 7:00 pm")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                // Participants
                HStack(spacing: -8) {
                    Circle()
                        .fill(Color.blue.opacity(0.7))
                        .frame(width: 24, height: 24)
                        .overlay(
                            Text("👤")
                                .font(.caption)
                                .foregroundColor(.white)
                        )
                    
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 24, height: 24)
                        .overlay(
                            Text("➕")
                                .font(.caption)
                                .foregroundColor(.white)
                        )
                }
            }
            .padding(12)
            .background(Color.white)
        }
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
        .frame(width: 200)
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
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
        }
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
    

}

#Preview {
    HomeView()
}
