//
//  ActivityInfoViewModel.swift
//  Flexithon02
//
//  Activity selection business logic - Team Member B
//

import Foundation
import Combine

class ActivityInfoViewModel: ObservableObject {
    @Published var activities: [Activity] = []
    @Published var isLoading = false
    
    func loadActivities() {
        // Team Member B: Load your activities here
        // This is placeholder data
        activities = [
            Activity(name: "Hiking", description: "Outdoor trail adventure", 
                    weatherSuitability: ["sunny", "cloudy"], icon: "figure.hiking"),
            Activity(name: "Museum Visit", description: "Indoor cultural experience", 
                    weatherSuitability: ["rainy", "cloudy"], icon: "building.columns"),
            Activity(name: "Beach Day", description: "Relax by the water", 
                    weatherSuitability: ["sunny"], icon: "beach.umbrella")
        ]
    }
}
