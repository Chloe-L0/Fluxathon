//
//  Activity.swift
//  Flexithon02
//
//  Activity data model for team collaboration
//

import Foundation

struct Activity: Identifiable, Codable {
    let id: UUID
    let name: String
    let description: String
    let weatherSuitability: [String] // e.g., ["sunny", "cloudy"]
    let icon: String
    
    init(id: UUID = UUID(), name: String, description: String, 
         weatherSuitability: [String], icon: String) {
        self.id = id
        self.name = name
        self.description = description
        self.weatherSuitability = weatherSuitability
        self.icon = icon
    }
}
