//
//  iFlagTriviaApp.swift
//  iFlagTrivia
//
//  Created by Yohannes Haile on 1/4/25.
//

import SwiftUI

@main
struct iFlagTriviaApp: App {
    @StateObject var themeManager = ThemeManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(themeManager)
        }
    }
}
