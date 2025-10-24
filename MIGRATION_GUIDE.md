# Migration Guide - Restructuring Your Flexithon02 Project

This guide will help you reorganize your existing project to match the team collaboration structure.

---

## 📋 Current Structure → New Structure

### What You Have Now:
```
Flexithon02/
├── Pages/
│   └── Weather/
│       ├── WeatherView.swift
│       └── WeatherViewModel.swift
├── Shared/
│   └── Theme/
│       └── AppTheme.swift
├── Models/
│   └── WeatherData.swift
├── Services/
│   └── LocationManager.swift
├── ContentView.swift
├── Flexithon02App.swift
└── WeatherApp.swift (?)
```

### What You Need:
```
Flexithon02/
├── Pages/
│   ├── Home/                    # ← Rename Weather to Home
│   ├── ActivityInfo/            # ← NEW - Create this
│   └── Confirmation/            # ← NEW - Create this
├── Shared/
│   ├── Components/              # ← NEW - Create this
│   ├── Extensions/              # ← NEW - Create this
│   ├── Utilities/               # ← NEW - Create this
│   └── Styles/                  # ← Rename Theme to Styles
│       └── AppTheme.swift
├── Models/
│   ├── WeatherData.swift
│   ├── Activity.swift           # ← NEW - Create this
│   └── UserSelection.swift      # ← NEW - Create this
├── Services/
│   ├── LocationManager.swift
│   └── APIService.swift         # ← NEW - If needed
├── Navigation/                  # ← NEW - Create this
└── Flexithon02App.swift
```

---

## 🔧 Step-by-Step Migration

### Step 1: Rename Folders (in Xcode)

1. **Rename `Pages/Weather/` → `Pages/Home/`**
   - Right-click `Weather` folder in Xcode
   - Select "Rename"
   - Change to "Home"

