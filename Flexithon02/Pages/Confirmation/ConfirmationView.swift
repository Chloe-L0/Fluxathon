//
//  ConfirmationView.swift
//  Flexithon02
//
//  Final confirmation page - Team Member C
//

import SwiftUI

struct ConfirmationView: View {
    @StateObject private var viewModel = ConfirmationViewModel()
    @EnvironmentObject var userSelection: UserSelection
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            // Main Content
            ScrollView {
                VStack(spacing: 24) {
                    // Congratulations Header with CG3.png
                    VStack(spacing: 16) {
                        Group {
                            if let uiImage = UIImage(named: "CG3.png") {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(maxWidth: .infinity, maxHeight: 300)
                            } else {
                                // Fallback content if image doesn't load
                                VStack(spacing: 20) {
                                    Text("Congratulations!")
                                        .font(.largeTitle)
                                        .fontWeight(.bold)
                                        .foregroundColor(.black)
                                    
                                    Text("You've joined the sunny crew")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                    
                                    Text("CG3.png not found")
                                        .font(.caption)
                                        .foregroundColor(.red)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 20)
                    }
                    .padding(.top, 30)
                    
                    // Activity Details
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Outdoor Volleyball")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                        
                        // Activity Details Card
                        VStack(spacing: 12) {
                            // Date & Time
                            HStack {
                                Image(systemName: "calendar.badge.clock")
                                    .foregroundStyle(.black)
                                    .frame(width: 20)
                                Text("OCT 24 3:00 pm -5:00 pm")
                                    .foregroundColor(.black)
                                Spacer()
                            }
                            
                            // Location
                            HStack {
                                Image(systemName: "location.fill")
                                    .foregroundStyle(.black)
                                    .frame(width: 20)
                                Text("Forsyth Park")
                                    .foregroundColor(.black)
                                Spacer()
                            }
                            
                            // Temperature
                            HStack {
                                Image(systemName: "thermometer")
                                    .foregroundStyle(.black)
                                    .frame(width: 20)
                                Text("72-78°F")
                                    .foregroundColor(.black)
                                Spacer()
                            }
                            
                            // Capacity
                            HStack {
                                Image(systemName: "person.3.fill")
                                    .foregroundStyle(.black)
                                    .frame(width: 20)
                                Text("Room for 3")
                                    .foregroundColor(.black)
                                Spacer()
                            }
                            
                            // Website
                            HStack {
                                Image(systemName: "doc.text")
                                    .foregroundStyle(.black)
                                    .frame(width: 20)
                                Text("www.forsythparkvolleyball.com")
                                    .foregroundColor(.black)
                                Spacer()
                            }
                        }
                        .padding(16)
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: .gray.opacity(0.2), radius: 2, x: 0, y: 1)
                    }
                    .padding(.horizontal, 20)
                    
                    // Action Buttons
                    VStack(spacing: 12) {
                        Button(action: {
                            // Go Chat With Group action
                        }) {
                            Text("Go Chat With Group")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.black.opacity(0.8))
                                .cornerRadius(12)
                        }
                        
                        Button(action: {
                            dismiss()
                        }) {
                            Text("Done")
                                .font(.headline)
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
            }
        }
        .background(Color.white)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .ignoresSafeArea(.all, edges: .bottom)
    }
}

#Preview {
    NavigationView {
        ConfirmationView()
            .environmentObject(UserSelection())
    }
}
