//
//  ActivityInfoView.swift
//  Flexithon02
//
//  Activity selection page - Team Member B
//

import SwiftUI

struct ActivityInfoView: View {
    @StateObject private var viewModel = ActivityInfoViewModel()
    @EnvironmentObject var userSelection: UserSelection
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Choose Your Activity")
                    .font(.title)
                    .bold()
                    .foregroundColor(AppTheme.Colors.textPrimary)
                
                // Team Member B: Add your activity list here
                
                // Placeholder activities
                ForEach(viewModel.activities) { activity in
                    Button(action: {
                        userSelection.selectedActivity = activity
                    }) {
                        HStack {
                            Image(systemName: activity.icon)
                                .font(.title2)
                            
                            VStack(alignment: .leading) {
                                Text(activity.name)
                                    .font(.headline)
                                Text(activity.description)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            if userSelection.selectedActivity?.id == activity.id {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                            }
                        }
                        .padding()
                        .background(AppTheme.Colors.cardBackgroundSecondary)
                        .cornerRadius(AppTheme.CornerRadius.medium)
                    }
                }
                
                // Navigation to confirmation
                if userSelection.selectedActivity != nil {
                    NavigationLink(destination: ConfirmationView()) {
                        Text("Join")
                            .appButtonStyle(style: .primary)
                    }
                    .padding(.top)
                }
            }
            .padding()
        }
        .background(AppTheme.Colors.background)
        .navigationTitle("Activities")
        .onAppear {
            viewModel.loadActivities()
        }
    }
}

#Preview {
    NavigationView {
        ActivityInfoView()
            .environmentObject(UserSelection())
    }
}
