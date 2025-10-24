# Flexithon02 - Team Collaboration Guide

## 📱 App Flow

This app has a **linear navigation flow**:

```
Home (Weather) → Activity Info → Confirmation
```

**NOT** a tab-based app - users navigate forward through pages.

---

## 🏗️ Project Structure

```
Flexithon02/
├── Pages/                    # ⚠️ Each team member works in their assigned folder
│   ├── Home/                 # Team Member A - Weather/Home page
│   ├── ActivityInfo/         # Team Member B - Activity selection
│   └── Confirmation/         # Team Member C - Final confirmation
│
├── Shared/                   # 🤝 Shared resources (coordinate with team)
│   ├── Components/           # Reusable UI components
│   ├── Extensions/
│   ├── Utilities/
│   └── Styles/
│
├── Models/                   # 📦 Shared data models
├── Services/                 # 🔧 API, Location, Storage
└── Navigation/               # 🧭 Navigation coordination
```

---

## 👥 Page Ownership

| Page | Owner | Folder | Description |
|------|-------|--------|-------------|
| **Home** | Team Member A | `Pages/Home/` | Weather display, location-based home page |
| **Activity Info** | Team Member B | `Pages/ActivityInfo/` | Activity selection and details |
| **Confirmation** | Team Member C | `Pages/Confirmation/` | Final confirmation screen |

---

## 🔄 Navigation Flow

### How Pages Connect

**Home → Activity Info:**
```swift
// In HomeView.swift
NavigationLink(destination: ActivityInfoView()) {
    Text("Continue")
}
```

**Activity Info → Confirmation:**
```swift
// In ActivityInfoView.swift
NavigationLink(destination: ConfirmationView()) {
    Text("Confirm Activity")
}
```

### Passing Data Between Pages

Use a **shared data model** passed through navigation:

```swift
// 1. Define in Models/UserSelection.swift
class UserSelection: ObservableObject {
    @Published var weatherData: WeatherData?
    @Published var selectedActivity: Activity?
}

// 2. In Flexithon02App.swift
@StateObject var userSelection = UserSelection()

WindowGroup {
    NavigationView {
        HomeView()
    }
    .environmentObject(userSelection)
}

// 3. Access in any view
@EnvironmentObject var userSelection: UserSelection
```

---

## ✅ Development Rules

### 1. **Work in Your Assigned Folder Only**
- Only modify files in `Pages/[YourPage]/`
- Keep all page-specific components inside your page folder

### 2. **Navigation Boundaries**
Each page should:
- Accept data through `@EnvironmentObject` or parameters
- Navigate forward using `NavigationLink`
- Update shared state through `@EnvironmentObject`

### 3. **Shared Data Models**
When passing data between pages:
1. Define model in `Models/`
2. Use `@EnvironmentObject` for app-wide state
3. Document what data each page expects

### 4. **Branch Naming Convention**
```
feature/[page-name]-[feature-description]

Examples:
✅ feature/home-weather-display
✅ feature/activityinfo-activity-list
✅ feature/confirmation-submit-button
```

### 5. **Before Committing**
- [ ] Code builds successfully (`Cmd + B`)
- [ ] Navigation flow works (can navigate from your page)
- [ ] Data passes correctly to next page
- [ ] Only your page files are modified
- [ ] Run `git status` to verify changed files

---

## 🔄 Git Workflow

### Initial Setup
```bash
git clone [repository-url]
cd Flexithon02
```

### Daily Workflow
```bash
# 1. Pull latest changes
git checkout main
git pull origin main

# 2. Create your feature branch
git checkout -b feature/home-weather-ui

# 3. Make your changes in Pages/Home/

# 4. Stage and commit
git add .
git commit -m "[Home] Add weather display UI"

# 5. Push your branch
git push origin feature/home-weather-ui

# 6. Create Pull Request on GitHub
```

---

## 📦 Data Flow Example

### Home Page (Team Member A)
```swift
// Get weather data
// Save to userSelection.weatherData
// Navigate to ActivityInfo
```

### Activity Info Page (Team Member B)
```swift
// Read userSelection.weatherData
// Show activity options based on weather
// Save selected activity to userSelection.selectedActivity
// Navigate to Confirmation
```

### Confirmation Page (Team Member C)
```swift
// Read userSelection.weatherData
// Read userSelection.selectedActivity
// Display summary
// Submit final data
```

---

## 🚫 Common Mistakes to Avoid

❌ **DON'T** modify other team members' page folders
❌ **DON'T** hardcode data - use shared models
❌ **DON'T** break navigation flow
❌ **DON'T** commit without testing the full flow

✅ **DO** work in your assigned page folder
✅ **DO** use `@EnvironmentObject` for shared data
✅ **DO** test navigation between pages
✅ **DO** communicate when adding shared models

---

## 🛠️ Xcode Setup

### Folder Organization in Xcode

1. **Pages Folder**
   - Create groups for: Home, ActivityInfo, Confirmation
   - Each has its own View, ViewModel, and Components

2. **Shared Folder**
   - Components for reusable UI elements
   - Styles for AppTheme

3. **Models Folder**
   - WeatherData.swift
   - Activity.swift
   - UserSelection.swift (for passing data)

---

## 📝 Pull Request Template

```markdown
## Page Affected
- [ ] Home
- [ ] Activity Info
- [ ] Confirmation
- [ ] Shared/Models

## Changes Made
Brief description of what you built/changed

## Navigation Impact
- [ ] No impact on navigation flow
- [ ] Updated navigation (describe)

## Data Models
- [ ] No new models
- [ ] Added/modified model: [name]

## Testing Done
- [ ] Builds successfully
- [ ] Can navigate TO this page
- [ ] Can navigate FROM this page
- [ ] Data passes correctly

## Screenshots
[Add screenshots of your page]
```

---

## 🎯 Quick Reference

### Navigation Pattern
```swift
NavigationLink(destination: NextView()) {
    Button("Continue") {
        // Optional: Save state before navigation
    }
}
```

### Accessing Shared Data
```swift
@EnvironmentObject var userSelection: UserSelection

// Read
let weather = userSelection.weatherData

// Write
userSelection.selectedActivity = activity
```

### Passing to Next Page
```swift
// Data is automatically available via @EnvironmentObject
NavigationLink(destination: ActivityInfoView()) {
    Text("Continue")
}
```

---

## 📞 Need Help?

- **Navigation issues**: Check NavigationView is at app root
- **Data not passing**: Verify @EnvironmentObject is set
- **Merge conflicts**: Ask in team chat before resolving

---

**Team Members:**
- **Member A (Home)**: Weather display, location handling
- **Member B (Activity Info)**: Activity selection UI
- **Member C (Confirmation)**: Final confirmation, submission

Happy coding! 🚀
