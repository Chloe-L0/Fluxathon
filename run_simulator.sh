#!/bin/bash

# Flexithon02 - Build and Run on Simulator Script
# Usage: ./run_simulator.sh

echo "🚀 Building and running Flexithon02 on iPhone 17 simulator..."

# Build the project
echo "📦 Building project..."
xcodebuild -project Flexithon02.xcodeproj -scheme Flexithon02 -destination 'platform=iOS Simulator,name=iPhone 17' -derivedDataPath ./DerivedData build

# Check if build succeeded
if [ $? -eq 0 ]; then
    echo "✅ Build successful!"
    
    # Boot simulator if needed
    echo "📱 Booting iPhone 17 simulator..."
    xcrun simctl boot "iPhone 17" 2>/dev/null || echo "Simulator already running"
    
    # Install the app
    echo "📲 Installing app..."
    xcrun simctl install "iPhone 17" "./DerivedData/Build/Products/Debug-iphonesimulator/Flexithon02.app"
    
    # Launch the app
    echo "🎯 Launching app..."
    xcrun simctl launch "iPhone 17" "gigi.Flexithon02"
    
    echo "🎉 App is now running on the simulator!"
else
    echo "❌ Build failed. Please check the errors above."
    exit 1
fi
