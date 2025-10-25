//
//  ActivityInfoView.swift
//  Flexithon02
//
//  Activity details page - Team Member B
//

import SwiftUI

struct ActivityInfoView: View {
    @EnvironmentObject var userSelection: UserSelection
    
    var body: some View {
        ScrollView {
            VStack(spacing: 8) {
                // Hero Image Section
                ZStack {
                    // Hero image with volleyball scene
                    if let image = UIImage(named: "AC4") {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 180)
                            .frame(maxWidth: .infinity)
                            .clipped()
                    } else {
                        Rectangle()
                            .fill(Color.blue.opacity(0.3))
                            .frame(height: 180)
                            .overlay(
                                Text("AC4 Image Not Found")
                                    .foregroundColor(.white)
                                    .font(.caption)
                            )
                    }
                }
                
                // Activity Title
                Text("Outdoor Volleyball")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .padding(.top, 8)
                
                // Activity Details Card
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "clock")
                            .foregroundColor(.gray)
                            .frame(width: 16, height: 16)
                        Text("OCT 24 3:00 pm -5:00 pm")
                            .foregroundColor(.black)
                            .font(.subheadline)
                    }
                    
                    HStack {
                        Image(systemName: "location")
                            .foregroundColor(.gray)
                            .frame(width: 16, height: 16)
                        Text("Forsyth Park")
                            .foregroundColor(.black)
                            .font(.subheadline)
                    }
                    
                    HStack {
                        Image(systemName: "thermometer")
                            .foregroundColor(.gray)
                            .frame(width: 16, height: 16)
                        Text("72-78°F")
                            .foregroundColor(.black)
                            .font(.subheadline)
                    }
                    
                    HStack {
                        Image(systemName: "person.3")
                            .foregroundColor(.gray)
                            .frame(width: 16, height: 16)
                        Text("Room for 3")
                            .foregroundColor(.black)
                            .font(.subheadline)
                    }
                    
                    HStack {
                        Image(systemName: "doc")
                            .foregroundColor(.gray)
                            .frame(width: 16, height: 16)
                        Text("www.forsythparkvolleyball.com")
                            .foregroundColor(.black)
                            .font(.subheadline)
                    }
                }
                .padding(12)
                .background(Color.white)
                .cornerRadius(8)
                .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 1)
                .padding(.horizontal, 8)
                .padding(.top, 8)
                
                // Information Section
                VStack(alignment: .leading, spacing: 8) {
                    Text("Information")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding(.horizontal, 16)
                        .padding(.top, 16)
                    
                    VStack(alignment: .leading, spacing: 6) {
                        HStack(alignment: .top, spacing: 8) {
                            Text("1.")
                                .foregroundColor(.black)
                                .fontWeight(.medium)
                                .font(.subheadline)
                            Text("Bring water and sunscreen to stay hydrated and protected from the sun.")
                                .foregroundColor(.black)
                                .font(.subheadline)
                        }
                        
                        HStack(alignment: .top, spacing: 8) {
                            Text("2.")
                                .foregroundColor(.black)
                                .fontWeight(.medium)
                                .font(.subheadline)
                            Text("Wear light, breathable sports clothes and shoes with good grip.")
                                .foregroundColor(.black)
                                .font(.subheadline)
                        }
                        
                        HStack(alignment: .top, spacing: 8) {
                            Text("3.")
                                .foregroundColor(.black)
                                .fontWeight(.medium)
                                .font(.subheadline)
                            Text("Arrive 10-15 minutes early to warm up and join a team easily.")
                                .foregroundColor(.black)
                                .font(.subheadline)
                        }
                        
                        HStack(alignment: .top, spacing: 8) {
                            Text("4.")
                                .foregroundColor(.black)
                                .fontWeight(.medium)
                                .font(.subheadline)
                            Text("Enjoy a relaxed, friendly game focused on fun and socializing.")
                                .foregroundColor(.black)
                                .font(.subheadline)
                        }
                        
                        HStack(alignment: .top, spacing: 8) {
                            Text("5.")
                                .foregroundColor(.black)
                                .fontWeight(.medium)
                                .font(.subheadline)
                            Text("Forsyth Park offers cafés, restrooms, and great amenities.")
                                .foregroundColor(.black)
                                .font(.subheadline)
                        }
                    }
                    .padding(12)
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 1)
                    .padding(.horizontal, 16)
                }
                
                // Join Button
                NavigationLink(destination: ConfirmationView()) {
                    Text("Join")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color.black.opacity(0.8))
                        .cornerRadius(8)
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                
                // Home Button
                HStack {
                    NavigationLink(destination: HomeView()) {
                        if let image = UIImage(named: "AC3") {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100, height: 70)
                        } else {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.gray)
                                .frame(width: 100, height: 70)
                                .overlay(
                                    Text("Home")
                                        .foregroundColor(.white)
                                        .font(.caption)
                                )
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .padding(.bottom, 20)
            }
        }
        .background(Color.gray.opacity(0.1))
        .navigationTitle("Activity")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationView {
        ActivityInfoView()
            .environmentObject(UserSelection())
    }
}