2. **Rename files inside Home/**
   - `WeatherView.swift` → `HomeView.swift`
   - `WeatherViewModel.swift` → `HomeViewModel.swift`
   - Update class names inside files to match

3. **Rename `Shared/Theme/` → `Shared/Styles/`**
   - Right-click `Theme` folder
   - Select "Rename"
   - Change to "Styles"

### Step 2: Create New Page Folders

**In Xcode Navigator:**

1. Right-click on `Pages` folder
2. Select "New Group"
3. Name it "ActivityInfo"
4. Inside ActivityInfo, create another "New Group" named "Components"

Repeat for "Confirmation" folder.

### Step 3: Create New Shared Folders

**In Xcode Navigator:**

1. Right-click on `Shared` folder
2. Create "New Group" for each:
   - Components
   - Extensions
   - Utilities

### Step 4: Handle ContentView.swift

**Option A: Delete it** (if it's just a placeholder)
- If ContentView is not being used, delete it

**Option B: Convert it to Navigation** (if it's your entry point)
- Create `Navigation` folder
- Move and rename to `MainNavigationView.swift`

### Step 5: Handle WeatherApp.swift

**Check what's in it:**
- If it's duplicate of `Flexithon02App.swift` → Delete it
- If it has important logic → Merge into `Flexithon02App.swift`

### Step 6: Create New Model Files

**Create `Models/Activity.swift`:**
```swift
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
```

**Create `Models/UserSelection.swift`:**
```swift
import Foundation
import SwiftUI

class UserSelection: ObservableObject {
    @Published var weatherData: WeatherData?
    @Published var selectedActivity: Activity?
    @Published var userLocation: String = ""
    
    func reset() {
        weatherData = nil
        selectedActivity = nil
        userLocation = ""
    }
}
```

---

## 📝 Update Your App Entry Point

**File: `Flexithon02/Flexithon02App.swift`**

Replace with:
```swift
import SwiftUI

@main
struct Flexithon02App: App {
    @StateObject private var userSelection = UserSelection()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView()
            }
            .environmentObject(userSelection)
        }
    }
}
```

---

## 📝 Update Home View (Previously Weather View)

**File: `Flexithon02/Pages/Home/HomeView.swift`**

Update to include navigation:
```swift
import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @EnvironmentObject var userSelection: UserSelection
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Weather Home")
                    .font(.largeTitle)
                
                // Your weather UI here
                
                // Navigation to next page
                NavigationLink(destination: ActivityInfoView()) {
                    Text("Find Activities")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(AppTheme.Colors.primary)
                        .cornerRadius(AppTheme.CornerRadius.medium)
                }
                .padding(.horizontal)
            }
            .padding()
        }
        .navigationTitle("Home")
        .onAppear {
            viewModel.loadData()
        }
    }
}

#Preview {
    NavigationView {
        HomeView()
            .environmentObject(UserSelection())
    }
}
```

---

## 📝 Create Activity Info Page

**Create: `Flexithon02/Pages/ActivityInfo/ActivityInfoView.swift`**

```swift
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
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(12)
                    }
                }
                
                // Navigation to confirmation
                if userSelection.selectedActivity != nil {
                    NavigationLink(destination: ConfirmationView()) {
                        Text("Continue")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(AppTheme.Colors.primary)
                            .cornerRadius(AppTheme.CornerRadius.medium)
                    }
                    .padding(.top)
                }
            }
            .padding()
        }
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
```

**Create: `Flexithon02/Pages/ActivityInfo/ActivityInfoViewModel.swift`**

```swift
import Foundation

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
```

---

## 📝 Create Confirmation Page

**Create: `Flexithon02/Pages/Confirmation/ConfirmationView.swift`**

```swift
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
                
                // Weather Summary
                if let weather = userSelection.weatherData {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Weather")
                            .font(.headline)
                        
                        // Team Member C: Display weather details
                        Text("Location: \(userSelection.userLocation)")
                        // Add more weather details
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)
                }
                
                // Activity Summary
                if let activity = userSelection.selectedActivity {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Selected Activity")
                            .font(.headline)
                        
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
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)
                }
                
                // Confirm Button
                Button(action: {
                    viewModel.confirmActivity(userSelection: userSelection)
                }) {
                    Text("Confirm & Book")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(AppTheme.Colors.primary)
                        .cornerRadius(AppTheme.CornerRadius.medium)
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
        .navigationTitle("Confirmation")
    }
}

#Preview {
    NavigationView {
        ConfirmationView()
            .environmentObject(UserSelection())
    }
}
```

**Create: `Flexithon02/Pages/Confirmation/ConfirmationViewModel.swift`**

```swift
import Foundation

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
```

---

## ✅ Verification Checklist

After migration:

- [ ] All 3 page folders exist: Home, ActivityInfo, Confirmation
- [ ] Each page has View, ViewModel, and Components folder
- [ ] Shared folders created: Components, Extensions, Utilities, Styles
- [ ] Models folder has: WeatherData, Activity, UserSelection
- [ ] App entry point uses NavigationView and @EnvironmentObject
- [ ] Can navigate: Home → ActivityInfo → Confirmation
- [ ] Data passes between pages via UserSelection
- [ ] Project builds without errors
- [ ] All files have proper imports

---

## 🚀 Next Steps

1. **Commit your restructured project**
   ```bash
   git add .
   git commit -m "Restructure project for team collaboration"
   ```

2. **Assign pages to team members:**
   - Member A: `Pages/Home/`
   - Member B: `Pages/ActivityInfo/`
   - Member C: `Pages/Confirmation/`

3. **Create branches for each member:**
   ```bash
   git checkout -b feature/home-initial
   git checkout -b feature/activityinfo-initial
   git checkout -b feature/confirmation-initial
   ```

4. **Update the README.md** with team member assignments

---

## 💡 Tips

- **Don't rush**: Take time to rename and organize properly
- **Test after each step**: Make sure project builds
- **Commit often**: After each major change
- **Ask for help**: If something breaks, post in team chat

Good luck with the migration! 🎉
