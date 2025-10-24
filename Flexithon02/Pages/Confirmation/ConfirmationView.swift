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
        ScrollView {
            VStack(spacing: 24) {
                // Header
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.green)
                
                Text("Confirm Your Activity")
                    .font(.title)
                    .bold()
                    .foregroundColor(AppTheme.Colors.textPrimary)
                
                // Weather Summary
                if let weather = userSelection.weatherData {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Weather")
                            .font(.headline)
                            .foregroundColor(AppTheme.Colors.textPrimary)
                        
                        // Team Member C: Display weather details
                        Text("Location: \(userSelection.userLocation)")
                            .foregroundColor(AppTheme.Colors.textSecondary)
                        Text("Temperature: \(String(format: "%.0f°C", weather.temperature))")
                            .foregroundColor(AppTheme.Colors.textSecondary)
                        Text("Condition: \(weather.condition)")
                            .foregroundColor(AppTheme.Colors.textSecondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(AppTheme.Colors.cardBackgroundSecondary)
                    .cornerRadius(AppTheme.CornerRadius.medium)
                }
                
                // Activity Summary
                if let activity = userSelection.selectedActivity {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Selected Activity")
                            .font(.headline)
                            .foregroundColor(AppTheme.Colors.textPrimary)
                        
                        HStack {
                            Image(systemName: activity.icon)
                                .font(.title2)
                            
                            VStack(alignment: .leading) {
                                Text(activity.name)
                                    .font(.headline)
                                    .foregroundColor(AppTheme.Colors.textPrimary)
                                Text(activity.description)
                                    .font(.caption)
                                    .foregroundColor(AppTheme.Colors.textSecondary)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(AppTheme.Colors.cardBackgroundSecondary)
                    .cornerRadius(AppTheme.CornerRadius.medium)
                }
                
                // Confirm Button
                Button(action: {
                    viewModel.confirmActivity(userSelection: userSelection)
                }) {
                    Text("Confirm & Book")
                        .appButtonStyle(style: .primary)
                }
                
                // Cancel/Back Button
                Button(action: {
                    dismiss()
                }) {
                    Text("Go Back")
                        .foregroundColor(.secondary)
                }
            }
            .padding()
        }
        .background(AppTheme.Colors.background)
        .navigationTitle("Confirmation")
    }
}

#Preview {
    NavigationView {
        ConfirmationView()
            .environmentObject(UserSelection())
    }
}
