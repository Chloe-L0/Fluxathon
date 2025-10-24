//
//  ContentView.swift
//  Flexithon02
//
//  Main app navigation and entry point
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            HomeView()
        }
        #if os(iOS)
        .navigationViewStyle(StackNavigationViewStyle())
        #endif
    }
}

#Preview {
    ContentView()
        .environmentObject(UserSelection())
}
