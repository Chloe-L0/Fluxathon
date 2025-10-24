//
//  ConfirmationViewModel.swift
//  Flexithon02
//
//  Confirmation business logic - Team Member C
//

import Foundation
import Combine

class ConfirmationViewModel: ObservableObject {
    @Published var isSubmitting = false
    @Published var confirmationMessage: String?
    
    func confirmActivity(userSelection: UserSelection) {
        // Team Member C: Handle confirmation logic here
        isSubmitting = true
        
        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.isSubmitting = false
            self.confirmationMessage = "Activity booked successfully!"
            
            // Reset selection after confirmation
            userSelection.reset()
        }
    }
}
